import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riv;
import 'package:mangayomi/models/video.dart' as vid;
import 'package:mangayomi/modules/anime/utils/audio_track_fallback.dart';
import 'package:mangayomi/modules/anime/utils/audio_track_label.dart';
import 'package:mangayomi/modules/anime/utils/player_labels.dart';
import 'package:mangayomi/modules/anime/utils/track_list_builder.dart';
import 'package:mangayomi/modules/anime/utils/video_prefs.dart';
import 'package:mangayomi/modules/anime/widgets/tv_player_pills.dart';
import 'package:mangayomi/utils/log/logger.dart';
import 'package:media_kit/media_kit.dart';

/// Manages audio and subtitle track resolution, language preference matching,
/// libmpv active track synchronization, audio decoder fallback recovery,
/// and TV track option builders.
mixin AnimeTrackSelectionMixin<T extends riv.ConsumerStatefulWidget>
    on riv.ConsumerState<T> {
  Player get trackPlayer;
  List<vid.Video> get trackVideos;
  vid.Video get firstVideoForTracks;
  bool get isLocalForTracks;
  String get defaultSubtitleLanguage;
  String get preferredAudioLanguagesCsv;
  ValueNotifier<VideoPrefs?> get selectedVideoPrefs;
  Future<void> openMediaFromTrackSelection(VideoPrefs prefs);

  bool initSubtitleAndAudio = true;
  SubtitleTrack? activeSubtitleTrack;
  AudioTrack? activeAudioTrack;
  final Set<String> _failedAudioTrackKeys = {};
  final Set<String> _failedAudioCodecs = {};
  String? _requestedAudioLanguage;
  bool _audioFallbackInProgress = false;
  bool _audioFallbackErrorQueued = false;

  void initializeDefaultSubtitleAndAudioTracks() {
    if (!initSubtitleAndAudio) return;
    initSubtitleAndAudio = false;
    if (activeSubtitleTrack != null) {
      try {
        unawaited(setSubtitleTrack(activeSubtitleTrack!));
      } catch (_) {}
    } else if (firstVideoForTracks.subtitles?.isNotEmpty ?? false) {
      try {
        final preferredSource = findPreferredSourceSubtitleTrack(
          firstVideoForTracks.subtitles!,
        );
        final defaultTrack =
            preferredSource ??
            firstVideoForTracks.subtitles!.firstWhere(
              (sub) => sub.label == defaultSubtitleLanguage,
              orElse: () => firstVideoForTracks.subtitles!.first,
            );
        final file = defaultTrack.file ?? "";
        final label = defaultTrack.label;
        final track = (file.startsWith("http") || file.startsWith("file"))
            ? SubtitleTrack.uri(file, title: label, language: label)
            : SubtitleTrack.data(file, title: label, language: label);
        unawaited(setSubtitleTrack(track));
      } catch (_) {}
    } else {
      unawaited(syncActiveSubtitleTrackFromMpv());
    }

    if (activeAudioTrack != null) {
      try {
        unawaited(setAudioTrack(activeAudioTrack!));
      } catch (_) {}
    } else if (firstVideoForTracks.audios?.isNotEmpty ?? false) {
      try {
        final preferredSource = findPreferredSourceAudioTrack(
          firstVideoForTracks.audios!,
        );
        final at = preferredSource ?? firstVideoForTracks.audios!.first;
        final track = AudioTrack.uri(
          at.file ?? "",
          title: at.label,
          language: at.label,
        );
        activeAudioTrack = track;
        unawaited(setAudioTrack(track));
      } catch (_) {}
    } else {
      unawaited(syncActiveAudioTrackFromMpv());
    }
  }

  SubtitleTrack? get effectiveSubtitleTrack {
    if (activeSubtitleTrack != null && activeSubtitleTrack!.id == 'no') {
      return activeSubtitleTrack;
    }
    final playerSubtitle = trackPlayer.state.track.subtitle;
    if (playerSubtitle.id == 'no') {
      return playerSubtitle;
    }
    if (activeSubtitleTrack != null && activeSubtitleTrack!.id != 'auto') {
      return activeSubtitleTrack;
    }
    if (playerSubtitle.id != 'auto') {
      return playerSubtitle;
    }
    final tracks = trackPlayer.state.tracks.subtitle
        .where((t) => t.id != 'auto' && t.id != 'no')
        .toList();
    if (tracks.isNotEmpty) {
      final preferred = _findPreferredSubtitleTrack(tracks);
      if (preferred != null) return preferred;
    }
    final extSubs = firstVideoForTracks.subtitles;
    if (extSubs != null && extSubs.isNotEmpty) {
      final preferredExt = findPreferredSourceSubtitleTrack(extSubs);
      final st = preferredExt ?? extSubs.first;
      final file = st.file ?? '';
      return (file.startsWith('http') || file.startsWith('file'))
          ? SubtitleTrack.uri(file, title: st.label, language: st.label)
          : SubtitleTrack.data(file, title: st.label, language: st.label);
    }
    return activeSubtitleTrack ?? playerSubtitle;
  }

  SubtitleTrack? _findPreferredSubtitleTrack(List<SubtitleTrack> tracks) {
    if (tracks.isEmpty) return null;
    final pref = defaultSubtitleLanguage.trim().toLowerCase();
    if (pref.isNotEmpty && pref != 'auto') {
      for (final track in tracks) {
        if (track.id == 'no' || track.id == 'auto') continue;
        if (audioTrackLanguagesMatch(track.language, pref) ||
            audioTrackLanguagesMatch(track.title, pref)) {
          return track;
        }
      }
    }
    return tracks.firstWhere(
      (t) => t.id != 'no' && t.id != 'auto',
      orElse: () => tracks.first,
    );
  }

  vid.Track? findPreferredSourceSubtitleTrack(List<vid.Track> tracks) {
    if (tracks.isEmpty) return null;
    final pref = defaultSubtitleLanguage.trim().toLowerCase();
    if (pref.isNotEmpty && pref != 'auto') {
      for (final track in tracks) {
        if (audioTrackLanguagesMatch(track.label, pref)) {
          return track;
        }
      }
    }
    return null;
  }

  bool isSubtitleTrackSelected(
    SubtitleTrack? candidate,
    SubtitleTrack? effective,
  ) {
    if (candidate == null || effective == null) return false;
    if (candidate.id == 'auto' || candidate.id == 'no') return false;
    if (effective.id == 'auto' || effective.id == 'no') return false;
    if (candidate.id == effective.id) return true;
    if (candidate.title != null &&
        candidate.title!.isNotEmpty &&
        candidate.title == effective.title) {
      return true;
    }
    return false;
  }

  Future<void> syncActiveSubtitleTrackFromMpv() async {
    if (!mounted) return;
    try {
      final active = await _activeSubtitleTrackFn();
      if (!mounted) return;
      if (active.id != 'auto') {
        if (activeSubtitleTrack?.id != active.id ||
            activeSubtitleTrack?.title != active.title ||
            activeSubtitleTrack?.language != active.language) {
          if (mounted) {
            setState(() {
              activeSubtitleTrack = active;
            });
          }
        }
      }
    } catch (_) {}
  }

  Future<void> setSubtitleTrack(SubtitleTrack track) async {
    activeSubtitleTrack = track;
    await trackPlayer.setSubtitleTrack(track);
  }

  Future<SubtitleTrack> _activeSubtitleTrackFn() async {
    final selectedSub = trackPlayer.state.track.subtitle;
    if (selectedSub.id != 'auto' && selectedSub.id != 'no') {
      return selectedSub;
    }

    final platform = trackPlayer.platform;
    if (platform is! NativePlayer) return selectedSub;
    final sid = await _nativeAudioProperty(platform, 'sid');
    final explicitlySelected = _subtitleTrackForNativeId(sid);
    if (explicitlySelected != null) return explicitlySelected;
    final activeId = await _nativeAudioProperty(
      platform,
      'current-tracks/sub/id',
    );
    return _subtitleTrackForNativeId(activeId) ?? selectedSub;
  }

  SubtitleTrack? _subtitleTrackForNativeId(String? id) {
    if (id == null || id == 'auto' || id == '-1') return null;
    if (id == 'no') return SubtitleTrack.no();
    for (final track in trackPlayer.state.tracks.subtitle) {
      if (track.id == id) return track;
    }
    return SubtitleTrack(id, null, null);
  }

  AudioTrack? get effectiveAudioTrack {
    if (activeAudioTrack != null && activeAudioTrack!.id == 'no') {
      return activeAudioTrack;
    }
    final playerAudio = trackPlayer.state.track.audio;
    if (playerAudio.id == 'no') {
      return playerAudio;
    }
    if (activeAudioTrack != null && activeAudioTrack!.id != 'auto') {
      return activeAudioTrack;
    }
    if (playerAudio.id != 'auto') {
      return playerAudio;
    }
    final tracks = trackPlayer.state.tracks.audio
        .where((t) => t.id != 'auto' && t.id != 'no')
        .toList();
    if (tracks.isNotEmpty) {
      final preferred = _findPreferredAudioTrack(tracks);
      if (preferred != null) return preferred;
    }
    final extAudios = firstVideoForTracks.audios;
    if (extAudios != null && extAudios.isNotEmpty) {
      final preferredExt = findPreferredSourceAudioTrack(extAudios);
      final at = preferredExt ?? extAudios.first;
      return AudioTrack.uri(at.file ?? '', title: at.label, language: at.label);
    }
    return activeAudioTrack ?? playerAudio;
  }

  AudioTrack? _findPreferredAudioTrack(List<AudioTrack> tracks) {
    if (tracks.isEmpty) return null;
    final preferredList = preferredAudioLanguagesCsv
        .split(',')
        .map((l) => l.trim().toLowerCase())
        .where((l) => l.isNotEmpty && l != 'auto')
        .toList();
    for (final pref in preferredList) {
      for (final track in tracks) {
        if (track.id == 'no' || track.id == 'auto') continue;
        if (audioTrackLanguagesMatch(track.language, pref) ||
            audioTrackLanguagesMatch(track.title, pref)) {
          return track;
        }
      }
    }
    return tracks.firstWhere(
      (t) => t.id != 'no' && t.id != 'auto',
      orElse: () => tracks.first,
    );
  }

  vid.Track? findPreferredSourceAudioTrack(List<vid.Track> tracks) {
    if (tracks.isEmpty) return null;
    final preferredList = preferredAudioLanguagesCsv
        .split(',')
        .map((l) => l.trim().toLowerCase())
        .where((l) => l.isNotEmpty && l != 'auto')
        .toList();
    for (final pref in preferredList) {
      for (final track in tracks) {
        if (audioTrackLanguagesMatch(track.label, pref)) {
          return track;
        }
      }
    }
    return null;
  }

  bool isAudioTrackSelected(AudioTrack? candidate, AudioTrack? effective) {
    if (candidate == null || effective == null) return false;
    if (candidate.id == 'auto' || candidate.id == 'no') return false;
    if (effective.id == 'auto' || effective.id == 'no') return false;
    if (candidate.id == effective.id) return true;
    if (candidate.title != null &&
        candidate.title!.isNotEmpty &&
        candidate.title == effective.title) {
      return true;
    }
    return false;
  }

  Future<void> syncActiveAudioTrackFromMpv() async {
    if (!mounted) return;
    try {
      final active = await _activeAudioTrackFn();
      if (!mounted) return;
      if (active.id != 'auto') {
        if (activeAudioTrack?.id != active.id ||
            activeAudioTrack?.title != active.title ||
            activeAudioTrack?.language != active.language) {
          if (mounted) {
            setState(() {
              activeAudioTrack = active;
            });
          }
        }
      }
    } catch (_) {}
  }

  Future<void> setAudioTrack(AudioTrack track) async {
    resetAudioFallbackState();
    _requestedAudioLanguage = track.language ?? _preferredAudioLanguage();
    activeAudioTrack = track;
    await trackPlayer.setAudioTrack(track);
  }

  String? _preferredAudioLanguage() {
    for (final language in preferredAudioLanguagesCsv.split(',')) {
      final value = language.trim();
      if (value.isNotEmpty) return value;
    }
    return null;
  }

  List<AudioTrack> _audioTracksForFallback() {
    final tracks = trackPlayer.state.tracks.audio.toList();
    for (final sourceTrack
        in firstVideoForTracks.audios ?? const <vid.Track>[]) {
      final file = sourceTrack.file;
      if (file == null || file.isEmpty) continue;
      tracks.add(
        AudioTrack.uri(
          file,
          title: sourceTrack.label,
          language: sourceTrack.label,
        ),
      );
    }
    return tracks;
  }

  void resetAudioFallbackState({bool resetRequestedLanguage = false}) {
    _failedAudioTrackKeys.clear();
    _failedAudioCodecs.clear();
    _audioFallbackErrorQueued = false;
    if (resetRequestedLanguage) _requestedAudioLanguage = null;
  }

  Future<AudioTrack> _activeAudioTrackFn() async {
    final selectedAudio = trackPlayer.state.track.audio;
    if (selectedAudio.id != 'auto' && selectedAudio.id != 'no') {
      return selectedAudio;
    }

    final platform = trackPlayer.platform;
    if (platform is! NativePlayer) return selectedAudio;
    final aid = await _nativeAudioProperty(platform, 'aid');
    final explicitlySelected = _audioTrackForNativeId(aid);
    if (explicitlySelected != null) return explicitlySelected;
    final activeId = await _nativeAudioProperty(
      platform,
      'current-tracks/audio/id',
    );
    return _audioTrackForNativeId(activeId) ?? selectedAudio;
  }

  Future<String?> _nativeAudioProperty(
    NativePlayer platform,
    String property,
  ) async {
    try {
      final value = (await platform.getProperty(property)).trim();
      return value.isEmpty ? null : value;
    } catch (_) {
      return null;
    }
  }

  Future<String?> _nativePreferredAudioLanguage() async {
    final platform = trackPlayer.platform;
    if (platform is! NativePlayer) return null;
    final alang = await _nativeAudioProperty(platform, 'alang');
    for (final language in alang?.split(',') ?? const <String>[]) {
      final value = language.trim();
      if (value.isNotEmpty && value != 'auto') return value;
    }
    return null;
  }

  AudioTrack? _audioTrackForNativeId(String? id) {
    if (id == null || id == 'auto' || id == 'no' || id == '-1') return null;
    for (final track in trackPlayer.state.tracks.audio) {
      if (track.id == id) return track;
    }
    return AudioTrack(id, null, null);
  }

  bool _isVideoDecoderError(String? codec, AudioTrack activeAudio) {
    final normalized = codec?.trim().toLowerCase();
    if (normalized == null || normalized.isEmpty) return false;
    if (activeAudio.codec?.trim().toLowerCase() == normalized) return false;
    final hasAudioCodec = trackPlayer.state.tracks.audio.any(
      (track) => track.codec?.trim().toLowerCase() == normalized,
    );
    final hasVideoCodec = trackPlayer.state.tracks.video.any(
      (track) => track.codec?.trim().toLowerCase() == normalized,
    );
    return hasVideoCodec && !hasAudioCodec;
  }

  void reportPlaybackError(String error) {
    final message = error.trim();
    if (message.isEmpty || !isAudioDecoderInitializationError(message)) return;
    if (_audioFallbackInProgress) {
      _audioFallbackErrorQueued = true;
      return;
    }
    unawaited(_recoverFromAudioDecoderError(message));
  }

  Future<void> _recoverFromAudioDecoderError(String message) async {
    _audioFallbackInProgress = true;
    try {
      final failedTrack = await _activeAudioTrackFn();
      final failedCodec = audioDecoderCodecFromError(message);
      if (_isVideoDecoderError(failedCodec, failedTrack)) return;

      _failedAudioTrackKeys.add(audioTrackFallbackKey(failedTrack));
      if (failedCodec != null) {
        _failedAudioCodecs.add(failedCodec.toLowerCase());
      }
      final requestedLanguage =
          failedTrack.language ??
          _requestedAudioLanguage ??
          _preferredAudioLanguage() ??
          await _nativePreferredAudioLanguage();
      final candidates = audioTrackFallbackCandidates(
        failedTrack: failedTrack,
        availableTracks: _audioTracksForFallback(),
        requestedLanguage: requestedLanguage,
        failedTrackKeys: _failedAudioTrackKeys,
        failedCodecs: _failedAudioCodecs,
      );
      if (candidates.isEmpty) return;

      final fallback = candidates.first;
      _requestedAudioLanguage = requestedLanguage;
      AppLogger.log(
        'Audio decoder failed for ${audioTrackLabel(failedTrack)}; '
        'trying ${audioTrackLabel(fallback)}.',
        logLevel: LogLevel.warning,
      );
      await trackPlayer.setAudioTrack(fallback);
    } catch (error, stackTrace) {
      AppLogger.log(
        'Audio track fallback failed: $error\n$stackTrace',
        logLevel: LogLevel.error,
      );
    } finally {
      _audioFallbackInProgress = false;
      if (_audioFallbackErrorQueued) {
        _audioFallbackErrorQueued = false;
        unawaited(_recoverFromAudioDecoderError(message));
      }
    }
  }

  List<({String label, bool selected, VoidCallback onTap})> tvQualityOptions() {
    final videoQuality = buildVideoQualityOptions(
      player: trackPlayer,
      videos: trackVideos,
      isLocal: isLocalForTracks,
    );
    return videoQuality.map((quality) {
      final selected =
          selectedVideoPrefs.value!.videoTrack!.title ==
              quality.videoTrack!.title ||
          isLocalForTracks;
      return (
        label: isLocalForTracks
            ? firstVideoForTracks.quality
            : quality.videoTrack!.title!,
        selected: selected,
        onTap: () {
          if (selectedVideoPrefs.value?.videoTrack?.id ==
              quality.videoTrack?.id) {
            return;
          }
          selectedVideoPrefs.value = quality;
          trackPlayer.stop();
          if (quality.isLocal) {
            if (isLocalForTracks) {
              trackPlayer.setVideoTrack(quality.videoTrack!);
            } else {
              openMediaFromTrackSelection(quality);
            }
          } else {
            openMediaFromTrackSelection(quality);
          }
          initSubtitleAndAudio = true;
        },
      );
    }).toList();
  }

  List<({String label, bool selected, VoidCallback onTap})>
  tvSubtitleOptions() {
    final uniqueSubtitle = buildUniqueSubtitleOptions(
      player: trackPlayer,
      videos: trackVideos,
      isLocal: isLocalForTracks,
    );
    final effective = effectiveSubtitleTrack;
    return uniqueSubtitle.map((sub) {
      final isNone = sub.subtitle?.id == 'no';
      final title = isNone
          ? 'Off'
          : (sub.title ?? subtitleTrackLabel(sub.subtitle));
      final selected = isNone
          ? (effective == null || effective.id == 'no')
          : isSubtitleTrackSelected(sub.subtitle, effective);
      return (
        label: title,
        selected: selected,
        onTap: () {
          try {
            unawaited(setSubtitleTrack(sub.subtitle!));
          } catch (_) {}
        },
      );
    }).toList();
  }

  List<({String label, bool selected, VoidCallback onTap})> tvAudioOptions() {
    final uniqueAudio = buildUniqueAudioOptions(
      player: trackPlayer,
      videos: trackVideos,
      isLocal: isLocalForTracks,
    );
    final effective = effectiveAudioTrack;
    return uniqueAudio.map((aud) {
      final isNone = aud.audio?.id == "no";
      final title = isNone ? "Off" : (aud.title ?? audioTrackLabel(aud.audio));
      final selected = isNone
          ? (effective == null || effective.id == "no")
          : isAudioTrackSelected(aud.audio, effective);
      return (
        label: title,
        selected: selected,
        onTap: () {
          try {
            activeAudioTrack = aud.audio!;
            unawaited(setAudioTrack(aud.audio!));
          } catch (_) {}
        },
      );
    }).toList();
  }

  List<TvTrackOption> buildTvQualityOptions() {
    if (isLocalForTracks || trackVideos.isEmpty) return const <TvTrackOption>[];
    final currentTitle = selectedVideoPrefs.value?.videoTrack?.title;
    return [
      for (final video in trackVideos)
        TvTrackOption(
          label: shortQualityLabel(video.quality),
          selected: currentTitle == video.quality,
          onSelect: () {
            if (selectedVideoPrefs.value?.videoTrack?.title == video.quality) {
              return;
            }
            final prefs = VideoPrefs(
              videoTrack: VideoTrack(video.url, video.quality, video.quality),
              headers: video.headers,
              isLocal: false,
            );
            selectedVideoPrefs.value = prefs;
            trackPlayer.stop();
            openMediaFromTrackSelection(prefs);
            initSubtitleAndAudio = true;
          },
        ),
    ];
  }
}
