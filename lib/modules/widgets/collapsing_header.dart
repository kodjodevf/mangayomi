import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';

/// Marks a screen's header as out of sight once its content has scrolled
/// past [threshold], and back in sight at the top.
///
/// Listens to the vertical scrolling under it: a list in a tab, a grid, the
/// outer scroll of a NestedScrollView. Horizontal paging between tabs is
/// ignored. [accept] narrows which scrollables count, by their depth for
/// instance.
class CollapseOnScroll extends StatelessWidget {
  const CollapseOnScroll({
    super.key,
    required this.collapsed,
    required this.child,
    this.threshold = ShioriSpace.s24,
    this.accept,
  });

  final ValueNotifier<bool> collapsed;
  final Widget child;
  final double threshold;
  final bool Function(ScrollNotification notification)? accept;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        if (notification.metrics.axis != Axis.vertical) return false;
        if (accept != null && !accept!(notification)) return false;
        collapsed.value = notification.metrics.pixels > threshold;
        return false;
      },
      child: child,
    );
  }
}

/// A part of a header that folds away while the content is scrolled: its
/// height closes to nothing as it fades, and opens again at the top.
class CollapsibleHeaderPart extends StatelessWidget {
  const CollapsibleHeaderPart({
    super.key,
    required this.collapsed,
    required this.child,
  });

  final bool collapsed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: collapsed ? 0 : 1),
      duration: ShioriMotion.of(context, ShioriMotion.standard),
      curve: ShioriMotion.standardCurve,
      child: child,
      builder: (context, open, child) => ClipRect(
        child: Align(
          alignment: Alignment.topCenter,
          heightFactor: open,
          child: Opacity(
            opacity: open,
            child: IgnorePointer(ignoring: open < 1, child: child),
          ),
        ),
      ),
    );
  }
}

/// A screen title that changes when its header folds away: the group's name
/// ("Activity") gives way to what is being shown ("Updates"). The old words
/// rise and fade as the new ones rise into place, so the change reads as one
/// movement rather than a swap.
class CollapsingTitle extends StatelessWidget {
  const CollapsingTitle(this.text, {super.key, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: ShioriMotion.of(context, ShioriMotion.standard),
      switchInCurve: ShioriMotion.enterCurve,
      switchOutCurve: ShioriMotion.exitCurve,
      layoutBuilder: (current, previous) => Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [...previous, ?current],
      ),
      transitionBuilder: (child, animation) {
        // In from below; out upward, since the outgoing animation runs in
        // reverse.
        final incoming = child.key == ValueKey(text);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, incoming ? 0.4 : -0.4),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Text(
        text,
        key: ValueKey(text),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
      ),
    );
  }
}
