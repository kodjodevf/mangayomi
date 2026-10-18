import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// The screen's brightness while reading or watching, through the app's own
/// platform channel rather than a plugin.
///
/// On Android only the app's window is brightened or dimmed; the system
/// setting is left alone and comes back with [reset]. On iOS the screen's
/// brightness is set, and the one before it is put back with [reset].
class ScreenBrightness {
  ScreenBrightness._();

  static const _channel = MethodChannel(
    'com.kodjodevf.mangayomi.screen_brightness',
  );

  /// Forces [isSupported] in tests, which run on the desktop.
  @visibleForTesting
  static bool? debugSupported;

  static bool get isSupported =>
      debugSupported ?? (Platform.isAndroid || Platform.isIOS);

  /// Sets the brightness, from 0 to 1.
  static Future<void> set(double value) =>
      _call('set', value.clamp(0.01, 1.0).toDouble());

  /// The brightness now, from 0 to 1: the one set here, else the system's;
  /// null where it cannot be read.
  static Future<double?> current() async {
    if (!isSupported) return null;
    try {
      final value = await _channel.invokeMethod<double>('get');
      return value?.clamp(0.0, 1.0).toDouble();
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }

  /// Gives the brightness back to the system.
  static Future<void> reset() => _call('reset');

  static Future<void> _call(String method, [Object? argument]) async {
    if (!isSupported) return;
    try {
      await _channel.invokeMethod(method, argument);
    } on MissingPluginException {
      // An older build: the screen keeps its own brightness.
    } on PlatformException {
      // Nothing changed.
    }
  }
}
