import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/novel/novel_reader_controller_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/modules/novel/widgets/novel_settings_controls.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_switches.dart';
import 'package:mangayomi/services/volume_keys.dart';
import 'package:mangayomi/modules/reader_common/utils/reader_orientation.dart';

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
      padding: const EdgeInsets.symmetric(vertical: ShioriSpace.s8),
      child: Column(
        children: [
          const ReaderOrientationRow(),
          const ReaderScreenBrightnessRow(),
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
              builder: (context, enabled, child) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NovelSwitchSetting(
                    icon: Symbols.timer_rounded,
                    value: enabled,
                    title: context.l10n.auto_scroll,
                    onChanged: (val) {
                      controller.setAutoScroll(val, offsetNotifier.value);
                      autoScrollPageNotifier.value = val;
                      autoScrollNotifier.value = val;
                    },
                  ),
                  if (enabled)
                    ValueListenableBuilder<double>(
                      valueListenable: offsetNotifier,
                      builder: (context, speed, _) => ShioriSliderRow(
                        icon: Symbols.speed_rounded,
                        title: context.l10n.speed,
                        value: speed.clamp(2.0, 30.0),
                        min: 2,
                        max: 30,
                        divisions: 28,
                        valueLabel: (v) => '${v.toStringAsFixed(1)}×',
                        onChanged: (val) => offsetNotifier.value = val,
                        onChangeEnd: (val) =>
                            controller.setAutoScroll(enabled, val),
                      ),
                    ),
                ],
              ),
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
          // The same switches as the manga reader's: one setting for both.
          if (VolumeKeys.isSupported) ...[
            const ReaderSwitchRow(ReaderSwitch.volumeKeysPaging),
            if (ref.watch(volumeKeysPagingStateProvider))
              const ReaderSwitchRow(ReaderSwitch.volumeKeysInverted),
          ],
        ],
      ),
    );
  }
}
