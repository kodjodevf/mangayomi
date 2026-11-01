import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/services/extension_store_service.dart';

void main() {
  group('ExtensionStoreService anime repo parsing', () {
    test('fetches and converts anime repo extensions even when sources list is empty', () async {
      final client = InterceptedClient.build(interceptors: []);
      const url =
          'https://raw.githubusercontent.com/yuzono/anime-repo/repo/index.min.json';

      final result = await ExtensionStoreService.fetchStore(url, client);

      expect(result, isNotNull);
      expect(result!.name, 'Yūzōnō');
      expect(result.sources, isNotEmpty);
      expect(result.sources.length, greaterThanOrEqualTo(200));

      final first = result.sources.firstWhere(
        (s) => s.name == 'AnimeOnsen',
        orElse: () => result.sources.first,
      );
      expect(first.name, 'AnimeOnsen');
      expect(first.itemType, ItemType.anime);
      expect(first.lang, 'all');
      expect(first.sourceCodeUrl, contains('.apk'));
    });

    test('strips Aniyomi: prefix and parses legacy JSON when sources list is empty', () async {
      final legacyPayload = jsonEncode([
        {
          'name': 'Aniyomi: SampleAnime',
          'pkg': 'eu.kanade.tachiyomi.animeextension.fr.sampleanime',
          'apk': 'sample.apk',
          'lang': 'fr',
          'code': 1,
          'version': '1.0.0',
          'nsfw': 0,
          'sources': [],
        },
        {
          'name': 'Tachiyomi: SampleManga',
          'pkg': 'eu.kanade.tachiyomi.extension.en.samplemanga',
          'apk': 'manga.apk',
          'lang': 'en',
          'code': 1,
          'version': '1.0.0',
          'nsfw': 0,
        },
      ]);

      final mockClient = MockClient((request) async {
        if (request.url.path.endsWith('repo.json')) {
          return http.Response('{"name": "Mock Repo"}', 200);
        }
        return http.Response(legacyPayload, 200);
      });

      final client = InterceptedClient.build(
        client: mockClient,
        interceptors: [],
      );

      final result = await ExtensionStoreService.fetchStore(
        'https://example.com/repo/index.min.json',
        client,
      );

      expect(result, isNotNull);
      expect(result!.name, 'Mock Repo');
      expect(result.sources.length, 2);

      final anime = result.sources.first;
      expect(anime.name, 'SampleAnime');
      expect(anime.itemType, ItemType.anime);
      expect(anime.lang, 'fr');
      expect(anime.sourceCodeUrl, 'https://example.com/repo/apk/sample.apk');

      final manga = result.sources.last;
      expect(manga.name, 'SampleManga');
      expect(manga.itemType, ItemType.manga);
      expect(manga.lang, 'en');
    });

    test(
      'falls back to legacy JSON when index_v2 returns 404 or empty',
      () async {
        final legacyPayload = jsonEncode([
          {
            'name': 'Aniyomi: FallbackAnime',
            'pkg': 'eu.kanade.tachiyomi.animeextension.es.fallback',
            'apk': 'fallback.apk',
            'lang': 'es',
            'code': 1,
            'version': '1.0.0',
            'nsfw': 0,
          },
        ]);

        final mockClient = MockClient((request) async {
          if (request.url.path.endsWith('repo.json')) {
            return http.Response(
              jsonEncode({
                'name': 'Fallback Repo',
                'index_v2': 'https://example.com/repo/index.pb',
              }),
              200,
            );
          }
          if (request.url.path.endsWith('index.pb')) {
            return http.Response('Not Found', 404);
          }
          return http.Response(legacyPayload, 200);
        });

        final client = InterceptedClient.build(
          client: mockClient,
          interceptors: [],
        );

        final result = await ExtensionStoreService.fetchStore(
          'https://example.com/repo/index.min.json',
          client,
        );

        expect(result, isNotNull);
        expect(result!.name, 'Fallback Repo');
        expect(result.sources.length, 1);
        expect(result.sources.first.name, 'FallbackAnime');
        expect(result.sources.first.lang, 'es');
      },
    );
  });
}
