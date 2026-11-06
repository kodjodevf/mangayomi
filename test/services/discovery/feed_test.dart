import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/services/anilist_discovery.dart';
import 'package:mangayomi/services/discovery/service_availability.dart';

void main() {
  setUp(ServiceAvailability.clearForTest);
  for (final otherWriter in [
    'success',
    'shorter refusal',
    'longer refusal then success',
  ]) {
    test('shared 429 survives another consumer: $otherWriter', () async {
      var requests = 0;
      final client = MockClient((_) async {
        requests++;
        return http.Response(
          '{"errors":[{"message":"Rate limited"}]}',
          429,
          headers: {'retry-after': '120'},
        );
      });
      await http.runWithClient(() async {
        await expectLater(
          fetchDiscoveryFeed(itemType: ItemType.manga),
          throwsA(isA<DiscoveryUnavailable>()),
        );
        final original = ServiceAvailability.outage(DiscoveryService.anilist)!;
        // Use the same shared-state API as an in-flight tracker response.
        if (otherWriter == 'success') {
          ServiceAvailability.markUp(DiscoveryService.anilist);
        } else if (otherWriter == 'shorter refusal') {
          ServiceAvailability.markDown(
            DiscoveryService.anilist,
            'late timeout',
            cooldown: Duration.zero,
          );
        } else {
          ServiceAvailability.markDown(
            DiscoveryService.anilist,
            'server trouble',
            cooldown: const Duration(minutes: 5),
          );
          ServiceAvailability.markUp(DiscoveryService.anilist);
        }
        await expectLater(
          fetchDiscoveryFeed(itemType: ItemType.manga),
          throwsA(isA<DiscoveryUnavailable>()),
        );
        expect(
          requests,
          1,
          reason: 'No consumer can erase or shorten Retry-After',
        );
        final current = ServiceAvailability.outage(DiscoveryService.anilist)!;
        expect(current.retryAfter!.isBefore(original.retryAfter!), isFalse);
      }, () => client);
    });
  }

  for (final popular in [false, true]) {
    test(
      'anime shelf uses ANIME without novel filters, popular=$popular',
      () async {
        final client = MockClient((request) async {
          final body = jsonDecode(request.body);
          expect(body['query'], contains('type: ANIME'));
          expect(body['query'], isNot(contains('format_in')));
          expect(body['query'], isNot(contains('format_not_in')));
          expect(body['query'], contains('isAdult: false'));
          expect(body['variables']['sort'], [
            popular ? 'POPULARITY_DESC' : 'TRENDING_DESC',
          ]);
          return http.Response(
            '{"data":{"Page":{"media":[{"id":1,"type":"ANIME","format":"TV","episodes":12,"title":{"romaji":"Anime title"}}]}}}',
            200,
          );
        });
        final works = await http.runWithClient(
          () => fetchDiscoveryFeed(itemType: ItemType.anime, popular: popular),
          () => client,
        );
        expect(works.single.isAnime, isTrue);
        expect(works.single.episodes, 12);
      },
    );
  }

  for (final type in [ItemType.manga, ItemType.novel]) {
    for (final popular in [false, true]) {
      test('catalog isolates $type and popular=$popular', () async {
        final client = MockClient((request) async {
          final body = jsonDecode(request.body);
          expect(
            body['query'],
            contains(
              type == ItemType.novel
                  ? 'format_in: [NOVEL]'
                  : 'format_not_in: [NOVEL]',
            ),
          );
          expect(body['query'], isNot(contains('isAdult: false')));
          expect(body['variables']['sort'], [
            popular ? 'POPULARITY_DESC' : 'TRENDING_DESC',
          ]);
          return http.Response('{"data":{"Page":{"media":[]}}}', 200);
        });
        expect(
          await http.runWithClient(
            () => fetchDiscoveryFeed(
              itemType: type,
              popular: popular,
              includeAdult: true,
            ),
            () => client,
          ),
          isEmpty,
        );
      });
    }
  }
  for (final body in [
    '{"data":null}',
    '{"errors":[{"message":"Unavailable"}]}',
    '<html>bad gateway</html>',
  ]) {
    test(
      'invalid catalog is an error rather than an empty shelf: $body',
      () async {
        await http.runWithClient(() async {
          await expectLater(
            fetchDiscoveryFeed(itemType: ItemType.manga),
            throwsException,
          );
        }, () => MockClient((_) async => http.Response(body, 200)));
      },
    );
  }

  test(
    'late success cannot clear concurrent 429 cooldown before retry',
    () async {
      final refusedResponse = Completer<http.Response>();
      final lateResponse = Completer<http.Response>();
      final bothStarted = Completer<void>();
      var requests = 0;
      final client = MockClient((_) {
        requests++;
        if (requests == 1) return refusedResponse.future;
        if (requests == 2) {
          bothStarted.complete();
          return lateResponse.future;
        }
        return Future.value(
          http.Response('{"data":{"Page":{"media":[]}}}', 200),
        );
      });
      await http.runWithClient(() async {
        final refusal = expectLater(
          fetchDiscoveryFeed(itemType: ItemType.manga),
          throwsA(isA<DiscoveryUnavailable>()),
        );
        final lateSuccess = fetchDiscoveryFeed(
          itemType: ItemType.manga,
          popular: true,
        );
        await bothStarted.future;
        refusedResponse.complete(
          http.Response(
            '{"errors":[{"message":"Too Many Requests"}]}',
            429,
            headers: {'retry-after': '120'},
          ),
        );
        await refusal;
        final cooldown = ServiceAvailability.outage(DiscoveryService.anilist);
        expect(cooldown, isNotNull);
        lateResponse.complete(
          http.Response('{"data":{"Page":{"media":[]}}}', 200),
        );
        expect(await lateSuccess, isEmpty);
        Object? retryError;
        try {
          await fetchDiscoveryFeed(itemType: ItemType.manga);
        } catch (error) {
          retryError = error;
        }
        expect(
          requests,
          2,
          reason: 'Retry must not issue HTTP before Retry-After',
        );
        expect(retryError, same(cooldown));
        expect(
          ServiceAvailability.outage(DiscoveryService.anilist),
          same(cooldown),
        );
      }, () => client);
    },
  );

  test(
    '429 respects Retry-After and prevents immediate repeated requests',
    () async {
      var requests = 0;
      final client = MockClient((_) async {
        requests++;
        return http.Response(
          '{"errors":[{"message":"Too Many Requests"}]}',
          429,
          headers: {'retry-after': '120'},
        );
      });
      await http.runWithClient(() async {
        for (var attempt = 0; attempt < 2; attempt++) {
          await expectLater(
            fetchDiscoveryFeed(itemType: ItemType.manga),
            throwsA(isA<DiscoveryUnavailable>()),
          );
        }
      }, () => client);
      expect(requests, 1);
      expect(
        ServiceAvailability.outage(DiscoveryService.anilist)!.retryAfter!
            .difference(DateTime.now())
            .inSeconds,
        inInclusiveRange(115, 120),
      );
    },
  );

  test(
    'public trending novels include details, exclude adult and need no login',
    () async {
      final client = MockClient((request) async {
        expect(request.headers.containsKey('authorization'), isFalse);
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        final query = body['query'] as String;
        expect(query, contains('format_in: [NOVEL]'));
        expect(query, contains('isAdult: false'));
        expect(query, contains('description(asHtml: false)'));
        expect(body['variables']['sort'], ['TRENDING_DESC']);
        return http.Response(
          jsonEncode({
            'data': {
              'Page': {
                'media': [
                  {
                    'id': 1,
                    'title': {'romaji': 'Novel'},
                    'format': 'NOVEL',
                    'description': 'Synopsis',
                    'genres': ['Fantasy'],
                  },
                ],
              },
            },
          }),
          200,
        );
      });
      final works = await http.runWithClient(
        () => fetchDiscoveryFeed(itemType: ItemType.novel),
        () => client,
      );
      expect(works.single.title, 'Novel');
      expect(works.single.description, 'Synopsis');
      expect(works.single.genres, ['Fantasy']);
    },
  );
}
