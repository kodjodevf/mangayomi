import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// Shows the auto-scroll switch and speed bottom sheet from the reader bottom bar.
///
/// The sheet stays open while adjusting so the speed can be tried as the page
/// moves behind it.
void showReaderAutoScrollSheet(
  BuildContext context, {
  required ValueNotifier<bool> autoScrollPage,
  required ValueNotifier<bool> autoScroll,
  required ValueNotifier<double> pageOffset,
  required void Function(bool enabled, double offset) onSave,
  required VoidCallback onAutoPageScroll,
}) {
  final l10n = context.l10n;
  showShioriSheet<void>(
    context,
    title: l10n.auto_scroll,
    builder: (_) => SafeArea(
      top: false,
      child: ValueListenableBuilder<bool>(
        valueListenable: autoScrollPage,
        builder: (context, enabled, _) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShioriSwitchRow(
              icon: Symbols.timer_rounded,
              title: l10n.auto_scroll,
              value: enabled,
              onChanged: (value) {
                onSave(value, pageOffset.value);
                autoScrollPage.value = value;
                autoScroll.value = value;
                onAutoPageScroll();
              },
            ),
            if (enabled)
              ValueListenableBuilder<double>(
                valueListenable: pageOffset,
                builder: (context, speed, _) => ShioriSliderRow(
                  icon: Symbols.speed_rounded,
                  title: l10n.speed,
                  value: speed.clamp(2.0, 30.0),
                  min: 2,
                  max: 30,
                  divisions: 28,
                  onChanged: (value) => pageOffset.value = value,
                  onChangeEnd: (value) => onSave(enabled, value),
                ),
              ),
            const SizedBox(height: ShioriSpace.s8),
          ],
        ),
      ),
    ),
  );
}
