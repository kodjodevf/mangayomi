import 'package:mangayomi/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_switches.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_mode_glyph.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/modules/reader_common/utils/reader_orientation.dart';
import 'package:mangayomi/services/volume_keys.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/reader_state_provider.dart';

/// The groups the reader settings are split into, each its own screen.
enum ReaderSettingsSection {
  mode(Symbols.chrome_reader_mode_rounded),
  layout(Symbols.auto_stories_rounded),
  navigation(Symbols.touch_app_rounded),
  swipe(Symbols.swipe_rounded);

  const ReaderSettingsSection(this.icon);

  final IconData icon;

  String title(BuildContext context) => switch (this) {
    mode => context.l10n.reading_mode,
    layout => context.l10n.page_layout,
    navigation => context.l10n.navigation_layout,
    swipe => context.l10n.chapter_swipe_actions,
  };

  /// What the screen holds, under its title in the list.
  String summary(BuildContext context) => switch (this) {
    mode => context.l10n.reader_section_mode_summary,
    layout => context.l10n.reader_section_layout_summary,
    navigation => context.l10n.reader_section_navigation_summary,
    swipe => context.l10n.reader_section_swipe_summary,
  };
}

class ReaderScreen extends ConsumerWidget {
  const ReaderScreen({super.key, this.section});

  /// The group to show; null shows the list of groups.
  final ReaderSettingsSection? section;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ── Reading Mode & Display ──
    final defaultReadingMode = ref.watch(defaultReadingModeStateProvider);
    final doubleTapAnimationSpeed = ref.watch(
      doubleTapAnimationSpeedStateProvider,
    );
    final pagePreloadAmount = ref.watch(pagePreloadAmountStateProvider);
    final scaleType = ref.watch(scaleTypeStateProvider);
    final backgroundColor = ref.watch(backgroundColorStateProvider);
    final fullScreenReader = ref.watch(fullScreenReaderStateProvider);
    final webtoonSidePadding = ref.watch(webtoonSidePaddingStateProvider);

    // ── Page Layout & Zoom ──
    final splitWidePages = ref.watch(splitWidePagesStateProvider);
    final dualPageRotateToFit = ref.watch(dualPageRotateToFitStateProvider);
    final landscapeZoom = ref.watch(landscapeZoomStateProvider);
    final zoomStartPosition = ref.watch(zoomStartPositionStateProvider);

    // ── Navigation & Tap Zones ──
    final navigationLayout = ref.watch(readerNavigationLayoutStateProvider);
    final tappingInversion = ref.watch(tappingInversionStateProvider);
    final readerHideThreshold = ref.watch(readerHideThresholdStateProvider);
    final flashOnPageChange = ref.watch(flashOnPageChangeStateProvider);
    final flashColor = ref.watch(flashColorStateProvider);
    final flashInterval = ref.watch(flashIntervalStateProvider);
    final flashDuration = ref.watch(flashDurationStateProvider);
    final chapterSwipeStart = ref.watch(chapterSwipeStartActionStateProvider);
    final chapterSwipeEnd = ref.watch(chapterSwipeEndActionStateProvider);

    final l10n = context.l10n;
    List<ShioriChoice<int>> named(List<String> names) => [
      for (final (i, name) in names.indexed) ShioriChoice(i, name),
    ];

    final sections = <ReaderSettingsSection, List<Widget>>{
      ReaderSettingsSection.mode: [
        ShioriSettingsGroup(
          title: l10n.display,
          children: [
            ShioriValueRow<ReaderMode>(
              title: l10n.default_reading_mode,
              value: defaultReadingMode,
              options: [
                for (final mode in ReaderMode.values)
                  ShioriChoice(
                    mode,
                    getReaderModeName(mode, context),
                    leading: ReaderModeGlyph(mode),
                  ),
              ],
              onChanged: (v) =>
                  ref.read(defaultReadingModeStateProvider.notifier).set(v),
            ),
            ShioriValueRow<ScaleType>(
              title: l10n.scale_type,
              value: scaleType,
              options: [
                for (final (i, name) in getScaleTypeNames(context).indexed)
                  ShioriChoice(ScaleType.values[i], name),
              ],
              onChanged: (v) =>
                  ref.read(scaleTypeStateProvider.notifier).set(v),
            ),
            ShioriValueRow<BackgroundColor>(
              title: l10n.background_color,
              value: backgroundColor,
              options: [
                for (final color in BackgroundColor.values)
                  ShioriChoice(color, getBackgroundColorName(color, context)),
              ],
              onChanged: (v) =>
                  ref.read(backgroundColorStateProvider.notifier).set(v),
            ),
            if (!isMobile)
              ShioriSwitchRow(
                title: l10n.fullscreen,
                value: fullScreenReader,
                onChanged: (v) =>
                    ref.read(fullScreenReaderStateProvider.notifier).set(v),
              ),
            const ReaderOrientationRow(),
            const ReaderScreenBrightnessRow(),
            const ReaderSwitchRow(ReaderSwitch.showPageNumber),
          ],
        ),
        ShioriSettingsGroup(
          title: l10n.group_reading,
          children: [
            const ReaderSwitchRow(ReaderSwitch.animatePageTransitions),
            ShioriValueRow<int>(
              title: l10n.double_tap_animation_speed,
              value: doubleTapAnimationSpeed,
              options: named([
                for (var i = 0; i < 3; i++) getAnimationSpeedName(i, context),
              ]),
              onChanged: (v) => ref
                  .read(doubleTapAnimationSpeedStateProvider.notifier)
                  .set(v),
            ),
            ShioriSliderRow(
              title: l10n.page_preload_amount,
              subtitle: l10n.page_preload_amount_subtitle,
              value: pagePreloadAmount.toDouble(),
              min: 1,
              max: 20,
              divisions: 19,
              defaultValue: 6,
              onReset: () =>
                  ref.read(pagePreloadAmountStateProvider.notifier).set(6),
              resetTooltip: l10n.reset,
              onChanged: (v) => ref
                  .read(pagePreloadAmountStateProvider.notifier)
                  .set(v.round()),
            ),
            const ReaderSwitchRow(ReaderSwitch.cropBorders),
            const ReaderSwitchRow(ReaderSwitch.navigateToPan),
            const ReaderSwitchRow(ReaderSwitch.keepScreenOn),
            const ReaderSwitchRow(ReaderSwitch.markDuplicateChaptersRead),
            const ReaderSwitchRow(ReaderSwitch.skipReadChapters),
            const ReaderSwitchRow(ReaderSwitch.skipFilteredChapters),
            const ReaderSwitchRow(ReaderSwitch.skipDuplicateChapters),
          ],
        ),
        ShioriSettingsGroup(
          title: l10n.reading_mode_webtoon,
          children: [
            const ReaderSwitchRow(ReaderSwitch.webtoonDisableZoomOut),
            const ReaderSwitchRow(ReaderSwitch.webtoonDoubleTapZoom),
            const ReaderSwitchRow(ReaderSwitch.showPageGaps),
            const ReaderSwitchRow(ReaderSwitch.splitTallImages),
            ShioriSliderRow(
              title: l10n.webtoon_side_padding,
              value: webtoonSidePadding.toDouble(),
              min: 0,
              max: 50,
              divisions: 50,
              valueLabel: (v) => '${v.round()} %',
              defaultValue: 0,
              onReset: () =>
                  ref.read(webtoonSidePaddingStateProvider.notifier).set(0),
              resetTooltip: l10n.reset,
              onChanged: (v) => ref
                  .read(webtoonSidePaddingStateProvider.notifier)
                  .set(v.round()),
            ),
          ],
        ),
      ],
      ReaderSettingsSection.layout: [
        ShioriSettingsGroup(
          children: [
            const ReaderSwitchRow(ReaderSwitch.splitWidePages),
            if (splitWidePages)
              const ReaderSwitchRow(ReaderSwitch.dualPageInvert),
            const ReaderSwitchRow(ReaderSwitch.dualPageRotateToFit),
            if (dualPageRotateToFit)
              const ReaderSwitchRow(ReaderSwitch.dualPageRotateToFitInvert),
            const ReaderSwitchRow(ReaderSwitch.doublePageSingleFirstPage),
            const ReaderSwitchRow(ReaderSwitch.doublePageAuto),
            const ReaderSwitchRow(ReaderSwitch.landscapeZoom),
            if (landscapeZoom)
              ShioriValueRow<int>(
                title: l10n.zoom_start_position,
                value: zoomStartPosition,
                options: named([
                  l10n.zoom_start_left,
                  l10n.zoom_start_right,
                  l10n.zoom_start_center,
                ]),
                onChanged: (v) =>
                    ref.read(zoomStartPositionStateProvider.notifier).set(v),
              ),
          ],
        ),
      ],
      ReaderSettingsSection.navigation: [
        ShioriSettingsGroup(
          children: [
            const ReaderSwitchRow(ReaderSwitch.usePageTapZones),
            ShioriValueRow<int>(
              title: l10n.navigation_layout,
              value: navigationLayout,
              options: named([
                for (var i = 0; i < 6; i++) _navLayoutNameGlobal(i, context),
              ]),
              onChanged: (v) =>
                  ref.read(readerNavigationLayoutStateProvider.notifier).set(v),
            ),
            ShioriValueRow<int>(
              title: l10n.tapping_inversion,
              value: tappingInversion,
              options: named([
                l10n.tapping_inversion_none,
                l10n.tapping_inversion_horizontal,
                l10n.tapping_inversion_vertical,
                l10n.tapping_inversion_both,
              ]),
              onChanged: (v) =>
                  ref.read(tappingInversionStateProvider.notifier).set(v),
            ),
            ShioriValueRow<int>(
              title: l10n.reader_hide_threshold,
              value: readerHideThreshold,
              options: named([
                l10n.reader_hide_threshold_highest,
                l10n.reader_hide_threshold_high,
                l10n.reader_hide_threshold_low,
                l10n.reader_hide_threshold_lowest,
              ]),
              onChanged: (v) =>
                  ref.read(readerHideThresholdStateProvider.notifier).set(v),
            ),
            const ReaderSwitchRow(ReaderSwitch.showNavigationOverlayOnStart),
            // The volume buttons as page turns, where a phone has them.
            if (VolumeKeys.isSupported) ...[
              const ReaderSwitchRow(ReaderSwitch.volumeKeysPaging),
              if (ref.watch(volumeKeysPagingStateProvider))
                const ReaderSwitchRow(ReaderSwitch.volumeKeysInverted),
            ],
          ],
        ),
        ShioriSettingsGroup(
          title: l10n.flash_on_page_change,
          children: [
            const ReaderSwitchRow(ReaderSwitch.flashOnPageChange),
            if (flashOnPageChange) ...[
              ShioriValueRow<int>(
                title: l10n.flash_color,
                value: flashColor,
                options: named([
                  l10n.flash_color_black,
                  l10n.flash_color_white,
                  l10n.flash_color_white_black,
                ]),
                onChanged: (v) =>
                    ref.read(flashColorStateProvider.notifier).set(v),
              ),
              ShioriSliderRow(
                title: l10n.flash_interval(flashInterval.toString()),
                value: flashInterval.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                valueLabel: (_) => '',
                defaultValue: 1,
                onReset: () =>
                    ref.read(flashIntervalStateProvider.notifier).set(1),
                resetTooltip: l10n.reset,
                onChanged: (v) => ref
                    .read(flashIntervalStateProvider.notifier)
                    .set(v.round()),
              ),
              ShioriSliderRow(
                title: l10n.flash_duration(flashDuration.toString()),
                value: flashDuration.toDouble(),
                min: 50,
                max: 500,
                divisions: 9,
                valueLabel: (_) => '',
                defaultValue: 100,
                onReset: () =>
                    ref.read(flashDurationStateProvider.notifier).set(100),
                resetTooltip: l10n.reset,
                onChanged: (v) => ref
                    .read(flashDurationStateProvider.notifier)
                    .set(v.round()),
              ),
            ],
          ],
        ),
      ],
      ReaderSettingsSection.swipe: [
        ShioriSettingsGroup(
          children: [
            ShioriValueRow<ChapterSwipeAction>(
              title: l10n.chapter_swipe_start,
              value: chapterSwipeStart,
              options: _chapterSwipeChoices(context),
              onChanged: (v) => ref
                  .read(chapterSwipeStartActionStateProvider.notifier)
                  .set(v),
            ),
            ShioriValueRow<ChapterSwipeAction>(
              title: l10n.chapter_swipe_end,
              value: chapterSwipeEnd,
              options: _chapterSwipeChoices(context),
              onChanged: (v) =>
                  ref.read(chapterSwipeEndActionStateProvider.notifier).set(v),
            ),
          ],
        ),
      ],
    };

    final section = this.section;
    if (section == null) return _hub(context);
    return Scaffold(
      appBar: AppBar(title: Text(section.title(context))),
      body: ListView(padding: tvPageInsets, children: sections[section]!),
    );
  }

  /// Reader settings, by what they are about: one line each, a summary
  /// under it, instead of thirty-nine rows on one screen.
  Widget _hub(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.reader)),
      body: ListView(
        padding: tvPageInsets,
        children: [
          for (final section in ReaderSettingsSection.values)
            ShioriSettingRow(
              autofocus: isTv && section == ReaderSettingsSection.values.first,
              icon: section.icon,
              title: section.title(context),
              subtitle: section.summary(context),
              trailing: const Icon(Symbols.chevron_forward_rounded),
              onTap: () =>
                  context.push('/readerSettingsSection', extra: section.index),
            ),
        ],
      ),
    );
  }
}

String getReaderModeName(ReaderMode readerMode, BuildContext context) {
  return switch (readerMode) {
    ReaderMode.vertical => context.l10n.reading_mode_vertical,
    ReaderMode.verticalContinuous =>
      context.l10n.reading_mode_vertical_continuous,
    ReaderMode.ltr => context.l10n.reading_mode_left_to_right,
    ReaderMode.rtl => context.l10n.reading_mode_right_to_left,
    ReaderMode.horizontalContinuous => context.l10n.horizontal_continious,
    ReaderMode.horizontalContinuousRTL =>
      "${context.l10n.horizontal_continious} (RTL)",
    _ => context.l10n.reading_mode_webtoon,
  };
}

String getBackgroundColorName(
  BackgroundColor backgroundColor,
  BuildContext context,
) {
  return switch (backgroundColor) {
    BackgroundColor.white => context.l10n.white,
    BackgroundColor.grey => context.l10n.grey,
    BackgroundColor.black => context.l10n.black,
    _ => context.l10n.automaic,
  };
}

Color? getBackgroundColor(BackgroundColor backgroundColor) {
  return switch (backgroundColor) {
    BackgroundColor.white => Colors.white,
    // shiori: a page background the reader picks
    BackgroundColor.grey => Colors.grey,
    BackgroundColor.black => Colors.black,
    _ => null,
  };
}

String getColorFilterBlendModeName(
  ColorFilterBlendMode backgroundColor,
  BuildContext context,
) {
  return switch (backgroundColor) {
    ColorFilterBlendMode.none => context.l10n.blend_mode_default,
    ColorFilterBlendMode.multiply => context.l10n.blend_mode_multiply,
    ColorFilterBlendMode.screen => context.l10n.blend_mode_screen,
    ColorFilterBlendMode.overlay => context.l10n.blend_mode_overlay,
    ColorFilterBlendMode.colorDodge => context.l10n.blend_mode_colorDodge,
    ColorFilterBlendMode.lighten => context.l10n.blend_mode_lighten,
    ColorFilterBlendMode.colorBurn => context.l10n.blend_mode_colorBurn,
    ColorFilterBlendMode.difference => context.l10n.blend_mode_difference,
    ColorFilterBlendMode.saturation => context.l10n.blend_mode_saturation,
    ColorFilterBlendMode.softLight => context.l10n.blend_mode_softLight,
    ColorFilterBlendMode.plus => context.l10n.blend_mode_plus,
    ColorFilterBlendMode.exclusion => context.l10n.blend_mode_exclusion,
    _ => context.l10n.blend_mode_darken,
  };
}

BlendMode? getColorFilterBlendMode(
  ColorFilterBlendMode backgroundColor,
  BuildContext context,
) {
  return switch (backgroundColor) {
    ColorFilterBlendMode.none => null,
    ColorFilterBlendMode.multiply => BlendMode.multiply,
    ColorFilterBlendMode.screen => BlendMode.screen,
    ColorFilterBlendMode.overlay => BlendMode.overlay,
    ColorFilterBlendMode.colorDodge => BlendMode.colorDodge,
    ColorFilterBlendMode.lighten => BlendMode.lighten,
    ColorFilterBlendMode.colorBurn => BlendMode.colorBurn,
    ColorFilterBlendMode.difference => BlendMode.difference,
    ColorFilterBlendMode.saturation => BlendMode.saturation,
    ColorFilterBlendMode.softLight => BlendMode.softLight,
    ColorFilterBlendMode.plus => BlendMode.plus,
    ColorFilterBlendMode.exclusion => BlendMode.exclusion,
    _ => BlendMode.darken,
  };
}

String getAnimationSpeedName(int type, BuildContext context) {
  return switch (type) {
    0 => context.l10n.no_animation,
    1 => context.l10n.normal,
    _ => context.l10n.fast,
  };
}

List<String> getScaleTypeNames(BuildContext context) {
  return [
    context.l10n.scale_type_fit_screen,
    context.l10n.scale_type_stretch,
    context.l10n.scale_type_fit_width,
    context.l10n.scale_type_fit_height,
    // l10n.scale_type_original_size,
    // l10n.scale_type_smart_fit,
  ];
}

String _navLayoutNameGlobal(int index, BuildContext context) {
  return switch (index) {
    0 => context.l10n.nav_layout_default,
    1 => context.l10n.nav_layout_l_shaped,
    2 => context.l10n.nav_layout_kindle,
    3 => context.l10n.nav_layout_edge,
    4 => context.l10n.nav_layout_right_and_left,
    5 => context.l10n.nav_layout_disabled,
    _ => context.l10n.nav_layout_default,
  };
}

List<ShioriChoice<ChapterSwipeAction>> _chapterSwipeChoices(
  BuildContext context,
) => [
  for (final action in ChapterSwipeAction.values)
    ShioriChoice(action, _chapterSwipeActionName(action, context)),
];

String _chapterSwipeActionName(
  ChapterSwipeAction action,
  BuildContext context,
) {
  return switch (action) {
    ChapterSwipeAction.toggleBookmark =>
      context.l10n.chapter_swipe_toggle_bookmark,
    ChapterSwipeAction.toggleRead => context.l10n.chapter_swipe_toggle_read,
    ChapterSwipeAction.download => context.l10n.chapter_swipe_download,
    ChapterSwipeAction.disabled => context.l10n.chapter_swipe_disabled,
  };
}
