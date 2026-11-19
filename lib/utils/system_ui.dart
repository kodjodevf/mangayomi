import 'package:flutter/services.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:window_manager/window_manager.dart';

/// Whether a screen may switch the window to fullscreen by itself, as the
/// reader and the player do as they open when their setting asks for it.
///
/// Not under Wayland: with Flutter 3.50 the app can freeze for good as its
/// window goes fullscreen there, the raster thread waiting on the compositor
/// while holding what GTK waits for
/// (https://github.com/flutter/flutter/issues/196529). The user can still
/// switch it themselves. Drop this once a Flutter release has the fix
/// (https://github.com/flutter/flutter/pull/196945).
final bool mayEnterFullScreenOnItsOwn = !isLinuxWayland;

void restoreSystemUI() => SystemChrome.setEnabledSystemUIMode(
  SystemUiMode.manual,
  overlays: SystemUiOverlay.values,
);

Future<bool> setFullScreen({bool? value}) async {
  if (value != null) {
    await windowManager.setFullScreen(value);
    return value;
  }
  final isFullScreen = await windowManager.isFullScreen();
  await windowManager.setFullScreen(!isFullScreen);
  return !isFullScreen;
}
