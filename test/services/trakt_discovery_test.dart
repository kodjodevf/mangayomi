import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mangayomi/services/discovery/trakt_discovery.dart';

http.Response _json(Object body, {int status = 200}) {
  return http.Response(
    jsonEncode(body),
    status,
    headers: const {'content-type': 'application/json'},
  );
}

Map<String, Object?> _show(
  String title,
  int trakt,
  int tmdb,
  int year, {
  String? originalTitle,
}) {
  return {
    'title': title,
    'original_title': originalTitle,
    'year': year,
    'overview': '$title overview',
    'rating': 8.75,
    'ids': {'trakt': trakt, 'tmdb': tmdb, 'slug': title.toLowerCase()},
  };
}

Map<String, Object?> _movie(String title, int trakt, int tmdb, int year) {
  return {
    'title': title,
    'year': year,
    'ids': {'trakt': trakt, 'tmdb': tmdb, 'slug': title.toLowerCase()},
  };
}

void main() {
  group('media resolution', () {
    test(
      'resolves an exact TMDB id and kind with public API headers',
      () async {
        late Uri requested;
        late Map<String, String> requestHeaders;
        final discovery = TraktDiscovery(
          get: (uri, {headers}) async {
            requested = uri;
            requestHeaders = Map.of(headers ?? const {});
            return _json([
              {'type': 'movie', 'movie': _movie('Wrong kind', 1, 1396, 2010)},
              {'type': 'show', 'show': _show('Breaking Bad', 1388, 1396, 2008)},
            ]);
          },
        );

        final result = await discovery.resolveByTmdbId(
          tmdbId: 1396,
          type: TraktMediaType.show,
        );

        expect(result?.title, 'Breaking Bad');
        expect(result?.ids.trakt, 1388);
        expect(result?.stableKey, 'trakt:show:1388');
        expect(requested.path, '/search/tmdb/1396');
        expect(requested.queryParameters['type'], 'show');
        expect(requestHeaders['trakt-api-version'], '2');
        expect(requestHeaders['trakt-api-key'], isNotEmpty);
      },
    );

    test('uses title similarity inside an exact year and kind', () async {
      late Uri requested;
      final discovery = TraktDiscovery(
        get: (uri, {headers}) async {
          requested = uri;
          return _json([
            {'type': 'show', 'show': _show('Friends Reunion', 2, 2, 1994)},
            {
              'type': 'show',
              'show': _show(
                'Friends',
                3,
                1668,
                1994,
                originalTitle: 'Friends (US)',
              ),
            },
            {'type': 'show', 'show': _show('Friends', 4, 4, 2021)},
          ]);
        },
      );

      final result = await discovery.resolveByTitle(
        title: 'Friends',
        year: 1994,
        type: TraktMediaType.show,
      );

      expect(result?.ids.tmdb, 1668);
      expect(requested.path, '/search/show');
      expect(requested.queryParameters['query'], 'Friends');
      expect(requested.queryParameters['years'], '1994');
    });

    test('does not accept a title from the wrong year', () async {
      final discovery = TraktDiscovery(
        get: (uri, {headers}) async => _json([
          {'type': 'show', 'show': _show('Friends', 4, 4, 2021)},
        ]),
      );

      final result = await discovery.resolveByTitle(
        title: 'Friends',
        year: 1994,
        type: TraktMediaType.show,
      );

      expect(result, isNull);
    });
  });

  test('related recommendations stay separate and respect the cap', () async {
    late Uri requested;
    final discovery = TraktDiscovery(
      maxRecommendations: 2,
      get: (uri, {headers}) async {
        requested = uri;
        return _json([
          _show('Breaking Bad', 1388, 1396, 2008),
          _show('Better Call Saul', 922, 60059, 2015),
          _show('The Wire', 1395, 1438, 2002),
          _show('Ozark', 2000, 69740, 2017),
        ]);
      },
    );
    const root = TraktRootMedia(
      type: TraktMediaType.show,
      title: 'Breaking Bad',
      year: 2008,
      ids: TraktIds(trakt: 1388, tmdb: 1396),
    );

    final results = await discovery.fetchRecommendations(root, limit: 50);

    expect(results.map((entry) => entry.media.title), [
      'Better Call Saul',
      'The Wire',
    ]);
    expect(results.map((entry) => entry.rank), [1, 2]);
    expect(requested.path, '/shows/1388/related');
    expect(requested.queryParameters['limit'], '2');
  });

  group('public watch-order lists', () {
    test('loads official and personal routes, validates the root, and preserves ranks', () async {
      final requestedPaths = <String>[];
      final discovery = TraktDiscovery(
        get: (uri, {headers}) async {
          requestedPaths.add(uri.path);
          if (uri.path == '/search/list') {
            return _json([
              {
                'type': 'list',
                'score': 1,
                'list': {
                  'name': 'Breaking Bad Universe Watch Order',
                  'description': 'The complete chronology',
                  'official': true,
                  'share_link': 'https://trakt.tv/lists/90',
                  'likes': 20,
                  'item_count': 4,
                  'ids': {'trakt': 90, 'slug': 'breaking-bad-universe'},
                },
              },
              {
                'type': 'list',
                'score': 5000,
                'list': {
                  'name': 'Breaking Bad Chronology',
                  'description': 'Community watch order',
                  'likes': 500,
                  'item_count': 2,
                  'ids': {'trakt': 12, 'slug': 'bb-order'},
                  'user': {
                    'name': 'Alice',
                    'username': 'alice',
                    'vip': true,
                    'ids': {'slug': 'alice'},
                  },
                },
              },
              {
                'type': 'list',
                'score': 9,
                'list': {
                  'name': 'Breaking Bad Watch Order',
                  'description': 'Does not actually include the show',
                  'likes': 5,
                  'item_count': 1,
                  'ids': {'trakt': 13, 'slug': 'bad-list'},
                  'user': {
                    'username': 'bob',
                    'ids': {'slug': 'bob'},
                  },
                },
              },
              {
                'type': 'list',
                'score': 8,
                'list': {
                  'name': 'AMC Universe Chronology',
                  'description': 'A cross-franchise timeline',
                  'likes': 30,
                  'item_count': 2,
                  'ids': {'trakt': 15, 'slug': 'amc-universe'},
                  'user': {
                    'name': 'Dave',
                    'username': 'dave',
                    'ids': {'slug': 'dave'},
                  },
                },
              },
              {
                'type': 'list',
                'score': 999,
                'list': {
                  'name': 'Weekend Favorites',
                  'description': 'Everything I liked, including Breaking Bad',
                  'likes': 1000,
                  'item_count': 20,
                  'ids': {'trakt': 14, 'slug': 'weekend-favorites'},
                  'user': {
                    'username': 'charlie',
                    'vip': true,
                    'ids': {'slug': 'charlie'},
                  },
                },
              },
            ]);
          }
          if (uri.path == '/lists/90/items') {
            expect(uri.queryParameters['type'], 'movie,show,season,episode');
            expect(uri.queryParameters['page'], '1');
            expect(uri.queryParameters['limit'], '200');
            expect(uri.queryParameters['sort_by'], 'rank');
            expect(uri.queryParameters['sort_how'], 'asc');
            return _json([
              {'rank': 10, 'show': _show('Better Call Saul', 922, 60059, 2015)},
              {
                'rank': 20,
                'season': {
                  'number': 1,
                  'title': 'Season One',
                  'ids': {'trakt': 2101},
                },
                'show': _show('Breaking Bad', 1388, 1396, 2008),
              },
              {
                'rank': 30,
                'episode': {
                  'season': 2,
                  'number': 13,
                  'title': 'ABQ',
                  'ids': {'trakt': 3001},
                },
                'show': _show('Breaking Bad', 1388, 1396, 2008),
              },
              {'rank': 40, 'movie': _movie('El Camino', 100, 559969, 2019)},
            ]);
          }
          if (uri.path == '/users/alice/lists/12/items') {
            return _json([
              {'rank': 7, 'show': _show('Breaking Bad', 1388, 1396, 2008)},
              {'rank': 11, 'movie': _movie('El Camino', 100, 559969, 2019)},
            ]);
          }
          if (uri.path == '/users/bob/lists/13/items') {
            return _json([
              {'rank': 1, 'show': _show('The Wire', 1395, 1438, 2002)},
              {'rank': 2, 'show': _show('Ozark', 2000, 69740, 2017)},
            ]);
          }
          if (uri.path == '/users/dave/lists/15/items') {
            return _json([
              {'rank': 1, 'show': _show('Breaking Bad', 1388, 1396, 2008)},
              {'rank': 2, 'movie': _movie('El Camino', 100, 559969, 2019)},
            ]);
          }
          fail('Unexpected request: $uri');
        },
      );
      const root = TraktRootMedia(
        type: TraktMediaType.show,
        title: 'Breaking Bad',
        year: 2008,
        ids: TraktIds(trakt: 1388, tmdb: 1396),
      );

      final results = await discovery.findWatchOrderLists(root, limit: 3);

      expect(results, hasLength(3));
      expect(results.first.isOfficial, isTrue);
      expect(results.first.author, 'Trakt');
      expect(results.first.sourceUrl, 'https://trakt.tv/lists/90');
      expect(results.first.stableKey, 'trakt:list:official:90');
      expect(results.first.items.map((item) => item.rank), [10, 20, 30, 40]);
      expect(results.first.items.map((item) => item.type), [
        TraktMediaType.show,
        TraktMediaType.season,
        TraktMediaType.episode,
        TraktMediaType.movie,
      ]);
      expect(results.first.items[1].parentShow?.ids.trakt, 1388);
      expect(results.first.items[2].seasonNumber, 2);
      expect(results.first.items[2].episodeNumber, 13);

      final personal = results.singleWhere(
        (candidate) => candidate.listId == '12',
      );
      expect(personal.author, 'Alice');
      expect(personal.stableKey, 'trakt:list:personal:alice:12');
      expect(personal.items.map((item) => item.rank), [7, 11]);

      final crossFranchise = results.singleWhere(
        (candidate) => candidate.listId == '15',
      );
      expect(crossFranchise.name, 'AMC Universe Chronology');
      expect(crossFranchise.items.first.represents(root), isTrue);

      expect(
        requestedPaths.where((path) => path == '/search/list'),
        hasLength(3),
      );
      expect(requestedPaths, contains('/lists/90/items'));
      expect(requestedPaths, contains('/users/alice/lists/12/items'));
      expect(requestedPaths, contains('/users/bob/lists/13/items'));
      expect(requestedPaths, contains('/users/dave/lists/15/items'));
      expect(requestedPaths, isNot(contains('/users/charlie/lists/14/items')));
    });
  });

  test('escapes Trakt search operators in titles and list queries', () async {
    final queries = <String>[];
    final discovery = TraktDiscovery(
      get: (uri, {headers}) async {
        queries.add(uri.queryParameters['query'] ?? '');
        return _json([]);
      },
    );

    await discovery.resolveByTitle(
      title: 'Mission: Impossible',
      type: TraktMediaType.movie,
    );
    await discovery.findWatchOrderLists(
      const TraktRootMedia(
        type: TraktMediaType.movie,
        title: 'Spider-Man',
        ids: TraktIds(trakt: 1),
      ),
    );

    expect(queries.first, r'Mission\: Impossible');
    expect(queries.skip(1), contains(r'Spider\-Man watch order'));
  });

  test(
    'show seasons omit specials, sort by number, and retain parent identity',
    () async {
      late Uri requested;
      final discovery = TraktDiscovery(
        maxSeasons: 2,
        get: (uri, {headers}) async {
          requested = uri;
          return _json([
            {
              'number': 0,
              'title': 'Specials',
              'episode_count': 10,
              'ids': {'trakt': 1},
            },
            {
              'number': 2,
              'title': 'Season 2',
              'episode_count': 13,
              'ids': {'trakt': 2},
            },
            {
              'number': 1,
              'title': 'Season 1',
              'episode_count': 7,
              'ids': {'trakt': 3},
            },
          ]);
        },
      );
      const show = TraktRootMedia(
        type: TraktMediaType.show,
        title: 'Breaking Bad',
        ids: TraktIds(trakt: 1388, tmdb: 1396),
      );

      final seasons = await discovery.fetchSeasons(show, limit: 20);

      expect(seasons.map((season) => season.number), [1, 2]);
      expect(seasons.every((season) => identical(season.show, show)), isTrue);
      expect(requested.path, '/shows/1388/seasons');
      expect(requested.queryParameters['limit'], '2');
    },
  );

  group('bounded failures', () {
    test('times out through the injectable transport', () async {
      final pending = Completer<http.Response>();
      final discovery = TraktDiscovery(
        requestTimeout: const Duration(milliseconds: 1),
        get: (uri, {headers}) => pending.future,
      );

      await expectLater(
        discovery.resolveByTmdbId(tmdbId: 1396, type: TraktMediaType.show),
        throwsA(isA<TraktDiscoveryException>()),
      );
    });

    test('reports HTTP failures without attempting to parse them', () async {
      final discovery = TraktDiscovery(
        get: (uri, {headers}) async => _json({'error': 'down'}, status: 503),
      );

      await expectLater(
        discovery.resolveByTmdbId(tmdbId: 1396, type: TraktMediaType.show),
        throwsA(
          isA<TraktDiscoveryException>().having(
            (error) => error.statusCode,
            'statusCode',
            503,
          ),
        ),
      );
    });
  });
}
