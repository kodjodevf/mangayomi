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

  /// Horizontal breathing room between the pill and its slot.
  static const _inset = 6.0;

  @override
  State<FloatingNavBar> createState() => _FloatingNavBarState();
}

class _FloatingNavBarState extends State<FloatingNavBar> {
  /// Pointer position in bar-local coordinates, or null when nothing is being
  /// dragged.
  double? _dragX;

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

  void _drop(double slot) {
    final target = _slotAt(_dragX!, slot);
    setState(() {
      _dragX = null;
      _droppedIndex = target;
    });
    if (target != widget.currentIndex) widget.onSelected(target);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final height = widget.shrunk ? 46.0 : 58.0;
    final pillHeight = widget.shrunk ? 32.0 : 40.0;
    final dragging = _dragX != null;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
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
                      final slot = constraints.maxWidth / count;
                      final pillWidth = slot - FloatingNavBar._inset * 2;
                      final resting = _droppedIndex ?? widget.currentIndex;

                      // While dragging the pill answers to the pointer and the
                      // icon under it lights up as a preview, but the tab does
                      // not change until the drag ends.
                      final highlighted = dragging
                          ? _slotAt(_dragX!, slot)
                          : resting;
                      final left = dragging
                          ? (_dragX! - pillWidth / 2).clamp(
                              FloatingNavBar._inset,
                              constraints.maxWidth -
                                  pillWidth -
                                  FloatingNavBar._inset,
                            )
                          : slot * resting + FloatingNavBar._inset;

                      return GestureDetector(
                        // Picking the pill up anywhere along the bar is more
                        // forgiving than having to grab it exactly.
                        onHorizontalDragStart: (d) =>
                            setState(() => _dragX = d.localPosition.dx),
                        onHorizontalDragUpdate: (d) =>
                            setState(() => _dragX = d.localPosition.dx),
                        onHorizontalDragEnd: (_) => _drop(slot),
                        onHorizontalDragCancel: () =>
                            setState(() => _dragX = null),
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
                              width: pillWidth,
                              height: pillHeight,
                              child: AnimatedContainer(
                                duration: FloatingNavBar._duration,
                                curve: FloatingNavBar._curve,
                                decoration: BoxDecoration(
                                  color: scheme.onSurface.withValues(
                                    // Reads as picked up while in hand.
                                    alpha: dragging ? 0.2 : 0.13,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    pillHeight / 2.6,
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
            tween: Tween(end: shrunk ? 21 : 24),
            duration: FloatingNavBar._duration,
            curve: FloatingNavBar._curve,
            builder: (context, size, child) => IconTheme(
              data: IconThemeData(
                size: size,
                color: selected
                    ? scheme.onSurface
                    : scheme.onSurface.withValues(alpha: 0.62),
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
