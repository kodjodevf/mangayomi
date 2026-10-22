import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

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
