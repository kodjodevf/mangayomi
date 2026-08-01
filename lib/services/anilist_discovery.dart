import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mangayomi/models/manga.dart';

/// AniList public GraphQL discovery client. No login required for browsing, so
/// this is separate from the AniList *tracker* (which is OAuth'd).
///
/// This slice powers recommendations, replacing the dead anibrain.ai backend
/// (shut down 2026, its API now redirects to a farewell page). The feed tab
/// (trending / seasonal / upcoming) and watch-order relations extend this client
/// in a follow-up PR. Unlike the old scrapers, failures are NOT silently
/// swallowed here: [_executeGraphQL] throws so callers can surface a real error
/// instead of a blank "No result".
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
    type
    episodes
    chapters
    averageScore
    genres
    season
    seasonYear
    startDate { year month }''';

/// Lean field set for the SEARCH query. AniList search is far more expensive
/// than a by-id lookup, and asking for the heavy [_mediaFields] on top of a
/// search (the large `description` field in particular) reliably returns a
/// server 500. Search only needs enough to resolve an id and show a result row,
/// so drop description/banner/genres/status here. Recommendations and relations
/// (cheap by-id lookups) still use the full [_mediaFields], cover included.
const String _searchFields = '''
    id
    idMal
    title { romaji english native }
    coverImage { large color }
    format
    episodes
    chapters
    averageScore
    season
    seasonYear''';

String _mediaTypeOf(ItemType itemType) =>
    itemType == ItemType.anime ? "ANIME" : "MANGA";

Future<Map<String, dynamic>?> _executeGraphQL(
  String query,
  Map<String, dynamic> variables,
) async {
  // Plain HTTP client with a fixed browser User-Agent. AniList is behind
  // Cloudflare, which 403-bans non-browser user-agents, so a bare client with a
  // known Chrome UA is the reliable choice (MClient would send the user's
  // configured UA, which may not satisfy Cloudflare).
  final client = http.Client();
  try {
    final res = await client.post(
      Uri.parse(_anilistEndpoint),
      headers: const {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "User-Agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
            "(KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36",
      },
      body: jsonEncode({"query": query, "variables": variables}),
    );
    final decoded = jsonDecode(res.body) as Map<String, dynamic>;
    if (decoded["errors"] != null) {
      throw Exception("AniList error: ${jsonEncode(decoded["errors"])}");
    }
    return decoded["data"] as Map<String, dynamic>?;
  } finally {
    client.close();
  }
}

/// One page of media, filtered/sorted by what the caller passes. Novels are
/// MANGA with format NOVEL on AniList, so item type maps to a type plus a format
/// filter. The feed PR extends this with season/status filters.
Future<List<DiscoveryMedia>> fetchDiscoveryPage({
  required ItemType itemType,
  List<String>? sort,
  String? search,
  int page = 1,
  int perPage = 25,
}) async {
  final variables = {
    "page": page,
    "perPage": perPage,
    "type": _mediaTypeOf(itemType),
    "sort": sort,
    "search": search,
  };
  // Inline the format filter as a literal only when there is one. Passing
  // `format_in: null` / `format_not_in: null` (i.e. the arg present but null)
  // makes AniList's search return a 500, so anime sends no format arg at all,
  // manga excludes NOVEL, and novels ask only for NOVEL.
  final formatFilter = switch (itemType) {
    ItemType.novel => ", format_in: [NOVEL]",
    ItemType.manga => ", format_not_in: [NOVEL]",
    ItemType.anime => "",
  };
  final query = '''
    query(\$page: Int, \$perPage: Int, \$type: MediaType, \$sort: [MediaSort], \$search: String) {
      Page(page: \$page, perPage: \$perPage) {
        media(type: \$type, sort: \$sort, search: \$search$formatFilter) {
$_searchFields
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

/// Best-effort resolve a title to its AniList media id. The recommendation
/// screen only knows a manga/anime name, so this maps it to an id.
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

/// A media plus its relations in one call, for building a watch order. AniList
/// gives no linear order, so the caller filters/orders the graph.
Future<(DiscoveryMedia?, List<DiscoveryRelation>)> fetchMediaWithRelations(
  int mediaId,
) async {
  final query = '''
    query(\$id: Int) {
      Media(id: \$id) {
$_mediaFields
        relations { edges { relationType node {
$_mediaFields
        } } }
      }
    }''';
  final data = await _executeGraphQL(query, {"id": mediaId});
  final media = data?["Media"] as Map<String, dynamic>?;
  if (media == null) return (null, const <DiscoveryRelation>[]);
  final edges = media["relations"]?["edges"] as List?;
  final relations = edges
          ?.map((e) => DiscoveryRelation.fromEdge(e as Map<String, dynamic>))
          .toList() ??
      <DiscoveryRelation>[];
  return (DiscoveryMedia.fromJson(media), relations);
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
  final String? type;
  final int? startYear;
  final int? startMonth;

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
    this.type,
    this.startYear,
    this.startMonth,
  });

  /// Preferred display title: English, then Romaji, then Native.
  String get title => english ?? romaji ?? native ?? "Unknown";

  /// Search term to bridge to installed sources (extensions match by title, so
  /// Romaji is usually the safest key, with English as a fallback).
  String get searchTitle => romaji ?? english ?? native ?? "";

  /// AniList type is ANIME or MANGA (novels are MANGA with format NOVEL).
  bool get isAnime => type == "ANIME";

  /// Chronological key (year then month) for release-order sorting; undated
  /// entries sort last.
  int get startSortKey =>
      startYear == null ? 1 << 30 : startYear! * 12 + (startMonth ?? 0);

  factory DiscoveryMedia.fromJson(Map<String, dynamic> json) {
    final t = json["title"] as Map<String, dynamic>?;
    final cover = json["coverImage"] as Map<String, dynamic>?;
    return DiscoveryMedia(
      id: json["id"] as int,
      idMal: json["idMal"] as int?,
      romaji: t?["romaji"] as String?,
      english: t?["english"] as String?,
      native: t?["native"] as String?,
      coverImage: cover?["large"] as String?,
      coverColor: cover?["color"] as String?,
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
      type: json["type"] as String?,
      startYear: (json["startDate"] as Map<String, dynamic>?)?["year"] as int?,
      startMonth: (json["startDate"] as Map<String, dynamic>?)?["month"] as int?,
    );
  }
}

class DiscoveryRelation {
  /// PREQUEL, SEQUEL, SIDE_STORY, PARENT, SPIN_OFF, ALTERNATIVE, ADAPTATION, etc.
  final String relationType;
  final DiscoveryMedia media;

  DiscoveryRelation({required this.relationType, required this.media});

  factory DiscoveryRelation.fromEdge(Map<String, dynamic> edge) =>
      DiscoveryRelation(
        relationType: edge["relationType"] as String? ?? "",
        media: DiscoveryMedia.fromJson(edge["node"] as Map<String, dynamic>),
      );
}
