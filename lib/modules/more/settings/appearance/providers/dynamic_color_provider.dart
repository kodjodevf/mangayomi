import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DynamicColorSchemesNotifier
    extends Notifier<(ColorScheme?, ColorScheme?)> {
  final (ColorScheme?, ColorScheme?) _initial;
  DynamicColorSchemesNotifier([
    (ColorScheme?, ColorScheme?) initial = (null, null),
  ]) : _initial = initial;

  @override
  (ColorScheme?, ColorScheme?) build() => _initial;

  void set(ColorScheme? light, ColorScheme? dark) {
    state = (light, dark);
  }
}

/// Holds the dynamic color schemes extracted from the system/wallpaper (Monet).
final dynamicColorSchemesProvider =
    NotifierProvider<DynamicColorSchemesNotifier, (ColorScheme?, ColorScheme?)>(
  DynamicColorSchemesNotifier.new,
);

/// Indicates whether dynamic colors (Monet / accent colors) are supported and detected on this device.
final dynamicColorAvailableProvider = Provider<bool>((ref) {
  final (light, dark) = ref.watch(dynamicColorSchemesProvider);
  return light != null || dark != null;
});
