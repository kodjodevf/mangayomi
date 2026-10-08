import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:window_manager/window_manager.dart' show windowManager;

/// Lets a desktop screen pin its window above others, and puts the window
/// back the way it was when the screen goes away.
mixin AlwaysOnTopStateMixin<T extends StatefulWidget> on State<T> {
  // The original alwaysOnTop state.
  // This will be used to restore the original state when the widget disposed.
  bool? _savedAlwaysOnTop;

  bool _alwaysOnTop = false;

  bool get alwaysOnTop => _alwaysOnTop;

  // Whether the platform support AlwaysOnTop feature.
  bool get supportsAlwaysOnTop => !kIsWeb && isDesktop;

  @override
  void initState() {
    super.initState();
    _initAlwaysOnTop();
  }

  @override
  void dispose() {
    super.dispose();
    _disposeAlwaysOnTop();
  }

  void toggleAlwaysOnTop() {
    setState(() => _alwaysOnTop = !_alwaysOnTop);
    windowManager.setAlwaysOnTop(_alwaysOnTop);
  }

  Future<void> _initAlwaysOnTop() async {
    if (supportsAlwaysOnTop) {
      _savedAlwaysOnTop = await windowManager.isAlwaysOnTop();
      if (mounted) {
        setState(() => _alwaysOnTop = _savedAlwaysOnTop!);
      }
    }
  }

  Future<void> _disposeAlwaysOnTop() async {
    if (supportsAlwaysOnTop) {
      if (_savedAlwaysOnTop != null) {
        await windowManager.setAlwaysOnTop(_savedAlwaysOnTop!);
      }
    }
  }
}
