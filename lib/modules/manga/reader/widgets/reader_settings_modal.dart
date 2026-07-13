import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/providers/color_filter_provider.dart';
import 'package:mangayomi/modules/manga/reader/widgets/color_filter_widget.dart';
import 'package:mangayomi/modules/manga/reader/widgets/custom_popup_menu_button.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_screen.dart';
import 'package:mangayomi/modules/widgets/custom_draggable_tabbar.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

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
  }) async {
    // Pause auto-scroll while settings are open
    final autoScrollWasRunning = autoScroll.value;
    if (autoScrollWasRunning) {
      autoScroll.value = false;
    }

    final l10n = l10nLocalizations(context)!;

    await customDraggableTabBar(
      tabs: [
        Tab(text: l10n.reading_mode),
        Tab(text: l10n.general),
        Tab(text: l10n.custom_filter),
      ],
      children: [
        // Reading Mode Tab
        _ReadingModeTab(
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
        const _CustomFilterTab(),
      ],
      context: context,
      vsync: vsync,
      fullWidth: true,
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

  const _ReadingModeTab({
    required this.currentReaderModeProvider,
    required this.autoScrollPage,
    required this.pageOffset,
    required this.onReaderModeChanged,
    required this.onAutoScrollSave,
    required this.onAutoScroll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    final readerMode = ref.watch(currentReaderModeProvider);
    final usePageTapZones = ref.watch(usePageTapZonesStateProvider);
    final cropBorders = ref.watch(cropBordersStateProvider);
    final splitWidePages = ref.watch(splitWidePagesStateProvider);
    final keepScreenOn = ref.watch(keepScreenOnReaderStateProvider);
    final showPageGaps = ref.watch(showPageGapsStateProvider);
    final webtoonSidePadding = ref.watch(webtoonSidePaddingStateProvider);
    final dualPageInvert = ref.watch(dualPageInvertStateProvider);
    final dualPageRotateToFit = ref.watch(dualPageRotateToFitStateProvider);
    final dualPageRotateToFitInvert = ref.watch(
      dualPageRotateToFitInvertStateProvider,
    );
    final landscapeZoom = ref.watch(landscapeZoomStateProvider);
    final zoomStartPosition = ref.watch(zoomStartPositionStateProvider);
    final automaticBackground = ref.watch(automaticBackgroundStateProvider);
    final webtoonDisableZoomOut = ref.watch(webtoonDisableZoomOutStateProvider);
    final webtoonDoubleTapZoomEnabled = ref.watch(
      webtoonDoubleTapZoomEnabledStateProvider,
    );
    final navigateToPan = ref.watch(navigateToPanStateProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            // Reader Mode
            CustomPopupMenuButton<ReaderMode>(
              label: l10n.reading_mode,
              title: getReaderModeName(readerMode!, context),
              onSelected: (value) {
                onReaderModeChanged(value, ref);
              },
              value: readerMode,
              list: ReaderMode.values,
              itemText: (mode) => getReaderModeName(mode, context),
            ),

            // Crop Borders
            SwitchListTile(
              value: cropBorders,
              title: Text(
                l10n.crop_borders,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
              onChanged: (value) {
                ref.read(cropBordersStateProvider.notifier).set(value);
              },
            ),

            if (readerMode.isContinuous) ...[
              SwitchListTile(
                value: webtoonDisableZoomOut,
                title: Text(
                  l10n.webtoon_disable_zoom_out,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
                onChanged: (value) {
                  ref
                      .read(webtoonDisableZoomOutStateProvider.notifier)
                      .set(value);
                },
              ),
              SwitchListTile(
                value: webtoonDoubleTapZoomEnabled,
                title: Text(
                  l10n.webtoon_double_tap_zoom_enabled,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
                onChanged: (value) {
                  ref
                      .read(webtoonDoubleTapZoomEnabledStateProvider.notifier)
                      .set(value);
                },
              ),
            ],

            if (!readerMode.isContinuous)
              SwitchListTile(
                value: navigateToPan,
                title: Text(
                  l10n.navigate_to_pan,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  l10n.navigate_to_pan_subtitle,
                  style: const TextStyle(fontSize: 11),
                ),
                onChanged: (value) {
                  ref.read(navigateToPanStateProvider.notifier).set(value);
                },
              ),

            SwitchListTile(
              value: splitWidePages,
              title: Text(
                l10n.split_wide_pages,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
              onChanged: (value) {
                ref.read(splitWidePagesStateProvider.notifier).set(value);
              },
            ),

            if (splitWidePages)
              SwitchListTile(
                value: dualPageInvert,
                title: Text(
                  l10n.dual_page_invert,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
                onChanged: (value) {
                  ref.read(dualPageInvertStateProvider.notifier).set(value);
                },
              ),

            SwitchListTile(
              value: dualPageRotateToFit,
              title: Text(
                l10n.dual_page_rotate_to_fit,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
              onChanged: (value) {
                ref.read(dualPageRotateToFitStateProvider.notifier).set(value);
              },
            ),

            if (dualPageRotateToFit)
              SwitchListTile(
                value: dualPageRotateToFitInvert,
                title: Text(
                  l10n.dual_page_rotate_to_fit_invert,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
                onChanged: (value) {
                  ref
                      .read(dualPageRotateToFitInvertStateProvider.notifier)
                      .set(value);
                },
              ),

            if (!readerMode.isContinuous)
              SwitchListTile(
                value: landscapeZoom,
                title: Text(
                  l10n.landscape_zoom,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
                onChanged: (value) {
                  ref.read(landscapeZoomStateProvider.notifier).set(value);
                },
              ),

            if (!readerMode.isContinuous && landscapeZoom)
              CustomPopupMenuButton<int>(
                label: l10n.zoom_start_position,
                title: switch (zoomStartPosition) {
                  0 => l10n.zoom_start_left,
                  1 => l10n.zoom_start_right,
                  _ => l10n.zoom_start_center,
                },
                onSelected: (value) {
                  ref.read(zoomStartPositionStateProvider.notifier).set(value);
                },
                value: zoomStartPosition,
                list: const [0, 1, 2],
                itemText: (pos) => switch (pos) {
                  0 => l10n.zoom_start_left,
                  1 => l10n.zoom_start_right,
                  _ => l10n.zoom_start_center,
                },
              ),

            SwitchListTile(
              value: automaticBackground,
              title: Text(
                l10n.automatic_background,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
              onChanged: (value) {
                ref.read(automaticBackgroundStateProvider.notifier).set(value);
              },
            ),

            // Page Tap Zones
            SwitchListTile(
              value: usePageTapZones,
              title: Text(
                l10n.use_page_tap_zones,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
              onChanged: (value) {
                ref.read(usePageTapZonesStateProvider.notifier).set(value);
              },
            ),

            // Keep Screen On
            SwitchListTile(
              value: keepScreenOn,
              title: Text(
                l10n.keep_screen_on,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
              onChanged: (value) {
                ref.read(keepScreenOnReaderStateProvider.notifier).set(value);
              },
            ),

            // Show Page Gaps (only for continuous modes)
            if (readerMode.isContinuous)
              SwitchListTile(
                value: showPageGaps,
                title: Text(
                  l10n.show_page_gaps,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
                onChanged: (value) {
                  ref.read(showPageGapsStateProvider.notifier).set(value);
                },
              ),

            // Webtoon Side Padding (only for continuous modes)
            if (readerMode.isContinuous)
              ListTile(
                title: Text(
                  '${l10n.webtoon_side_padding}: $webtoonSidePadding%',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
                subtitle: Slider(
                  min: 0,
                  max: 50,
                  divisions: 50,
                  value: webtoonSidePadding.toDouble(),
                  onChanged: (value) {
                    ref
                        .read(webtoonSidePaddingStateProvider.notifier)
                        .set(value.toInt());
                  },
                ),
              ),

            // Auto-scroll (only for continuous modes)
            if (readerMode.isContinuous)
              ValueListenableBuilder(
                valueListenable: autoScrollPage,
                builder: (context, valueT, child) {
                  return Column(
                    children: [
                      SwitchListTile(
                        secondary: Icon(
                          valueT ? Icons.timer : Icons.timer_outlined,
                        ),
                        value: valueT,
                        title: Text(
                          context.l10n.auto_scroll,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge!.color!
                                .withValues(alpha: 0.9),
                            fontSize: 14,
                          ),
                        ),
                        onChanged: (val) {
                          onAutoScrollSave(val, pageOffset.value);
                          autoScrollPage.value = val;
                          onAutoScroll(val);
                        },
                      ),
                      if (valueT)
                        ValueListenableBuilder(
                          valueListenable: pageOffset,
                          builder: (context, value, child) => Slider(
                            min: 2.0,
                            max: 30.0,
                            divisions: max(28, 3),
                            value: value,
                            onChanged: (val) {
                              pageOffset.value = val;
                            },
                            onChangeEnd: (val) {
                              onAutoScrollSave(valueT, val);
                            },
                          ),
                        ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// General Tab with Consumer for reactive updates.
class _GeneralTab extends ConsumerWidget {
  final VoidCallback onFullScreenToggle;

  const _GeneralTab({required this.onFullScreenToggle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    final showPagesNumber = ref.watch(showPagesNumberStateProvider);
    final animatePageTransitions = ref.watch(
      animatePageTransitionsStateProvider,
    );
    final scaleType = ref.watch(scaleTypeStateProvider);
    final fullScreenReader = ref.watch(fullScreenReaderStateProvider);
    final backgroundColor = ref.watch(backgroundColorStateProvider);
    final navigationLayout = ref.watch(readerNavigationLayoutStateProvider);

    final tappingInversion = ref.watch(tappingInversionStateProvider);
    final flashOnPageChange = ref.watch(flashOnPageChangeStateProvider);
    final flashColor = ref.watch(flashColorStateProvider);
    final flashInterval = ref.watch(flashIntervalStateProvider);
    final flashDuration = ref.watch(flashDurationStateProvider);
    final showNavigationOverlayOnStart = ref.watch(
      showNavigationOverlayOnStartStateProvider,
    );
    final readerHideThreshold = ref.watch(readerHideThresholdStateProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Background Color
            CustomPopupMenuButton<BackgroundColor>(
              label: l10n.background_color,
              title: getBackgroundColorName(backgroundColor, context),
              onSelected: (value) {
                ref.read(backgroundColorStateProvider.notifier).set(value);
              },
              value: backgroundColor,
              list: BackgroundColor.values,
              itemText: (color) => getBackgroundColorName(color, context),
            ),

            // Scale Type
            CustomPopupMenuButton<ScaleType>(
              label: l10n.scale_type,
              title: getScaleTypeNames(context)[scaleType.index],
              onSelected: (value) {
                ref
                    .read(scaleTypeStateProvider.notifier)
                    .set(ScaleType.values[value.index]);
              },
              value: scaleType,
              list: ScaleType.values.where((scale) {
                try {
                  return getScaleTypeNames(
                    context,
                  ).contains(getScaleTypeNames(context)[scale.index]);
                } catch (_) {
                  return false;
                }
              }).toList(),
              itemText: (scale) => getScaleTypeNames(context)[scale.index],
            ),

            // Navigation Layout
            ListTile(
              title: Text(
                l10n.navigation_layout,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
              subtitle: Text(_navLayoutName(navigationLayout, context)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return SimpleDialog(
                      title: Text(l10n.navigation_layout),
                      children: [
                        RadioGroup<int>(
                          groupValue: navigationLayout,
                          onChanged: (val) {
                            ref
                                .read(
                                  readerNavigationLayoutStateProvider.notifier,
                                )
                                .set(val!);
                            Navigator.pop(ctx);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(6, (i) {
                              return RadioListTile<int>(
                                value: i,
                                title: Text(_navLayoutName(i, context)),
                              );
                            }),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            // Tapping Inversion
            ListTile(
              title: Text(
                l10n.tapping_inversion,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
              subtitle: Text(switch (tappingInversion) {
                1 => l10n.tapping_inversion_horizontal,
                2 => l10n.tapping_inversion_vertical,
                3 => l10n.tapping_inversion_both,
                _ => l10n.tapping_inversion_none,
              }),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return SimpleDialog(
                      title: Text(l10n.tapping_inversion),
                      children: [
                        RadioGroup<int>(
                          groupValue: tappingInversion,
                          onChanged: (val) {
                            ref
                                .read(tappingInversionStateProvider.notifier)
                                .set(val!);
                            Navigator.pop(ctx);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RadioListTile<int>(
                                value: 0,
                                title: Text(l10n.tapping_inversion_none),
                              ),
                              RadioListTile<int>(
                                value: 1,
                                title: Text(l10n.tapping_inversion_horizontal),
                              ),
                              RadioListTile<int>(
                                value: 2,
                                title: Text(l10n.tapping_inversion_vertical),
                              ),
                              RadioListTile<int>(
                                value: 3,
                                title: Text(l10n.tapping_inversion_both),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            // Flash on Page Change
            SwitchListTile(
              value: flashOnPageChange,
              title: Text(
                l10n.flash_on_page_change,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                l10n.flash_on_page_change_subtitle,
                style: const TextStyle(fontSize: 11),
              ),
              onChanged: (value) {
                ref.read(flashOnPageChangeStateProvider.notifier).set(value);
              },
            ),
            if (flashOnPageChange) ...[
              ListTile(
                title: Text(
                  l10n.flash_color,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      ChoiceChip(
                        label: Text(l10n.flash_color_black),
                        selected: flashColor == 0,
                        onSelected: (val) {
                          if (val) {
                            ref.read(flashColorStateProvider.notifier).set(0);
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: Text(l10n.flash_color_white),
                        selected: flashColor == 1,
                        onSelected: (val) {
                          if (val) {
                            ref.read(flashColorStateProvider.notifier).set(1);
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: Text(l10n.flash_color_white_black),
                        selected: flashColor == 2,
                        onSelected: (val) {
                          if (val) {
                            ref.read(flashColorStateProvider.notifier).set(2);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  l10n.flash_interval(flashInterval.toString()),
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
                subtitle: Slider(
                  min: 1,
                  max: 10,
                  divisions: 9,
                  value: flashInterval.toDouble(),
                  onChanged: (val) {
                    ref
                        .read(flashIntervalStateProvider.notifier)
                        .set(val.toInt());
                  },
                ),
              ),
              ListTile(
                title: Text(
                  l10n.flash_duration(flashDuration.toString()),
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
                subtitle: Slider(
                  min: 50,
                  max: 500,
                  divisions: 9,
                  value: flashDuration.toDouble(),
                  onChanged: (val) {
                    ref
                        .read(flashDurationStateProvider.notifier)
                        .set(val.toInt());
                  },
                ),
              ),
            ],

            // Show Navigation Overlay
            SwitchListTile(
              value: showNavigationOverlayOnStart,
              title: Text(
                l10n.show_navigation_overlay_on_start,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
              onChanged: (value) {
                ref
                    .read(showNavigationOverlayOnStartStateProvider.notifier)
                    .set(value);
              },
            ),

            // Reader Hide Threshold
            ListTile(
              title: Text(
                l10n.reader_hide_threshold,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
              subtitle: Text(switch (readerHideThreshold) {
                0 => l10n.reader_hide_threshold_highest,
                1 => l10n.reader_hide_threshold_high,
                2 => l10n.reader_hide_threshold_low,
                _ => l10n.reader_hide_threshold_lowest,
              }),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return SimpleDialog(
                      title: Text(l10n.reader_hide_threshold),
                      children: [
                        RadioGroup<int>(
                          groupValue: readerHideThreshold,
                          onChanged: (val) {
                            ref
                                .read(readerHideThresholdStateProvider.notifier)
                                .set(val!);
                            Navigator.pop(ctx);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RadioListTile<int>(
                                value: 0,
                                title: Text(l10n.reader_hide_threshold_highest),
                              ),
                              RadioListTile<int>(
                                value: 1,
                                title: Text(l10n.reader_hide_threshold_high),
                              ),
                              RadioListTile<int>(
                                value: 2,
                                title: Text(l10n.reader_hide_threshold_low),
                              ),
                              RadioListTile<int>(
                                value: 3,
                                title: Text(l10n.reader_hide_threshold_lowest),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            // Fullscreen
            SwitchListTile(
              value: fullScreenReader,
              title: Text(
                l10n.fullscreen,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
              onChanged: (value) {
                onFullScreenToggle();
              },
            ),

            // Show Page Numbers
            SwitchListTile(
              value: showPagesNumber,
              title: Text(
                l10n.show_page_number,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
              onChanged: (value) {
                ref.read(showPagesNumberStateProvider.notifier).set(value);
              },
            ),

            // Animate Page Transitions
            SwitchListTile(
              value: animatePageTransitions,
              title: Text(
                l10n.animate_page_transitions,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
              onChanged: (value) {
                ref
                    .read(animatePageTransitionsStateProvider.notifier)
                    .set(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom Filter Tab with Consumer for reactive updates.
class _CustomFilterTab extends ConsumerWidget {
  const _CustomFilterTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    final customColorFilter = ref.watch(customColorFilterStateProvider);
    final enableCustomColorFilter = ref.watch(
      enableCustomColorFilterStateProvider,
    );
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

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Color Enhancements ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                l10n.color_enhancements,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),

            // Invert Colors
            SwitchListTile(
              value: invertColors,
              title: Text(
                l10n.invert_colors,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
              onChanged: (value) {
                ref.read(invertColorsStateProvider.notifier).set(value);
              },
            ),

            // Grayscale
            SwitchListTile(
              value: grayscale,
              title: Text(
                l10n.grayscale,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
              onChanged: (value) {
                ref.read(grayscaleStateProvider.notifier).set(value);
              },
            ),

            // Brightness Slider
            _enhancementSlider(
              label: l10n.brightness,
              value: brightness,
              min: -1.0,
              max: 1.0,
              defaultValue: 0.0,
              onChanged: (v) =>
                  ref.read(readerBrightnessStateProvider.notifier).set(v),
              context: context,
            ),

            // Contrast Slider
            _enhancementSlider(
              label: l10n.contrast,
              value: contrast,
              min: 0.0,
              max: 2.0,
              defaultValue: 1.0,
              onChanged: (v) =>
                  ref.read(readerContrastStateProvider.notifier).set(v),
              context: context,
            ),

            // Saturation Slider
            _enhancementSlider(
              label: l10n.saturation,
              value: saturation,
              min: 0.0,
              max: 2.0,
              defaultValue: 1.0,
              onChanged: (v) =>
                  ref.read(readerSaturationStateProvider.notifier).set(v),
              context: context,
            ),

            const Divider(height: 24),

            // ── Custom RGBA Color Filter ──

            // Enable Custom Color Filter
            SwitchListTile(
              value: enableCustomColorFilter,
              title: Text(
                l10n.custom_color_filter,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
              onChanged: (value) {
                ref
                    .read(enableCustomColorFilterStateProvider.notifier)
                    .set(value);
              },
            ),

            if (enableCustomColorFilter) ...[
              // RGBA Sliders
              rgbaFilterWidget(a, r, g, b, (val) {
                final notifier = ref.read(
                  customColorFilterStateProvider.notifier,
                );
                if (val.$3 == "r") {
                  notifier.set(a, val.$1.toInt(), g, b, val.$2);
                } else if (val.$3 == "g") {
                  notifier.set(a, r, val.$1.toInt(), b, val.$2);
                } else if (val.$3 == "b") {
                  notifier.set(a, r, g, val.$1.toInt(), val.$2);
                } else {
                  notifier.set(val.$1.toInt(), r, g, b, val.$2);
                }
              }, context),

              // Blend Mode
              CustomPopupMenuButton<ColorFilterBlendMode>(
                label: l10n.color_filter_blend_mode,
                title: getColorFilterBlendModeName(
                  colorFilterBlendMode,
                  context,
                ),
                onSelected: (value) {
                  ref
                      .read(colorFilterBlendModeStateProvider.notifier)
                      .set(value);
                },
                value: colorFilterBlendMode,
                list: ColorFilterBlendMode.values,
                itemText: (mode) => getColorFilterBlendModeName(mode, context),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _enhancementSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required double defaultValue,
    required ValueChanged<double> onChanged,
    required BuildContext context,
  }) {
    final isDefault = (value - defaultValue).abs() < 0.01;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(
                  context,
                ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Slider(
              min: min,
              max: max,
              value: value.clamp(min, max),
              onChanged: onChanged,
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              value.toStringAsFixed(1),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          if (!isDefault)
            IconButton(
              icon: const Icon(Icons.replay, size: 18),
              onPressed: () => onChanged(defaultValue),
              tooltip: l10nLocalizations(context)!.reset,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            )
          else
            const SizedBox(width: 32),
        ],
      ),
    );
  }
}
