import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/novel/novel_reader_controller_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/modules/novel/widgets/novel_settings_controls.dart';

class GeneralSettingsTab extends ConsumerWidget {
  final ValueNotifier<bool>? autoScrollPage;
  final ValueNotifier<bool>? autoScroll;
  final NovelReaderController? readerController;
  final ValueNotifier<double>? pageOffset;
  const GeneralSettingsTab({
    this.autoScrollPage,
    this.autoScroll,
    this.readerController,
    this.pageOffset,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoScrollPageNotifier = autoScrollPage;
    final autoScrollNotifier = autoScroll;
    final controller = readerController;
    final offsetNotifier = pageOffset;
    final hasActiveSession =
        autoScrollPageNotifier != null &&
        autoScrollNotifier != null &&
        controller != null &&
        offsetNotifier != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          NovelSwitchSetting(
            title: context.l10n.keep_screen_on,
            value: ref.watch(keepScreenOnReaderStateProvider),
            onChanged: (value) {
              ref.read(keepScreenOnReaderStateProvider.notifier).set(value);
            },
          ),
          NovelSwitchSetting(
            title: context.l10n.show_scroll_percentage,
            value: ref.watch(novelShowScrollPercentageStateProvider),
            onChanged: (value) {
              ref
                  .read(novelShowScrollPercentageStateProvider.notifier)
                  .set(value);
            },
          ),
          if (hasActiveSession)
            ValueListenableBuilder(
              valueListenable: autoScrollPageNotifier,
              builder: (context, valueT, child) {
                return Column(
                  children: [
                    NovelSwitchSetting(
                      secondary: Icon(
                        valueT ? Icons.timer : Icons.timer_outlined,
                        size: 20,
                      ),
                      value: valueT,
                      title: context.l10n.auto_scroll,
                      onChanged: (val) {
                        controller.setAutoScroll(val, offsetNotifier.value);
                        autoScrollPageNotifier.value = val;
                        autoScrollNotifier.value = val;
                      },
                    ),
                    if (valueT)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor
                                .withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Theme.of(context).primaryColor
                                  .withValues(alpha: 0.15),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.speed_rounded,
                                        size: 16,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        context.l10n.speed,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.color,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ValueListenableBuilder<double>(
                                    valueListenable: offsetNotifier,
                                    builder: (context, val, _) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor
                                            .withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '${val.toStringAsFixed(1)}x',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              ValueListenableBuilder<double>(
                                valueListenable: offsetNotifier,
                                builder: (context, value, child) => Row(
                                  children: [
                                    Icon(
                                      Icons.directions_walk_rounded,
                                      size: 16,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color
                                          ?.withValues(alpha: 0.5),
                                    ),
                                    Expanded(
                                      child: SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          trackHeight: 3,
                                          thumbShape:
                                              const RoundSliderThumbShape(
                                                enabledThumbRadius: 6,
                                              ),
                                          overlayShape:
                                              const RoundSliderOverlayShape(
                                                overlayRadius: 12,
                                              ),
                                        ),
                                        child: Slider(
                                          min: 2.0,
                                          max: 30.0,
                                          divisions: max(28, 3),
                                          value: value.clamp(2.0, 30.0),
                                          onChanged: (val) {
                                            offsetNotifier.value = val;
                                          },
                                          onChangeEnd: (val) {
                                            controller.setAutoScroll(
                                              valueT,
                                              val,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.directions_run_rounded,
                                      size: 16,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color
                                          ?.withValues(alpha: 0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          NovelSwitchSetting(
            title: context.l10n.remove_extra_paragraph_spacing,
            value: ref.watch(novelRemoveExtraParagraphSpacingStateProvider),
            onChanged: (value) {
              ref
                  .read(novelRemoveExtraParagraphSpacingStateProvider.notifier)
                  .set(value);
            },
          ),

          NovelSwitchSetting(
            title: context.l10n.use_page_tap_zones,
            value: ref.watch(novelTapToScrollStateProvider),
            onChanged: (value) {
              ref.read(novelTapToScrollStateProvider.notifier).set(value);
            },
          ),
        ],
      ),
    );
  }
}
