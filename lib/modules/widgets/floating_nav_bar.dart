import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

/// The floating capsule bar used on Apple platforms in place of the material
/// NavigationBar. Icons only, with a single highlight pill that slides between
/// slots, and a shrunk state for when the user is scrolling down.
///
/// The pill can also be dragged: it follows the pointer freely and the tab only
/// changes once it is let go, so a drag can be taken back by returning to the
/// slot it started from.
class FloatingNavBar extends StatefulWidget {
  const FloatingNavBar({
    super.key,
    required this.destinations,
    required this.currentIndex,
    required this.onSelected,
    required this.shrunk,
  });

  final List<NavigationDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  /// Set while the user is scrolling down, so the bar gets out of the way
  /// without disappearing entirely.
  final bool shrunk;

  static const _duration = Duration(milliseconds: 260);
  static const _curve = Curves.easeOutCubic;

  /// Horizontal breathing room between the pill and its slot. The outermost
  /// edges skip it so the pill can sit flush inside the bar's own end caps.
  static const _inset = 6.0;

  /// How much of a drag past the end of the bar turns into extra pill width
  /// rather than movement, so the pill visibly gives against the cap.
  static const _edgeStretch = 0.5;

  /// Pixels of extra width per pixel of pointer movement in a frame, which is
  /// what makes the pill look like it is being pulled along.
  static const _speedStretch = 0.9;
  static const _maxSpeedStretch = 24.0;

  /// The bar's own margin. It narrows while a drag is in flight so the whole
  /// bar grows outwards with the pill rather than the pill moving inside a
  /// fixed frame.
  static const _margin = 14.0;
  static const _dragMargin = 7.0;

  /// Extra bar height while dragging. The pill is sized from the bar, so it
  /// grows with it.
  static const _dragLift = 6.0;

  /// Gap between the pill and the bar's edge, top and bottom. Small, so the
  /// pill reads as nearly filling the bar.
  static const _pillGap = 4.0;

  @override
  State<FloatingNavBar> createState() => _FloatingNavBarState();
}

class _FloatingNavBarState extends State<FloatingNavBar> {
  /// Pointer position in bar-local coordinates, or null when nothing is being
  /// dragged.
  double? _dragX;

  /// Smoothed drag speed, carried as the extra width it earns. Smoothing keeps
  /// per-event jitter from making the pill flutter.
  double _stretch = 0;

  /// The slot the pill was dropped on, kept until the parent reports the same
  /// index. Routing is not synchronous, so without this the pill would spring
  /// back to the old tab for the frames in between.
  int? _droppedIndex;

  @override
  void didUpdateWidget(FloatingNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_droppedIndex != null && widget.currentIndex == _droppedIndex) {
      _droppedIndex = null;
    }
  }

  int _slotAt(double x, double slot) =>
      (x / slot).floor().clamp(0, widget.destinations.length - 1);

  void _startDrag(double x) => setState(() {
    _dragX = x;
    _stretch = 0;
  });

  void _updateDrag(double x) => setState(() {
    final travelled = (x - _dragX!).abs() * FloatingNavBar._speedStretch;
    _stretch = (_stretch * 0.6 + travelled * 0.4).clamp(
      0.0,
      FloatingNavBar._maxSpeedStretch,
    );
    _dragX = x;
  });

  void _endDrag(double slot) {
    final target = _slotAt(_dragX!, slot);
    setState(() {
      _dragX = null;
      _stretch = 0;
      _droppedIndex = target;
    });
    if (target != widget.currentIndex) widget.onSelected(target);
  }

  /// Left and right edges of the pill, in bar-local coordinates.
  ///
  /// At rest it spans its slot, except at either end where it runs out to the
  /// bar's own edge. While dragging it is centred on the pointer, and pushing
  /// it past an end pins that edge and spends the rest on width.
  (double, double) _pillEdges(double slot, double width, int index) {
    final count = widget.destinations.length;
    if (_dragX == null) {
      return (
        index == 0 ? 0 : slot * index + FloatingNavBar._inset,
        index == count - 1 ? width : slot * (index + 1) - FloatingNavBar._inset,
      );
    }

    // Clamp the centre before the edges. Clamping the edges instead lets a
    // pointer far past the bar push one edge beyond the other and invert the
    // pill.
    final pillWidth = math.min(
      slot - FloatingNavBar._inset * 2 + _stretch,
      width,
    );
    final centre = _dragX!.clamp(pillWidth / 2, width - pillWidth / 2);
    var left = centre - pillWidth / 2;
    var right = centre + pillWidth / 2;

    // Whatever the pointer asked for beyond that is spent widening the pill
    // into the cap, so it gives rather than stopping dead.
    final overshoot = (_dragX! - centre).abs() * FloatingNavBar._edgeStretch;
    if (_dragX! < centre) {
      right = math.min(width, right + overshoot);
    } else if (_dragX! > centre) {
      left = math.max(0, left - overshoot);
    }
    return (left, right);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dragging = _dragX != null;
    final height =
        (widget.shrunk ? 46.0 : 58.0) +
        (dragging ? FloatingNavBar._dragLift : 0.0);
    final pillHeight = height - FloatingNavBar._pillGap * 2;
    final margin = dragging
        ? FloatingNavBar._dragMargin
        : FloatingNavBar._margin;

    return SafeArea(
      top: false,
      child: AnimatedPadding(
        duration: FloatingNavBar._duration,
        curve: FloatingNavBar._curve,
        padding: EdgeInsets.fromLTRB(margin, 0, margin, 6),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: FloatingNavBar._duration,
            curve: FloatingNavBar._curve,
            height: height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(height / 2),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    // Tinted from the theme rather than a fixed dark, since the
                    // palette is chosen at runtime.
                    color: scheme.surface.withValues(alpha: 0.62),
                    border: Border.all(
                      color: scheme.onSurface.withValues(alpha: 0.08),
                    ),
                    borderRadius: BorderRadius.circular(height / 2),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final count = widget.destinations.length;
                      final width = constraints.maxWidth;
                      final slot = width / count;
                      final resting = _droppedIndex ?? widget.currentIndex;

                      // While dragging the pill answers to the pointer and the
                      // icon under it lights up as a preview, but the tab does
                      // not change until the drag ends.
                      final highlighted = dragging
                          ? _slotAt(_dragX!, slot)
                          : resting;
                      final (left, right) = _pillEdges(slot, width, resting);

                      return GestureDetector(
                        // Picking the pill up anywhere along the bar is more
                        // forgiving than having to grab it exactly.
                        onHorizontalDragStart: (d) =>
                            _startDrag(d.localPosition.dx),
                        onHorizontalDragUpdate: (d) =>
                            _updateDrag(d.localPosition.dx),
                        onHorizontalDragEnd: (_) => _endDrag(slot),
                        onHorizontalDragCancel: () => setState(() {
                          _dragX = null;
                          _stretch = 0;
                        }),
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            // One pill that travels, rather than a highlight
                            // fading in and out under each icon in turn.
                            AnimatedPositioned(
                              // A dragged pill has to track the finger exactly;
                              // easing here would make it lag behind.
                              duration: dragging
                                  ? Duration.zero
                                  : FloatingNavBar._duration,
                              curve: FloatingNavBar._curve,
                              left: left,
                              width: right - left,
                              height: pillHeight,
                              child: AnimatedContainer(
                                duration: FloatingNavBar._duration,
                                curve: FloatingNavBar._curve,
                                decoration: BoxDecoration(
                                  color: scheme.onSurface.withValues(
                                    // Reads as picked up while in hand.
                                    alpha: dragging ? 0.2 : 0.13,
                                  ),
                                  // Matches the bar's own end caps, so the pill
                                  // looks like part of it rather than a chip
                                  // laid on top.
                                  borderRadius: BorderRadius.circular(
                                    pillHeight / 2,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                for (var i = 0; i < count; i++)
                                  Expanded(
                                    child: _FloatingNavItem(
                                      destination: widget.destinations[i],
                                      selected: i == highlighted,
                                      shrunk: widget.shrunk,
                                      onTap: () => widget.onSelected(i),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingNavItem extends StatelessWidget {
  const _FloatingNavItem({
    required this.destination,
    required this.selected,
    required this.shrunk,
    required this.onTap,
  });

  final NavigationDestination destination;
  final bool selected;
  final bool shrunk;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final icon = selected
        ? (destination.selectedIcon ?? destination.icon)
        : destination.icon;
    final color = selected
        ? scheme.onSurface
        : scheme.onSurface.withValues(alpha: 0.62);
    return Semantics(
      // The label is gone visually, so it has to survive for screen readers.
      label: destination.label,
      selected: selected,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: shrunk ? 23 : 27),
            duration: FloatingNavBar._duration,
            curve: FloatingNavBar._curve,
            builder: (context, size, child) => IconTheme(
              data: IconThemeData(
                size: size,
                color: color,
                // Several destinations (history, more) have an "outlined"
                // variant that is the same drawing, so filling cannot show
                // selection. Thickening the stroke does, and it is harmless on
                // the icons that do fill.
                shadows: selected
                    ? [Shadow(color: color, blurRadius: 0.9)]
                    : null,
              ),
              child: child!,
            ),
            child: icon,
          ),
        ),
      ),
    );
  }
}
