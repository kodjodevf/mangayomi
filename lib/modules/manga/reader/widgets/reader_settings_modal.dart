import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/settings/keyboard_shortcuts/key_bindings.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_switches.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/reader_common/mixins/reader_gestures.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_mode_picker.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/modules/reader_common/utils/reader_orientation.dart';
import 'package:mangayomi/services/volume_keys.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/providers/color_filter_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_screen.dart';
import 'package:mangayomi/modules/widgets/custom_draggable_tabbar.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';

String _navLayoutName(int index, BuildContext context) {
  final l10n = l10nLocalizations(context)!;
  return switch (index) {
    0 => l10n.nav_layout_default,
    1 => l10n.nav_layout_l_shaped,
    2 => l10n.nav_layout_kindle,
    3 => l10n.nav_layout_edge,
    4 => l10n.nav_layout_right_and_left,
    5 => l10n.nav_layout_disabled,
    _ => l10n.nav_layout_default,
  };
}

/// Settings modal for the manga reader using Riverpod providers directly.
///
/// This is a complete replacement for the _showModalSettings() method.
/// It uses the same providers and matches the exact behavior.
class ReaderSettingsModal {
  /// Shows the settings modal.
  ///
  /// Parameters:
  /// - [context]: The build context
  /// - [vsync]: The ticker provider (usually the State object)
  /// - [currentReaderModeProvider]: The provider for current reader mode
  /// - [autoScrollPage]: ValueNotifier for auto-scroll page state
  /// - [autoScroll]: ValueNotifier for auto-scroll running state
  /// - [pageOffset]: ValueNotifier for page offset (scroll speed)
  /// - [onReaderModeChanged]: Callback when reader mode changes
  /// - [onAutoScrollSave]: Callback to save auto-scroll settings
  /// - [onFullScreenToggle]: Callback to toggle fullscreen
  /// - [onAutoPageScroll]: Callback to trigger auto-scroll
  static Future<void> show({
    required BuildContext context,
    required TickerProvider vsync,
    required ProviderListenable<ReaderMode?> currentReaderModeProvider,
    required ValueNotifier<bool> autoScrollPage,
    required ValueNotifier<bool> autoScroll,
    required ValueNotifier<double> pageOffset,
    required void Function(ReaderMode mode, WidgetRef ref) onReaderModeChanged,
    required void Function(bool enabled, double offset) onAutoScrollSave,
    required VoidCallback onFullScreenToggle,
    required VoidCallback onAutoPageScroll,
    String seriesName = '',
  }) async {
    // Pause auto-scroll while settings are open
    final autoScrollWasRunning = autoScroll.value;
    if (autoScrollWasRunning) {
      autoScroll.value = false;
    }

    final l10n = l10nLocalizations(context)!;
    // On while the custom filter is, so the sheet lets the page show through
    // on that tab and the filter can be set by eye.
    final filterOn = ValueNotifier(false);

    await customDraggableTabBar(
      tabs: [
        Tab(text: l10n.reading_mode),
        Tab(text: l10n.general),
        Tab(text: l10n.custom_filter),
      ],
      children: [
        // Reading Mode Tab
        _ReadingModeTab(
          seriesName: seriesName,
          currentReaderModeProvider: currentReaderModeProvider,
          autoScrollPage: autoScrollPage,
          pageOffset: pageOffset,
          onReaderModeChanged: onReaderModeChanged,
          onAutoScrollSave: onAutoScrollSave,
          onAutoScroll: (val) {
            autoScroll.value = val;
          },
        ),

        // General Tab
        _GeneralTab(onFullScreenToggle: onFullScreenToggle),

        // Custom Filter Tab
        _CustomFilterTab(filterOn: filterOn),
      ],
      context: context,
      vsync: vsync,
      fullWidth: true,
      // The page stays in sight: every setting here changes it.
      dimBehind: false,
      seeThroughTab: 2,
      seeThrough: filterOn,
    );

    // Resume auto-scroll if it was running
    if (autoScrollWasRunning || autoScroll.value) {
      if (autoScrollPage.value) {
        onAutoPageScroll();
        autoScroll.value = true;
      }
    }
  }
}

/// Reading Mode Tab with Consumer for reactive updates.
class _ReadingModeTab extends ConsumerWidget {
  final ProviderListenable<ReaderMode?> currentReaderModeProvider;
  final ValueNotifier<bool> autoScrollPage;
  final ValueNotifier<double> pageOffset;
  final void Function(ReaderMode mode, WidgetRef ref) onReaderModeChanged;
  final void Function(bool enabled, double offset) onAutoScrollSave;
  final void Function(bool val) onAutoScroll;
  final String seriesName;

  const _ReadingModeTab({
    required this.seriesName,
    required this.currentReaderModeProvider,
    required this.autoScrollPage,
    required this.pageOffset,
    required this.onReaderModeChanged,
    required this.onAutoScrollSave,
    required this.onAutoScroll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final readerMode = ref.watch(currentReaderModeProvider);
    final splitWidePages = ref.watch(splitWidePagesStateProvider);
    final webtoonSidePadding = ref.watch(webtoonSidePaddingStateProvider);
    final dualPageRotateToFit = ref.watch(dualPageRotateToFitStateProvider);
    final landscapeZoom = ref.watch(landscapeZoomStateProvider);
    final zoomStartPosition = ref.watch(zoomStartPositionStateProvider);
    final continuous = readerMode!.isContinuous;

    // The sheet scrolls; a tab is a column, not a list of its own.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: ShioriSpace.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ReaderModePicker(
            mode: readerMode,
            defaultMode: ref.watch(defaultReadingModeStateProvider),
            seriesName: seriesName,
            onChanged: (value) => onReaderModeChanged(value, ref),
            onSetDefault: () => ref
                .read(defaultReadingModeStateProvider.notifier)
                .set(readerMode),
          ),
          const SizedBox(height: ShioriSpace.s8),
          // Grouped as in Settings › Reader, so a switch is found in the
          // same place in both.
          ShioriSettingsGroup(
            title: l10n.group_reading,
            children: [
              const ReaderSwitchRow(ReaderSwitch.cropBorders),
              if (!continuous)
                const ReaderSwitchRow(ReaderSwitch.navigateToPan),
              const ReaderSwitchRow(ReaderSwitch.usePageTapZones),
              const ReaderSwitchRow(ReaderSwitch.keepScreenOn),
            ],
          ),
          if (continuous)
            ShioriSettingsGroup(
              title: l10n.reading_mode_webtoon,
              children: [
                const ReaderSwitchRow(ReaderSwitch.webtoonDisableZoomOut),
                const ReaderSwitchRow(ReaderSwitch.webtoonDoubleTapZoom),
                const ReaderSwitchRow(ReaderSwitch.showPageGaps),
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
                ValueListenableBuilder(
                  valueListenable: autoScrollPage,
                  builder: (context, enabled, _) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShioriSwitchRow(
                        icon: Symbols.timer_rounded,
                        title: l10n.auto_scroll,
                        value: enabled,
                        onChanged: (val) {
                          onAutoScrollSave(val, pageOffset.value);
                          autoScrollPage.value = val;
                          onAutoScroll(val);
                        },
                      ),
                      if (enabled)
                        ValueListenableBuilder(
                          valueListenable: pageOffset,
                          builder: (context, speed, _) => ShioriSliderRow(
                            title: l10n.speed,
                            value: speed,
                            min: 2,
                            max: 30,
                            divisions: 28,
                            onChanged: (val) => pageOffset.value = val,
                            onChangeEnd: (val) =>
                                onAutoScrollSave(enabled, val),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ShioriSettingsGroup(
            title: l10n.page_layout,
            children: [
              const ReaderSwitchRow(ReaderSwitch.splitWidePages),
              if (splitWidePages)
                const ReaderSwitchRow(ReaderSwitch.dualPageInvert),
              const ReaderSwitchRow(ReaderSwitch.dualPageRotateToFit),
              if (dualPageRotateToFit)
                const ReaderSwitchRow(ReaderSwitch.dualPageRotateToFitInvert),
              const ReaderSwitchRow(ReaderSwitch.doublePageSingleFirstPage),
              const ReaderSwitchRow(ReaderSwitch.doublePageAuto),
              if (!continuous)
                const ReaderSwitchRow(ReaderSwitch.landscapeZoom),
              if (!continuous && landscapeZoom)
                ShioriValueRow<int>(
                  title: l10n.zoom_start_position,
                  value: zoomStartPosition,
                  options: [
                    ShioriChoice(0, l10n.zoom_start_left),
                    ShioriChoice(1, l10n.zoom_start_right),
                    ShioriChoice(2, l10n.zoom_start_center),
                  ],
                  onChanged: (v) =>
                      ref.read(zoomStartPositionStateProvider.notifier).set(v),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// What is changed while reading; the rest lives in Settings.
class _GeneralTab extends ConsumerWidget {
  final VoidCallback onFullScreenToggle;

  const _GeneralTab({required this.onFullScreenToggle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final scaleType = ref.watch(scaleTypeStateProvider);
    final fullScreenReader = ref.watch(fullScreenReaderStateProvider);
    final backgroundColor = ref.watch(backgroundColorStateProvider);
    final navigationLayout = ref.watch(readerNavigationLayoutStateProvider);
    final tappingInversion = ref.watch(tappingInversionStateProvider);
    final flashOnPageChange = ref.watch(flashOnPageChangeStateProvider);
    final flashColor = ref.watch(flashColorStateProvider);
    final flashInterval = ref.watch(flashIntervalStateProvider);
    final flashDuration = ref.watch(flashDurationStateProvider);
    final readerHideThreshold = ref.watch(readerHideThresholdStateProvider);
    final scaleNames = getScaleTypeNames(context);

    // The sheet scrolls; a tab is a column, not a list of its own.
    return Padding(
      padding: const EdgeInsets.only(
        top: ShioriSpace.s8,
        bottom: ShioriSpace.s16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // This sheet holds what is changed while reading; the rest lives in
          // Settings, one tap away rather than out of sight.
          ShioriSettingsGroup(
            children: [
              ShioriSettingRow(
                icon: Symbols.tune_rounded,
                title: l10n.all_reader_settings,
                trailing: const Icon(Symbols.chevron_forward_rounded),
                onTap: () => context.push('/readerMode'),
              ),
              // Where a keyboard can be found, what it does here.
              if (isDesktop)
                ShioriSettingRow(
                  icon: Symbols.keyboard_rounded,
                  title: l10n.keyboard_shortcuts,
                  trailing: const Icon(Symbols.chevron_forward_rounded),
                  onTap: () => showReaderShortcuts(
                    context,
                    bindings: ref.read(keyBindingsStateProvider),
                  ),
                ),
            ],
          ),
          ShioriSettingsGroup(
            title: l10n.display,
            children: [
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
              ShioriValueRow<ScaleType>(
                title: l10n.scale_type,
                value: scaleType,
                options: [
                  for (final (i, name) in scaleNames.indexed)
                    ShioriChoice(ScaleType.values[i], name),
                ],
                onChanged: (v) =>
                    ref.read(scaleTypeStateProvider.notifier).set(v),
              ),
              if (!isMobile)
                ShioriSwitchRow(
                  title: l10n.fullscreen,
                  value: fullScreenReader,
                  onChanged: (_) => onFullScreenToggle(),
                ),
              const ReaderOrientationRow(),
              const ReaderScreenBrightnessRow(),
              const ReaderSwitchRow(ReaderSwitch.showPageNumber),
              const ReaderSwitchRow(ReaderSwitch.animatePageTransitions),
            ],
          ),
          ShioriSettingsGroup(
            title: ReaderSettingsSection.navigation.title(context),
            children: [
              ShioriValueRow<int>(
                title: l10n.navigation_layout,
                value: navigationLayout,
                options: [
                  for (var i = 0; i < 6; i++)
                    ShioriChoice(i, _navLayoutName(i, context)),
                ],
                onChanged: (v) => ref
                    .read(readerNavigationLayoutStateProvider.notifier)
                    .set(v),
              ),
              ShioriValueRow<int>(
                title: l10n.tapping_inversion,
                value: tappingInversion,
                options: [
                  ShioriChoice(0, l10n.tapping_inversion_none),
                  ShioriChoice(1, l10n.tapping_inversion_horizontal),
                  ShioriChoice(2, l10n.tapping_inversion_vertical),
                  ShioriChoice(3, l10n.tapping_inversion_both),
                ],
                onChanged: (v) =>
                    ref.read(tappingInversionStateProvider.notifier).set(v),
              ),
              ShioriValueRow<int>(
                title: l10n.reader_hide_threshold,
                value: readerHideThreshold,
                options: [
                  ShioriChoice(0, l10n.reader_hide_threshold_highest),
                  ShioriChoice(1, l10n.reader_hide_threshold_high),
                  ShioriChoice(2, l10n.reader_hide_threshold_low),
                  ShioriChoice(3, l10n.reader_hide_threshold_lowest),
                ],
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
                  options: [
                    ShioriChoice(0, l10n.flash_color_black),
                    ShioriChoice(1, l10n.flash_color_white),
                    ShioriChoice(2, l10n.flash_color_white_black),
                  ],
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
      ),
    );
  }
}

/// The page's colours: quick enhancements, then a custom RGBA filter.
class _CustomFilterTab extends ConsumerWidget {
  const _CustomFilterTab({required this.filterOn});

  final ValueNotifier<bool> filterOn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final customColorFilter = ref.watch(customColorFilterStateProvider);
    final enableCustomColorFilter = ref.watch(
      enableCustomColorFilterStateProvider,
    );
    // Told after the frame, as the sheet around this tab listens to it.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) filterOn.value = enableCustomColorFilter;
    });
    final colorFilterBlendMode = ref.watch(colorFilterBlendModeStateProvider);
    final invertColors = ref.watch(invertColorsStateProvider);
    final grayscale = ref.watch(grayscaleStateProvider);
    final brightness = ref.watch(readerBrightnessStateProvider);
    final contrast = ref.watch(readerContrastStateProvider);
    final saturation = ref.watch(readerSaturationStateProvider);

    int r = customColorFilter?.r ?? 0;
    int g = customColorFilter?.g ?? 0;
    int b = customColorFilter?.b ?? 0;
    int a = customColorFilter?.a ?? 0;
    final filter = ref.read(customColorFilterStateProvider.notifier);

    ShioriSliderRow enhancement(
      String label,
      double value,
      double min,
      double max,
      double defaultValue,
      ValueChanged<double> set,
    ) => ShioriSliderRow(
      title: label,
      value: value,
      min: min,
      max: max,
      valueLabel: (v) => v.toStringAsFixed(1),
      defaultValue: defaultValue,
      onReset: () => set(defaultValue),
      resetTooltip: l10n.reset,
      onChanged: set,
    );

    // The sheet scrolls; a tab is a column, not a list of its own.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: ShioriSpace.s8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ShioriSettingsGroup(
            title: l10n.color_enhancements,
            children: [
              ShioriSwitchRow(
                title: l10n.invert_colors,
                value: invertColors,
                onChanged: (v) =>
                    ref.read(invertColorsStateProvider.notifier).set(v),
              ),
              ShioriSwitchRow(
                title: l10n.grayscale,
                value: grayscale,
                onChanged: (v) =>
                    ref.read(grayscaleStateProvider.notifier).set(v),
              ),
              enhancement(
                l10n.brightness,
                brightness,
                -1,
                1,
                0,
                (v) => ref.read(readerBrightnessStateProvider.notifier).set(v),
              ),
              enhancement(
                l10n.contrast,
                contrast,
                0,
                2,
                1,
                (v) => ref.read(readerContrastStateProvider.notifier).set(v),
              ),
              enhancement(
                l10n.saturation,
                saturation,
                0,
                2,
                1,
                (v) => ref.read(readerSaturationStateProvider.notifier).set(v),
              ),
            ],
          ),
          ShioriSettingsGroup(
            children: [
              ShioriSwitchRow(
                title: l10n.custom_color_filter,
                value: enableCustomColorFilter,
                onChanged: (v) => ref
                    .read(enableCustomColorFilterStateProvider.notifier)
                    .set(v),
              ),
              if (enableCustomColorFilter) ...[
                // The colour the filter lays over the page, then its four
                // channels as the app's other sliders: named, with their
                // value, saved when let go.
                _FilterSwatch(a: a, r: r, g: g, b: b),
                for (final (label, value, apply)
                    in <(String, int, void Function(int, bool))>[
                      (
                        l10n.color_red,
                        r,
                        (v, end) => filter.set(a, v, g, b, end),
                      ),
                      (
                        l10n.color_green,
                        g,
                        (v, end) => filter.set(a, r, v, b, end),
                      ),
                      (
                        l10n.color_blue,
                        b,
                        (v, end) => filter.set(a, r, g, v, end),
                      ),
                    ])
                  ShioriSliderRow(
                    title: label,
                    value: value.toDouble(),
                    min: 0,
                    max: 255,
                    divisions: 255,
                    valueLabel: (v) => '${v.round()}',
                    onChanged: (v) => apply(v.round(), false),
                    onChangeEnd: (v) => apply(v.round(), true),
                  ),
                ShioriSliderRow(
                  title: l10n.color_opacity,
                  value: a.toDouble(),
                  min: 0,
                  max: 255,
                  divisions: 255,
                  valueLabel: (v) => '${(v / 255 * 100).round()} %',
                  onChanged: (v) => filter.set(v.round(), r, g, b, false),
                  onChangeEnd: (v) => filter.set(v.round(), r, g, b, true),
                ),
                ShioriValueRow<ColorFilterBlendMode>(
                  title: l10n.color_filter_blend_mode,
                  value: colorFilterBlendMode,
                  options: [
                    for (final mode in ColorFilterBlendMode.values)
                      ShioriChoice(
                        mode,
                        getColorFilterBlendModeName(mode, context),
                      ),
                  ],
                  onChanged: (v) => ref
                      .read(colorFilterBlendModeStateProvider.notifier)
                      .set(v),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// The custom filter's colour as it will lie over the page, with its code.
class _FilterSwatch extends StatelessWidget {
  const _FilterSwatch({
    required this.a,
    required this.r,
    required this.g,
    required this.b,
  });

  final int a, r, g, b;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    String hex(int v) => v.toRadixString(16).padLeft(2, '0').toUpperCase();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ShioriSpace.s16,
        vertical: ShioriSpace.s8,
      ),
      child: Row(
        spacing: ShioriSpace.s12,
        children: [
          // On a light ground, so a faint filter still shows.
          Container(
            width: tokens.scaled(40),
            height: tokens.scaled(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(ShioriShape.card),
              border: Border.all(color: tokens.color.hairline),
            ),
            foregroundDecoration: BoxDecoration(
              color: Color.fromARGB(a, r, g, b),
              borderRadius: BorderRadius.circular(ShioriShape.card),
            ),
          ),
          Text(
            '#${hex(a)}${hex(r)}${hex(g)}${hex(b)}',
            style: tokens.text.row.copyWith(
              color: tokens.color.fg,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
