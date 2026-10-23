import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mangayomi/utils/error_toast.dart';

/// Secure screen settings: never, only in incognito mode, always.
enum SecureScreenMode { never, incognito, always }

/// Whether the screen is kept out of screenshots and the app switcher, for
/// [mode], with incognito mode [incognito].
bool isScreenSecure(SecureScreenMode mode, {required bool incognito}) =>
    switch (mode) {
      SecureScreenMode.never => false,
      SecureScreenMode.incognito => incognito,
      SecureScreenMode.always => true,
    };

/// Keeps the app's window out of screenshots, screen recordings and the
/// app switcher's preview, on Android.
abstract final class SecureScreen {
  static const _channel = MethodChannel(
    'com.kodjodevf.mangayomi.secure_screen',
  );

  static bool _secure = false;

  static Future<void> apply(bool secure) async {
    if (!Platform.isAndroid || secure == _secure) return;
    _secure = secure;
    try {
      await _channel.invokeMethod('set', secure);
    } catch (e, s) {
      recordError(e, stack: s, source: 'secure_screen');
    }
  }
}
