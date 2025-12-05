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

    final isContinuousMode =
        readerMode == ReaderMode.verticalContinuous ||
        readerMode == ReaderMode.webtoon ||
        readerMode == ReaderMode.horizontalContinuous;

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

            // Auto-scroll (only for continuous modes)
            if (isContinuousMode)
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
}
