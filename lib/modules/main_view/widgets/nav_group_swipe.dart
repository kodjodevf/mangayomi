import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/main_view/nav_groups.dart';
import 'package:mangayomi/modules/main_view/widgets/nav_group_switcher.dart';

/// How far a sideways swipe must go, in logical pixels, to switch.
const double _switchDistance = 72;

/// How fast a sideways fling must be, in logical pixels a second.
const double _switchVelocity = 700;

/// A sideways swipe over [child] opens the next or the previous member of
/// [route]'s group, as a tap on the group's switcher would: Manga, Anime and
/// Novels in Library.
///
/// What scrolls sideways inside keeps its swipe: over category tabs, the
/// swipe that goes past the first or the last one switches.
class NavGroupSwipe extends ConsumerStatefulWidget {
  const NavGroupSwipe({
    super.key,
    required this.route,
    required this.child,
    this.enabled = true,
  });

  final String route;
  final Widget child;
  final bool enabled;

  @override
  ConsumerState<NavGroupSwipe> createState() => _NavGroupSwipeState();
}

class _NavGroupSwipeState extends ConsumerState<NavGroupSwipe> {
  double _drag = 0;

  /// How far the category pages were pulled past their first or last one.
  double _overscroll = 0;

  /// Opens the member next to this one, toward the end of the switcher for
  /// a swipe to the start side, which is how pages turn.
  void _switch({required bool towardEnd}) {
    final members = visibleGroupMembers(
      widget.route,
      ref.read(visibleNavDestinationsProvider),
    );
    final i = members.indexOf(widget.route);
    final j = towardEnd ? i + 1 : i - 1;
    if (i < 0 || j < 0 || j >= members.length) return;
    HapticFeedback.selectionClick();
    context.go(members[j]);
  }

  /// [offset] is how far the swipe went toward the end side of the screen.
  void _maybeSwitch(double offset, double velocity) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    // A swipe toward the start side opens the next member, as a page turns.
    final towardEnd = rtl ? offset > 0 : offset < 0;
    final far = offset.abs() >= _switchDistance;
    final fast =
        velocity.abs() >= _switchVelocity && velocity.sign == offset.sign;
    if (far || fast) _switch(towardEnd: towardEnd);
  }

  bool _onScroll(ScrollNotification notification) {
    // The category pages only: the tab strip and the Continue row scroll
    // sideways too, and swiping them past their end is not asking to switch.
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
      if (pulled.abs() >= _switchDistance) _maybeSwitch(pulled, 0);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || !isGroupedNavRoute(ref, widget.route)) {
      return widget.child;
    }
    return NotificationListener<ScrollNotification>(
      onNotification: _onScroll,
      // Where nothing inside scrolls sideways, the swipe reaches this.
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragStart: (_) => _drag = 0,
        onHorizontalDragUpdate: (details) => _drag += details.primaryDelta ?? 0,
        onHorizontalDragEnd: (details) =>
            _maybeSwitch(_drag, details.primaryVelocity ?? 0),
        child: widget.child,
      ),
    );
  }
}
