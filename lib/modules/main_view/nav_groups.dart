import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/repositories/settings_repository.dart';

/// Destinations the navigation folds into one, each switched from its own
/// screen: the three libraries into Library, Updates and History into
/// Activity. The routes themselves stay: deep links, the user's order and
/// hidden items, and the TV layout keep working on them.
abstract final class NavGroup {
  static const library = '_library';
  static const activity = '_activity';

  static const members = {
    library: ['/MangaLibrary', '/AnimeLibrary', '/NovelLibrary'],
    activity: ['/updates', '/history'],
  };

  /// The group [route] belongs to, or null.
  static String? of(String? route) {
    if (route == null) return null;
    for (final MapEntry(:key, :value) in members.entries) {
      if (value.contains(route)) return key;
    }
    return null;
  }
}

/// The navigation route of a media's library.
String libraryRouteFor(ItemType type) => switch (type) {
  ItemType.manga => '/MangaLibrary',
  ItemType.anime => '/AnimeLibrary',
  ItemType.novel => '/NovelLibrary',
};

/// [destinations] with each group's members folded into the group, at the
/// place of its first member. A group with fewer than two visible members is
/// left alone: a single library is still called by its own name.
List<String> groupDestinations(List<String> destinations) {
  final counts = <String, int>{};
  for (final d in destinations) {
    final g = NavGroup.of(d);
    if (g != null) counts[g] = (counts[g] ?? 0) + 1;
  }
  final out = <String>[];
  for (final d in destinations) {
    final g = NavGroup.of(d);
    if (g == null || counts[g]! < 2) {
      out.add(d);
    } else if (!out.contains(g)) {
      out.add(g);
    }
  }
  return out;
}

/// The route a tap on [destination] opens: itself for a plain route; for a
/// group, the member last visited if it is still visible, else the group's
/// first visible member in the user's order.
String resolveNavDestination(
  String destination, {
  required List<String> visible,
  String? lastVisited,
}) {
  final members = NavGroup.members[destination];
  if (members == null) return destination;
  if (lastVisited != null && visible.contains(lastVisited)) return lastVisited;
  return visible.firstWhere(members.contains, orElse: () => members.first);
}

/// Whether the navigation groups its destinations. On by default, also for a
/// library saved before the option existed; never on a television, whose
/// layout has its own home.
class NavGroupingState extends Notifier<bool> {
  @override
  bool build() => settingsRepository.current.groupNavDestinations ?? true;

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.groupNavDestinations = value);
  }
}

final navGroupingProvider = NotifierProvider<NavGroupingState, bool>(
  NavGroupingState.new,
);

/// The destinations the user has visible, in their order: hidden items and
/// the anime-only TV layout's dropped libraries removed.
final visibleNavDestinationsProvider = Provider<List<String>>((ref) {
  final order = ref.watch(navigationOrderStateProvider);
  final hidden = ref.watch(hideItemsStateProvider);
  final animeOnly = ref.watch(animeOnlyTvModeProvider);
  return order
      .where((d) => !hidden.contains(d))
      .where(
        (d) => !animeOnly || (d != '/MangaLibrary' && d != '/NovelLibrary'),
      )
      .toList();
});

/// The last member visited in each group, so a tap on the group returns
/// where the user was.
class LastNavMemberState extends Notifier<Map<String, String>> {
  @override
  Map<String, String> build() => const {};

  void visit(String route) {
    final group = NavGroup.of(route);
    if (group == null || state[group] == route) return;
    state = {...state, group: route};
  }
}

final lastNavMemberProvider =
    NotifierProvider<LastNavMemberState, Map<String, String>>(
      LastNavMemberState.new,
    );
