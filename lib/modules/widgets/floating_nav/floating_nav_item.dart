import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/floating_nav_bar.dart';

/// One navigation item: sharing the bar evenly, or hugging its own content.
/// Exists so each item can carry the key the bar measures it by.
class FloatingNavSized extends StatelessWidget {
  const FloatingNavSized({
    super.key,
    required this.expand,
    required this.child,
  });

  final bool expand;
  final Widget child;

  @override
  Widget build(BuildContext context) => expand ? Expanded(child: child) : child;
}

/// Scales the bar up while a drag is in flight, and lets it give sideways when
/// the pill is pushed into an end cap.
class FloatingNavZoom extends StatelessWidget {
  const FloatingNavZoom({
    super.key,
    required this.zoom,
    required this.give,
    required this.child,
  });

  final double zoom;

  /// Signed, negative pushes left. Scales horizontally from the opposite edge
  /// so the bar grows towards the side being pushed.
  final double give;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: FloatingNavBar.duration,
      curve: FloatingNavBar.curve,
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

class FloatingNavItem extends StatelessWidget {
  const FloatingNavItem({
    super.key,
    required this.destination,
    required this.selected,
    required this.iconSize,
    required this.nudge,
    required this.onTap,
    required this.light,
    this.label,
    this.labelStyle,
  });

  final NavigationDestination destination;
  final bool selected;
  final double iconSize;
  final bool light;

  /// Horizontal shift so the icon lands on the pill's centre rather than its
  /// slot's. Zero everywhere except the two end slots.
  final double nudge;

  /// Shown beside the icon in the labelled layout; null keeps it icon-only.
  final String? label;
  final TextStyle? labelStyle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final icon = selected
        ? (destination.selectedIcon ?? destination.icon)
        : destination.icon;
    // Each selected icon uses the foreground paired with its pill. Unselected
    // icons stay neutral and remain readable while the pill crosses them.
    final color = light
        ? (selected ? scheme.onPrimaryContainer : scheme.onSurfaceVariant)
        : (selected ? scheme.onSecondaryContainer : scheme.onSurface);
    Widget themedItem(double size, Color resolvedColor) => IconTheme(
      data: IconThemeData(
        size: size,
        color: resolvedColor,
        // Several destinations (history, more) have an "outlined" variant
        // that is the same drawing, so filling cannot show selection.
        shadows: selected
            ? [Shadow(color: resolvedColor, blurRadius: 0.9)]
            : null,
      ),
      child: label == null
          ? icon
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                const SizedBox(width: FloatingNavBar.labelGap),
                Flexible(
                  child: Text(
                    label!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: labelStyle?.copyWith(color: resolvedColor),
                  ),
                ),
              ],
            ),
    );
    return Semantics(
      // The label is gone visually, so it has to survive for screen readers.
      label: destination.label,
      selected: selected,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Center(
          child: Transform.translate(
            offset: Offset(nudge, 0),
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: iconSize),
              duration: FloatingNavBar.duration,
              curve: FloatingNavBar.curve,
              builder: (context, size, _) {
                if (!light) return themedItem(size, color);
                return TweenAnimationBuilder<Color?>(
                  tween: ColorTween(end: color),
                  duration: FloatingNavBar.duration,
                  curve: FloatingNavBar.curve,
                  builder: (context, animatedColor, _) =>
                      themedItem(size, animatedColor ?? color),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
