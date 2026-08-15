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

/// Platforms using the floating capsule navigation bar rather than the
/// material one. Apple only for now; Android, Windows and Linux still take the
/// material bar or the rail.
final bool usesFloatingNav = isApple;

/// What the device reported, hydrated once at startup by [initIsTv].
bool _isTvDetected = false;

/// Set by [debugIsTvOverride]; wins over detection when non-null.
bool? _isTvOverride;

/// Whether the app should use the Android TV / leanback layout.
///
/// False on every non-Android platform. Roughly 125 call sites branch on this,
/// so it is effectively a second layout mode rather than a device flag, and
/// until now it could only ever be true on real TV hardware. [debugIsTvOverride]
/// exists so the TV layout can be driven from a test or a desktop debug build
/// instead, which is the only way to reproduce a TV layout bug without a
/// television on the desk.
bool get isTv => _isTvOverride ?? _isTvDetected;

/// Forces the TV layout on or off regardless of what the device reported.
///
/// Pass null to go back to detection. Intended for tests and for exercising the
/// TV layout on a desktop debug build; production code should read [isTv].
@visibleForTesting
set debugIsTvOverride(bool? value) => _isTvOverride = value;

/// The current override, or null when [isTv] is following detection.
@visibleForTesting
bool? get debugIsTvOverride => _isTvOverride;

/// Asks the native side whether this is a TV / leanback device and caches the
/// answer. No-op (and leaves [isTv] false) on non-Android platforms or if the
/// channel isn't available. Safe to call once the engine is up.
Future<void> initIsTv() async {
  if (!Platform.isAndroid) return;
  try {
    const channel = MethodChannel('com.kodjodevf.mangayomi.device');
    _isTvDetected = (await channel.invokeMethod<bool>('isTv')) ?? false;
  } catch (_) {
    _isTvDetected = false;
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
