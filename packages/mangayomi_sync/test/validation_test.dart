import 'package:mangayomi_sync/mangayomi_sync.dart';
import 'package:test/test.dart';

void main() {
  Map<String, dynamic> manga({
    String link = '/title',
    String? imageUrl,
    String? description,
    List<String> genre = const [],
  }) => {
    'clientId': 1,
    'source': 'Demo',
    'link': link,
    'itemType': 'MANGA',
    'name': 'Title',
    'imageUrl': imageUrl,
    'description': description,
    'genre': genre,
    'updatedAt': 10,
  };

  Map<String, dynamic> request(Map<String, dynamic> row) => {
    'since': 0,
    'manga': [row],
  };

  group('validateSyncRequest', () {
    test('takes a manga whose link a source filled with its own data', () {
      // What the sync server refused in the field: one link over 2000
      // characters stopped every sync of the device.
      final link = '/manga?data=${'x' * 5000}';
      final valid = validateSyncRequest(request(manga(link: link)));
      expect(valid.rows['manga']!.single['link'], link);
    });

    test('still refuses a link past its limit, naming the row', () {
      expect(
        () => validateSyncRequest(request(manga(link: 'x' * 70000))),
        throwsA(
          isA<SyncRequestInvalid>().having(
            (e) => e.message,
            'message',
            'manga[0].link',
          ),
        ),
      );
    });

    test('still refuses a description past its limit', () {
      expect(
        () => validateSyncRequest(request(manga(description: 'x' * 10001))),
        throwsA(isA<SyncRequestInvalid>()),
      );
    });
  });

  group('fitSyncRow', () {
    test('leaves a row that fits as it is', () {
      final row = manga(description: 'Short');
      final fitted = fitSyncRow('manga', row);
      expect(fitted.tooLong, isNull);
      expect(identical(fitted.row, row), isTrue);
    });

    test('shortens text that is only shown, and the request then passes', () {
      final row = manga(description: 'x' * 12000, genre: ['g' * 150, 'ok']);
      final fitted = fitSyncRow('manga', row);
      expect(fitted.tooLong, isNull);
      expect((fitted.row!['description'] as String).length, 10000);
      expect(fitted.row!['genre'], ['g' * 100, 'ok']);
      // The device's own row is not changed.
      expect((row['description'] as String).length, 12000);
      expect(() => validateSyncRequest(request(fitted.row!)), returnsNormally);
    });

    test('never cuts a character in two', () {
      final text = '${'x' * 9999}😀';
      final fitted = fitSyncRow('manga', manga(description: '${text}more'));
      expect(fitted.row!['description'], 'x' * 9999);
    });

    test('leaves out a cover address over its limit', () {
      final fitted = fitSyncRow('manga', manga(imageUrl: 'x' * 70000));
      expect(fitted.tooLong, isNull);
      expect(fitted.row!['imageUrl'], isNull);
      expect(fitted.row!['link'], '/title');
    });

    test('leaves out a tracking address that is not a web address', () {
      final fitted = fitSyncRow('tracks', {
        'clientId': 1,
        'mangaClientId': 2,
        'status': 'READING',
        'itemType': 'MANGA',
        'trackingUrl': 'javascript:alert(1)',
        'updatedAt': 10,
      });
      expect(fitted.row!['trackingUrl'], isNull);
    });

    test('cannot fit a link: it names the field instead', () {
      final fitted = fitSyncRow('manga', manga(link: 'x' * 70000));
      expect(fitted.row, isNull);
      expect(fitted.tooLong, 'link');
    });

    test('cannot fit a chapter url either', () {
      final fitted = fitSyncRow('chapters', {
        'clientId': 1,
        'mangaClientId': 2,
        'url': 'x' * 70000,
        'updatedAt': 10,
      });
      expect(fitted.tooLong, 'url');
    });
  });
}
