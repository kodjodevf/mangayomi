import 'package:flutter_test/flutter_test.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';

void main() {
  group('Dalvik network safety tests', () {
    test('fetchFilterListDalvik gracefully handles 500 and Map error response without throwing', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          '{"error": "Internal Server Error", "status": 500}',
          500,
          headers: {'content-type': 'application/json'},
        );
      });
      final intercepted = InterceptedClient.build(
        interceptors: [],
        client: mockClient,
      );

      final source = Source()
        ..id = 123
        ..itemType = ItemType.manga
        ..sourceCode = 'dummy'
        ..lang = 'fr';

      final filterList = await fetchFilterListDalvik(
        intercepted,
        source,
        'http://127.0.0.1:57467',
      );
      expect(filterList, isNull);
    });

    test('fetchHeadersDalvik gracefully handles 500 error response without throwing', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          '{"error": "Failed to get headers", "status": 500}',
          500,
          headers: {'content-type': 'application/json'},
        );
      });
      final intercepted = InterceptedClient.build(
        interceptors: [],
        client: mockClient,
      );

      final source = Source()
        ..id = 123
        ..itemType = ItemType.manga
        ..sourceCode = 'dummy'
        ..lang = 'fr';

      final headers = await fetchHeadersDalvik(
        intercepted,
        source,
        'http://127.0.0.1:57467',
      );
      expect(headers, isEmpty);
    });

    test('fetchPreferencesDalvik gracefully handles 500 error response without throwing', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          '{"error": "Failed to get preferences", "status": 500}',
          500,
          headers: {'content-type': 'application/json'},
        );
      });
      final intercepted = InterceptedClient.build(
        interceptors: [],
        client: mockClient,
      );

      final source = Source()
        ..id = 123
        ..itemType = ItemType.manga
        ..sourceCode = 'dummy'
        ..lang = 'fr';

      final prefs = await fetchPreferencesDalvik(
        intercepted,
        source,
        'http://127.0.0.1:57467',
      );
      expect(prefs, isNull);
    });
  });
}
