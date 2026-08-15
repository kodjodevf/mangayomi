import 'dart:ui';

import 'package:flutter/material.dart';

/// The floating capsule bar used on Apple platforms in place of the material
/// NavigationBar. Icons only, with a single highlight pill that slides between
/// slots, and a shrunk state for when the user is scrolling down.
class FloatingNavBar extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final height = shrunk ? 46.0 : 58.0;
    final pillHeight = shrunk ? 32.0 : 40.0;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: _duration,
            curve: _curve,
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
                      final slot = constraints.maxWidth / destinations.length;
                      return Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          // One pill that travels, rather than a highlight
                          // fading in and out under each icon in turn.
                          AnimatedPositioned(
                            duration: _duration,
                            curve: _curve,
                            left: slot * currentIndex + 6,
                            width: slot - 12,
                            height: pillHeight,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: scheme.onSurface.withValues(alpha: 0.13),
                                borderRadius: BorderRadius.circular(
                                  pillHeight / 2.6,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              for (var i = 0; i < destinations.length; i++)
                                Expanded(
                                  child: __FloatingNavItem(
                                    destination: destinations[i],
                                    selected: i == currentIndex,
                                    shrunk: shrunk,
                                    onTap: () => onSelected(i),
                                  ),
                                ),
                            ],
                          ),
                        ],
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

class __FloatingNavItem extends StatelessWidget {
  const __FloatingNavItem({
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
