import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/services/discovery/media_lookup_context.dart';
import 'package:mangayomi/services/discovery/search_target.dart';
import 'package:mangayomi/services/discovery/trakt_discovery.dart';

enum WesternWatchOrderItemKind { movie, show, season, episode }

enum WesternWatchOrderItemRole { previous, current, next, neutral }

enum WesternWatchOrderSourceKind { publicList, showSeasons }

/// Where a western watch-order plan came from.
final class WesternWatchOrderSource {
  const WesternWatchOrderSource({
    required this.kind,
    required this.name,
    this.author,
    this.url,
    this.isOfficial = false,
  });

  final WesternWatchOrderSourceKind kind;
  final String name;
  final String? author;
  final String? url;
  final bool isOfficial;
}

/// A selectable, already validated Trakt list.
final class WesternWatchOrderOption {
  const WesternWatchOrderOption({
    required this.key,
    required this.name,
    required this.score,
    required this.isOfficial,
    this.author,
    this.url,
  });

  factory WesternWatchOrderOption.fromCandidate(TraktListCandidate candidate) {
    return WesternWatchOrderOption(
      key: candidate.stableKey,
      name: candidate.displayName,
      author: candidate.author,
      url: candidate.sourceUrl,
      score: candidate.score,
      isOfficial: candidate.isOfficial,
    );
  }

  final String key;
  final String name;
  final String? author;
  final String? url;
  final double score;
  final bool isOfficial;
}

/// A renderable row in a western watch-order hierarchy.
final class WesternWatchOrderItem {
  const WesternWatchOrderItem({
    required this.key,
    required this.title,
    required this.kind,
    required this.depth,
    required this.role,
    required this.searchTarget,
    required this.ids,
    this.image,
    this.sourceRank,
    this.year,
    this.seasonNumber,
    this.episodeNumber,
    this.episodeCount,
  });

  final String key;
  final String title;
  final WesternWatchOrderItemKind kind;

  /// Zero for a title, one for a season, and two for an episode.
  final int depth;
  final WesternWatchOrderItemRole role;
  final SearchTarget searchTarget;
  final TraktIds ids;
  final String? image;

  /// The list owner's rank, retained without release-date reordering.
  final int? sourceRank;
  final int? year;
  final int? seasonNumber;
  final int? episodeNumber;
  final int? episodeCount;

  WesternWatchOrderItem withRole(WesternWatchOrderItemRole value) {
    return WesternWatchOrderItem(
      key: key,
      title: title,
      kind: kind,
      depth: depth,
      role: value,
      searchTarget: searchTarget,
      ids: ids,
      image: image,
      sourceRank: sourceRank,
      year: year,
      seasonNumber: seasonNumber,
      episodeNumber: episodeNumber,
      episodeCount: episodeCount,
    );
  }
}

final class WesternWatchOrderPlan {
  const WesternWatchOrderPlan({
    required this.root,
    required this.source,
    required this.items,
    required this.options,
    this.selectedCandidateKey,
  });

  final TraktRootMedia root;
  final WesternWatchOrderSource source;
  final List<WesternWatchOrderItem> items;

  /// Every trusted list returned by Trakt, including the selected list.
  final List<WesternWatchOrderOption> options;
  final String? selectedCandidateKey;

  List<WesternWatchOrderOption> get alternatives => List.unmodifiable(
    options.where((option) => option.key != selectedCandidateKey),
  );
}

/// Builds a western franchise or season plan from public Trakt metadata.
///
/// Related-title recommendations are intentionally not used here because
/// similarity is not evidence of a viewing order.
final class WesternWatchOrderPlanner {
  WesternWatchOrderPlanner({
    TraktDiscovery? discovery,
    this.maxRenderedItems = 80,
    this.maxListCandidates = 5,
  }) : _discovery = discovery ?? TraktDiscovery();

  final TraktDiscovery _discovery;
  final int maxRenderedItems;
  final int maxListCandidates;
  final Map<String, Future<List<TraktListCandidate>>> _candidateCache = {};
  final Map<String, Future<List<TraktSeason>>> _seasonCache = {};

  Future<WesternWatchOrderPlan?> build(
    MediaLookupContext context, {
    String? selectedCandidateKey,
    TraktRootMedia? resolvedRoot,
  }) async {
    final type = _rootType(context.kind);
    if (type == null || maxRenderedItems <= 0) return null;

    final root = resolvedRoot ?? await _resolveRoot(context, type);
    if (root == null) return null;
    if (root.type != type) return null;

    final candidates = await _loadCandidates(root);
    if (candidates.isNotEmpty) {
      final selected = candidates.firstWhere(
        (candidate) => candidate.stableKey == selectedCandidateKey,
        orElse: () => candidates.first,
      );
      final items = await _buildListItems(
        selected.items,
        root: root,
        itemType: context.itemType,
      );
      if (items.isNotEmpty) {
        return WesternWatchOrderPlan(
          root: root,
          source: WesternWatchOrderSource(
            kind: WesternWatchOrderSourceKind.publicList,
            name: selected.displayName,
            author: selected.author,
            url: selected.sourceUrl,
            isOfficial: selected.isOfficial,
          ),
          items: items,
          options: List.unmodifiable(
            candidates.map(WesternWatchOrderOption.fromCandidate),
          ),
          selectedCandidateKey: selected.stableKey,
        );
      }
    }

    if (root.type != TraktMediaType.show) return null;
    return _buildShowFallback(root, context.itemType);
  }

  Future<List<TraktListCandidate>> _loadCandidates(TraktRootMedia root) {
    final key = root.stableKey;
    final cached = _candidateCache[key];
    if (cached != null) return cached;

    final request = () async {
      try {
        final candidates = (await _discovery.findWatchOrderLists(
          root,
          limit: maxListCandidates,
        )).toList()..sort(compareTraktListCandidates);
        return List<TraktListCandidate>.unmodifiable(candidates);
      } catch (_) {
        _candidateCache.remove(key);
        rethrow;
      }
    }();
    _candidateCache[key] = request;
    return request;
  }

  Future<TraktRootMedia?> _resolveRoot(
    MediaLookupContext context,
    TraktMediaType type,
  ) async {
    if (context.tmdbId case final int tmdbId when tmdbId > 0) {
      final exact = await _discovery.resolveByTmdbId(
        tmdbId: tmdbId,
        type: type,
      );
      if (exact != null) return exact;
    }
    if (context.traktId case final int traktId when traktId > 0) {
      final exact = await _discovery.resolveByTraktId(
        traktId: traktId,
        type: type,
      );
      if (exact != null) return exact;
    }
    return _discovery.resolveByTitle(
      title: context.title,
      year: context.year,
      type: type,
    );
  }

  Future<List<WesternWatchOrderItem>> _buildListItems(
    List<TraktListItem> sourceItems, {
    required TraktRootMedia root,
    required ItemType itemType,
  }) async {
    final sorted = sourceItems.indexed.toList()
      ..sort((a, b) {
        final byRank = a.$2.rank.compareTo(b.$2.rank);
        return byRank == 0 ? a.$1.compareTo(b.$1) : byRank;
      });
    final explicitChildren = <String>{
      for (final entry in sorted)
        if (entry.$2.parentShow case final TraktRootMedia show) _mediaKey(show),
    };
    final rows = <WesternWatchOrderItem>[];
    final expansions = <String, ({TraktRootMedia show, int? sourceRank})>{};
    String? activeShowKey;
    int? activeSeasonNumber;

    for (final entry in sorted) {
      final item = entry.$2;
      switch (item.type) {
        case TraktMediaType.movie:
          final media = item.media;
          if (media == null) continue;
          rows.add(
            _titleRow(
              media,
              itemType,
              sourceRank: item.rank,
              keySuffix: 'item:${entry.$1}',
            ),
          );
          activeShowKey = null;
          activeSeasonNumber = null;
        case TraktMediaType.show:
          final media = item.media;
          if (media == null) continue;
          final row = _titleRow(
            media,
            itemType,
            sourceRank: item.rank,
            keySuffix: 'item:${entry.$1}',
          );
          rows.add(row);
          activeShowKey = _mediaKey(media);
          activeSeasonNumber = null;
          if (explicitChildren.contains(activeShowKey)) continue;
          expansions[row.key] = (show: media, sourceRank: item.rank);
        case TraktMediaType.season:
          final parent = item.parentShow;
          final number = item.seasonNumber;
          if (parent == null || number == null) continue;
          final parentKey = _mediaKey(parent);
          if (activeShowKey != parentKey) {
            rows.add(
              _titleRow(
                parent,
                itemType,
                sourceRank: item.rank,
                keySuffix: 'group:${entry.$1}',
              ),
            );
            activeShowKey = parentKey;
          }
          activeSeasonNumber = number;
          rows.add(
            _explicitSeasonRow(item, parent: parent, itemType: itemType),
          );
        case TraktMediaType.episode:
          final parent = item.parentShow;
          final seasonNumber = item.seasonNumber;
          final episodeNumber = item.episodeNumber;
          if (parent == null || seasonNumber == null || episodeNumber == null) {
            continue;
          }
          final parentKey = _mediaKey(parent);
          if (activeShowKey != parentKey) {
            rows.add(
              _titleRow(
                parent,
                itemType,
                sourceRank: item.rank,
                keySuffix: 'group:${entry.$1}',
              ),
            );
            activeShowKey = parentKey;
            activeSeasonNumber = null;
          }
          if (activeSeasonNumber != seasonNumber) {
            rows.add(
              _syntheticSeasonRow(
                parent,
                seasonNumber,
                itemType: itemType,
                sourceRank: item.rank,
                keySuffix: 'group:${entry.$1}',
              ),
            );
            activeSeasonNumber = seasonNumber;
          }
          rows.add(_episodeRow(item, parent: parent, itemType: itemType));
      }
    }

    final capped = _rootCenteredRows(_assignTopLevelRoles(rows, root));
    if (capped.isEmpty) return const [];

    var remaining = maxRenderedItems - capped.length;
    if (remaining <= 0 || expansions.isEmpty) return capped;

    final currentIndex = capped.indexWhere(
      (row) => row.role == WesternWatchOrderItemRole.current,
    );
    final expansionKeys =
        expansions.keys
            .where((key) => capped.any((row) => row.key == key))
            .toList()
          ..sort((a, b) {
            final aIndex = capped.indexWhere((row) => row.key == a);
            final bIndex = capped.indexWhere((row) => row.key == b);
            final aCurrent =
                capped[aIndex].role == WesternWatchOrderItemRole.current;
            final bCurrent =
                capped[bIndex].role == WesternWatchOrderItemRole.current;
            if (aCurrent != bCurrent) return aCurrent ? -1 : 1;
            return (aIndex - currentIndex).abs().compareTo(
              (bIndex - currentIndex).abs(),
            );
          });
    final expanded = <String, List<WesternWatchOrderItem>>{};
    for (final key in expansionKeys) {
      if (remaining <= 0) break;
      final expansion = expansions[key]!;
      final seasons = await _loadSeasons(expansion.show);
      final children = _seasonRows(
        seasons,
        itemType: itemType,
        sourceRank: expansion.sourceRank,
        anchorKey: key,
      ).take(remaining).toList(growable: false);
      if (children.isEmpty) continue;
      expanded[key] = children;
      remaining -= children.length;
    }

    return List.unmodifiable([
      for (final row in capped) ...[row, ...?expanded[row.key]],
    ]);
  }

  List<WesternWatchOrderItem> _rootCenteredRows(
    List<WesternWatchOrderItem> rows,
  ) {
    final groups = <List<WesternWatchOrderItem>>[];
    for (final row in rows) {
      if (row.depth == 0) {
        groups.add([row]);
      } else if (groups.isNotEmpty) {
        groups.last.add(row);
      }
    }
    final currentGroup = groups.indexWhere(
      (group) => group.first.role == WesternWatchOrderItemRole.current,
    );
    if (currentGroup == -1 || groups.isEmpty) return const [];

    final groupCount = groups.length < maxRenderedItems
        ? groups.length
        : maxRenderedItems;
    var start = currentGroup - (groupCount ~/ 2);
    if (start < 0) start = 0;
    if (start + groupCount > groups.length) {
      start = groups.length - groupCount;
    }
    final selected = groups.sublist(start, start + groupCount);
    final retained = <int, List<WesternWatchOrderItem>>{
      for (var index = 0; index < selected.length; index++)
        index: [selected[index].first],
    };
    var remaining = maxRenderedItems - selected.length;
    final localCurrent = currentGroup - start;
    final allocationOrder = List.generate(selected.length, (index) => index)
      ..sort((a, b) {
        final byDistance = (a - localCurrent).abs().compareTo(
          (b - localCurrent).abs(),
        );
        return byDistance == 0 ? a.compareTo(b) : byDistance;
      });
    for (final index in allocationOrder) {
      if (remaining <= 0) break;
      final children = selected[index].skip(1).take(remaining);
      retained[index]!.addAll(children);
      remaining -= retained[index]!.length - 1;
    }
    return List.unmodifiable([
      for (var index = 0; index < selected.length; index++) ...retained[index]!,
    ]);
  }

  Future<WesternWatchOrderPlan> _buildShowFallback(
    TraktRootMedia root,
    ItemType itemType,
  ) async {
    final rows = <WesternWatchOrderItem>[_titleRow(root, itemType)];
    final seasons = await _loadSeasons(root);
    _appendSeasons(rows, seasons, itemType: itemType);
    return WesternWatchOrderPlan(
      root: root,
      source: WesternWatchOrderSource(
        kind: WesternWatchOrderSourceKind.showSeasons,
        name: '${root.title} seasons',
      ),
      items: _assignTopLevelRoles(rows, root),
      options: const [],
    );
  }

  void _appendSeasons(
    List<WesternWatchOrderItem> rows,
    List<TraktSeason> seasons, {
    required ItemType itemType,
    int? sourceRank,
  }) {
    final available = maxRenderedItems - rows.length;
    if (available <= 0) return;
    for (final row in _seasonRows(
      seasons,
      itemType: itemType,
      sourceRank: sourceRank,
      anchorKey: rows.first.key,
    ).take(available)) {
      if (rows.length >= maxRenderedItems) break;
      rows.add(row);
    }
  }

  List<WesternWatchOrderItem> _seasonRows(
    List<TraktSeason> seasons, {
    required ItemType itemType,
    required String anchorKey,
    int? sourceRank,
  }) {
    final ordered = seasons.where((season) => season.number != 0).toList()
      ..sort((a, b) => a.number.compareTo(b.number));
    return List.unmodifiable([
      for (final season in ordered)
        WesternWatchOrderItem(
          key: '$anchorKey:season:${season.number}',
          title: season.title ?? 'Season ${season.number}',
          kind: WesternWatchOrderItemKind.season,
          depth: 1,
          role: WesternWatchOrderItemRole.neutral,
          searchTarget: SearchTarget(
            query: season.show.title,
            itemType: itemType,
          ),
          ids: season.ids,
          image: season.show.posterUrl,
          sourceRank: sourceRank,
          year: season.firstAired?.year,
          seasonNumber: season.number,
          episodeCount: season.episodeCount,
        ),
    ]);
  }

  Future<List<TraktSeason>> _loadSeasons(TraktRootMedia show) {
    final key = show.stableKey;
    final cached = _seasonCache[key];
    if (cached != null) return cached;

    final request = () async {
      try {
        return await _discovery.fetchSeasons(show);
      } catch (_) {
        _seasonCache.remove(key);
        rethrow;
      }
    }();
    _seasonCache[key] = request;
    return request;
  }
}

WesternWatchOrderItem _titleRow(
  TraktRootMedia media,
  ItemType itemType, {
  int? sourceRank,
  String? keySuffix,
}) {
  return WesternWatchOrderItem(
    key: keySuffix == null
        ? _mediaKey(media)
        : '${_mediaKey(media)}:$keySuffix',
    title: media.title,
    kind: media.type == TraktMediaType.movie
        ? WesternWatchOrderItemKind.movie
        : WesternWatchOrderItemKind.show,
    depth: 0,
    role: WesternWatchOrderItemRole.neutral,
    searchTarget: SearchTarget(query: media.title, itemType: itemType),
    ids: media.ids,
    image: media.posterUrl,
    sourceRank: sourceRank,
    year: media.year,
  );
}

WesternWatchOrderItem _explicitSeasonRow(
  TraktListItem item, {
  required TraktRootMedia parent,
  required ItemType itemType,
}) {
  final number = item.seasonNumber!;
  return WesternWatchOrderItem(
    key: '${_mediaKey(parent)}:season:$number:${item.ids.trakt ?? item.rank}',
    title: item.title,
    kind: WesternWatchOrderItemKind.season,
    depth: 1,
    role: WesternWatchOrderItemRole.neutral,
    searchTarget: SearchTarget(query: parent.title, itemType: itemType),
    ids: item.ids,
    image: parent.posterUrl,
    sourceRank: item.rank,
    year: item.year,
    seasonNumber: number,
  );
}

WesternWatchOrderItem _syntheticSeasonRow(
  TraktRootMedia parent,
  int seasonNumber, {
  required ItemType itemType,
  required int sourceRank,
  String? keySuffix,
}) {
  return WesternWatchOrderItem(
    key:
        '${_mediaKey(parent)}:season:$seasonNumber:group${keySuffix == null ? '' : ':$keySuffix'}',
    title: 'Season $seasonNumber',
    kind: WesternWatchOrderItemKind.season,
    depth: 1,
    role: WesternWatchOrderItemRole.neutral,
    searchTarget: SearchTarget(query: parent.title, itemType: itemType),
    ids: const TraktIds(),
    image: parent.posterUrl,
    sourceRank: sourceRank,
    seasonNumber: seasonNumber,
  );
}

WesternWatchOrderItem _episodeRow(
  TraktListItem item, {
  required TraktRootMedia parent,
  required ItemType itemType,
}) {
  return WesternWatchOrderItem(
    key:
        '${_mediaKey(parent)}:season:${item.seasonNumber}:episode:${item.episodeNumber}:${item.ids.trakt ?? item.rank}',
    title: item.title,
    kind: WesternWatchOrderItemKind.episode,
    depth: 2,
    role: WesternWatchOrderItemRole.neutral,
    searchTarget: SearchTarget(query: parent.title, itemType: itemType),
    ids: item.ids,
    image: parent.posterUrl,
    sourceRank: item.rank,
    year: item.year,
    seasonNumber: item.seasonNumber,
    episodeNumber: item.episodeNumber,
  );
}

List<WesternWatchOrderItem> _assignTopLevelRoles(
  List<WesternWatchOrderItem> rows,
  TraktRootMedia root,
) {
  bool matchesRoot(WesternWatchOrderItem row) =>
      row.depth == 0 &&
      _typeMatches(row.kind, root.type) &&
      _idsMatch(row.ids, root.ids);

  var currentIndex = rows.indexWhere(
    (row) => matchesRoot(row) && !row.key.contains(':group:'),
  );
  if (currentIndex == -1) currentIndex = rows.indexWhere(matchesRoot);
  if (currentIndex == -1) return List.unmodifiable(rows);

  return List.unmodifiable([
    for (var index = 0; index < rows.length; index++)
      if (rows[index].depth != 0)
        rows[index].withRole(WesternWatchOrderItemRole.neutral)
      else if (matchesRoot(rows[index]) && index != currentIndex)
        rows[index].withRole(WesternWatchOrderItemRole.neutral)
      else if (index < currentIndex)
        rows[index].withRole(WesternWatchOrderItemRole.previous)
      else if (index == currentIndex)
        rows[index].withRole(WesternWatchOrderItemRole.current)
      else
        rows[index].withRole(WesternWatchOrderItemRole.next),
  ]);
}

TraktMediaType? _rootType(MediaKind kind) {
  return switch (kind) {
    MediaKind.movie => TraktMediaType.movie,
    MediaKind.show => TraktMediaType.show,
    MediaKind.unknown || MediaKind.anime => null,
  };
}

bool _typeMatches(WesternWatchOrderItemKind kind, TraktMediaType type) {
  return (kind == WesternWatchOrderItemKind.movie &&
          type == TraktMediaType.movie) ||
      (kind == WesternWatchOrderItemKind.show && type == TraktMediaType.show);
}

bool _idsMatch(TraktIds first, TraktIds second) {
  return (first.trakt != null && first.trakt == second.trakt) ||
      (first.tmdb != null && first.tmdb == second.tmdb) ||
      (first.tvdb != null && first.tvdb == second.tvdb) ||
      (first.imdb != null && first.imdb == second.imdb) ||
      (first.slug != null && first.slug == second.slug);
}

String _mediaKey(TraktRootMedia media) => media.stableKey;
