import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// How far a sideways swipe must go, in logical pixels, to count.
const double _swipeDistance = 72;

/// How fast a sideways fling must be, in logical pixels a second.
const double _swipeVelocity = 700;

/// Calls [onNext] or [onPrevious] for a sideways swipe over [child], as a
/// page turns: a swipe toward the start side goes to the next.
///
/// What scrolls sideways inside keeps its swipe: over horizontal pages, it
/// is the swipe that goes past the first or the last page that counts.
/// The strips that scroll sideways without paging (tab bars, carousels)
/// are left alone.
class SideSwipeDetector extends StatefulWidget {
  const SideSwipeDetector({
    super.key,
    required this.child,
    this.onNext,
    this.onPrevious,
    this.enabled = true,
  });

  final Widget child;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final bool enabled;

  @override
  State<SideSwipeDetector> createState() => _SideSwipeDetectorState();
}

class _SideSwipeDetectorState extends State<SideSwipeDetector> {
  double _drag = 0;

  /// How far the pages were pulled past their first or last one.
  double _overscroll = 0;

  /// [offset] is how far the swipe went toward the end side of the screen.
  void _maybeSwipe(double offset, double velocity) {
    final far = offset.abs() >= _swipeDistance;
    final fast =
        velocity.abs() >= _swipeVelocity && velocity.sign == offset.sign;
    if (!far && !fast) return;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final next = rtl ? offset > 0 : offset < 0;
    final action = next ? widget.onNext : widget.onPrevious;
    if (action == null) return;
    HapticFeedback.selectionClick();
    action();
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification.metrics is! PageMetrics ||
        notification.metrics.axis != Axis.horizontal) {
      return false;
    }
    if (notification is ScrollStartNotification) {
      _overscroll = 0;
    } else if (notification is OverscrollNotification) {
      // Clamped pages, as on Android: the pull past the edge is reported.
      _overscroll -= notification.overscroll;
    } else if (notification is ScrollUpdateNotification) {
      // Bouncing pages, as on iOS: the pull shows as being out of range.
      final m = notification.metrics;
      if (m.pixels < m.minScrollExtent) {
        _overscroll = m.minScrollExtent - m.pixels;
      } else if (m.pixels > m.maxScrollExtent) {
        _overscroll = m.maxScrollExtent - m.pixels;
      }
    } else if (notification is ScrollEndNotification) {
      final pulled = _overscroll;
      _overscroll = 0;
      if (pulled.abs() >= _swipeDistance) _maybeSwipe(pulled, 0);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    return NotificationListener<ScrollNotification>(
      onNotification: _onScroll,
      // Where nothing inside scrolls sideways, the swipe reaches this.
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragStart: (_) => _drag = 0,
        onHorizontalDragUpdate: (details) => _drag += details.primaryDelta ?? 0,
        onHorizontalDragEnd: (details) =>
            _maybeSwipe(_drag, details.primaryVelocity ?? 0),
        child: widget.child,
      ),
    );
  }
}
