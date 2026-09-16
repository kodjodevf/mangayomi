import 'package:mangayomi/models/video.dart' as vid;
import 'package:mangayomi/modules/anime/utils/audio_track_label.dart';
import 'package:mangayomi/modules/anime/utils/video_prefs.dart';
import 'package:media_kit/media_kit.dart';

/// Pure builders for the player's track-selection lists (video quality,
/// subtitle, audio). Shared by the settings-sheet widgets and the TV
/// d-pad panel, which used to each recompute the same dedup/sort/label
/// logic independently.
///
/// [player] is only read for its currently-loaded tracks, never mutated;
/// none of these touch playback state.
List<VideoPrefs> buildVideoQualityOptions({
  required Player player,
  required List<vid.Video> videos,
  required bool isLocal,
}) {
  final videoQuality = player.state.tracks.video
      .where((element) => element.w != null && element.h != null && isLocal)
      .toList()
      .map((e) => VideoPrefs(videoTrack: e, isLocal: true))
      .toList();

  if (videos.isNotEmpty && !isLocal) {
    for (var video in videos) {
      videoQuality.add(
        VideoPrefs(
          videoTrack: VideoTrack(video.url, video.quality, video.quality),
          headers: video.headers,
          isLocal: false,
        ),
      );
    }
  }
  return videoQuality;
}

List<VideoPrefs> buildUniqueSubtitleOptions({
  required Player player,
  required List<vid.Video> videos,
  required bool isLocal,
}) {
  List<VideoPrefs> videoSubtitle = player.state.tracks.subtitle
      .where((e) => e.id != 'auto' && e.id != 'no')
      .map((e) => VideoPrefs(isLocal: true, subtitle: e))
      .toList();

  final subs = <String>[];
  if (videos.isNotEmpty) {
    for (var video in videos) {
      for (var sub in video.subtitles ?? []) {
        if (!subs.contains(sub.file)) {
          final file = sub.file!;
          final label = sub.label;
          videoSubtitle.add(
            VideoPrefs(
              isLocal: isLocal,
              subtitle: (file.startsWith("http") || file.startsWith("file"))
                  ? SubtitleTrack.uri(file, title: label, language: label)
                  : SubtitleTrack.data(file, title: label, language: label),
            ),
          );
          subs.add(sub.file!);
        }
      }
    }
  }

  videoSubtitle = videoSubtitle
      .map((e) {
        final label = subtitleTrackLabel(e.subtitle);
        e.title = (label.isNotEmpty && label != 'None')
            ? label
            : (e.subtitle?.title ??
                  e.subtitle?.language ??
                  e.subtitle?.channels ??
                  (e.subtitle?.id != 'auto' && e.subtitle?.id != 'no'
                      ? e.subtitle?.id
                      : null) ??
                  "");
        return e;
      })
      .toList()
      .where((element) => element.title!.isNotEmpty)
      .toList();

  final seen = <String>{};
  final uniqueSubtitle = <VideoPrefs>[];
  for (var element in videoSubtitle) {
    final key = element.subtitle?.id ?? element.title ?? '';
    if (key.isNotEmpty && seen.add(key)) {
      uniqueSubtitle.add(element);
    }
  }
  uniqueSubtitle.sort((a, b) => (a.title ?? '').compareTo(b.title ?? ''));
  uniqueSubtitle.insert(0, VideoPrefs(isLocal: false, subtitle: SubtitleTrack.no()));
  return uniqueSubtitle;
}

List<VideoPrefs> buildUniqueAudioOptions({
  required Player player,
  required List<vid.Video> videos,
  required bool isLocal,
}) {
  List<VideoPrefs> videoAudio = player.state.tracks.audio
      .where((e) => e.id != 'auto' && e.id != 'no')
      .map((e) => VideoPrefs(isLocal: true, audio: e))
      .toList();

  final audios = <String>[];
  if (videos.isNotEmpty && !isLocal) {
    for (var video in videos) {
      for (var audio in video.audios ?? []) {
        if (!audios.contains(audio.file)) {
          videoAudio.add(
            VideoPrefs(
              isLocal: false,
              audio: AudioTrack.uri(
                audio.file!,
                title: audio.label,
                language: audio.label,
              ),
            ),
          );
          audios.add(audio.file!);
        }
      }
    }
  }

  videoAudio = videoAudio
      .map((e) {
        final label = audioTrackLabel(e.audio);
        e.title = (label.isNotEmpty && label != 'None')
            ? label
            : (e.audio?.title ??
                  e.audio?.language ??
                  e.audio?.channels ??
                  (e.audio?.id != 'auto' && e.audio?.id != 'no'
                      ? e.audio?.id
                      : null) ??
                  "");
        return e;
      })
      .toList()
      .where((element) => element.title!.isNotEmpty)
      .toList();

  final seen = <String>{};
  final uniqueAudio = <VideoPrefs>[];
  for (var element in videoAudio) {
    final key = element.audio?.id ?? element.title ?? '';
    if (key.isNotEmpty && seen.add(key)) {
      uniqueAudio.add(element);
    }
  }
  uniqueAudio.sort((a, b) => (a.title ?? '').compareTo(b.title ?? ''));
  uniqueAudio.insert(0, VideoPrefs(isLocal: false, audio: AudioTrack.no()));
  return uniqueAudio;
}
