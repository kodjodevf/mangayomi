import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/services/anilist_discovery.dart';
import 'package:mangayomi/services/discovery/media_lookup_context.dart';
import 'package:mangayomi/services/discovery/trakt_discovery.dart';
import 'package:mangayomi/services/recommendation.dart';

http.Response _json(Object body) => http.Response(jsonEncode(body), 200);

void main() {
  test(
    'western recommendations resolve an exact TMDB show through Trakt',
    () async {
      final requested = <Uri>[];
      final discovery = TraktDiscovery(
        get: (uri, {headers}) async {
          requested.add(uri);
          if (uri.path == '/search/tmdb/1396') {
            return _json([
              {
                'type': 'show',
                'show': {
                  'title': 'Breaking Bad',
                  'year': 2008,
                  'ids': {'trakt': 1388, 'tmdb': 1396},
                },
              },
            ]);
          }
          if (uri.path == '/shows/1388/related') {
            return _json([
              {
                'title': 'Better Call Saul',
                'year': 2015,
                'rating': 8.6,
                'overview': 'A lawyer before he was Saul Goodman.',
                'genres': ['drama', 'crime'],
                'images': {
                  'poster': ['media.trakt.tv/better-call-saul.webp'],
                },
                'ids': {'trakt': 922, 'tmdb': 60059},
              },
              {
                'title': 'El Camino',
                'year': 2019,
                'ids': {'trakt': 100, 'tmdb': 559969},
              },
            ]);
          }
          fail('Unexpected request: $uri');
        },
      );

      final results = await getRecommendations(
        const MediaLookupContext(
          title: 'Breaking Bad',
          itemType: ItemType.anime,
          kind: MediaKind.show,
          catalog: DiscoveryCatalog.trakt,
          tmdbId: 1396,
        ),
        AlgorithmWeights(),
        trakt: discovery,
      );

      expect(requested.map((uri) => uri.path), [
        '/search/tmdb/1396',
        '/shows/1388/related',
      ]);
      expect(results.map((result) => result.title), [
        'Better Call Saul',
        'El Camino',
      ]);
      expect(results.first.rating?.valueLabel, '8.6/10');
      expect(results.last.rating, isNull);
      expect(results.first.searchTarget.query, 'Better Call Saul');
      expect(results.first.searchTarget.itemType, ItemType.anime);
      expect(results.first.kind, MediaKind.show);
      expect(results.first.genres, ['drama', 'crime']);
      expect(results.first.imgURLs, [
        'https://media.trakt.tv/better-call-saul.webp',
      ]);
    },
  );

  test('AniList mapping preserves its scale and hides a missing rating', () {
    final rated = RecommendationResult.fromDiscovery(
      DiscoveryMedia(
        id: 1,
        english: 'Death Note',
        averageScore: 84,
        type: 'ANIME',
      ),
      itemType: ItemType.anime,
    );
    final unrated = RecommendationResult.fromDiscovery(
      DiscoveryMedia(id: 2, english: 'Monster', type: 'ANIME'),
      itemType: ItemType.anime,
    );

    expect(rated.rating?.valueLabel, '84%');
    expect(unrated.rating, isNull);
    expect(rated.searchTarget.query, 'Death Note');
    expect(rated.searchTarget.itemType, ItemType.anime);
    expect(rated.kind, MediaKind.anime);
  });
}
