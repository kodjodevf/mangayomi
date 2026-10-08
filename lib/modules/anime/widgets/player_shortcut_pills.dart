import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/video.dart' as vid;
import 'package:mangayomi/modules/anime/providers/anime_player_controller_provider.dart';
import 'package:mangayomi/modules/anime/utils/audio_track_label.dart';
import 'package:mangayomi/modules/anime/utils/player_labels.dart';
import 'package:mangayomi/modules/anime/utils/video_prefs.dart';
import 'package:mangayomi/modules/anime/widgets/unified_settings_sheet.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:media_kit/media_kit.dart';

/// The row of shortcut pills in the player's bottom bar: quality, subtitles,
/// audio, speed and fit each open their section of the player settings,
/// followed by the full settings and the fullscreen toggle.
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
  });

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
        if (hasMultipleVideos)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.5),
            child: Builder(
              builder: (context) => ValueListenableBuilder<VideoPrefs?>(
                valueListenable: video,
                builder: (context, videoPrefs, _) {
                  final rawQuality =
                      videoPrefs?.videoTrack?.title ??
                      (videos.isNotEmpty ? videos.first.quality : '');
                  final qualityLabel = shortQualityLabel(rawQuality);
                  return PlayerPillButton(
                    icon: Icons.high_quality,
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
        _trackPill(
          builder: (context) {
            final subTrack = subtitleTrack();
            final isSubOff = subTrack == null || subTrack.id == 'no';
            final shortLabel = isSubOff
                ? ''
                : _shortTrackName(subtitleTrackLabel(subTrack));

            return PlayerPillButton(
              icon: Icons.subtitles_outlined,
              label: !isSubOff && shortLabel.isNotEmpty ? shortLabel : 'Off',
              showLabel: !iconOnly,
              tooltip: context.l10n.video_subtitle,
              isCompact: isMobile,
              onTap: () => onSubtitles(context),
            );
          },
        ),

        // Audio track shortcut pill (if multiple audio tracks or explicitly set)
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
              icon: Icons.audiotrack_outlined,
              label: shortLabel.isNotEmpty ? shortLabel : null,
              showLabel: !iconOnly,
              tooltip: context.l10n.video_audio,
              isCompact: isMobile,
              onTap: () => onAudio(context),
            );
          },
        ),

        // Playback speed pill
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.5),
          child: Builder(
            builder: (context) => ValueListenableBuilder<double>(
              valueListenable: playbackSpeed,
              builder: (context, speed, _) => PlayerPillButton(
                icon: Icons.speed,
                label: '${speed}x',
                showLabel: !iconOnly,
                tooltip: context.l10n.playback_speed,
                isCompact: isMobile,
                onTap: () => onSpeed(context),
              ),
            ),
          ),
        ),

        // Fit screen pill
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.5),
          child: ValueListenableBuilder<BoxFit>(
            valueListenable: fit,
            builder: (context, fit, _) => PlayerPillButton(
              icon: Icons.fit_screen_outlined,
              label: fitShortLabel(fit),
              showLabel: !iconOnly,
              tooltip: context.l10n.scale_type_fit_screen,
              isCompact: isMobile,
              onTap: onChangeFit,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.5),
          child: Builder(
            builder: (btnContext) => PlayerPillButton(
              icon: Icons.video_settings,
              tooltip: context.l10n.settings,
              isCompact: isMobile,
              onTap: () => onSettings(btnContext),
            ),
          ),
        ),

        if (!isTv)
          Consumer(
            builder: (context, ref, _) {
              final isFullscreen = ref.watch(fullscreenProvider);
              return Padding(
                padding: const EdgeInsets.only(left: 2.5, right: 5),
                child: PlayerPillButton(
                  icon: isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
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
    padding: const EdgeInsets.symmetric(horizontal: 2.5),
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
