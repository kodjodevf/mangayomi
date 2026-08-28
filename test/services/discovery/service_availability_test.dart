import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/discovery/service_availability.dart';
import 'package:mangayomi/services/anilist_discovery.dart';
import 'package:mangayomi/services/discovery/kitsu_discovery.dart';

/// AniList disabled their public API on 2026-08-22, answering every request
/// with a 403 and a sentence saying so. What the app did with that was report
/// "Request timed out", which is both wrong and unactionable.
void main() {
  setUp(ServiceAvailability.clearForTest);
  tearDown(ServiceAvailability.clearForTest);

  group('reading a refusal', () {
    // Captured from graphql.anilist.co, 2026-08-22.
    final disabled = jsonDecode('''
      {"errors":[{"message":"The AniList API has been temporarily disabled due to severe stability issues.","status":403}]}
    ''') as Map<String, dynamic>;

    test("passes on the service's own words rather than inventing any", () {
      expect(
        anilistRefusal(403, disabled),
        'The AniList API has been temporarily disabled due to severe stability issues.',
      );
    });

    test('still says something when the body explains nothing', () {
      expect(anilistRefusal(403, null), contains('403'));
      expect(anilistRefusal(503, null), contains('server trouble'));
    });

    test('a normal answer is not a refusal', () {
      expect(anilistRefusal(200, {'data': {}}), isNull);
      // A GraphQL error inside a 200 is a query problem, not the service
      // refusing, and must not put it on the naughty list.
      expect(anilistRefusal(200, disabled), isNull);
      expect(anilistRefusal(404, null), isNull);
    });
  });

  group('the cooldown', () {
    test('a refusal stops the next call before it is sent', () {
      expect(ServiceAvailability.isAvailable(DiscoveryService.anilist), true);

      ServiceAvailability.markDown(DiscoveryService.anilist, 'disabled');

      expect(ServiceAvailability.isAvailable(DiscoveryService.anilist), false);
      expect(
        ServiceAvailability.outage(DiscoveryService.anilist)!.reason,
        'disabled',
      );
    });

    test('it expires, so an outage is not permanent', () {
      ServiceAvailability.markDown(
        DiscoveryService.anilist,
        'disabled',
        cooldown: Duration.zero,
      );

      expect(ServiceAvailability.isAvailable(DiscoveryService.anilist), true);
    });

    test('one service being down says nothing about the other', () {
      ServiceAvailability.markDown(DiscoveryService.anilist, 'disabled');

      expect(ServiceAvailability.isAvailable(DiscoveryService.kitsu), true);
    });

    test('an answer clears it', () {
      ServiceAvailability.markDown(DiscoveryService.anilist, 'disabled');
      ServiceAvailability.markUp(DiscoveryService.anilist);

      expect(ServiceAvailability.isAvailable(DiscoveryService.anilist), true);
    });

    test('what it throws names the service and the reason', () {
      final outage = ServiceAvailability.markDown(
        DiscoveryService.anilist,
        'temporarily disabled',
      );

      expect(outage.toString(), contains('AniList'));
      expect(outage.toString(), contains('temporarily disabled'));
    });
  });

  group('losing the network', () {
    test('is not the same as a service refusing', () {
      // Otherwise a tunnel or a flaky wifi puts every service on the naughty
      // list for ten minutes.
      expect(
        isNetworkFailure(const SocketExceptionStub('Failed host lookup')),
        true,
      );
      expect(isNetworkFailure(StateError('nope')), false);
    });
  });

  group('the Kitsu fallback', () {
    // Captured from kitsu.io/api/edge, 2026-08-22.
    final relations = jsonDecode('''
      {"data":[{"id":"11","type":"mediaRelationships",
        "attributes":{"role":"side_story"},
        "relationships":{"destination":{"data":{"type":"anime","id":"2"}}}}],
       "included":[{"id":"2","type":"anime","attributes":{
        "canonicalTitle":"Cowboy Bebop: Knockin on Heavens Door",
        "titles":{"en":"Knockin on Heavens Door","en_jp":"Cowboy Bebop: Tengoku no Tobira"},
        "synopsis":"A bounty.","subtype":"movie","status":"finished",
        "episodeCount":1,"averageRating":"81.24","startDate":"2001-09-01",
        "posterImage":{"large":"https://example.test/p.jpg"}}}]}
    ''') as Map<String, dynamic>;

    test('stitches the relationship list back onto the media it points at', () {
      final parsed = kitsuRelationsFrom(relations);

      expect(parsed, hasLength(1));
      // Kitsu says side_story where AniList says SIDE_STORY, and the watch
      // order matches on the AniList spelling.
      expect(parsed.first.relationType, 'SIDE_STORY');
      expect(parsed.first.media.english, 'Knockin on Heavens Door');
    });

    test('what it produces is tagged as Kitsu, because the ids differ', () {
      final media = kitsuRelationsFrom(relations).first.media;

      expect(media.source, DiscoveryService.kitsu);
      expect(media.id, 2);
    });

    test('maps the fields the UI actually reads', () {
      final media = kitsuRelationsFrom(relations).first.media;

      expect(media.coverImage, 'https://example.test/p.jpg');
      expect(media.episodes, 1);
      expect(media.format, 'MOVIE');
      // Kitsu rates out of 100 as a decimal string; AniList uses a whole number.
      expect(media.averageScore, 81);
      expect(media.startYear, 2001);
      expect(media.startMonth, 9);
      expect(media.isAnime, true);
    });

    test('a body with no relations is empty, not a crash', () {
      expect(kitsuRelationsFrom(null), isEmpty);
      expect(kitsuRelationsFrom({'data': []}), isEmpty);
    });
  });

  group('an AniList media', () {
    test('is tagged as AniList without anyone having to say so', () {
      final media = DiscoveryMedia.fromJson({
        'id': 1,
        'title': {'romaji': 'Cowboy Bebop'},
        'type': 'ANIME',
      });

      expect(media.source, DiscoveryService.anilist);
    });
  });
}

/// Stands in for a SocketException without needing a real socket.
class SocketExceptionStub implements Exception {
  const SocketExceptionStub(this.message);
  final String message;
  @override
  String toString() => 'SocketException: $message';
}
