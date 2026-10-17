import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/main_view/nav_groups.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:shiori/shiori.dart';

/// Whether [route] is shown as one member of a grouped destination, so its
/// screen carries the group's switcher and title.
bool isGroupedNavRoute(WidgetRef ref, String route) {
  if (isTv || !ref.watch(navGroupingProvider)) return false;
  final group = NavGroup.of(route);
  if (group == null) return false;
  final visible = ref.watch(visibleNavDestinationsProvider);
  return NavGroup.members[group]!.where(visible.contains).length >= 2;
}

/// The title a grouped screen takes: the group's, not the member's.
String navGroupTitle(BuildContext context, String route) =>
    switch (NavGroup.of(route)) {
      NavGroup.library => context.l10n.library,
      NavGroup.activity => context.l10n.activity,
      _ => '',
    };

/// The switcher at the top of a grouped screen: Manga, Anime and Novels in
/// Library; Updates and History in Activity. Renders nothing when the
/// navigation is not grouped, so screens can always include it.
class NavGroupSwitcher extends ConsumerWidget {
  const NavGroupSwitcher({
    super.key,
    required this.route,
    this.padding = const EdgeInsets.fromLTRB(
      ShioriSpace.s16,
      ShioriSpace.s4,
      ShioriSpace.s16,
      ShioriSpace.s8,
    ),
  });

  /// The route of the screen this sits on: the selected member.
  final String route;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!isGroupedNavRoute(ref, route)) return const SizedBox.shrink();
    final l10n = context.l10n;
    final visible = ref.watch(visibleNavDestinationsProvider);
    final members =
        NavGroup.members[NavGroup.of(route)]!
            .where(visible.contains)
            // The user's own order, not the group's.
            .toList()
          ..sort((a, b) => visible.indexOf(a).compareTo(visible.indexOf(b)));
    ShioriSegment<String> segment(String r) => switch (r) {
      '/MangaLibrary' => ShioriSegment(
        value: r,
        label: l10n.manga,
        icon: Symbols.book_rounded,
      ),
      '/AnimeLibrary' => ShioriSegment(
        value: r,
        label: l10n.anime,
        icon: Symbols.video_library_rounded,
      ),
      '/NovelLibrary' => ShioriSegment(
        value: r,
        label: l10n.novel,
        icon: Symbols.auto_stories_rounded,
      ),
      '/updates' => ShioriSegment(
        value: r,
        label: l10n.updates,
        icon: Symbols.new_releases_rounded,
      ),
      _ => ShioriSegment(
        value: r,
        label: l10n.history,
        icon: Symbols.history_rounded,
      ),
    };
    return Padding(
      padding: padding,
      child: ShioriSegmentedControl<String>(
        segments: [for (final r in members) segment(r)],
        selected: route,
        onSelected: (r) => context.go(r),
      ),
    );
  }
}
