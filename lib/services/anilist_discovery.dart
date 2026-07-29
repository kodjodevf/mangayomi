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
  // Use a plain HTTP client, NOT the app's MClient. AniList discovery is public
  // and behind Cloudflare; MClient's interceptor rewrites the request (injects
  // the app's cookies/User-Agent, etc.) in a way that makes the public GraphQL
  // endpoint return 500. A bare client sending only a browser User-Agent (which
  // Cloudflare requires) mirrors the request that works from curl.
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
/// filter (null filters are ignored by AniList). The feed PR extends this with
/// season/status filters.
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
    "formatIn": itemType == ItemType.novel ? const ["NOVEL"] : null,
    "formatNotIn": itemType == ItemType.manga ? const ["NOVEL"] : null,
  };
  const query = '''
    query(\$page: Int, \$perPage: Int, \$type: MediaType, \$sort: [MediaSort],
          \$search: String, \$formatIn: [MediaFormat], \$formatNotIn: [MediaFormat]) {
      Page(page: \$page, perPage: \$perPage) {
        media(type: \$type, sort: \$sort, search: \$search,
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

/// Related entries (prequels/sequels/side stories/adaptations) for building a
/// watch order. AniList returns the raw relation graph; the caller derives the
/// order it wants.
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

  /// Search term to bridge to installed sources (extensions match by title, so
  /// Romaji is usually the safest key, with English as a fallback).
  String get searchTitle => romaji ?? english ?? native ?? "";

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
