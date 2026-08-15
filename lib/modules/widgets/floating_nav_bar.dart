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
  static const _inset = 4.0;

  /// How much of a drag past the end of the bar turns into extra pill width
  /// rather than movement, so the pill visibly gives against the cap.
  static const _edgeStretch = 0.5;

  /// Pixels of extra width per pixel of pointer movement in a frame, which is
  /// what makes the pill look like it is being pulled along.
  static const _speedStretch = 0.9;
  static const _maxSpeedStretch = 24.0;

  /// The bar's own side margin.
  static const _margin = 20.0;

  /// How much the whole bar scales up while a drag is in flight. This is a
  /// zoom, not a stretch: the icons scale with it, so the bar keeps its
  /// proportions instead of deforming.
  static const _dragZoom = 1.06;

  /// How much of the bar's width a full edge push adds, applied as a
  /// horizontal scale anchored at the far side so the bar gives in the
  /// direction being pushed.
  static const _barGive = 0.05;

  /// Gap between the pill and the bar's edge, top and bottom. Small, so the
  /// pill reads as nearly filling the bar.
  static const _pillGap = 2.0;

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

  /// Signed overshoot past an end of the bar, -1 to 1. Drives how far the bar
  /// itself gives, so the whole component deforms rather than just the pill.
  double _edgePush = 0;

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
    _edgePush = 0;
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
    final changing = target != widget.currentIndex;
    setState(() {
      _dragX = null;
      _stretch = 0;
      _edgePush = 0;
      // Only hold a dropped slot when the selection is actually moving.
      // Otherwise the pill would sit on a slot the app never navigated to.
      _droppedIndex = changing ? target : null;
    });
    if (changing) widget.onSelected(target);
  }

  void _cancelDrag() => setState(() {
    _dragX = null;
    _stretch = 0;
    _edgePush = 0;
  });

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
    final beyond = _dragX! - centre;
    final overshoot = beyond.abs() * FloatingNavBar._edgeStretch;
    if (beyond < 0) {
      right = math.min(width, right + overshoot);
    } else if (beyond > 0) {
      left = math.max(0, left - overshoot);
    }
    // Read during layout only; the drag callbacks rebuild anyway, so the bar
    // picks this up on the same frame it is computed for.
    _edgePush = (beyond / 60).clamp(-1.0, 1.0);
    return (left, right);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final light = theme.brightness == Brightness.light;
    final dragging = _dragX != null;
    final height = widget.shrunk ? 46.0 : 58.0;
    final pillHeight = height - FloatingNavBar._pillGap * 2;

    // Sit closer to the bottom than a full safe-area inset would put us. The
    // bar is a floating capsule, not a docked bar, so it can overlap the home
    // indicator's margin without crowding it.
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final bottom = math.max(8.0, safeBottom - 12);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        FloatingNavBar._margin,
        0,
        FloatingNavBar._margin,
        bottom,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: _Zoom(
          zoom: dragging ? FloatingNavBar._dragZoom : 1.0,
          give: dragging ? _edgePush * FloatingNavBar._barGive : 0.0,
          child: SizedBox(
            height: height,
            child: DecoratedBox(
              // Outside the clip: a clipped child cannot cast a shadow past
              // its own bounds, and in a light theme the shadow is most of
              // what separates the bar from the page.
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height / 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: light ? 0.16 : 0.34),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(height / 2),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      // A light theme has nothing darker behind it for the
                      // blur to pull in, so translucency alone leaves the bar
                      // invisible against the page. Go nearly opaque there and
                      // keep the glass effect for dark.
                      color: light
                          ? scheme.surfaceContainerHighest.withValues(
                              alpha: 0.94,
                            )
                          : scheme.surface.withValues(alpha: 0.62),
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

                        // Fill and weight belong to the selected tab, never to
                        // whichever slot the pill happens to be over. The pill
                        // alone shows where a drag currently is.
                        final (left, right) = _pillEdges(slot, width, resting);

                        return GestureDetector(
                          // Picking the pill up anywhere along the bar is more
                          // forgiving than having to grab it exactly.
                          onHorizontalDragStart: (d) =>
                              _startDrag(d.localPosition.dx),
                          onHorizontalDragUpdate: (d) =>
                              _updateDrag(d.localPosition.dx),
                          onHorizontalDragEnd: (_) => _endDrag(slot),
                          onHorizontalDragCancel: _cancelDrag,
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
                                        selected: i == resting,
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
      ),
    );
  }
}

/// Scales the bar up while a drag is in flight, and lets it give sideways when
/// the pill is pushed into an end cap.
class _Zoom extends StatelessWidget {
  const _Zoom({required this.zoom, required this.give, required this.child});

  final double zoom;

  /// Signed, negative pushes left. Scales horizontally from the opposite edge
  /// so the bar grows towards the side being pushed.
  final double give;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: FloatingNavBar._duration,
      curve: FloatingNavBar._curve,
      scale: zoom,
      alignment: Alignment.bottomCenter,
      child: Transform.scale(
        scaleX: 1 + give.abs(),
        scaleY: 1,
        alignment: give < 0 ? Alignment.centerRight : Alignment.centerLeft,
        child: child,
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
