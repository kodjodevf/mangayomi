import 'dart:convert';

import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/services/anilist_discovery.dart';
import 'package:mangayomi/services/discovery/service_availability.dart';
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
Future<List<WatchOrderItem>> fetchWatchOrder(
  String id, {
  DiscoveryService source = DiscoveryService.anilist,
}) async {
  final rootId = int.tryParse(id);
  if (rootId == null) return [];

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
    final meta = [
      if (m.format != null) m.format!,
      if (m.episodes != null) "${m.episodes} eps",
      if (m.startYear != null) "${m.startYear}",
    ].join(" | ");
    items.add(
      WatchOrderItem(
        id: m.id.toString(),
        anilistId: m.id.toString(),
        image: m.coverImage ?? "",
        name: m.romaji ?? m.title,
        nameEnglish: m.english,
        text: meta,
        role: role,
      ),
    );
  }
  return items;
}

/// Resolve an anime name to its AniList id and build its watch order directly,
/// with no manual pick step. The resolved title becomes the "current" anchor.
Future<List<WatchOrderItem>> fetchWatchOrderByName(String name) async {
  // searchMediaRef falls back to Kitsu when AniList will not answer, and says
  // which of them resolved the name so the walk below asks the same service.
  final ref = await searchMediaRef(ItemType.anime, name);
  if (ref == null) return [];
  final (source, mediaId) = ref;
  return fetchWatchOrder(mediaId.toString(), source: source);
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

/// Where an entry sits relative to the one the user opened watch order from.
enum WatchOrderRole { previous, current, next }

class WatchOrderItem {
  final String id;
  final String anilistId;
  final String image;
  final String name;
  final String? nameEnglish;
  final String text;
  final WatchOrderRole role;

  WatchOrderItem({
    required this.id,
    required this.anilistId,
    required this.image,
    required this.name,
    required this.nameEnglish,
    required this.text,
    this.role = WatchOrderRole.next,
  });
}
