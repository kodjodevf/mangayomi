import 'package:flutter/services.dart';

void restoreSystemUI() => SystemChrome.setEnabledSystemUIMode(
  SystemUiMode.manual,
  overlays: SystemUiOverlay.values,
);
