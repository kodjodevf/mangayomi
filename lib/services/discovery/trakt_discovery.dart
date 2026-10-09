import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mangayomi/services/discovery/title_match.dart';

const String _traktBaseUrl = 'https://api.trakt.tv';
const String _traktClientId =
    '5520c7e24da0d8d73ec80315b61b9849483583b013cb7f296c6db723eb9886a1';
const String _traktUserAgent = 'Mangayomi Trakt Discovery';

typedef TraktHttpGet = Future<http.Response> Function(
  Uri uri, {
  Map<String, String>? headers,
});

enum TraktMediaType {
  movie('movie'),
  show('show'),
  season('season'),
  episode('episode');

  const TraktMediaType(this.apiName);

  final String apiName;
}

class TraktIds {
  const TraktIds({this.trakt, this.tmdb, this.tvdb, this.imdb, this.slug});

  factory TraktIds.fromJson(Object? value) {
    final json = _map(value);
    return TraktIds(
      trakt: _int(json?['trakt']),
      tmdb: _int(json?['tmdb']),
      tvdb: _int(json?['tvdb']),
      imdb: _string(json?['imdb']),
      slug: _string(json?['slug']),
    );
  }

  final int? trakt;
  final int? tmdb;
  final int? tvdb;
  final String? imdb;
  final String? slug;

  bool matches(TraktIds other) {
    if (trakt != null && other.trakt != null) return trakt == other.trakt;
    if (tmdb != null && other.tmdb != null) return tmdb == other.tmdb;
    if (tvdb != null && other.tvdb != null) return tvdb == other.tvdb;
    if (imdb != null && other.imdb != null) return imdb == other.imdb;
    return slug != null && other.slug != null && slug == other.slug;
  }
}

class TraktRootMedia {
  const TraktRootMedia({
    required this.type,
    required this.title,
    required this.ids,
    this.year,
    this.originalTitle,
    this.overview,
    this.rating,
    this.runtime,
    this.posterUrl,
    this.genres = const [],
  });

  final TraktMediaType type;
  final String title;
  final String? originalTitle;
  final int? year;
  final TraktIds ids;
  final String? overview;
  final double? rating;
  final int? runtime;
  final String? posterUrl;
  final List<String> genres;

  String get stableKey {
    if (ids.trakt case final int trakt) {
      return 'trakt:${type.apiName}:$trakt';
    }
    if (ids.tmdb case final int tmdb) return 'tmdb:${type.apiName}:$tmdb';
    return 'trakt:${type.apiName}:${ids.slug ?? title}';
  }
}

class TraktRecommendation {
  const TraktRecommendation({required this.rank, required this.media});

  final int rank;
  final TraktRootMedia media;
}

class TraktSeason {
  const TraktSeason({
    required this.number,
    required this.ids,
    required this.show,
    this.title,
    this.overview,
    this.episodeCount,
    this.rating,
    this.firstAired,
  });

  final int number;
  final String? title;
  final String? overview;
  final int? episodeCount;
  final double? rating;
  final DateTime? firstAired;
  final TraktIds ids;
  final TraktRootMedia show;
}

class TraktListItem {
  const TraktListItem({
    required this.rank,
    required this.type,
    required this.title,
    required this.ids,
    this.year,
    this.media,
    this.parentShow,
    this.seasonNumber,
    this.episodeNumber,
    this.notes,
  });

  /// The list owner's explicit order. It is not recomputed from release dates.
  final int rank;
  final TraktMediaType type;
  final String title;
  final int? year;
  final TraktIds ids;
  final TraktRootMedia? media;

  /// Present for season and episode rows, so they can be matched to a show.
  final TraktRootMedia? parentShow;
  final int? seasonNumber;
  final int? episodeNumber;
  final String? notes;

  bool represents(TraktRootMedia root) {
    if (type == root.type && ids.matches(root.ids)) return true;
    return root.type == TraktMediaType.show &&
        parentShow?.ids.matches(root.ids) == true;
  }
}

class TraktListCandidate {
  const TraktListCandidate({
    required this.listId,
    required this.name,
    required this.isOfficial,
    required this.score,
    this.ownerSlug,
    this.author,
    this.description,
    this.sourceUrl,
    this.likes = 0,
    this.itemCount = 0,
    this.items = const [],
  });

  final String listId;
  final String name;
  final String? ownerSlug;
  final String? author;
  final String? description;
  final String? sourceUrl;
  final bool isOfficial;
  final int likes;
  final int itemCount;
  final double score;

  /// Populated by [TraktDiscovery.findWatchOrderLists]. Keeping it on the
  /// candidate lets a selector open the chosen list without another request.
  final List<TraktListItem> items;

  String get stableKey => isOfficial
      ? 'trakt:list:official:$listId'
      : 'trakt:list:personal:${ownerSlug ?? 'unknown'}:$listId';

  String get displayName => name;

  TraktListCandidate withItems(List<TraktListItem> value) {
    return TraktListCandidate(
      listId: listId,
      name: name,
      ownerSlug: ownerSlug,
      author: author,
      description: description,
      sourceUrl: sourceUrl,
      isOfficial: isOfficial,
      likes: likes,
      itemCount: itemCount,
      score: score,
      items: List.unmodifiable(value),
    );
  }
}

int compareTraktListCandidates(
  TraktListCandidate first,
  TraktListCandidate second,
) {
  if (first.isOfficial != second.isOfficial) {
    return first.isOfficial ? -1 : 1;
  }
  final scoreComparison = second.score.compareTo(first.score);
  if (scoreComparison != 0) return scoreComparison;
  final likesComparison = second.likes.compareTo(first.likes);
  if (likesComparison != 0) return likesComparison;
  return first.listId.compareTo(second.listId);
}

class TraktDiscoveryException implements Exception {
  const TraktDiscoveryException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => statusCode == null
      ? 'TraktDiscoveryException: $message'
      : 'TraktDiscoveryException: $message (HTTP $statusCode)';
}

/// Public Trakt metadata only. No account or OAuth state is used here.
class TraktDiscovery {
  TraktDiscovery({
    TraktHttpGet? get,
    this.requestTimeout = const Duration(seconds: 12),
    this.maxRecommendations = 25,
    this.maxListCandidates = 9,
    this.maxListItems = 200,
    this.maxSeasons = 100,
  }) : _get = get ?? http.get;

  final TraktHttpGet _get;
  final Duration requestTimeout;
  final int maxRecommendations;
  final int maxListCandidates;
  final int maxListItems;
  final int maxSeasons;

  static const _headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'trakt-api-key': _traktClientId,
    'trakt-api-version': '2',
    'User-Agent': _traktUserAgent,
  };

  Future<TraktRootMedia?> resolveByTmdbId({
    required int tmdbId,
    required TraktMediaType type,
  }) async {
    _requireRootType(type);
    final rows = await _getList('/search/tmdb/$tmdbId', {
      'type': type.apiName,
      'extended': 'full,images',
    });
    for (final row in rows) {
      final media = _rootFromSearchRow(row, type);
      if (media?.ids.tmdb == tmdbId) return media;
    }
    return null;
  }

  Future<TraktRootMedia?> resolveByTraktId({
    required int traktId,
    required TraktMediaType type,
  }) async {
    _requireRootType(type);
    final rows = await _getList('/search/trakt/$traktId', {
      'type': type.apiName,
      'extended': 'full,images',
    });
    for (final row in rows) {
      final media = _rootFromSearchRow(row, type);
      if (media?.ids.trakt == traktId) return media;
    }
    return null;
  }

  Future<TraktRootMedia?> resolveByTitle({
    required String title,
    required TraktMediaType type,
    int? year,
  }) async {
    _requireRootType(type);
    final rows = await _getList('/search/${type.apiName}', {
      'query': _escapeSearchQuery(title),
      'fields': 'title,original_title,aliases,translations',
      'extended': 'full,images',
      'limit': '10',
      if (year != null) 'years': '$year',
    });
    final candidates = rows
        .map((row) => _rootFromSearchRow(row, type))
        .whereType<TraktRootMedia>()
        .where((media) => year == null || media.year == year)
        .toList();
    if (candidates.isEmpty) return null;

    final best = bestTitleMatch(title, [
      for (final media in candidates)
        [
          media.title,
          if (media.originalTitle case final String original) original,
        ],
    ]);
    return best == null ? null : candidates[best];
  }

  Future<List<TraktRecommendation>> fetchRecommendations(
    TraktRootMedia root, {
    int limit = 20,
  }) async {
    _requireRootType(root.type);
    final id = _rootIdentifier(root);
    final capped = _cap(limit, maxRecommendations);
    if (capped == 0) return const [];
    final plural = root.type == TraktMediaType.movie ? 'movies' : 'shows';
    final rows = await _getList('/$plural/$id/related', {
      'extended': 'full,images',
      'limit': '$capped',
    });

    final results = <TraktRecommendation>[];
    for (final row in rows) {
      final media = _rootFromPayload(_mediaPayload(row, root.type), root.type);
      if (media == null || media.ids.matches(root.ids)) continue;
      results.add(TraktRecommendation(rank: results.length + 1, media: media));
      if (results.length == capped) break;
    }
    return List.unmodifiable(results);
  }

  /// Finds relevant public lists and returns only lists that contain [root].
  ///
  /// Three narrow searches are safer than accepting a generic popular list.
  /// Candidates are capped before their items are loaded, and every accepted
  /// result carries those loaded items for the caller to reuse.
  Future<List<TraktListCandidate>> findWatchOrderLists(
    TraktRootMedia root, {
    int limit = 5,
  }) async {
    _requireRootType(root.type);
    final resultLimit = _cap(limit, maxListCandidates);
    if (resultLimit == 0) return const [];

    final perSearch = _cap(maxListCandidates, 10);
    final byKey = <String, TraktListCandidate>{};
    for (final phrase in const ['watch order', 'chronology', 'collection']) {
      final rows = await _getList('/search/list', {
        'query': '${_escapeSearchQuery(root.title)} $phrase',
        'fields': 'name,description',
        'extended': 'full',
        'limit': '$perSearch',
      });
      for (final row in rows) {
        final candidate = _listCandidate(row, root, phrase);
        if (candidate == null) continue;
        final previous = byKey[candidate.stableKey];
        if (previous == null || candidate.score > previous.score) {
          byKey[candidate.stableKey] = candidate;
        }
      }
    }

    final candidates = byKey.values.toList()..sort(compareTraktListCandidates);
    final accepted = <TraktListCandidate>[];
    final validationLimit = _cap(resultLimit + 2, maxListCandidates);
    for (final candidate in candidates.take(validationLimit)) {
      List<TraktListItem> items;
      try {
        items = await fetchListItems(candidate);
      } on TraktDiscoveryException catch (error) {
        // Public search can briefly retain a deleted or newly private list.
        // Skip only those stale candidates; network and server failures still
        // surface to the caller instead of looking like an empty result.
        if (error.statusCode == 403 || error.statusCode == 404) continue;
        rethrow;
      }
      if (items.length < 2) continue;
      if (!items.any((item) => item.represents(root))) continue;
      accepted.add(candidate.withItems(items));
      if (accepted.length == resultLimit) break;
    }
    return List.unmodifiable(accepted);
  }

  Future<List<TraktListItem>> fetchListItems(
    TraktListCandidate candidate, {
    int? limit,
  }) async {
    final capped = _cap(limit ?? maxListItems, maxListItems);
    if (capped == 0) return const [];
    final path = candidate.isOfficial
        ? '/lists/${candidate.listId}/items'
        : '/users/${candidate.ownerSlug}/lists/${candidate.listId}/items';
    final rows = await _getList(path, {
      'type': 'movie,show,season,episode',
      'extended': 'full,images',
      'page': '1',
      'limit': '$capped',
      'sort_by': 'rank',
      'sort_how': 'asc',
    });

    final items = <TraktListItem>[];
    for (var index = 0; index < rows.length && items.length < capped; index++) {
      final item = _listItem(rows[index], fallbackRank: index + 1);
      if (item != null) items.add(item);
    }
    return List.unmodifiable(items);
  }

  Future<List<TraktSeason>> fetchSeasons(
    TraktRootMedia show, {
    int? limit,
  }) async {
    if (show.type != TraktMediaType.show) {
      throw ArgumentError.value(show.type, 'show.type', 'must be show');
    }
    final capped = _cap(limit ?? maxSeasons, maxSeasons);
    if (capped == 0) return const [];
    final rows = await _getList('/shows/${_rootIdentifier(show)}/seasons', {
      'extended': 'full',
      'limit': '$capped',
    });
    final seasons = <TraktSeason>[];
    for (final row in rows) {
      final season = _season(row, show);
      if (season == null || season.number == 0) continue;
      seasons.add(season);
      if (seasons.length == capped) break;
    }
    seasons.sort((a, b) => a.number.compareTo(b.number));
    return List.unmodifiable(seasons);
  }

  Future<List<Map<String, dynamic>>> _getList(
    String path,
    Map<String, String> query,
  ) async {
    final uri = Uri.parse('$_traktBaseUrl$path')
        .replace(queryParameters: query.isEmpty ? null : query);
    http.Response response;
    try {
      response = await _get(uri, headers: _headers).timeout(requestTimeout);
    } on TimeoutException {
      throw TraktDiscoveryException(
        'Request timed out after ${requestTimeout.inSeconds} seconds',
      );
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw TraktDiscoveryException(
        'Trakt request failed',
        statusCode: response.statusCode,
      );
    }
    Object? decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw const TraktDiscoveryException('Trakt returned invalid JSON');
    }
    if (decoded is! List) {
      throw const TraktDiscoveryException('Trakt returned an unexpected body');
    }
    return decoded.whereType<Map<String, dynamic>>().toList();
  }
}

TraktRootMedia? _rootFromSearchRow(
  Map<String, dynamic> row,
  TraktMediaType expectedType,
) {
  final declared = _mediaType(_string(row['type']));
  if (declared != null && declared != expectedType) return null;
  return _rootFromPayload(_mediaPayload(row, expectedType), expectedType);
}

Map<String, dynamic>? _mediaPayload(
  Map<String, dynamic> row,
  TraktMediaType type,
) {
  return _map(row[type.apiName]) ?? row;
}

TraktRootMedia? _rootFromPayload(
  Map<String, dynamic>? json,
  TraktMediaType type,
) {
  if (json == null) return null;
  final title = _string(json['title']);
  if (title == null) return null;
  return TraktRootMedia(
    type: type,
    title: title,
    originalTitle: _string(json['original_title']),
    year: _int(json['year']),
    ids: TraktIds.fromJson(json['ids']),
    overview: _string(json['overview']),
    rating: _double(json['rating']),
    runtime: _int(json['runtime']),
    posterUrl: _firstImage(json['images'], 'poster'),
    genres: (json['genres'] as List?)?.whereType<String>().toList() ?? const [],
  );
}

TraktListCandidate? _listCandidate(
  Map<String, dynamic> row,
  TraktRootMedia root,
  String phrase,
) {
  final json = _map(row['list']) ?? row;
  final name = _string(json['name']);
  final ids = _map(json['ids']);
  final id = _string(ids?['trakt']) ?? _string(ids?['slug']);
  if (name == null || id == null) return null;

  final user = _map(json['user']);
  final userIds = _map(user?['ids']);
  final owner = _string(userIds?['slug']) ?? _string(user?['username']);
  final official = json['official'] == true || json['type'] == 'official';
  if (!official && owner == null) return null;

  final likes = _int(json['likes']) ?? 0;
  final itemCount = _int(json['item_count']) ?? 0;
  final author = _string(user?['name']) ?? _string(user?['username']);
  final searchText = normalizeTitle(
    '$name ${_string(json['description']) ?? ''}',
  );
  final normalizedTitle = normalizeTitle(root.title);
  final normalizedPhrase = normalizeTitle(phrase);
  final isVip = user?['vip'] == true || user?['vip_ep'] == true;
  final hasRootReference = searchText.contains(normalizedTitle);
  final hasTitleMatch = titleSimilarity(root.title, name) >= 0.5;
  final hasStrongOrderIntent = const [
    'watch order',
    'viewing order',
    'release order',
    'chronolog',
    'timeline',
  ].any(searchText.contains);
  final hasFranchiseScope =
      hasRootReference ||
      hasTitleMatch ||
      const ['franchise', 'universe', 'saga'].any(searchText.contains);
  final hasCredibleCollectionIntent =
      searchText.contains('collection') &&
      (hasRootReference || hasTitleMatch) &&
      (official || isVip || likes >= 10);
  final hasCredibleOrderIntent = hasStrongOrderIntent && hasFranchiseScope;

  // Containing the root title is necessary but not sufficient. A favorites
  // or mixed-media list can include the title without expressing any viewing
  // order. Strong ordering language also needs a title or franchise signal so
  // cross-franchise timelines remain eligible without admitting generic lists.
  // Looser collection language additionally needs a direct title match and a
  // credible owner signal.
  if (!hasCredibleOrderIntent && !hasCredibleCollectionIntent) return null;

  var score = _double(row['score']) ?? 0;
  if (official) score += 100;
  if (isVip) score += 20;
  if (hasRootReference) score += 35;
  if (searchText.contains(normalizedPhrase)) score += 25;
  if (searchText.contains('watch order')) score += 20;
  if (searchText.contains('chronolog')) score += 18;
  if (searchText.contains('franchise')) score += 12;
  if (itemCount >= 2 && itemCount <= 250) score += 10;
  if (itemCount > 500) score -= 25;
  score += likes.clamp(0, 1000) / 100;

  return TraktListCandidate(
    listId: id,
    name: name,
    ownerSlug: owner,
    author: author ?? (official ? 'Trakt' : null),
    description: _string(json['description']),
    sourceUrl:
        _string(json['share_link']) ??
        (official
            ? 'https://trakt.tv/lists/$id'
            : 'https://trakt.tv/users/$owner/lists/${_string(ids?['slug']) ?? id}'),
    isOfficial: official,
    likes: likes,
    itemCount: itemCount,
    score: score,
  );
}

TraktListItem? _listItem(
  Map<String, dynamic> row, {
  required int fallbackRank,
}) {
  final type = _listItemType(row);
  if (type == null) return null;
  final json = _map(row[type.apiName]);
  if (json == null) return null;
  final parentJson = _map(row['show']) ?? _map(json['show']);
  final parentShow = _rootFromPayload(parentJson, TraktMediaType.show);
  final rank = _int(row['rank']) ?? fallbackRank;

  switch (type) {
    case TraktMediaType.movie:
    case TraktMediaType.show:
      final media = _rootFromPayload(json, type);
      if (media == null) return null;
      return TraktListItem(
        rank: rank,
        type: type,
        title: media.title,
        year: media.year,
        ids: media.ids,
        media: media,
        notes: _string(row['notes']),
      );
    case TraktMediaType.season:
      final number = _int(json['number']);
      if (number == null) return null;
      return TraktListItem(
        rank: rank,
        type: type,
        title: _string(json['title']) ?? 'Season $number',
        ids: TraktIds.fromJson(json['ids']),
        parentShow: parentShow,
        seasonNumber: number,
        notes: _string(row['notes']),
      );
    case TraktMediaType.episode:
      final season = _int(json['season']);
      final number = _int(json['number']);
      if (season == null || number == null) return null;
      return TraktListItem(
        rank: rank,
        type: type,
        title: _string(json['title']) ?? 'S${season}E$number',
        ids: TraktIds.fromJson(json['ids']),
        parentShow: parentShow,
        seasonNumber: season,
        episodeNumber: number,
        notes: _string(row['notes']),
      );
  }
}

TraktSeason? _season(Map<String, dynamic> json, TraktRootMedia show) {
  final number = _int(json['number']);
  if (number == null) return null;
  return TraktSeason(
    number: number,
    title: _string(json['title']),
    overview: _string(json['overview']),
    episodeCount: _int(json['episode_count']),
    rating: _double(json['rating']),
    firstAired: DateTime.tryParse(_string(json['first_aired']) ?? ''),
    ids: TraktIds.fromJson(json['ids']),
    show: show,
  );
}

TraktMediaType? _listItemType(Map<String, dynamic> json) {
  // Season and episode rows also carry a `show` object identifying their
  // parent, so inspect the concrete child keys before the parent key.
  for (final type in const [
    TraktMediaType.episode,
    TraktMediaType.season,
    TraktMediaType.movie,
    TraktMediaType.show,
  ]) {
    if (json[type.apiName] is Map) return type;
  }
  return _mediaType(_string(json['type']));
}

TraktMediaType? _mediaType(String? value) {
  for (final type in TraktMediaType.values) {
    if (type.apiName == value) return type;
  }
  return null;
}

String _rootIdentifier(TraktRootMedia root) {
  final value = root.ids.trakt ?? root.ids.slug;
  if (value == null) {
    throw ArgumentError.value(root.ids, 'root.ids', 'needs a Trakt id or slug');
  }
  return '$value';
}

void _requireRootType(TraktMediaType type) {
  if (type != TraktMediaType.movie && type != TraktMediaType.show) {
    throw ArgumentError.value(type, 'type', 'must be movie or show');
  }
}

int _cap(int requested, int maximum) {
  if (requested <= 0 || maximum <= 0) return 0;
  return requested < maximum ? requested : maximum;
}

Map<String, dynamic>? _map(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return value.cast<String, dynamic>();
  return null;
}

String? _string(Object? value) {
  final string = value?.toString().trim();
  return string == null || string.isEmpty || string == 'null' ? null : string;
}

int? _int(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

double? _double(Object? value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '');
}

String? _firstImage(Object? images, String key) {
  final value = _map(images)?[key];
  if (value is String) return _absoluteImage(_string(value));
  if (value is List) {
    return _absoluteImage(value.whereType<String>().firstOrNull);
  }
  return null;
}

String? _absoluteImage(String? value) {
  if (value == null) return null;
  if (value.startsWith('//')) return 'https:$value';
  if (!value.contains('://')) return 'https://$value';
  return value;
}

String _escapeSearchQuery(String value) {
  const reserved = <String>{
    '+',
    '-',
    '&',
    '|',
    '!',
    '(',
    ')',
    '{',
    '}',
    '[',
    ']',
    '^',
    '"',
    '~',
    '*',
    '?',
    ':',
    '/',
    '\\',
  };
  final escaped = StringBuffer();
  for (final rune in value.runes) {
    final character = String.fromCharCode(rune);
    if (reserved.contains(character)) escaped.write(r'\');
    escaped.write(character);
  }
  return escaped.toString();
}
