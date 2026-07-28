import 'dart:convert';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/services/http/m_client.dart';

/// AniList public GraphQL discovery client. No login required for browsing, so
/// this is separate from the AniList *tracker* (which is OAuth'd). It powers the
/// planned Feed tab (trending / seasonal / upcoming / popular), recommendations,
/// and watch-order relations.
///
/// Replaces the dead anibrain.ai recommendation backend (shut down 2026). Unlike
/// the old scrapers, failures are NOT silently swallowed here: [_executeGraphQL]
/// throws, so callers can surface a real error instead of a blank "No result".
///
/// Queries verified against https://graphql.anilist.co (2026-07).
const String _anilistEndpoint = "https://graphql.anilist.co/";

/// Shared media selection set. Keep every media query returning the same fields
/// so one [DiscoveryMedia.fromJson] handles them all.
const String _mediaFields = '''
    id
    idMal
    title { romaji english native }
    coverImage { large color }
    bannerImage
    description(asHtml: false)
    format
    status
    episodes
    chapters
    averageScore
    genres
    season
    seasonYear''';

String _mediaTypeOf(ItemType itemType) =>
    itemType == ItemType.anime ? "ANIME" : "MANGA";

Future<Map<String, dynamic>?> _executeGraphQL(
  String query,
  Map<String, dynamic> variables,
) async {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  final res = await http.post(
    Uri.parse(_anilistEndpoint),
    headers: const {
      "Content-Type": "application/json",
      "Accept": "application/json",
    },
    body: jsonEncode({"query": query, "variables": variables}),
  );
  final decoded = jsonDecode(res.body) as Map<String, dynamic>;
  if (decoded["errors"] != null) {
    throw Exception("AniList error: ${jsonEncode(decoded["errors"])}");
  }
  return decoded["data"] as Map<String, dynamic>?;
}

/// One page of media, filtered/sorted by whatever the caller passes. Backs
/// trending, popular, seasonal and title search. Novels are MANGA with
/// format NOVEL on AniList, so item type maps to a type + a format filter.
Future<List<DiscoveryMedia>> fetchDiscoveryPage({
  required ItemType itemType,
  List<String>? sort,
  String? season,
  int? seasonYear,
  String? status,
  String? search,
  int page = 1,
  int perPage = 25,
}) async {
  final variables = {
    "page": page,
    "perPage": perPage,
    "type": _mediaTypeOf(itemType),
    "sort": sort,
    "season": season,
    "seasonYear": seasonYear,
    "status": status,
    "search": search,
    // Null filters are ignored by AniList, so this cleanly separates
    // manga (exclude novels) from novels (only novels).
    "formatIn": itemType == ItemType.novel ? const ["NOVEL"] : null,
    "formatNotIn": itemType == ItemType.manga ? const ["NOVEL"] : null,
  };
  const query = '''
    query(\$page: Int, \$perPage: Int, \$type: MediaType, \$sort: [MediaSort],
          \$season: MediaSeason, \$seasonYear: Int, \$status: MediaStatus,
          \$search: String, \$formatIn: [MediaFormat], \$formatNotIn: [MediaFormat]) {
      Page(page: \$page, perPage: \$perPage) {
        media(type: \$type, sort: \$sort, season: \$season, seasonYear: \$seasonYear,
              status: \$status, search: \$search,
              format_in: \$formatIn, format_not_in: \$formatNotIn) {
$_mediaFields
        }
      }
    }''';
  final data = await _executeGraphQL(query, variables);
  final list = data?["Page"]?["media"] as List?;
  return list
          ?.map((e) => DiscoveryMedia.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [];
}

Future<List<DiscoveryMedia>> fetchTrending(ItemType itemType, {int page = 1}) =>
    fetchDiscoveryPage(itemType: itemType, sort: const ["TRENDING_DESC"], page: page);

Future<List<DiscoveryMedia>> fetchPopular(ItemType itemType, {int page = 1}) =>
    fetchDiscoveryPage(itemType: itemType, sort: const ["POPULARITY_DESC"], page: page);

/// Popular titles airing/publishing this season (mainly meaningful for anime).
Future<List<DiscoveryMedia>> fetchThisSeason(ItemType itemType, {int page = 1}) {
  final now = DateTime.now();
  return fetchDiscoveryPage(
    itemType: itemType,
    season: currentSeason(now),
    seasonYear: now.year,
    sort: const ["POPULARITY_DESC"],
    page: page,
  );
}

/// Anticipated titles for next season (not yet released).
Future<List<DiscoveryMedia>> fetchUpcoming(ItemType itemType, {int page = 1}) {
  final (season, year) = nextSeason(DateTime.now());
  return fetchDiscoveryPage(
    itemType: itemType,
    season: season,
    seasonYear: year,
    sort: const ["POPULARITY_DESC"],
    page: page,
  );
}

/// Best-effort resolve a title to its AniList media id (for repointing the
/// existing recommendation screen, which only knows a manga/anime name).
Future<int?> searchMediaId(ItemType itemType, String title) async {
  final results = await fetchDiscoveryPage(
    itemType: itemType,
    search: title,
    sort: const ["SEARCH_MATCH"],
    perPage: 1,
  );
  return results.firstOrNull?.id;
}

/// "More like this" for a given AniList media id.
Future<List<DiscoveryMedia>> fetchRecommendations(
  int mediaId, {
  int perPage = 25,
}) async {
  const query = '''
    query(\$id: Int, \$perPage: Int) {
      Media(id: \$id) {
        recommendations(sort: RATING_DESC, perPage: \$perPage) {
          nodes { mediaRecommendation {
$_mediaFields
          } }
        }
      }
    }''';
  final data = await _executeGraphQL(query, {"id": mediaId, "perPage": perPage});
  final nodes = data?["Media"]?["recommendations"]?["nodes"] as List?;
  return nodes
          ?.map((n) => (n as Map<String, dynamic>)["mediaRecommendation"])
          .whereType<Map<String, dynamic>>()
          .map((m) => DiscoveryMedia.fromJson(m))
          .toList() ??
      const [];
}

/// Related entries (prequels/sequels/side stories/adaptations). Raw graph for
/// building a watch order; the linear ordering is derived by the caller.
Future<List<DiscoveryRelation>> fetchRelations(int mediaId) async {
  const query = '''
    query(\$id: Int) {
      Media(id: \$id) {
        relations { edges { relationType node {
$_mediaFields
        } } }
      }
    }''';
  final data = await _executeGraphQL(query, {"id": mediaId});
  final edges = data?["Media"]?["relations"]?["edges"] as List?;
  return edges
          ?.map((e) => DiscoveryRelation.fromEdge(e as Map<String, dynamic>))
          .toList() ??
      const [];
}

/// AniList season for a given date (WINTER=Dec-Feb, SPRING=Mar-May,
/// SUMMER=Jun-Aug, FALL=Sep-Nov).
String currentSeason([DateTime? now]) {
  final month = (now ?? DateTime.now()).month;
  if (month == 12 || month <= 2) return "WINTER";
  if (month <= 5) return "SPRING";
  if (month <= 8) return "SUMMER";
  return "FALL";
}

/// The season/year immediately after [now] (wraps FALL -> WINTER of next year).
(String, int) nextSeason([DateTime? now]) {
  now ??= DateTime.now();
  const order = ["WINTER", "SPRING", "SUMMER", "FALL"];
  final current = currentSeason(now);
  final next = order[(order.indexOf(current) + 1) % 4];
  final year = current == "FALL" ? now.year + 1 : now.year;
  return (next, year);
}

class DiscoveryMedia {
  final int id;
  final int? idMal;
  final String? romaji;
  final String? english;
  final String? native;
  final String? coverImage;
  final String? coverColor;
  final String? bannerImage;
  final String? description;
  final String? format;
  final String? status;
  final int? episodes;
  final int? chapters;
  final int? averageScore;
  final List<String> genres;
  final String? season;
  final int? seasonYear;

  DiscoveryMedia({
    required this.id,
    this.idMal,
    this.romaji,
    this.english,
    this.native,
    this.coverImage,
    this.coverColor,
    this.bannerImage,
    this.description,
    this.format,
    this.status,
    this.episodes,
    this.chapters,
    this.averageScore,
    this.genres = const [],
    this.season,
    this.seasonYear,
  });

  /// Preferred display title: English, then Romaji, then Native.
  String get title => english ?? romaji ?? native ?? "Unknown";

  /// Search term to bridge to installed sources (the reader extensions match by
  /// title, so Romaji is usually the safest key, with English as a fallback).
  String get searchTitle => romaji ?? english ?? native ?? "";

  factory DiscoveryMedia.fromJson(Map<String, dynamic> json) {
    final t = json["title"] as Map<String, dynamic>?;
    return DiscoveryMedia(
      id: json["id"] as int,
      idMal: json["idMal"] as int?,
      romaji: t?["romaji"] as String?,
      english: t?["english"] as String?,
      native: t?["native"] as String?,
      coverImage: (json["coverImage"] as Map<String, dynamic>?)?["large"] as String?,
      coverColor: (json["coverImage"] as Map<String, dynamic>?)?["color"] as String?,
      bannerImage: json["bannerImage"] as String?,
      description: json["description"] as String?,
      format: json["format"] as String?,
      status: json["status"] as String?,
      episodes: json["episodes"] as int?,
      chapters: json["chapters"] as int?,
      averageScore: json["averageScore"] as int?,
      genres: (json["genres"] as List?)?.cast<String>() ?? const [],
      season: json["season"] as String?,
      seasonYear: json["seasonYear"] as int?,
    );
  }
}

class DiscoveryRelation {
  /// PREQUEL, SEQUEL, SIDE_STORY, ADAPTATION, PARENT, ALTERNATIVE, etc.
  final String relationType;
  final DiscoveryMedia media;

  DiscoveryRelation({required this.relationType, required this.media});

  factory DiscoveryRelation.fromEdge(Map<String, dynamic> edge) =>
      DiscoveryRelation(
        relationType: edge["relationType"] as String? ?? "",
        media: DiscoveryMedia.fromJson(edge["node"] as Map<String, dynamic>),
      );
}
