import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riv;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/anime/mixins/anime_mpv_bridge_mixin.dart';
import 'package:mangayomi/modules/anime/mixins/anime_track_selection_mixin.dart';
import 'package:mangayomi/modules/anime/providers/auto_play_next_provider.dart';
import 'package:mangayomi/modules/anime/utils/audio_track_label.dart';
import 'package:mangayomi/modules/anime/utils/player_labels.dart';
import 'package:mangayomi/modules/anime/utils/player_shortcuts.dart';
import 'package:mangayomi/modules/anime/utils/temporary_playback_speed.dart';
import 'package:mangayomi/modules/anime/utils/track_list_builder.dart';
import 'package:mangayomi/modules/anime/utils/video_prefs.dart';
import 'package:mangayomi/modules/anime/widgets/audio_section_widget.dart';
import 'package:mangayomi/modules/anime/widgets/player_settings_sections.dart';
import 'package:mangayomi/modules/anime/widgets/subtitle_section_widget.dart';
import 'package:mangayomi/modules/anime/widgets/unified_settings_sheet.dart';
import 'package:mangayomi/modules/more/settings/keyboard_shortcuts/key_bindings.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:shiori/shiori.dart';

/// Builds and presents the unified settings menu (mobile bottom sheet and
/// desktop anchored popup) and its drilldown sections for the anime player.
mixin AnimePlayerSettingsMixin<T extends riv.ConsumerStatefulWidget>
    on
        riv.ConsumerState<T>,
        AnimeMpvBridgeMixin<T>,
        AnimeTrackSelectionMixin<T> {
  Chapter get settingsEpisode;
  GlobalKey<VideoState> get settingsVideoStateKey;
  ValueNotifier<double> get settingsPlaybackSpeed;
  ValueNotifier<BoxFit> get settingsFit;
  ValueNotifier<bool> get settingsAutoplayNext;
  Future<void> settingsSetPlaybackSpeed(double speed);
  Future<void> settingsShareScreenshot(
    BuildContext sheetContext,
    Chapter episode,
  );

  // Sections in the unified sheet: quality(0), audio(1), subtitles(2), appearance(3),
  // then chapters(4) when present, then speed, then fit.
  int get qualitySectionIndex => 0;
  int get audioSectionIndex => 1;
  int get subtitleSectionIndex => 2;
  int get chaptersSectionIndex => 4;
  int get speedSectionIndex => mpvChapterMarks.value.isNotEmpty ? 5 : 4;

  void _popSettings(BuildContext context) {
    final scope = SettingsDrilldownScope.of(context);
    if (scope != null && !scope.isDirectShortcut) {
      scope.goHome();
    } else if (scope != null) {
      scope.close();
    } else {
      Navigator.pop(context);
    }
  }

  Widget _videoQualityWidget(BuildContext context) {
    return VideoQualitySectionWidget(
      videoQuality: buildVideoQualityOptions(
        player: trackPlayer,
        videos: trackVideos,
        isLocal: isLocalForTracks,
      ),
      isLocal: isLocalForTracks,
      localQualityLabel: firstVideoForTracks.quality,
      currentVideo: selectedVideoPrefs.value,
      onSelect: (quality) {
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
      onDone: () => _popSettings(context),
    );
  }

  List<SettingsEntry> buildPlayerSettingsEntries(BuildContext context) {
    final hasSubtitleTrack = _computeHasSubtitleTrack();
    return [
      SettingsEntry(
        label: context.l10n.video_quality,
        icon: Symbols.hd_rounded,
        featured: true,
        valueBuilder: (context) => ValueListenableBuilder<VideoPrefs?>(
          valueListenable: selectedVideoPrefs,
          builder: (context, v, _) => Text(
            isLocalForTracks
                ? firstVideoForTracks.quality
                : (v?.videoTrack?.title ?? ''),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        contentBuilder: (context) => _videoQualityWidget(context),
      ),
      SettingsEntry(
        label: context.l10n.video_audio,
        icon: Symbols.graphic_eq_rounded,
        featured: true,
        valueBuilder: (context) => StreamBuilder<Track>(
          stream: trackPlayer.stream.track,
          initialData: trackPlayer.state.track,
          builder: (context, snapshot) {
            final effective = effectiveAudioTrack;
            if (effective == null || effective.id == 'no') {
              return Text(
                context.l10n.off,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            }
            final rawLabel = audioTrackLabel(effective);
            final label = (rawLabel.isNotEmpty && rawLabel != 'None')
                ? rawLabel
                : (effective.title ??
                      effective.language ??
                      effective.channels ??
                      '');
            return Text(
              label.isEmpty ? context.l10n.off : label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          },
        ),
        contentBuilder: (context) => _videoAudios(context),
      ),
      SettingsEntry(
        label: context.l10n.video_subtitle,
        icon: Symbols.closed_caption_rounded,
        featured: true,
        valueBuilder: (context) => StreamBuilder<Track>(
          stream: trackPlayer.stream.track,
          initialData: trackPlayer.state.track,
          builder: (context, snapshot) {
            final effective = effectiveSubtitleTrack;
            final rawLabel = subtitleTrackLabel(effective);
            final label = (rawLabel.isNotEmpty && rawLabel != 'None')
                ? rawLabel
                : (effective?.title ??
                      effective?.language ??
                      effective?.channels ??
                      '');
            return Text(
              (label.isEmpty || effective?.id == 'no')
                  ? context.l10n.off
                  : label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          },
        ),
        contentBuilder: (context) => _videoSubtitle(context),
      ),
      SettingsEntry(
        label: context.l10n.appearance,
        icon: Symbols.text_fields_rounded,
        group: context.l10n.group_subtitles,
        contentBuilder: (context) =>
            _appearanceSectionWidget(context, hasSubtitleTrack),
      ),
      if (mpvChapterMarks.value.isNotEmpty)
        SettingsEntry(
          label: context.l10n.chapters,
          icon: Symbols.bookmarks_rounded,
          group: context.l10n.group_playback,
          valueBuilder: (context) => ValueListenableBuilder<int?>(
            valueListenable: mpvCurrentChapterMark,
            builder: (context, i, _) => Text(
              i != null
                  ? mpvChapterMarks.value.elementAtOrNull(i)?.$1 ?? ''
                  : '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          contentBuilder: (context) => _chaptersSectionWidget(context),
        ),
      SettingsEntry(
        label: context.l10n.playback_speed,
        icon: Symbols.slow_motion_video_rounded,
        featured: true,
        valueBuilder: (context) => ValueListenableBuilder<double>(
          valueListenable: settingsPlaybackSpeed,
          builder: (context, v, _) => Text(temporaryPlaybackSpeedLabel(v)),
        ),
        contentBuilder: (context) => _speedSectionWidget(context),
      ),
      SettingsEntry(
        label: context.l10n.video_fit,
        icon: Symbols.aspect_ratio_rounded,
        group: context.l10n.group_playback,
        valueBuilder: (context) => ValueListenableBuilder<BoxFit>(
          valueListenable: settingsFit,
          builder: (context, fit, _) => Text(fitShortLabel(fit)),
        ),
        contentBuilder: (context) => _fitSectionWidget(context),
      ),
      SettingsEntry(
        label: context.l10n.autoplay_next,
        icon: Symbols.autoplay_rounded,
        group: context.l10n.group_playback,
        toggle: settingsAutoplayNext
          ..value = ref.read(autoPlayNextEpisodeProvider),
        onToggle: (on) {
          if (on != ref.read(autoPlayNextEpisodeProvider)) {
            ref.read(autoPlayNextEpisodeProvider.notifier).toggle();
          }
          settingsAutoplayNext.value = on;
        },
      ),
      if (mpvUseMpvConfig)
        SettingsEntry(
          label: context.l10n.shaders,
          icon: Symbols.auto_fix_high_rounded,
          group: context.l10n.advanced,
          valueBuilder: (context) => ValueListenableBuilder<String>(
            valueListenable: mpvSelectedShader,
            builder: (context, shader, _) => Text(
              shader.isEmpty ? context.l10n.off : shader,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          contentBuilder: (context) => _shadersSectionWidget(context),
        ),
      if (mpvUseMpvConfig)
        SettingsEntry(
          label: context.l10n.statistics,
          icon: Symbols.monitoring_rounded,
          group: context.l10n.advanced,
          contentBuilder: (context) => _statsSectionWidget(context),
        ),
      if (mpvUseMpvConfig && (mpvCustomButtons.value?.isNotEmpty ?? false))
        SettingsEntry(
          label: context.l10n.custom_buttons,
          icon: Symbols.smart_button_rounded,
          group: context.l10n.advanced,
          contentBuilder: (context) => _customButtonsSectionWidget(context),
        ),
      if (isDesktop)
        SettingsEntry(
          label: context.l10n.keyboard_shortcuts,
          icon: Symbols.keyboard_rounded,
          group: context.l10n.advanced,
          onTap: (sheetContext) {
            Navigator.pop(sheetContext);
            if (!mounted) return;
            showPlayerShortcuts(
              this.context,
              skipIntroSeconds: ref.read(defaultSkipIntroLengthStateProvider),
              shaders: mpvUseMpvConfig,
              bindings: ref.read(keyBindingsStateProvider),
            );
          },
        ),
      if (!isDesktop)
        SettingsEntry(
          label: context.l10n.share,
          icon: Icons.adaptive.share,
          group: context.l10n.group_playback,
          onTap: (sheetContext) {
            unawaited(settingsShareScreenshot(sheetContext, settingsEpisode));
          },
        ),
    ];
  }

  Future<void> openPlayerSettings(
    BuildContext context, {
    int initialIndex = -1,
  }) async {
    await syncActiveAudioTrackFromMpv();
    await syncActiveSubtitleTrackFromMpv();
    if (!context.mounted) return;
    final entries = buildPlayerSettingsEntries(context);
    if (isDesktop) {
      await showDesktopPlayerSettingsMenu(
        context,
        title: context.l10n.settings,
        entries: entries,
        initialIndex: initialIndex,
      );
      if (mounted) setState(() {});
      return;
    }
    final beside = playerSettingsOpenBeside(context);
    final wasPlaying = !beside && trackPlayer.state.playing;
    if (!beside) trackPlayer.pause();
    await showUnifiedPlayerSettings(
      context,
      title: context.l10n.settings,
      entries: entries,
      initialIndex: initialIndex,
    );
    if (!mounted) return;
    setState(() {});
    if (wasPlaying) trackPlayer.play();
  }

  bool _computeHasSubtitleTrack() {
    final realPlayerTracks = trackPlayer.state.tracks.subtitle.where(
      (e) =>
          e.id != 'auto' &&
          e.id != 'no' &&
          (e.title ?? e.language ?? e.channels ?? '').isNotEmpty,
    );
    final hasSourceTracks = trackVideos.any(
      (v) => (v.subtitles?.isNotEmpty ?? false),
    );
    return realPlayerTracks.isNotEmpty || hasSourceTracks;
  }

  Widget _appearanceSectionWidget(BuildContext context, bool hasSubtitleTrack) {
    return AppearanceSectionWidget(
      useLibass: mpvUseLibass,
      hasSubtitleTrack: hasSubtitleTrack,
    );
  }

  Widget _chaptersSectionWidget(BuildContext context) {
    return ChaptersSectionWidget(
      chapterMarks: mpvChapterMarks.value,
      currentChapterMark: mpvCurrentChapterMark,
      onSeek: (ms) => trackPlayer.seek(Duration(milliseconds: ms)),
      onDone: () => _popSettings(context),
    );
  }

  Widget _speedSectionWidget(BuildContext context) {
    return SpeedSectionWidget(
      playbackSpeed: settingsPlaybackSpeed,
      onSelect: settingsSetPlaybackSpeed,
      onDone: () => _popSettings(context),
    );
  }

  Widget _fitSectionWidget(BuildContext context) {
    return FitSectionWidget(
      fit: settingsFit,
      fitLabel: fitShortLabel,
      onSelect: (fit) {
        settingsFit.value = fit;
        settingsVideoStateKey.currentState?.update(fit: fit);
      },
      onDone: () => _popSettings(context),
    );
  }

  Widget _shadersSectionWidget(BuildContext context) {
    return ShadersSectionWidget(
      selectedShader: mpvSelectedShader,
      onSelect: (arg) => (trackPlayer.platform as NativePlayer).command([
        "script-message",
        arg,
      ]),
      onDone: () => _popSettings(context),
    );
  }

  Widget _statsSectionWidget(BuildContext context) {
    return StatsSectionWidget(
      onSelect: (arg) => (trackPlayer.platform as NativePlayer).command([
        "script-binding",
        arg,
      ]),
      onDone: () => _popSettings(context),
    );
  }

  Widget _customButtonsSectionWidget(BuildContext context) {
    return CustomButtonsSectionWidget(
      customButtons: mpvCustomButtons,
      onSelect: (btn) => (trackPlayer.platform as NativePlayer).command([
        "script-message",
        "call_button_${btn.id}",
      ]),
      onDone: () => _popSettings(context),
    );
  }

  Widget _videoSubtitle(BuildContext context) {
    return SubtitleSectionWidget(
      player: trackPlayer,
      videos: trackVideos,
      isLocal: isLocalForTracks,
      episode: settingsEpisode,
      effectiveSubtitleTrack: effectiveSubtitleTrack,
      isTrackSelected: isSubtitleTrackSelected,
      onSetSubtitleTrack: setSubtitleTrack,
      subDelayController: mpvSubDelayController,
      subSpeedController: mpvSubSpeedController,
      onDone: () => _popSettings(context),
    );
  }

  Widget _videoAudios(BuildContext context) {
    return AudioSectionWidget(
      audioOptions: buildUniqueAudioOptions(
        player: trackPlayer,
        videos: trackVideos,
        isLocal: isLocalForTracks,
      ),
      effectiveAudioTrack: effectiveAudioTrack,
      isTrackSelected: isAudioTrackSelected,
      onSelect: (track) {
        activeAudioTrack = track;
        unawaited(setAudioTrack(track));
      },
      onDone: () => _popSettings(context),
    );
  }
}
