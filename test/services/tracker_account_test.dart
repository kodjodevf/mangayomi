import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/trackers/tracker_account.dart';

/// Every service answers "who am I" in its own shape, and before this the app
/// kept one string per login and called it `username`. On MyAnimeList that was
/// a name; on AniList, Simkl and Kitsu it was a numeric id. Nothing showed it,
/// so the mismatch went unnoticed until chiaki.site's sequel lookup, which is
/// given `user=` and matches by handle, was handed an AniList id.
void main() {
  group('AniList', () {
    test('keeps the id and the name apart', () {
      final viewer = jsonDecode('''
        {
          "id": 123456,
          "name": "RyanYuuki",
          "avatar": {"large": "https://s4.anilist.co/file/avatar/123456.png"},
          "mediaListOptions": {"scoreFormat": "POINT_10"}
        }
      ''') as Map<String, dynamic>;

      final account = anilistAccount(viewer);

      // The id stays a string because two queries parse it back with
      // int.parse, and it must survive that round trip.
      expect(account.id, '123456');
      expect(int.parse(account.id), 123456);
      expect(account.name, 'RyanYuuki');
      expect(account.avatarUrl, endsWith('123456.png'));
    });

    test('survives an account with no avatar set', () {
      final account = anilistAccount({
        'id': 7,
        'name': 'someone',
        'avatar': null,
      });

      expect(account.id, '7');
      expect(account.name, 'someone');
      expect(account.avatarUrl, isNull);
    });
  });

  group('MyAnimeList', () {
    test('is the one service where the id is the name', () {
      final account = malAccount({
        'id': 999,
        'name': 'someone',
        'picture': 'https://api-cdn.myanimelist.net/images/userimages/1.jpg',
      });

      expect(account.id, 'someone');
      expect(account.name, 'someone');
      expect(account.avatarUrl, contains('userimages'));
    });

    test('reads no picture as no picture rather than an empty URL', () {
      // An empty string here would be handed to an image provider and drawn
      // as a broken image.
      expect(malAccount({'name': 'someone', 'picture': ''}).avatarUrl, isNull);
      expect(malAccount({'name': 'someone'}).avatarUrl, isNull);
    });
  });

  group('Simkl', () {
    test('takes the id from account and the name from user', () {
      final settings = jsonDecode('''
        {
          "user": {
            "name": "Someone",
            "joined_at": "2020-01-01T00:00:00Z",
            "avatar": "https://simkl.in/avatars/1_male.jpg"
          },
          "account": {"id": 4242, "timezone": "Europe/Paris", "type": "free"}
        }
      ''') as Map<String, dynamic>;

      final account = simklAccount(settings);

      expect(account.id, '4242');
      expect(account.name, 'Someone');
      expect(account.avatarUrl, contains('simkl.in'));
    });

    test('still logs in when the user block is missing', () {
      final account = simklAccount({
        'account': {'id': 1},
      });

      expect(account.id, '1');
      expect(account.name, isNull);
    });
  });

  group('Kitsu', () {
    test('falls back to the slug, which is readable, not the numeric id', () {
      final account = kitsuAccount({
        'id': '55555',
        'attributes': {
          'slug': 'some-one',
          'name': null,
          'ratingSystem': 'simple',
          'avatar': {'original': 'https://media.kitsu.io/users/avatars/1.png'},
        },
      });

      expect(account.id, '55555');
      expect(account.name, 'some-one');
      expect(account.avatarUrl, contains('kitsu.io'));
    });

    test('prefers the name when there is one', () {
      final account = kitsuAccount({
        'id': '1',
        'attributes': {'slug': 'some-one', 'name': 'Some One'},
      });

      expect(account.name, 'Some One');
      expect(account.avatarUrl, isNull);
    });
  });

  test('no service reports an id it cannot give back', () {
    // The stored id is what the service's own API is called with, so an empty
    // one would silently break every later request rather than the login.
    final accounts = [
      anilistAccount({'id': 1, 'name': 'a'}),
      malAccount({'name': 'b'}),
      simklAccount({
        'account': {'id': 2},
      }),
      kitsuAccount({
        'id': '3',
        'attributes': {'slug': 'c'},
      }),
    ];

    for (final account in accounts) {
      expect(account.id, isNotEmpty);
    }
  });
}
