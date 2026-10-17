import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/custom_button.dart';
import 'package:mangayomi/modules/anime/providers/state_provider.dart';
import 'package:mangayomi/modules/anime/utils/video_prefs.dart';
import 'package:mangayomi/modules/anime/widgets/subtitle_setting_widget.dart';
import 'package:mangayomi/modules/anime/widgets/unified_settings_sheet.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';

/// The player settings sheet's "video quality" section: one row per
/// available quality, selecting it (unless it's already active) via
/// [onSelect]. [currentVideo] is read once, not reactively - this section is
/// rebuilt fresh each time it's opened, same as the original inline builder.
class VideoQualitySectionWidget extends StatelessWidget {
  final List<VideoPrefs> videoQuality;
  final bool isLocal;
  final String localQualityLabel;
  final VideoPrefs? currentVideo;
  final void Function(VideoPrefs quality) onSelect;
  final VoidCallback onDone;

  const VideoQualitySectionWidget({
    super.key,
    required this.videoQuality,
    required this.isLocal,
    required this.localQualityLabel,
    required this.currentVideo,
    required this.onSelect,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Column(
        children: videoQuality.map((quality) {
          final selected =
              currentVideo!.videoTrack!.title == quality.videoTrack!.title ||
              isLocal;
          return SettingsOptionRow(
            label: isLocal ? localQualityLabel : quality.videoTrack!.title!,
            selected: selected,
            onTap: () {
              if (currentVideo?.videoTrack?.id == quality.videoTrack?.id) {
                onDone();
                return;
              }
              onSelect(quality);
              onDone();
            },
          );
        }).toList(),
      ),
    );
  }
}

/// The player settings sheet's "chapters" section, one row per chapter mark.
class ChaptersSectionWidget extends StatelessWidget {
  final List<(String, int)> chapterMarks;
  final ValueListenable<int?> currentChapterMark;
  final void Function(int milliseconds) onSeek;
  final VoidCallback onDone;

  const ChaptersSectionWidget({
    super.key,
    required this.chapterMarks,
    required this.currentChapterMark,
    required this.onSeek,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int?>(
      valueListenable: currentChapterMark,
      builder: (context, current, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Column(
          children: chapterMarks.asMap().entries.map((entry) {
            final index = entry.key;
            final mark = entry.value;
            return SettingsOptionRow(
              label: mark.$1,
              hint: Duration(milliseconds: mark.$2).label(),
              selected: current == index,
              onTap: () {
                onSeek(mark.$2);
                onDone();
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// The player settings sheet's "playback speed" section.
class SpeedSectionWidget extends StatelessWidget {
  static const speeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.50, 1.75, 2.0];

  final ValueListenable<double> playbackSpeed;
  final ValueChanged<double> onSelect;
  final VoidCallback onDone;

  const SpeedSectionWidget({
    super.key,
    required this.playbackSpeed,
    required this.onSelect,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Column(
        children: speeds.map((speed) {
          return ValueListenableBuilder<double>(
            valueListenable: playbackSpeed,
            builder: (context, current, _) => SettingsOptionRow(
              label: '${speed}x',
              selected: current == speed,
              onTap: () {
                onSelect(speed);
                onDone();
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// The player settings sheet's "video fit" section.
class FitSectionWidget extends StatelessWidget {
  static const fits = [
    BoxFit.contain,
    BoxFit.cover,
    BoxFit.fill,
    BoxFit.fitHeight,
    BoxFit.fitWidth,
    BoxFit.scaleDown,
    BoxFit.none,
  ];

  final ValueListenable<BoxFit> fit;
  final String Function(BoxFit) fitLabel;
  final ValueChanged<BoxFit> onSelect;
  final VoidCallback onDone;

  const FitSectionWidget({
    super.key,
    required this.fit,
    required this.fitLabel,
    required this.onSelect,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Column(
        children: fits.map((f) {
          return ValueListenableBuilder<BoxFit>(
            valueListenable: fit,
            builder: (context, current, _) => SettingsOptionRow(
              label: fitLabel(f),
              selected: current == f,
              onTap: () {
                onSelect(f);
                onDone();
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// The player settings sheet's "shaders" section (mpv GLSL shader presets).
class ShadersSectionWidget extends StatelessWidget {
  static const shaderModes = [
    ("Anime4K: Mode A (Fast)", "set_anime_a"),
    ("Anime4K: Mode B (Fast)", "set_anime_b"),
    ("Anime4K: Mode C (Fast)", "set_anime_c"),
    ("Anime4K: Mode A+A (Fast)", "set_anime_aa"),
    ("Anime4K: Mode B+B (Fast)", "set_anime_bb"),
    ("Anime4K: Mode C+A (Fast)", "set_anime_ca"),
    ("Anime4K: Mode A (HQ)", "set_anime_hq_a"),
    ("Anime4K: Mode B (HQ)", "set_anime_hq_b"),
    ("Anime4K: Mode C (HQ)", "set_anime_hq_c"),
    ("Anime4K: Mode A+A (HQ)", "set_anime_hq_aa"),
    ("Anime4K: Mode B+B (HQ)", "set_anime_hq_bb"),
    ("Anime4K: Mode C+A (HQ)", "set_anime_hq_ca"),
    ("AMD FSR", "set_fsr"),
    ("Luma Upscaling", "set_luma"),
    ("Qualcomm Snapdragon GSR", "set_snapdragon"),
    ("NVIDIA Image Scaling", "set_nvidia"),
    ("Clear GLSL shaders", "clear_anime"),
  ];

  final ValueListenable<String> selectedShader;
  final void Function(String scriptMessageArg) onSelect;
  final VoidCallback onDone;

  const ShadersSectionWidget({
    super.key,
    required this.selectedShader,
    required this.onSelect,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: selectedShader,
      builder: (context, selected, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Column(
          children: shaderModes.map((mode) {
            return SettingsOptionRow(
              label: mode.$1,
              selected: selected == mode.$1,
              onTap: () {
                onSelect(mode.$2);
                onDone();
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// The player settings sheet's "statistics" section (mpv stats overlay
/// pages). Not really selectable state - each row just fires an mpv
/// script-binding - so unlike the others, no row is ever shown checked.
class StatsSectionWidget extends StatelessWidget {
  static const statsModes = [
    ("Stats Toggle", "stats/display-stats-toggle"),
    ("Stats Page 1", "stats/display-page-1"),
    ("Stats Page 2", "stats/display-page-2"),
    ("Stats Page 3", "stats/display-page-3"),
    ("Stats Page 4", "stats/display-page-4"),
    ("Stats Page 5", "stats/display-page-5"),
  ];

  final void Function(String scriptBindingArg) onSelect;
  final VoidCallback onDone;

  const StatsSectionWidget({
    super.key,
    required this.onSelect,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Column(
        children: statsModes.map((mode) {
          return SettingsOptionRow(
            label: mode.$1,
            selected: false,
            onTap: () {
              onSelect(mode.$2);
              onDone();
            },
          );
        }).toList(),
      ),
    );
  }
}

/// The player settings sheet's "custom buttons" section (user-defined mpv
/// script-message shortcuts).
class CustomButtonsSectionWidget extends StatelessWidget {
  final ValueListenable<List<CustomButton>?> customButtons;
  final void Function(CustomButton button) onSelect;
  final VoidCallback onDone;

  const CustomButtonsSectionWidget({
    super.key,
    required this.customButtons,
    required this.onSelect,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CustomButton>?>(
      valueListenable: customButtons,
      builder: (context, buttons, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Column(
          children: (buttons ?? []).map((btn) {
            return SettingsOptionRow(
              label: btn.title!,
              selected: false,
              onTap: () {
                onSelect(btn);
                onDone();
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// The player settings sheet's "appearance" section: the ASS-subtitle
/// override switch (only when libass is in use) plus the shared subtitle
/// appearance controls (font, color, position...).
class AppearanceSectionWidget extends ConsumerWidget {
  final bool useLibass;
  final bool hasSubtitleTrack;

  const AppearanceSectionWidget({
    super.key,
    required this.useLibass,
    required this.hasSubtitleTrack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // FontSettingWidget/ColorSettingWidget style themselves from the ambient
    // Theme - they used to open inside their own draggable menu.
    // Forced dark here so they stay legible against this sheet's dark ground
    // even when the app itself runs in light mode.
    return Theme(
      data: ThemeData.dark(useMaterial3: true),
      child: Column(
        children: [
          if (useLibass) ...[
            Consumer(
              builder: (context, ref, _) {
                final overrideAss = ref.watch(overrideAssSubtitlesStateProvider);
                return SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  value: overrideAss,
                  title: Text(
                    context.l10n.override_ass_subtitles,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    context.l10n.override_ass_subtitles_info,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  onChanged: (val) {
                    ref
                        .read(subtitleSettingsStateProvider.notifier)
                        .setOverrideAss(val);
                  },
                );
              },
            ),
            const Divider(height: 1, color: Color(0x14FFFFFF)),
          ],
          SubtitleAppearanceWidget(hasSubtitleTrack: hasSubtitleTrack),
        ],
      ),
    );
  }
}
