import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

/// macOS, Linux or Windows
final bool isDesktop =
    Platform.isMacOS || Platform.isLinux || Platform.isWindows;

/// Android or iOS
final bool isMobile = Platform.isAndroid || Platform.isIOS;

/// macOS or iOS
final bool isApple = Platform.isMacOS || Platform.isIOS;

/// Whether the app is running on an Android TV / leanback device.
///
/// Defaults to false and is hydrated once at startup by [initIsTv] (Android
/// only); it stays false on every other platform. Nothing branches on this
/// yet — it's the detection foundation for Android TV support (see #729).
bool isTv = false;

/// Asks the native side whether this is a TV / leanback device and caches the
/// answer in [isTv]. No-op (and leaves [isTv] false) on non-Android platforms
/// or if the channel isn't available. Safe to call once the engine is up.
Future<void> initIsTv() async {
  if (!Platform.isAndroid) return;
  try {
    const channel = MethodChannel('com.kodjodevf.mangayomi.device');
    isTv = (await channel.invokeMethod<bool>('isTv')) ?? false;
  } catch (_) {
    isTv = false;
  }
  if (kDebugMode) {
    debugPrint('[platform] isTv = $isTv');
  }
}

/// Horizontal breathing room for a TV screen's scrolling content.
///
/// A TV is viewed from across the room and its panel may overscan, so content
/// running flush to the edges reads badly. Off-TV this is [EdgeInsets.zero], so
/// phone and desktop layouts are byte-for-byte unchanged.
EdgeInsets get tvPageInsets =>
    isTv ? const EdgeInsets.symmetric(horizontal: 16) : EdgeInsets.zero;
