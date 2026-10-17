import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// The volume buttons as page turns, through the app's own platform channel
/// rather than a plugin.
///
/// On Android the activity takes the volume keys while this is enabled and
/// passes them here; the volume does not change. iOS has no way to take the
/// buttons: the volume is watched instead and put back to half after each
/// press, so both buttons register, and it is given back as it was when
/// this is disabled.
class VolumeKeys {
  VolumeKeys._();

  static const _channel = MethodChannel('com.kodjodevf.mangayomi.volume_keys');

  static void Function(bool up)? _onPress;

  /// Forces [isSupported] in tests, which run on the desktop.
  @visibleForTesting
  static bool? debugSupported;

  /// Whether the platform can do it at all.
  static bool get isSupported =>
      debugSupported ?? (Platform.isAndroid || Platform.isIOS);

  /// Starts passing the volume buttons to [onPress], with `true` for volume
  /// up; replaces any listener before it.
  static Future<void> enable(void Function(bool up) onPress) async {
    if (!isSupported) return;
    _onPress = onPress;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'press') _onPress?.call(call.arguments == 'up');
    });
    try {
      await _channel.invokeMethod('enable');
    } on MissingPluginException {
      _onPress = null;
    } on PlatformException {
      _onPress = null;
    }
  }

  /// Gives the volume buttons back to the system.
  static Future<void> disable() async {
    if (!isSupported || _onPress == null) return;
    _onPress = null;
    try {
      await _channel.invokeMethod('disable');
    } on MissingPluginException {
      // Nothing was taken.
    } on PlatformException {
      // Nothing was taken.
    }
  }
}
