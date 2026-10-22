import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/screen_brightness.dart';
import 'package:shiori/shiori.dart';

/// Whether the screen can be held one way at all: phones and tablets.
bool get readerOrientationSupported => Platform.isAndroid || Platform.isIOS;

/// Holds the screen as [value] says while a reader is open: 0 follows the
/// device, 1 portrait, 2 landscape.
void applyReaderOrientation(int value) {
  if (!readerOrientationSupported) return;
  SystemChrome.setPreferredOrientations(switch (value) {
    1 => const [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    2 => const [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ],
    // Empty: every orientation the app allows.
    _ => const [],
  });
}

/// Lets the screen turn freely again, as the rest of the app does.
void releaseReaderOrientation() => applyReaderOrientation(0);

/// The orientation setting as a row, for Settings › Reader and the readers'
/// sheets; nothing where the screen cannot be held. No icon, as none of the
/// rows around it in those groups has one.
class ReaderOrientationRow extends ConsumerWidget {
  const ReaderOrientationRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!readerOrientationSupported) return const SizedBox.shrink();
    final l10n = context.l10n;
    return ShioriValueRow<int>(
      title: l10n.reader_orientation,
      value: ref.watch(readerOrientationStateProvider),
      options: [
        ShioriChoice(0, l10n.orientation_free),
        ShioriChoice(1, l10n.orientation_portrait),
        ShioriChoice(2, l10n.orientation_landscape),
      ],
      onChanged: (v) =>
          ref.read(readerOrientationStateProvider.notifier).set(v),
    );
  }
}

/// Applies the readers' screen brightness: 1 to 100, or -1 for the
/// system's own.
void applyReaderScreenBrightness(int value) {
  if (value < 0) {
    ScreenBrightness.reset();
  } else {
    ScreenBrightness.set(value / 100);
  }
}

/// The screen brightness setting as a slider row; nothing where the screen
/// cannot be set. Following the system, the slider rests at the middle and
/// says so; once set, the reset goes back to the system.
class ReaderScreenBrightnessRow extends ConsumerWidget {
  const ReaderScreenBrightnessRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ScreenBrightness.isSupported) return const SizedBox.shrink();
    final l10n = context.l10n;
    final value = ref.watch(readerScreenBrightnessStateProvider);
    final system = value < 0;
    final shown = system ? 50.0 : value.toDouble();
    final notifier = ref.read(readerScreenBrightnessStateProvider.notifier);
    return ShioriSliderRow(
      title: l10n.screen_brightness,
      subtitle: system ? l10n.screen_brightness_system : null,
      value: shown,
      min: 1,
      max: 100,
      divisions: 99,
      valueLabel: (v) => system ? '' : '${v.round()} %',
      // The reset shows only once a brightness is chosen.
      defaultValue: system ? shown : -1,
      onReset: () => notifier.set(-1),
      resetTooltip: l10n.reset,
      onChanged: (v) => notifier.set(v.round(), end: false),
      onChangeEnd: (v) => notifier.set(v.round()),
    );
  }
}
