import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/episode_list_screen.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/episode_screen.dart';

const _list = '/statistics/episodes';
const _prologue = 'prologue';

String episodeListLocation(ItemType itemType) => '$_list?type=${itemType.name}';

/// `yyyy-MM`, or `prologue` for [month] null.
String episodeSlug(DateTime? month) => month == null
    ? _prologue
    : '${month.year.toString().padLeft(4, '0')}-'
          '${month.month.toString().padLeft(2, '0')}';

/// [month] null is the Prologue.
String episodeLocation(ItemType itemType, DateTime? month) =>
    '$_list/${episodeSlug(month)}?type=${itemType.name}';

/// `yyyy-MM` to the first of that month, or null.
DateTime? parseEpisodeMonth(String? slug) {
  final match = RegExp(r'^(\d{4})-(\d{2})$').firstMatch(slug ?? '');
  if (match == null) return null;
  final month = int.parse(match.group(2)!);
  if (month < 1 || month > 12) return null;
  return DateTime(int.parse(match.group(1)!), month);
}

ItemType _itemType(GoRouterState state) =>
    ItemType.values.asNameMap()[state.uri.queryParameters['type']] ??
    ItemType.manga;

/// The Episodes list and one Episode. An unknown month goes back to the list.
final episodeRoutes = <GoRoute>[
  GoRoute(
    path: _list,
    pageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: EpisodeListScreen(itemType: _itemType(state)),
    ),
  ),
  GoRoute(
    path: '$_list/:month',
    redirect: (context, state) {
      final slug = state.pathParameters['month'];
      if (slug == _prologue || parseEpisodeMonth(slug) != null) return null;
      return episodeListLocation(_itemType(state));
    },
    pageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: EpisodeScreen(
        itemType: _itemType(state),
        month: parseEpisodeMonth(state.pathParameters['month']),
      ),
    ),
  ),
];
