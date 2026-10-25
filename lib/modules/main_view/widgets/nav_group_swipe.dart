import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/main_view/nav_groups.dart';
import 'package:mangayomi/modules/main_view/widgets/nav_group_switcher.dart';
import 'package:mangayomi/modules/widgets/side_swipe_detector.dart';

/// A sideways swipe over [child] opens the next or the previous member of
/// [route]'s group, as a tap on the group's switcher would: Manga, Anime and
/// Novels in Library. See [SideSwipeDetector] for what counts as a swipe.
class NavGroupSwipe extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    if (!enabled || !isGroupedNavRoute(ref, route)) return child;
    final members = visibleGroupMembers(
      route,
      ref.watch(visibleNavDestinationsProvider),
    );
    final i = members.indexOf(route);
    return SideSwipeDetector(
      onNext: i >= 0 && i + 1 < members.length
          ? () => context.go(members[i + 1])
          : null,
      onPrevious: i > 0 ? () => context.go(members[i - 1]) : null,
      child: child,
    );
  }
}
