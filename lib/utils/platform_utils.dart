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

/// Whether this device can use the floating capsule navigation bar.
///
/// Everywhere touch-first plus the two desktops that already match it: Apple,
/// Android and Linux. Windows is left on the material bar and the rail for
/// now, and a TV never takes the capsule at all. The capsule is driven by
/// pointer events and holds no focus handling, so a remote could not reach it;
/// leaving TV out is what keeps it on the rail it is actually navigable with.
///
/// A getter rather than a final, because [isTv] is hydrated asynchronously by
/// [initIsTv]. A top-level final is initialised on first read and cached for
/// the rest of the process, so on a TV it would latch whatever detection had
/// answered by then, which early in startup is "not a TV".
bool get supportsFloatingNav =>
    (isApple || Platform.isAndroid || Platform.isLinux) && !isTv;

/// Resolves the opt-in preference against platform and input support.
bool shouldUseFloatingNav({required bool enabled}) =>
    enabled && supportsFloatingNav;

/// Shares the shell's effective navigation mode with screens and overlays.
///
/// It defaults to false outside the main shell, so a standalone route or test
/// never gains floating-bar spacing just because it runs on a supported host.
class FloatingNavigationScope extends InheritedWidget {
  const FloatingNavigationScope({
    super.key,
    required this.enabled,
    required super.child,
  });

  final bool enabled;

  static bool enabledOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<FloatingNavigationScope>()
          ?.enabled ??
      false;

  @override
  bool updateShouldNotify(FloatingNavigationScope oldWidget) =>
      enabled != oldWidget.enabled;
}

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

/// Horizontal inset for primary TV controls and scrolling content.
///
/// Television panels can crop a small part of the picture, and content viewed
/// from across the room needs more edge separation than a handheld layout.
/// Five percent scales naturally from compact TV viewports to 4K while the
/// clamp avoids wasting space at either extreme. Off-TV this is zero so shared
/// screens keep their existing phone and desktop layout.
double tvHorizontalSafeInset(BuildContext context) {
  if (!isTv) return 0;
  return (MediaQuery.sizeOf(context).width * 0.05).clamp(24.0, 64.0);
}

EdgeInsets tvOverscanHorizontalInsets(BuildContext context) =>
    EdgeInsets.symmetric(horizontal: tvHorizontalSafeInset(context));

/// Bottom room a scrolling page should leave clear.
///
/// On Apple the nav bar floats over the content, and the shell sets
/// `extendBody`, so the Scaffold reports the bar's height here. On a pushed
/// route with no bar this is just the home indicator's inset. Either way a
/// scroll view that sets its own padding *replaces* what the Scaffold provided
/// rather than adding to it, which is how a list ends up running underneath
/// the bar; adding this back is what fixes it.
EdgeInsets pageBottomInsets(BuildContext context) =>
    FloatingNavigationScope.enabledOf(context)
    ? EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom + 8)
    : EdgeInsets.zero;
