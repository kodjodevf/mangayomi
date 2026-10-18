import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/eval/mihon/service.dart';
import 'package:mangayomi/models/source.dart';

// Exercise the real detail/chapters RPC mapping without cookies, a database,
// a running extension server, or any public manga source.
class _FixtureService extends MihonExtensionService {
  late final InterceptedClient _fixtureClient;

  @override
  InterceptedClient get client => _fixtureClient;

  _FixtureService(Future<http.Response> Function(http.Request) handler)
    : super(
        Source(
          id: 1,
          name: 'Fixture',
          lang: 'en',
          baseUrl: 'https://example.org',
        ),
        'https://bridge.example.org',
      ) {
    _fixtureClient = InterceptedClient.build(
      client: MockClient(handler),
      interceptors: [],
    );
  }

  @override
  Map<String, String> getCookie() => {};
}

void main() {
  for (final entry in <String, (String?, String)>{
    'memo only': ('|mangayomi-memo|new', '/work|mangayomi-memo|new'),
    'missing URL': (null, '/work|mangayomi-memo|old'),
    'blank URL': ('  ', '/work|mangayomi-memo|old'),
    'canonical URL': ('/canonical', '/canonical'),
    'canonical URL with memo': (
      '/canonical|mangayomi-memo|new',
      '/canonical|mangayomi-memo|new',
    ),
  }.entries) {
    test('detail preserves a usable URL for ${entry.key}', () async {
      final requests = <Map<String, dynamic>>[];
      final service = _FixtureService((request) async {
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        requests.add(body);
        final result = body['method'] == 'getDetailsManga'
            ? {'title': 'Fixture', 'url': entry.value.$1, 'status': 1}
            : [
                {'name': 'Chapter 1', 'url': '/chapter/1'},
              ];
        return http.Response(jsonEncode(result), 200);
      });
      addTearDown(service.client.close);

      final first = await service.getDetail('/work|mangayomi-memo|old');
      expect(first.link, entry.value.$2);
      final second = await service.getDetail(first.link!);
      // Canonical URLs and memo replacements are stable across refreshes.
      expect(second.link, entry.value.$2);
      expect(second.chapters!.single.url, '/chapter/1');
      expect(requests.map((r) => r['method']), [
        'getDetailsManga',
        'getChapterList',
        'getDetailsManga',
        'getChapterList',
      ]);
      expect(requests.map((r) => (r['mangaData'] as Map)['url']), [
        '/work|mangayomi-memo|old',
        '/work|mangayomi-memo|old',
        entry.value.$2,
        entry.value.$2,
      ]);
    });
  }
}
