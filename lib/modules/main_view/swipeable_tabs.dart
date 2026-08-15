import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Lets a horizontal drag carry you between top-level tabs, showing both the
/// page you are leaving and the one you are arriving at while your finger is
/// down.
///
/// The shell renders exactly one tab, so the neighbour does not exist until it
/// is asked for. [pageBuilder] builds it for the duration of the drag only;
/// once the drag commits, [onSwitch] navigates and the shell supplies the real
/// one. Building a whole screen for a peek is cheap next to rebuilding the
/// navigation stack around a PageView, and it leaves deep links, route
/// arguments and the desktop rail untouched.
class SwipeableTabs extends StatefulWidget {
  const SwipeableTabs({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.count,
    required this.pageBuilder,
    required this.onSwitch,
    this.enabled = true,
  });

  /// The live page, as built by the shell.
  final Widget child;
  final int currentIndex;
  final int count;

  /// Builds a neighbouring tab for the peek.
  final Widget Function(int index) pageBuilder;

  /// Called once a drag has carried far enough to commit.
  final ValueChanged<int> onSwitch;

  /// Off on tablets and TV, where the rail is the navigation and a horizontal
  /// drag belongs to the content.
  final bool enabled;

  /// How far across the width the drag has to travel to commit.
  static const _commitFraction = 0.28;

  /// Or how fast it has to be going, so a flick works without the distance.
  static const _commitVelocity = 450.0;

  static const _settleDuration = Duration(milliseconds: 220);

  /// Gap between the outgoing and incoming page while they are both on screen,
  /// so the two read as separate surfaces rather than one sliding sheet.
  static const _separator = 10.0;

  /// How far a pointer has to travel before this widget treats it as its own
  /// drag. Deliberately twice the touch slop: any scrollable inside the page
  /// claims at the normal slop, so by the time this triggers the inner one has
  /// already taken the pointer if it wanted it.
  static const _slop = 36.0;

  /// How much more horizontal than vertical the movement has to be. Keeps this
  /// to deliberate sideways drags instead of catching diagonals meant for the
  /// content.
  static const _horizontalBias = 2.0;

  @override
  State<SwipeableTabs> createState() => _SwipeableTabsState();
}

class _SwipeableTabsState extends State<SwipeableTabs>
    with SingleTickerProviderStateMixin {
  late final AnimationController _settle = AnimationController(
    vsync: this,
    duration: SwipeableTabs._settleDuration,
  )..addListener(() => setState(() {}));

  /// Drag offset in pixels. Negative means dragging towards the next tab.
  double _offset = 0;

  /// Where the settle animation started and where it is heading, so the
  /// controller's 0..1 value can be read as a position.
  double _settleFrom = 0;
  double _settleTo = 0;

  bool _dragging = false;

  /// Set when an inner horizontal scrollable claims the pointer. It keeps the
  /// gesture; all this widget does then is pick up the overscroll it reports
  /// once it runs out of room.
  bool _innerOwns = false;
  bool _engaged = false;
  Offset _down = Offset.zero;
  VelocityTracker? _velocity;

  @override
  void dispose() {
    _settle.dispose();
    super.dispose();
  }

  double get _position => _settle.isAnimating || _settle.value > 0 && !_dragging
      ? _settleFrom + (_settleTo - _settleFrom) * _settle.value
      : _offset;

  /// The neighbour a given drag direction leads to, or null at either end.
  int? _neighbourFor(double offset) {
    if (offset == 0) return null;
    final index = offset < 0
        ? widget.currentIndex + 1
        : widget.currentIndex - 1;
    if (index < 0 || index >= widget.count) return null;
    return index;
  }

  void _onPointerDown(PointerDownEvent event) {
    _down = event.position;
    _engaged = false;
    _innerOwns = false;
    _velocity = VelocityTracker.withKind(event.kind)
      ..addPosition(event.timeStamp, event.position);
  }

  void _onPointerMove(PointerMoveEvent event) {
    _velocity?.addPosition(event.timeStamp, event.position);
    // An inner scrollable is driving; the overscroll path takes over from here.
    if (_innerOwns) return;

    final total = event.position - _down;
    if (!_engaged) {
      // Clearly sideways and past the slop, or it belongs to whatever is
      // underneath.
      if (total.dx.abs() < SwipeableTabs._slop ||
          total.dx.abs() <= total.dy.abs() * SwipeableTabs._horizontalBias) {
        return;
      }
      _settle.stop();
      _engaged = true;
      _dragging = true;
      _offset = 0;
    }

    final width = context.size?.width ?? 1;
    var next = _offset + event.delta.dx;
    // Nothing to reveal past the first or last tab, so resist rather than
    // dragging a blank gap into view.
    if (_neighbourFor(next) == null) next = _offset + event.delta.dx * 0.25;
    setState(() => _offset = next.clamp(-width, width));
  }

  void _onPointerUp(PointerEvent event) {
    final v = _velocity?.getVelocity().pixelsPerSecond.dx ?? 0;
    _velocity = null;
    if (!_engaged) return;
    _engaged = false;
    _finish(velocity: v);
  }

  void _finish({required double velocity}) {
    final width = context.size?.width ?? 1;
    final target = _neighbourFor(_offset);

    final farEnough = _offset.abs() > width * SwipeableTabs._commitFraction;
    final fastEnough =
        velocity.abs() > SwipeableTabs._commitVelocity &&
        velocity.sign == _offset.sign;

    _dragging = false;
    if (target != null && (farEnough || fastEnough)) {
      _settleFrom = _offset;
      _settleTo = _offset < 0 ? -width : width;
      _settle.forward(from: 0).whenComplete(() {
        HapticFeedback.selectionClick();
        widget.onSwitch(target);
        // The shell swaps the child in on the next frame; drop the peek then,
        // not before, or the outgoing page flashes back into view.
        if (mounted) {
          setState(() {
            _offset = 0;
            _settle.value = 0;
          });
        }
      });
    } else {
      _settleFrom = _offset;
      _settleTo = 0;
      _settle.forward(from: 0);
    }
    setState(() {});
  }

  /// Carries an inner tab set's overscroll into the same drag.
  ///
  /// A TabBarView wins the gesture before this widget ever sees it, and
  /// Flutter does not pass a drag up to a parent scrollable at the edge. But
  /// TabBarView clamps rather than bouncing, so once it has nowhere left to go
  /// it reports the leftover as overscroll, and that is the rest of the same
  /// finger movement. Reading it here is what lets a swipe run out of the last
  /// section and straight on into the next tab.
  bool _onInnerScroll(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.horizontal) return false;

    // Whoever started scrolling horizontally owns this pointer, so stay out of
    // its way rather than fighting it for the gesture.
    if (notification is ScrollStartNotification) _innerOwns = true;

    if (notification is OverscrollNotification) {
      final width = context.size?.width ?? 1;
      // Overscroll past the end is a drag towards the next tab, which moves
      // the pages the other way.
      var next = _offset - notification.overscroll;
      if (_neighbourFor(next) == null) return false;
      _settle.stop();
      setState(() {
        _dragging = true;
        _offset = next.clamp(-width, width);
      });
      return false;
    }

    if (notification is ScrollEndNotification && _offset != 0) {
      _finish(velocity: 0);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    final position = _position;
    final neighbour = _neighbourFor(position);

    return NotificationListener<ScrollNotification>(
      onNotification: _onInnerScroll,
      // A Listener, not a GestureDetector. A drag recognizer here joins the
      // gesture arena and beats the scrollables inside the page, which left
      // inner tab sets unswipeable except by their header. Raw pointer events
      // never enter the arena, so everything underneath keeps working and this
      // widget only acts when nothing else claimed the pointer.
      child: Listener(
        onPointerDown: _onPointerDown,
        onPointerMove: _onPointerMove,
        onPointerUp: _onPointerUp,
        onPointerCancel: _onPointerUp,
        // Always the same shape, even at rest. Swapping between a bare child
        // and a wrapped one reparents the page the moment a drag starts, which
        // throws away the state of anything inside it: an inner tab set loses
        // its position and its half-finished gesture.
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            // The neighbour sits a full width away plus the gap, so the
            // two never touch while both are on screen.
            final step = width + SwipeableTabs._separator;
            return Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Transform.translate(
                  offset: Offset(position, 0),
                  child: widget.child,
                ),
                if (neighbour != null)
                  Transform.translate(
                    offset: Offset(position + (position < 0 ? step : -step), 0),
                    child: SizedBox(
                      width: width,
                      child: widget.pageBuilder(neighbour),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
