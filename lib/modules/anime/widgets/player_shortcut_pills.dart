import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/anime/utils/temporary_playback_speed.dart';
import 'package:mangayomi/models/video.dart' as vid;
import 'package:mangayomi/modules/anime/providers/anime_player_controller_provider.dart';
import 'package:mangayomi/modules/anime/utils/audio_track_label.dart';
import 'package:mangayomi/modules/anime/utils/player_labels.dart';
import 'package:mangayomi/modules/anime/utils/video_prefs.dart';
import 'package:mangayomi/modules/anime/widgets/unified_settings_sheet.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:media_kit/media_kit.dart';

/// The pills [PlayerShortcutPills] can show.
enum PlayerPill { quality, subtitles, audio, speed, fit, settings, fullscreen }

/// The row of shortcut pills in the player's bars: quality, subtitles,
/// audio, speed and fit each open their section of the player settings,
/// followed by the full settings and the fullscreen toggle. [pills] picks
/// which, so a phone can put the stream's at the top and the playback's at
/// the foot.
class PlayerShortcutPills extends StatelessWidget {
  const PlayerShortcutPills({
    super.key,
    required this.videos,
    required this.video,
    required this.player,
    required this.subtitleTrack,
    required this.audioTrack,
    required this.playbackSpeed,
    required this.fit,
    required this.onQuality,
    required this.onSubtitles,
    required this.onAudio,
    required this.onSpeed,
    required this.onSettings,
    required this.onChangeFit,
    required this.onToggleFullscreen,
    this.iconOnly = false,
    this.pills = const {...PlayerPill.values},
  });

  final Set<PlayerPill> pills;

  final List<vid.Video> videos;
  final ValueNotifier<VideoPrefs?> video;
  final Player player;
  final SubtitleTrack? Function() subtitleTrack;
  final AudioTrack? Function() audioTrack;
  final ValueNotifier<double> playbackSpeed;
  final ValueNotifier<BoxFit> fit;
  final ValueChanged<BuildContext> onQuality;
  final ValueChanged<BuildContext> onSubtitles;
  final ValueChanged<BuildContext> onAudio;
  final ValueChanged<BuildContext> onSpeed;
  final ValueChanged<BuildContext> onSettings;
  final VoidCallback onChangeFit;
  final bool iconOnly;

  /// Called with whether the player is fullscreen now.
  final ValueChanged<bool> onToggleFullscreen;

  @override
  Widget build(BuildContext context) {
    final hasMultipleVideos = videos.length > 1;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Quality shortcut pill
        if (hasMultipleVideos && pills.contains(PlayerPill.quality))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s4),
            child: Builder(
              builder: (context) => ValueListenableBuilder<VideoPrefs?>(
                valueListenable: video,
                builder: (context, videoPrefs, _) {
                  final rawQuality =
                      videoPrefs?.videoTrack?.title ??
                      (videos.isNotEmpty ? videos.first.quality : '');
                  final qualityLabel = shortQualityLabel(rawQuality);
                  return PlayerPillButton(
                    icon: Symbols.hd_rounded,
                    label: qualityLabel.isNotEmpty ? qualityLabel : null,
                    showLabel: !iconOnly,
                    tooltip: context.l10n.video_quality,
                    isCompact: isMobile,
                    onTap: () => onQuality(context),
                  );
                },
              ),
            ),
          ),

        // Subtitles CC shortcut pill
        if (pills.contains(PlayerPill.subtitles))
          _trackPill(
            builder: (context) {
              final subTrack = subtitleTrack();
              final isSubOff = subTrack == null || subTrack.id == 'no';
              final shortLabel = isSubOff
                  ? ''
                  : _shortTrackName(subtitleTrackLabel(subTrack));

              return PlayerPillButton(
                icon: Symbols.closed_caption_rounded,
                label: !isSubOff && shortLabel.isNotEmpty ? shortLabel : 'Off',
                showLabel: !iconOnly,
                tooltip: context.l10n.video_subtitle,
                isCompact: isMobile,
                onTap: () => onSubtitles(context),
              );
            },
          ),

        // Audio track shortcut pill (if multiple audio tracks or explicitly set)
        if (pills.contains(PlayerPill.audio))
          _trackPill(
            builder: (context) {
              final track = audioTrack();
              final isAudioOff = track == null || track.id == 'no';
              final shortLabel = isAudioOff
                  ? ''
                  : _shortTrackName(audioTrackLabel(track));
              final hasMultipleAudios =
                  player.state.tracks.audio.length > 1 ||
                  videos.any((v) => (v.audios?.length ?? 0) > 1);

              if (!hasMultipleAudios && shortLabel.isEmpty) {
                return const SizedBox.shrink();
              }

              return PlayerPillButton(
                icon: Symbols.graphic_eq_rounded,
                label: shortLabel.isNotEmpty ? shortLabel : null,
                showLabel: !iconOnly,
                tooltip: context.l10n.video_audio,
                isCompact: isMobile,
                onTap: () => onAudio(context),
              );
            },
          ),

        // Playback speed pill
        if (pills.contains(PlayerPill.speed))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s4),
            child: Builder(
              builder: (context) => ValueListenableBuilder<double>(
                valueListenable: playbackSpeed,
                builder: (context, speed, _) => PlayerPillButton(
                  icon: Symbols.slow_motion_video_rounded,
                  label: temporaryPlaybackSpeedLabel(speed),
                  showLabel: !iconOnly,
                  tooltip: context.l10n.playback_speed,
                  isCompact: isMobile,
                  onTap: () => onSpeed(context),
                ),
              ),
            ),
          ),

        // Fit screen pill
        if (pills.contains(PlayerPill.fit))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s4),
            child: ValueListenableBuilder<BoxFit>(
              valueListenable: fit,
              builder: (context, fit, _) => PlayerPillButton(
                icon: Symbols.aspect_ratio_rounded,
                label: fitShortLabel(fit),
                showLabel: !iconOnly,
                tooltip: context.l10n.scale_type_fit_screen,
                isCompact: isMobile,
                onTap: onChangeFit,
              ),
            ),
          ),

        if (pills.contains(PlayerPill.settings))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s4),
            child: Builder(
              builder: (btnContext) => PlayerPillButton(
                icon: Symbols.tune_rounded,
                tooltip: context.l10n.settings,
                isCompact: isMobile,
                onTap: () => onSettings(btnContext),
              ),
            ),
          ),

        if (!isTv && pills.contains(PlayerPill.fullscreen))
          Consumer(
            builder: (context, ref, _) {
              final isFullscreen = ref.watch(fullscreenProvider);
              return Padding(
                padding: const EdgeInsets.only(
                  left: ShioriSpace.s4,
                  right: ShioriSpace.s4,
                ),
                child: PlayerPillButton(
                  icon: isFullscreen
                      ? Symbols.fullscreen_exit_rounded
                      : Symbols.fullscreen_rounded,
                  tooltip: context.l10n.fullscreen,
                  isCompact: isMobile,
                  onTap: () => onToggleFullscreen(isFullscreen),
                ),
              );
            },
          ),
      ],
    );
  }

  /// A pill that rebuilds whenever mpv reports a track change.
  Widget _trackPill({required WidgetBuilder builder}) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s4),
    child: Builder(
      builder: (context) => StreamBuilder<Track>(
        stream: player.stream.track,
        builder: (context, _) => builder(context),
      ),
    ),
  );

  String _shortTrackName(String rawName) =>
      rawName.isNotEmpty && rawName != 'None' ? shortTrackLabel(rawName) : '';
}
