import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Frame-driven auto-scroll shared by the manga and novel readers.
///
/// Scrolls [autoScrollController] at [autoScrollSpeed] × 10 px/s while
/// [autoScrollEnabled] is on and [canAutoScroll] holds, pauses while the user
/// drags, and turns itself off at the end of the content.
mixin ReaderAutoScroll<T extends StatefulWidget> on State<T>, TickerProvider {
  ValueNotifier<bool> get autoScrollEnabled;
  ValueNotifier<double> get autoScrollSpeed;
  ScrollController get autoScrollController;

  /// Auto-scroll only runs in continuous reading modes.
  bool get canAutoScroll;

  /// Set while a finger or pointer drags the content, so the ticker yields.
  bool isUserDragging = false;

  Ticker? _autoScrollTicker;
  Duration _lastAutoScrollTick = Duration.zero;

  void onAutoScrollChanged() {
    if (autoScrollEnabled.value && canAutoScroll) {
      startAutoScroll();
    } else {
      stopAutoScroll();
    }
  }

  void startAutoScroll() {
    _autoScrollTicker ??= createTicker(_onAutoScrollTick);
    _lastAutoScrollTick = Duration.zero;
    if (!_autoScrollTicker!.isActive) {
      _autoScrollTicker!.start();
    }
  }

  void stopAutoScroll() {
    if (_autoScrollTicker != null && _autoScrollTicker!.isActive) {
      _autoScrollTicker!.stop();
    }
    _lastAutoScrollTick = Duration.zero;
  }

  void disposeAutoScroll() => _autoScrollTicker?.dispose();

  void _onAutoScrollTick(Duration elapsed) {
    if (!mounted || !autoScrollEnabled.value || !canAutoScroll) {
      stopAutoScroll();
      return;
    }
    if (isUserDragging) {
      _lastAutoScrollTick = elapsed;
      return;
    }
    if (_lastAutoScrollTick == Duration.zero) {
      _lastAutoScrollTick = elapsed;
      return;
    }
    final double dt =
        (elapsed - _lastAutoScrollTick).inMicroseconds / 1000000.0;
    _lastAutoScrollTick = elapsed;

    if (dt <= 0 || dt > 0.1) return;

    final controller = autoScrollController;
    if (controller.hasClients) {
      final position = controller.position;
      final double pixelsPerSecond = autoScrollSpeed.value * 10.0;
      final double delta = pixelsPerSecond * dt;
      final double currentOffset = position.pixels;
      final double maxScroll = position.maxScrollExtent;
      final double minScroll = position.minScrollExtent;

      if (currentOffset >= maxScroll && delta > 0) {
        autoScrollEnabled.value = false;
        stopAutoScroll();
        return;
      }

      final double newOffset = (currentOffset + delta).clamp(
        minScroll,
        maxScroll,
      );
      if (newOffset != currentOffset) {
        controller.jumpTo(newOffset);
      }
    }
  }
}
