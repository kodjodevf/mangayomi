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

  /// Space between the pill and the bar itself: top, bottom, and the two end
  /// caps. One value for every bar edge is what keeps that gap even.
  static const _pillInset = 5.0;

  /// Space between the pill and its slot's boundary with a neighbour. Smaller
  /// than the bar inset, which is what lets the pill be wider without eating
  /// into the even gap around the bar's own edges.
  static const _pillSlotInset = 1.5;

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

  /// How much the pill grows when picked up. A scale rather than a smaller
  /// gap: shrinking only the vertical gap makes the pill rounder instead of
  /// bigger, since its width does not change with it.
  static const _pillZoom = 1.07;

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
    const outer = FloatingNavBar._pillInset;
    final base = slot - FloatingNavBar._pillSlotInset * 2;

    // Keep the pill a fixed distance from the bar's own ends, so the gap there
    // matches the top and bottom. Clamping the centre rather than the edges
    // also stops a pointer far past the bar from inverting the pill.
    double centreFor(double wanted, double pillWidth) {
      final lo = outer + pillWidth / 2;
      final hi = width - outer - pillWidth / 2;
      return wanted.clamp(math.min(lo, hi), math.max(lo, hi));
    }

    if (_dragX == null) {
      final centre = centreFor(slot * (index + 0.5), base);
      return (centre - base / 2, centre + base / 2);
    }

    final pillWidth = math.min(base + _stretch, width - outer * 2);
    final centre = centreFor(_dragX!, pillWidth);

    // Past an end the pill pins there, keeping its inset. It must not grow
    // backwards, away from the push: the bar takes the give instead.
    // Read during layout only; the drag callbacks rebuild anyway, so the bar
    // picks this up on the same frame it is computed for.
    _edgePush = ((_dragX! - centre) / 60).clamp(-1.0, 1.0);
    return (centre - pillWidth / 2, centre + pillWidth / 2);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final light = theme.brightness == Brightness.light;
    final dragging = _dragX != null;
    final height = widget.shrunk ? 46.0 : 58.0;

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
                  child: Container(
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
                                top: FloatingNavBar._pillInset,
                                bottom: FloatingNavBar._pillInset,
                                // Grows from the middle on every side, so it
                                // keeps its shape. Scaling only the height
                                // would just make it rounder.
                                child: AnimatedScale(
                                  duration: FloatingNavBar._duration,
                                  curve: FloatingNavBar._curve,
                                  scale: dragging
                                      ? FloatingNavBar._pillZoom
                                      : 1.0,
                                  child: AnimatedContainer(
                                    duration: FloatingNavBar._duration,
                                    curve: FloatingNavBar._curve,
                                    decoration: ShapeDecoration(
                                      color: scheme.onSurface.withValues(
                                        // Reads as picked up while in hand.
                                        alpha: dragging ? 0.2 : 0.13,
                                      ),
                                      // A stadium is a full capsule at any
                                      // size, so the pill stays as round as the
                                      // bar's own caps however it scales.
                                      shape: const StadiumBorder(),
                                    ),
                                  ),
                                ),
                              ),
                              // A lit top and bottom edge instead of an
                              // outline. Drawn over everything, since it is the
                              // surface catching light, not a frame behind it.
                              Positioned.fill(
                                child: IgnorePointer(
                                  child: _GlassEdge(
                                    color: scheme.onSurface,
                                    light: light,
                                    radius: height / 2,
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

/// The lit top and bottom edges of the bar.
///
/// The bar's reflection.
///
/// It falls away continuously from the top and bottom edges and reaches zero
/// at exactly one line, the horizontal equator, so any distance off centre
/// still catches light. It runs at full strength the whole way across: the
/// bar's rounded caps curve the top and bottom edges down on their own, so the
/// reflection follows the shape without being faded inwards to fake it.
class _GlassEdge extends StatelessWidget {
  const _GlassEdge({
    required this.color,
    required this.light,
    required this.radius,
  });

  final Color color;
  final bool light;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: light ? 0.16 : 0.26),
            Colors.transparent,
            color.withValues(alpha: light ? 0.10 : 0.17),
          ],
          stops: const [0.0, 0.5, 1.0],
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
