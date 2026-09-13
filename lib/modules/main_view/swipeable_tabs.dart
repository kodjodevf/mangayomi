import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Lays out the shell's branch navigators, and lets a horizontal drag carry
/// you between them with both pages visible while your finger is down.
///
/// Every branch stays mounted whichever tab is showing, which is what the
/// stateful shell is for, so the peek shows the real page with its own scroll
/// position rather than a second copy built for the occasion. The ones not on
/// screen are held offstage: still alive, not laid out, not painted.
///
/// It also carries a tab change that came from a tap. Switching a branch never
/// animates by itself, so without this the page would simply appear; here it
/// arrives from the side its tab sits on.
class SwipeableTabs extends StatefulWidget {
  const SwipeableTabs({
    super.key,
    required this.branches,
    required this.order,
    required this.currentIndex,
    required this.onSwitch,
    this.onProgress,
    this.enabled = true,
  });

  /// Every branch navigator the shell built, in the shell's own order.
  final List<Widget> branches;

  /// Which branch each entry of the visible tab strip belongs to, in the
  /// user's own arrangement. Null where an entry is a toggle rather than a
  /// destination, like the merged-library switch.
  final List<int?> order;

  /// Position in [order], not in [branches].
  final int currentIndex;

  /// Called once a drag has carried far enough to commit.
  final ValueChanged<int> onSwitch;

  /// Reports which tab the swipe is heading for and how far along it is, 0 to
  /// 1, so the navigation bar can follow the drag instead of only hearing
  /// about it once the swipe has finished.
  final void Function(int? target, double progress)? onProgress;

  /// Whether a drag switches tabs. Off leaves the layout and the tap slide
  /// exactly as they are and simply stops listening for the gesture.
  final bool enabled;

  /// Drag speed, in points a second, at which the pill stops reaching.
  ///
  /// The reach is for a deliberate drag: you pull, the pill strains, you see
  /// it. Flicking through tabs one after another is not that, and a pill
  /// stretching on every flick is noise, so it fades out as the drag gets
  /// quicker and a fast swipe simply switches.
  static const _deliberateBelow = 400.0;
  static const _hurriedAbove = 1600.0;

  /// How far across the width the drag has to travel to commit.
  static const _commitFraction = 0.28;

  /// Or how fast it has to be going, so a flick works without the distance.
  static const _commitVelocity = 450.0;

  static const _settleDuration = Duration(milliseconds: 220);

  /// How long to wait for the shell to actually change tab after a commit
  /// before assuming it is not going to and putting the pages back. Long
  /// enough to be well clear of a router round trip, since firing early is
  /// what causes the page just left to flash back into the middle.
  static const _handoverGiveUp = Duration(milliseconds: 400);

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
  late final AnimationController _settle =
      AnimationController(vsync: this, duration: SwipeableTabs._settleDuration)
        ..addListener(() {
          setState(() {});
          // The cached width, not the render object's: this fires mid-pipeline,
          // when the box may be dirty for layout, and asking then throws.
          _report(_position, _lastWidth);
        });

  /// Drag offset in pixels. Negative means dragging towards the next tab.
  double _offset = 0;

  /// Where the settle animation started and where it is heading, so the
  /// controller's 0..1 value can be read as a position.
  double _settleFrom = 0;
  double _settleTo = 0;

  bool _dragging = false;

  /// Last known width. The settle listener cannot ask the render object for its
  /// size: it fires mid-pipeline, when the box may be dirty for layout, and
  /// asking then throws.
  double _lastWidth = 0;

  /// Smoothed drag speed, and the timestamp it was last measured at.
  double _speed = 0;
  Duration _lastStamp = Duration.zero;

  /// 1 for a slow, deliberate drag and 0 for a hurried one.
  double get _deliberate {
    if (_speed <= SwipeableTabs._deliberateBelow) return 1;
    if (_speed >= SwipeableTabs._hurriedAbove) return 0;
    final span = SwipeableTabs._hurriedAbove - SwipeableTabs._deliberateBelow;
    return 1 - (_speed - SwipeableTabs._deliberateBelow) / span;
  }

  /// Set when an inner horizontal scrollable claims the pointer. It keeps the
  /// gesture; all this widget does then is pick up the overscroll it reports
  /// once it runs out of room.
  bool _innerOwns = false;
  bool _engaged = false;

  /// The tab a tap-driven slide is coming from, while it plays.
  ///
  /// A drag works its neighbour out from the direction it is going, but a tap
  /// can jump several tabs at once, and the page sliding out then is the one
  /// you left rather than the one next door.
  int? _outgoing;

  /// Set while a committed drag hands over to the shell, so the tab change it
  /// causes is not mistaken for a tap and animated a second time.
  bool _committing = false;

  /// Fallback for a commit whose tab change never arrives.
  Timer? _handover;
  Offset _down = Offset.zero;
  VelocityTracker? _velocity;

  @override
  void didUpdateWidget(SwipeableTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex == oldWidget.currentIndex) return;
    // The drag that caused this has already carried the pages across. This is
    // the build that brings the new tab in, so the offset the settle left
    // behind goes now: any earlier and the outgoing page reappears in the
    // middle for a frame.
    if (_committing) {
      _handover?.cancel();
      _committing = false;
      _offset = 0;
      _settle.value = 0;
      return;
    }
    if (_dragging || _settle.isAnimating) return;
    if (_lastWidth <= 0) return;

    // Arrives from the side its tab sits on: a tab to the right comes in from
    // the right, and the one being left goes out to the left behind it.
    final from = widget.currentIndex > oldWidget.currentIndex ? 1 : -1;
    _outgoing = oldWidget.currentIndex;
    _offset = 0;
    _settleFrom = from * (_lastWidth + SwipeableTabs._separator);
    _settleTo = 0;
    _settle.forward(from: 0).whenComplete(() {
      if (mounted) setState(() => _outgoing = null);
    });
  }

  @override
  void dispose() {
    _handover?.cancel();
    _settle.dispose();
    super.dispose();
  }

  double get _position => _settle.isAnimating || _settle.value > 0 && !_dragging
      ? _settleFrom + (_settleTo - _settleFrom) * _settle.value
      : _offset;

  /// Tells the bar where this drag is going. Called after every change to the
  /// position, including the settle, so the pill tracks the whole gesture and
  /// not just its start and end.
  void _report(double position, double width) {
    final report = widget.onProgress;
    if (report == null) return;
    // A tap has already moved the bar's selection; reporting a target here
    // would have the pill reach for a tab it is standing on.
    if (_outgoing != null) return;
    final target = _neighbourFor(position);
    if (target == null || width <= 0) {
      report(null, 0);
      return;
    }
    // Scaled by how deliberate the drag is, so a flick reports almost nothing
    // and the pill does not stretch on every quick swipe.
    final progress = (position.abs() / width).clamp(0.0, 1.0);
    report(target, progress * _deliberate);
  }

  /// The neighbour a given drag direction leads to, or null at either end.
  int? _neighbourFor(double offset) {
    if (offset == 0) return null;
    final index = offset < 0
        ? widget.currentIndex + 1
        : widget.currentIndex - 1;
    if (index < 0 || index >= widget.order.length) return null;
    return index;
  }

  /// Only a finger drives this.
  ///
  /// On desktop the same shell is used, so without this a click-and-drag
  /// anywhere on a page switched tabs, which is not what dragging a mouse
  /// means. A trackpad swipe arrives as a scroll rather than a drag and never
  /// reached here anyway.
  static bool _isDragKind(PointerDeviceKind kind) =>
      kind == PointerDeviceKind.touch || kind == PointerDeviceKind.stylus;

  void _onPointerDown(PointerDownEvent event) {
    if (!widget.enabled || !_isDragKind(event.kind)) return;
    _down = event.position;
    _speed = 0;
    _lastStamp = event.timeStamp;
    _engaged = false;
    _innerOwns = false;
    _velocity = VelocityTracker.withKind(event.kind)
      ..addPosition(event.timeStamp, event.position);
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (!widget.enabled || !_isDragKind(event.kind)) return;
    _velocity?.addPosition(event.timeStamp, event.position);

    final dt = (event.timeStamp - _lastStamp).inMicroseconds / 1000000;
    _lastStamp = event.timeStamp;
    if (dt > 0) {
      // Smoothed, or a single stuttering frame reads as a flick.
      _speed = _speed * 0.7 + (event.delta.dx.abs() / dt) * 0.3;
    }
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
    _lastWidth = width;
    final next = _offset + event.delta.dx;
    // Nothing to reveal past the first or last tab. The page stays put rather
    // than giving: a page that shifts under the finger reads as the swipe
    // having been taken, and then nothing happens.
    if (_neighbourFor(next) == null) return;
    setState(() => _offset = next.clamp(-width, width));
    _report(_offset, width);
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
    _lastWidth = width;
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
        _committing = true;
        widget.onSwitch(target);
        // The bar's own selection takes over from here.
        widget.onProgress?.call(null, 0);
        // The offset is deliberately left where the settle put it. Zeroing it
        // here would centre the page again while the shell still has the old
        // tab selected, and the page you just swiped away flashes back for a
        // frame before the new one arrives. It is cleared in didUpdateWidget
        // instead, on the build that actually brings the new tab in.
        //
        // Unless the switch never lands: a destination that only toggles the
        // library switcher can leave the selection where it was, and without
        // this the page would stay parked off screen.
        //
        // On a timer rather than the next frame. The router does not swap the
        // branch in the frame it is asked to, so a next-frame fallback fires
        // into that gap and puts the page back in the middle itself, which is
        // the very flicker it is here to avoid.
        _handover?.cancel();
        _handover = Timer(SwipeableTabs._handoverGiveUp, () {
          if (!mounted || !_committing) return;
          setState(() {
            _committing = false;
            _offset = 0;
            _settle.value = 0;
          });
        });
      });
    } else {
      _settleFrom = _offset;
      _settleTo = 0;
      _settle.forward(from: 0).whenComplete(() {
        if (mounted) widget.onProgress?.call(null, 0);
      });
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
    if (!widget.enabled) return false;
    if (notification.metrics.axis != Axis.horizontal) return false;

    // Whoever started scrolling horizontally owns this pointer, so stay out of
    // its way rather than fighting it for the gesture.
    if (notification is ScrollStartNotification) _innerOwns = true;

    if (notification is OverscrollNotification) {
      final width = context.size?.width ?? 1;
      _lastWidth = width;
      // Overscroll past the end is a drag towards the next tab, which moves
      // the pages the other way.
      var next = _offset - notification.overscroll;
      if (_neighbourFor(next) == null) return false;
      _settle.stop();
      setState(() {
        _dragging = true;
        _offset = next.clamp(-width, width);
      });
      _report(_offset, width);
      return false;
    }

    if (notification is ScrollEndNotification && _offset != 0) {
      _finish(velocity: 0);
    }
    return false;
  }

  /// One branch, always in the same slot of the stack.
  ///
  /// Position and visibility change; the shape never does. Swapping a branch
  /// between two different wrappers as it becomes current would reparent it,
  /// and everything inside would lose its state on every tab change.
  Widget _slot({
    required int branch,
    required int? neighbour,
    required double position,
    required double width,
    required double step,
  }) {
    final strip = widget.order.indexOf(branch);
    final isCurrent = strip == widget.currentIndex;
    final isNeighbour = neighbour != null && strip == neighbour;
    final visible = isCurrent || isNeighbour;

    return Positioned(
      key: ValueKey(branch),
      left: isCurrent
          ? position
          : isNeighbour
          ? position + (position < 0 ? step : -step)
          : 0,
      top: 0,
      bottom: 0,
      width: width,
      // Offstage rather than dropped: the branch keeps its state, and skips
      // layout and paint while it is nowhere to be seen. TickerMode stops
      // anything in there animating out of sight.
      child: TickerMode(
        enabled: visible,
        child: Offstage(
          offstage: !visible,
          // Inert until it is actually yours. Left live, the page being
          // dragged into view took focus early, and its insides scrolled
          // under a finger that was still on the page behind it.
          child: IgnorePointer(
            ignoring: !isCurrent,
            child: FocusScope(
              canRequestFocus: isCurrent,
              child: widget.branches[branch],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final position = _position;
    // A tap knows exactly which page it is leaving; a drag infers it from the
    // direction the finger went.
    final neighbour = _outgoing ?? _neighbourFor(position);

    return NotificationListener<ScrollNotification>(
      onNotification: _onInnerScroll,
      // A Listener, not a GestureDetector. A drag recognizer here joins the
      // gesture arena and beats the scrollables inside the page, which left
      // inner tab sets unswipeable except by their header. Raw pointer events
      // never enter the arena, so everything underneath keeps working and this
      // widget only acts when nothing else claimed the pointer.
      child: Listener(
        // Translucent, or a drag starting anywhere the page has no widget to
        // hit never arrives here at all. Children still receive the pointer,
        // since this only listens and never enters the gesture arena.
        behavior: HitTestBehavior.translucent,
        onPointerDown: _onPointerDown,
        onPointerMove: _onPointerMove,
        onPointerUp: _onPointerUp,
        onPointerCancel: _onPointerUp,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            _lastWidth = width;
            // The neighbour sits a full width away plus the gap, so the two
            // never touch while both are on screen.
            final step = width + SwipeableTabs._separator;
            // Positioned, not just translated. A Stack sizes itself to its
            // children and hands them loose constraints, but a page expects
            // the tight ones the Scaffold body used to give it; without those,
            // anything that fills its parent collapses, a category TabBar
            // included.
            return Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                for (var branch = 0; branch < widget.branches.length; branch++)
                  _slot(
                    branch: branch,
                    neighbour: neighbour,
                    position: position,
                    width: width,
                    step: step,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
