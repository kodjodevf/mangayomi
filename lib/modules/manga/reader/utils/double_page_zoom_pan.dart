import 'package:flutter/animation.dart';
import 'package:photo_view/photo_view.dart';

/// Pure geometry for "pan to the edge, then turn the page" in a zoomed
/// double-page spread: given how far the current pan already is from the
/// edge, decides whether the next/previous-page gesture should pan further
/// or fall through to an actual page turn.
class DoublePageZoomNavigation {
  const DoublePageZoomNavigation();

  static const double _edgeSlack = 15.0;

  /// The pan target for a "next page" gesture, or `null` if the pan is
  /// already at (or past) its edge and the caller should turn the page
  /// instead. [dx] is the spread's current horizontal pan offset, [maxX] the
  /// furthest it can pan (0 or negative means not zoomed in enough to pan).
  double? nextPanTarget({
    required double dx,
    required double maxX,
    required double step,
    required bool isReverseHorizontal,
  }) => _panTarget(
    dx: dx,
    maxX: maxX,
    step: step,
    // "Next" pans toward the reading direction: forward (positive) in RTL,
    // backward (negative) otherwise.
    towardPositive: isReverseHorizontal,
  );

  /// Same as [nextPanTarget], for a "previous page" gesture (the opposite
  /// pan direction).
  double? previousPanTarget({
    required double dx,
    required double maxX,
    required double step,
    required bool isReverseHorizontal,
  }) => _panTarget(
    dx: dx,
    maxX: maxX,
    step: step,
    towardPositive: !isReverseHorizontal,
  );

  double? _panTarget({
    required double dx,
    required double maxX,
    required double step,
    required bool towardPositive,
  }) {
    if (maxX < _edgeSlack) return null;
    if (towardPositive) {
      if (dx >= maxX - _edgeSlack) return null;
      return (dx + step).clamp(-maxX, maxX);
    } else {
      if (dx <= -maxX + _edgeSlack) return null;
      return (dx - step).clamp(-maxX, maxX);
    }
  }
}

/// Owns the [AnimationController] that drives a double-page spread's pan
/// animation (the "pan toward the edge" half of zoom-then-turn-page). A
/// plain class rather than a mixin/widget: the reader's State just creates
/// one (passing itself as its vsync, since it already mixes in
/// TickerProviderStateMixin) and disposes it alongside its own state.
class DoublePagePanAnimator {
  DoublePagePanAnimator(this._vsync);

  final TickerProvider _vsync;
  AnimationController? _controller;

  void dispose() {
    _controller?.dispose();
  }

  /// Animates the spread's currently-active [PhotoViewController] (looked up
  /// fresh on every tick via [controllerLookup], since which spread is
  /// "current" can change mid-animation) to [targetDx].
  void animateTo({
    required PhotoViewController? Function() controllerLookup,
    required double targetDx,
  }) {
    final controller = controllerLookup();
    if (controller == null) return;

    _controller?.dispose();

    final startDx = controller.position.dx;
    final dy = controller.position.dy;

    final animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: _vsync,
    );
    _controller = animationController;

    final animation = Tween<double>(begin: startDx, end: targetDx).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic),
    );

    animation.addListener(() {
      final activeController = controllerLookup();
      if (activeController != null) {
        activeController.position = Offset(animation.value, dy);
      }
    });

    animationController.forward();
  }
}
