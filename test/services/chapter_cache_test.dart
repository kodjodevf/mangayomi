import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/services/chapter_cache.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ChapterCache Tests', () {
    late ChapterCache cache;
    late Directory tempDir;

    setUp(() async {
      cache = ChapterCache();
      tempDir = await Directory.systemTemp.createTemp('chapter_cache_test_');
      cache.customCacheDir = tempDir;
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('getKey includes mangaId and chapter url strictly', () {
      final chapter1 = Chapter(name: 'Chapter 1', mangaId: 42, url: '/manga/chapter-1');
      final chapter2 = Chapter(name: 'Chapter 1', mangaId: 42, url: '/manga/chapter-1-revised');
      final chapter3 = Chapter(name: 'Chapter 1', mangaId: 99, url: '/manga/chapter-1');

      expect(cache.getKey(chapter1), equals('42_/manga/chapter-1'));
      expect(cache.getKey(chapter2), equals('42_/manga/chapter-1-revised'));
      expect(cache.getKey(chapter3), equals('99_/manga/chapter-1'));

      // Changing URL changes the key
      expect(cache.getKey(chapter1), isNot(equals(cache.getKey(chapter2))));
    });

    test('putPageListToCache and getPageListFromCache round-trip works', () async {
      final chapter = Chapter(name: 'Ch 1', mangaId: 10, url: '/c1');
      final pages = [
        PageUrl('https://example.com/1.jpg', headers: {'Referer': 'https://example.com'}),
        PageUrl('https://example.com/2.jpg'),
      ];

      // Initially cache is empty
      final initial = await cache.getPageListFromCache(chapter);
      expect(initial, isNull);

      // Save to cache
      await cache.putPageListToCache(chapter, pages);

      // Read back from cache
      final cached = await cache.getPageListFromCache(chapter);
      expect(cached, isNotNull);
      expect(cached!.length, equals(2));
      expect(cached[0].url, equals('https://example.com/1.jpg'));
      expect(cached[0].headers?['Referer'], equals('https://example.com'));
      expect(cached[1].url, equals('https://example.com/2.jpg'));
    });

    test('cache misses when chapter URL changes', () async {
      final oldChapter = Chapter(name: 'Ch 1', mangaId: 10, url: '/old-url');
      final newChapter = Chapter(name: 'Ch 1', mangaId: 10, url: '/new-url');
      final pages = [PageUrl('https://example.com/1.jpg')];

      await cache.putPageListToCache(oldChapter, pages);

      // Cache hit for old chapter
      expect(await cache.getPageListFromCache(oldChapter), isNotNull);

      // Cache miss for new chapter because URL changed
      expect(await cache.getPageListFromCache(newChapter), isNull);
    });

    test('cache persists without time-based expiry until explicitly removed or cleared', () async {
      final chapter = Chapter(name: 'Ch 1', mangaId: 10, url: '/c1');
      final pages = [PageUrl('https://example.com/1.jpg')];

      await cache.putPageListToCache(chapter, pages);

      // Cache hit remains valid on multiple retrievals
      expect(await cache.getPageListFromCache(chapter), isNotNull);
      expect(await cache.getPageListFromCache(chapter), isNotNull);
    });

    test('remove and clear methods work properly', () async {
      final chapter1 = Chapter(name: 'Ch 1', mangaId: 10, url: '/c1');
      final chapter2 = Chapter(name: 'Ch 2', mangaId: 10, url: '/c2');
      final pages = [PageUrl('https://example.com/1.jpg')];

      await cache.putPageListToCache(chapter1, pages);
      await cache.putPageListToCache(chapter2, pages);

      expect(await cache.getPageListFromCache(chapter1), isNotNull);
      expect(await cache.getPageListFromCache(chapter2), isNotNull);

      // Remove chapter 1
      await cache.remove(chapter1);
      expect(await cache.getPageListFromCache(chapter1), isNull);
      expect(await cache.getPageListFromCache(chapter2), isNotNull);

      // Clear all
      final deleted = await cache.clear();
      expect(deleted, equals(1));
      expect(await cache.getPageListFromCache(chapter2), isNull);
    });

    test('trimCache evicts oldest entries when exceeding maxBytes', () async {
      final chapter1 = Chapter(name: 'Ch 1', mangaId: 1, url: '/c1');
      final chapter2 = Chapter(name: 'Ch 2', mangaId: 2, url: '/c2');
      final pages = [PageUrl('https://example.com/1.jpg')];

      await cache.putPageListToCache(chapter1, pages);
      // Small pause to ensure differing modification times
      await Future.delayed(const Duration(milliseconds: 20));
      await cache.putPageListToCache(chapter2, pages);

      expect(await cache.getPageListFromCache(chapter1), isNotNull);
      expect(await cache.getPageListFromCache(chapter2), isNotNull);

      // Force trim down to 1 byte — should evict oldest (chapter1) first
      await cache.trimCache(maxBytes: 1);

      // After trimming to 1 byte, both or at least chapter1 was evicted
      expect(await cache.getPageListFromCache(chapter1), isNull);
    });
  });
}
