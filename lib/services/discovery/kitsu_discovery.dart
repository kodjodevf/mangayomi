import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/services/anilist_discovery.dart';
import 'package:mangayomi/services/discovery/title_match.dart';
import 'package:mangayomi/services/discovery/service_availability.dart';
import 'package:mangayomi/utils/constant.dart';

/// Kitsu, used when AniList will not answer.
///
/// It covers the two things a fallback can honestly cover: resolving a title to
/// an id, and the relations hanging off that id. Kitsu has no "more like this"
/// endpoint, so recommendations stay AniList-only and say so rather than
/// quietly returning nothing.
///
/// Kitsu ids are not AniList ids, which is why [DiscoveryMedia.source] exists:
/// whatever answered the search has to answer the follow-up calls too.
const String _kitsuEndpoint = "https://kitsu.io/api/edge";
const Duration _kitsuTimeout = Duration(seconds: 15);

String _kitsuType(ItemType itemType) =>
    itemType == ItemType.anime ? "anime" : "manga";

Future<Map<String, dynamic>?> _get(
  String path,
  Map<String, String> query,
) async {
  final known = ServiceAvailability.outage(DiscoveryService.kitsu);
  if (known != null) throw known;

  final client = http.Client();
  try {
    final res = await client
        .get(
          Uri.parse('$_kitsuEndpoint$path').replace(queryParameters: query),
          headers: const {
            "Accept": "application/vnd.api+json",
            "User-Agent": metadataApiUserAgent,
          },
        )
        .timeout(_kitsuTimeout);

    if (res.statusCode == 403 || res.statusCode >= 500) {
      throw ServiceAvailability.markDown(
        DiscoveryService.kitsu,
        "answered HTTP ${res.statusCode}",
      );
    }
    final decoded = jsonDecode(res.body);
    if (decoded is! Map<String, dynamic>) return null;
    ServiceAvailability.markUp(DiscoveryService.kitsu);
    return decoded;
  } on TimeoutException {
    throw ServiceAvailability.markDown(
      DiscoveryService.kitsu,
      "did not answer within ${_kitsuTimeout.inSeconds}s",
      cooldown: const Duration(minutes: 2),
    );
  } finally {
    client.close();
  }
}

/// Kitsu's own shape, mapped onto the AniList-shaped [DiscoveryMedia] the rest
/// of the app already understands.
DiscoveryMedia kitsuMediaFrom(Map<String, dynamic> entry) {
  final attributes = (entry["attributes"] as Map<String, dynamic>?) ?? const {};
  final titles = (attributes["titles"] as Map<String, dynamic>?) ?? const {};
  final poster = attributes["posterImage"] as Map<String, dynamic>?;
  final rating = double.tryParse('${attributes["averageRating"] ?? ''}');
  final startDate = '${attributes["startDate"] ?? ''}'.split('-');

  return DiscoveryMedia(
    id: int.tryParse('${entry["id"]}') ?? 0,
    source: DiscoveryService.kitsu,
    romaji:
        titles["en_jp"] as String? ?? attributes["canonicalTitle"] as String?,
    english: titles["en"] as String?,
    native: titles["ja_jp"] as String?,
    coverImage: poster?["large"] as String? ?? poster?["original"] as String?,
    description: attributes["synopsis"] as String?,
    // Kitsu subtypes (TV, movie, manga, novel) line up with AniList formats
    // once upper-cased, which is all the UI does with this field.
    format: (attributes["subtype"] as String?)?.toUpperCase(),
    status: (attributes["status"] as String?)?.toUpperCase(),
    episodes: attributes["episodeCount"] as int?,
    chapters: attributes["chapterCount"] as int?,
    // Kitsu rates out of 100 as a decimal string; AniList uses a whole number.
    averageScore: rating?.round(),
    type: entry["type"] == "anime" ? "ANIME" : "MANGA",
    startYear: startDate.isNotEmpty ? int.tryParse(startDate.first) : null,
    startMonth: startDate.length > 1 ? int.tryParse(startDate[1]) : null,
  );
}

/// Resolves [title] to a Kitsu id, or null when nothing is close enough.
///
/// Asks for several and picks the one whose own titles match, rather than
/// taking the first and trusting it. A library title comes from whichever
/// source it was added from, and those disagree with Kitsu about punctuation,
/// romanisation and how much of a subtitle to keep.
///
/// Returning null is a real answer here. Relations of the wrong series look
/// exactly as confident as relations of the right one.
Future<int?> kitsuSearchMediaId(ItemType itemType, String title) async {
  final body = await _get('/${_kitsuType(itemType)}', {
    'filter[text]': title,
    'page[limit]': '5',
  });
  final data = (body?["data"] as List?)
      ?.whereType<Map<String, dynamic>>()
      .toList();
  if (data == null || data.isEmpty) return null;

  final best = bestTitleMatch(title, [for (final e in data) kitsuTitlesOf(e)]);
  if (best == null) return null;
  return int.tryParse('${data[best]["id"]}');
}

/// Every name Kitsu knows an entry by.
///
/// The abbreviations are worth including: they carry the alternate
/// romanisations and the fan-translation names, which is often what a source
/// called it.
List<String> kitsuTitlesOf(Map<String, dynamic> entry) {
  final attributes = (entry["attributes"] as Map<String, dynamic>?) ?? const {};
  final titles = (attributes["titles"] as Map<String, dynamic>?) ?? const {};
  return [
    ...titles.values.whereType<String>(),
    if (attributes["canonicalTitle"] case final String canonical) canonical,
    ...?(attributes["abbreviatedTitles"] as List?)?.whereType<String>(),
  ].where((t) => t.isNotEmpty).toList();
}

/// A Kitsu media plus its relations, shaped like the AniList call it stands in
/// for.
Future<(DiscoveryMedia?, List<DiscoveryRelation>)> kitsuMediaWithRelations(
  ItemType itemType,
  int mediaId,
) async {
  final self = await _get('/${_kitsuType(itemType)}/$mediaId', const {});
  final selfData = self?["data"] as Map<String, dynamic>?;
  final media = selfData == null ? null : kitsuMediaFrom(selfData);

  final body = await _get('/media-relationships', {
    'filter[source_id]': '$mediaId',
    'filter[source_type]': itemType == ItemType.anime ? 'Anime' : 'Manga',
    'include': 'destination',
    'page[limit]': '20',
  });

  return (media, kitsuRelationsFrom(body));
}

/// Kitsu returns the relationships and the media they point at in separate
/// arrays, joined by id, so this stitches them back together.
List<DiscoveryRelation> kitsuRelationsFrom(Map<String, dynamic>? body) {
  final data = body?["data"] as List?;
  final included = body?["included"] as List?;
  if (data == null || included == null) return const [];

  final byId = <String, Map<String, dynamic>>{};
  for (final entry in included.whereType<Map<String, dynamic>>()) {
    byId['${entry["type"]}:${entry["id"]}'] = entry;
  }

  final relations = <DiscoveryRelation>[];
  for (final entry in data.whereType<Map<String, dynamic>>()) {
    final destination =
        ((entry["relationships"] as Map<String, dynamic>?)?["destination"]
                as Map<String, dynamic>?)?["data"]
            as Map<String, dynamic>?;
    if (destination == null) continue;
    final media = byId['${destination["type"]}:${destination["id"]}'];
    if (media == null) continue;
    final role =
        (entry["attributes"] as Map<String, dynamic>?)?["role"] as String?;
    relations.add(
      DiscoveryRelation(
        // Kitsu says side_story where AniList says SIDE_STORY.
        relationType: (role ?? '').toUpperCase(),
        media: kitsuMediaFrom(media),
      ),
    );
  }
  return relations;
}
