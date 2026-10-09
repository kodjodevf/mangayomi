import 'dart:convert';

import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/services/anilist_discovery.dart';
import 'package:mangayomi/services/discovery/media_catalog_resolver.dart';
import 'package:mangayomi/services/discovery/media_lookup_context.dart';
import 'package:mangayomi/services/discovery/search_target.dart';
import 'package:mangayomi/services/discovery/service_availability.dart';
import 'package:mangayomi/services/discovery/trakt_discovery.dart';
import 'package:mangayomi/services/discovery/western_watch_order.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/constant.dart';

const _sequelData =
    "&types%5B%5D=1&types%5B%5D=3&types%5B%5D=2&types%5B%5D=4&types%5B%5D=9&score=0&date_from=false&date_to=false&include_ptw=1&exclude_h=1&exclude_planned=1&exclude_dropped=0&exclude_not_aired=0&exclude_short=1&exclude_short_value=3";

Future<List<SequelItem>> fetchSequels(
  String? malUsername,
  String? anilistUsername,
) async {
  if (malUsername == null && anilistUsername == null) {
    return [];
  }
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  try {
    final url = Uri.parse("https://chiaki.site/?/tools/sequel_locator_fetch");
    final res = await http.post(
      url,
      headers: {
        "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
        "priority": "u=1, i",
        "Referer": "https://chiaki.site/?/tools/watch_order",
        "User-Agent": metadataApiUserAgent,
      },
      body:
          "user=${malUsername ?? anilistUsername}&list_source=${malUsername != null ? "mal" : "anilist"}$_sequelData",
    );
    final data = jsonDecode(res.body) as Map<String, dynamic>?;
    return (data?["data"] as List?)
            ?.map((e) => SequelItem.fromJson(e))
            .toList() ??
        [];
  } catch (_) {
    return [];
  }
}

/// Search AniList for anime to build a watch order from (was chiaki.site).
/// Errors propagate so the screen shows a real message instead of "No result".
Future<List<WatchOrderSearch>> searchWatchOrder(String name) async {
  final results = await fetchDiscoveryPage(
    itemType: ItemType.anime,
    search: name,
    sort: const ["SEARCH_MATCH"],
    perPage: 15,
  );
  return results
      .map(
        (m) => WatchOrderSearch(
          id: m.id.toString(),
          image: m.coverImage ?? "",
          type: m.format ?? "",
          name: m.title,
          year: m.seasonYear ?? 0,
        ),
      )
      .toList();
}

/// Build a watch order from an AniList media id. Two gates keep it accurate:
/// (1) include only the ANIME line — drop the manga/light-novel the anime was
/// adapted from and loose shared-character links; and (2) order by release date
/// rather than relation type, which is the reliable watch order for most
/// franchises (AniList's relation graph has no order of its own).
Future<WatchOrderPlan> fetchWatchOrder(
  String id, {
  DiscoveryService source = DiscoveryService.anilist,
}) async {
  final rootId = int.tryParse(id);
  final provenance = WatchOrderSource(
    kind: WatchOrderSourceKind.animeReleaseOrder,
    service: source.label,
  );
  if (rootId == null) {
    return WatchOrderPlan(source: provenance, items: const []);
  }

  // AniList relations are a single hop, so a chained franchise (S1 -> Cour 2 ->
  // S2 -> S3, each a SEQUEL of the previous) needs a graph walk. Traverse the
  // main story line (prequel/sequel/parent) and additionally collect side
  // content (side story/spin-off/alternative/summary/compilation) from visited
  // nodes without expanding out of it. Anime only, and capped so a huge
  // franchise can't run away.
  const chain = {"PREQUEL", "SEQUEL", "PARENT"};
  const extra = {
    "SIDE_STORY",
    "SPIN_OFF",
    "ALTERNATIVE",
    "SUMMARY",
    "COMPILATION",
  };
  final collected = <int, DiscoveryMedia>{};
  final queue = <int>[rootId];
  final visited = <int>{};
  var queries = 0;
  while (queue.isNotEmpty && queries < 20) {
    final current = queue.removeAt(0);
    if (!visited.add(current)) continue;
    queries++;
    final (self, relations) = await fetchMediaWithRelations(
      current,
      source: source,
    );
    if (self != null && self.isAnime) collected[self.id] = self;
    for (final r in relations) {
      if (!r.media.isAnime) continue;
      if (chain.contains(r.relationType)) {
        collected[r.media.id] = r.media;
        if (!visited.contains(r.media.id)) queue.add(r.media.id);
      } else if (extra.contains(r.relationType)) {
        collected[r.media.id] = r.media;
      }
    }
  }

  // Order by air date (the reliable watch order); undated entries sink last.
  final unique = collected.values.toList()
    ..sort((a, b) => a.startSortKey.compareTo(b.startSortKey));

  // The queried title is the anchor: entries before it are "previous", it is
  // "current", entries after are "next".
  final currentIndex = unique.indexWhere((m) => m.id == rootId);
  final items = <WatchOrderItem>[];
  for (var i = 0; i < unique.length; i++) {
    final m = unique[i];
    final role = currentIndex < 0
        ? WatchOrderRole.next
        : i < currentIndex
        ? WatchOrderRole.previous
        : i == currentIndex
        ? WatchOrderRole.current
        : WatchOrderRole.next;
    items.add(
      WatchOrderItem(
        key: '${m.source.name}:${m.id}',
        kind: WatchOrderItemKind.anime,
        image: m.coverImage ?? "",
        name: m.romaji ?? m.title,
        nameEnglish: m.english,
        format: m.format,
        year: m.startYear,
        episodeCount: m.episodes,
        searchTarget: SearchTarget(
          query: m.english ?? m.romaji ?? m.native ?? m.title,
          itemType: ItemType.anime,
        ),
        role: role,
      ),
    );
  }
  return WatchOrderPlan(source: provenance, items: List.unmodifiable(items));
}

/// Resolve an anime name to its AniList id and build its watch order directly,
/// with no manual pick step. The resolved title becomes the "current" anchor.
Future<WatchOrderPlan> fetchWatchOrderByName(String name) async {
  // searchMediaRef falls back to Kitsu when AniList will not answer, and says
  // which of them resolved the name so the walk below asks the same service.
  final ref = await searchMediaRef(ItemType.anime, name);
  if (ref == null) {
    return const WatchOrderPlan(
      source: WatchOrderSource(
        kind: WatchOrderSourceKind.animeReleaseOrder,
        service: 'AniList',
      ),
      items: [],
    );
  }
  final (source, mediaId) = ref;
  return fetchWatchOrder(mediaId.toString(), source: source);
}

/// Build a truthful western franchise order from validated Trakt lists.
///
/// Shows fall back to their own seasons when no credible public list exists.
/// Movies return null in that situation, rather than treating similar titles
/// as an invented viewing order.
Future<WatchOrderPlan?> fetchWesternWatchOrder(
  MediaLookupContext media, {
  String? selectedSourceKey,
  WesternWatchOrderPlanner? planner,
  TraktRootMedia? resolvedRoot,
}) async {
  final western = await (planner ?? WesternWatchOrderPlanner()).build(
    media,
    selectedCandidateKey: selectedSourceKey,
    resolvedRoot: resolvedRoot,
  );
  if (western == null) return null;

  final source = switch (western.source.kind) {
    WesternWatchOrderSourceKind.showSeasons => WatchOrderSource(
      kind: WatchOrderSourceKind.traktSeasons,
      service: 'Trakt',
      name: western.source.name,
    ),
    WesternWatchOrderSourceKind.publicList => WatchOrderSource(
      kind: western.source.isOfficial
          ? WatchOrderSourceKind.traktOfficialList
          : WatchOrderSourceKind.traktCommunityList,
      service: 'Trakt',
      name: western.source.name,
      author: western.source.author,
      url: western.source.url,
    ),
  };

  return WatchOrderPlan(
    source: source,
    items: List.unmodifiable(
      western.items.map(
        (item) => WatchOrderItem(
          key: item.key,
          kind: switch (item.kind) {
            WesternWatchOrderItemKind.movie => WatchOrderItemKind.movie,
            WesternWatchOrderItemKind.show => WatchOrderItemKind.show,
            WesternWatchOrderItemKind.season => WatchOrderItemKind.season,
            WesternWatchOrderItemKind.episode => WatchOrderItemKind.episode,
          },
          image: item.image ?? '',
          name: item.title,
          nameEnglish: null,
          depth: item.depth.clamp(0, 2),
          role: switch (item.role) {
            WesternWatchOrderItemRole.previous => WatchOrderRole.previous,
            WesternWatchOrderItemRole.current => WatchOrderRole.current,
            WesternWatchOrderItemRole.next => WatchOrderRole.next,
            WesternWatchOrderItemRole.neutral => WatchOrderRole.neutral,
          },
          searchTarget: item.searchTarget,
          rank: item.sourceRank,
          year: item.year,
          seasonNumber: item.seasonNumber,
          episodeNumber: item.episodeNumber,
          episodeCount: item.episodeCount,
        ),
      ),
    ),
    options: List.unmodifiable(
      western.options.map(
        (option) => WatchOrderOption(
          key: option.key,
          name: option.name,
          author: option.author,
          url: option.url,
          isOfficial: option.isOfficial,
        ),
      ),
    ),
    selectedOptionKey: western.selectedCandidateKey,
  );
}

/// Choose AniList or Trakt once, then build the matching watch-order plan.
Future<WatchOrderPlan?> fetchWatchOrderForMedia(
  MediaLookupContext media, {
  String? selectedSourceKey,
  WesternWatchOrderPlanner? planner,
  MediaCatalogResolver? catalogResolver,
}) async {
  final resolved = await (catalogResolver ?? MediaCatalogResolver()).resolve(
    media,
  );
  if (resolved.catalog == DiscoveryCatalog.anilist) {
    final id = resolved.anilistId;
    return id == null
        ? fetchWatchOrderByName(media.title)
        : fetchWatchOrder(id.toString());
  }
  return fetchWesternWatchOrder(
    media,
    selectedSourceKey: selectedSourceKey,
    planner: planner,
    resolvedRoot: resolved.traktRoot,
  );
}

class SequelItem {
  final String id;
  final String? anilistId;
  final String image;
  final String episodes;
  final String title;
  final String group;
  final String groupId;
  final String period;
  final String score;
  final String scoreUsers;
  final String type;
  final List<SequelReason> reason;

  SequelItem({
    required this.id,
    required this.anilistId,
    required this.image,
    required this.episodes,
    required this.title,
    required this.group,
    required this.groupId,
    required this.period,
    required this.score,
    required this.scoreUsers,
    required this.type,
    required this.reason,
  });

  factory SequelItem.fromJson(Map<String, dynamic> json) {
    return SequelItem(
      id: json["id"],
      anilistId: json["anilist_id"],
      image: "https://chiaki.site/${json["image_url"]}",
      episodes: json["episodes"],
      title: json["title"],
      group: json["group"],
      groupId: json["group_id"],
      period: json["period"],
      score: json["score"],
      scoreUsers: json["score_users"],
      type: json["type"],
      reason:
          (json["reason"] as List?)
              ?.map((e) => SequelReason.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class SequelReason {
  final String id;
  final String image;
  final String title;

  SequelReason({required this.id, required this.image, required this.title});

  factory SequelReason.fromJson(Map<String, dynamic> json) {
    return SequelReason(
      id: json["id"],
      image: "https://chiaki.site/${json["image_url"]}",
      title: json["title"],
    );
  }
}

class WatchOrderSearch {
  final String id;
  final String image;
  final String type;
  final String name;
  final int year;

  WatchOrderSearch({
    required this.id,
    required this.image,
    required this.type,
    required this.name,
    required this.year,
  });

  factory WatchOrderSearch.fromJson(Map<String, dynamic> json) {
    return WatchOrderSearch(
      id: json["id"],
      image: "https://chiaki.site/${json["image"]}",
      type: json["type"],
      name: json["value"],
      year: json["year"],
    );
  }
}

enum WatchOrderSourceKind {
  animeReleaseOrder,
  traktOfficialList,
  traktCommunityList,
  traktSeasons,
}

class WatchOrderSource {
  const WatchOrderSource({
    required this.kind,
    required this.service,
    this.name,
    this.author,
    this.url,
  });

  final WatchOrderSourceKind kind;
  final String service;
  final String? name;
  final String? author;
  final String? url;
}

class WatchOrderOption {
  const WatchOrderOption({
    required this.key,
    required this.name,
    required this.isOfficial,
    this.author,
    this.url,
  });

  final String key;
  final String name;
  final bool isOfficial;
  final String? author;
  final String? url;
}

class WatchOrderPlan {
  const WatchOrderPlan({
    required this.source,
    required this.items,
    this.options = const [],
    this.selectedOptionKey,
  });

  final WatchOrderSource source;
  final List<WatchOrderItem> items;
  final List<WatchOrderOption> options;
  final String? selectedOptionKey;
}

enum WatchOrderItemKind { anime, movie, show, season, episode }

/// Where an entry sits relative to the title that opened watch order.
enum WatchOrderRole { previous, current, next, neutral }

class WatchOrderItem {
  const WatchOrderItem({
    required this.key,
    required this.kind,
    required this.image,
    required this.name,
    required this.nameEnglish,
    required this.searchTarget,
    this.depth = 0,
    this.role = WatchOrderRole.neutral,
    this.format,
    this.rank,
    this.year,
    this.seasonNumber,
    this.episodeNumber,
    this.episodeCount,
  });

  final String key;
  final WatchOrderItemKind kind;
  final String image;
  final String name;
  final String? nameEnglish;
  final SearchTarget? searchTarget;
  final int depth;
  final WatchOrderRole role;
  final String? format;
  final int? rank;
  final int? year;
  final int? seasonNumber;
  final int? episodeNumber;
  final int? episodeCount;
}
