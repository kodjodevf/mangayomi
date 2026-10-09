import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/reader/managers/chapter_preload_manager.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/utils/reader_page_index_math.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';

final ch1 = Chapter(id: 101, mangaId: 1, name: 'Chapter 1', url: '/c1');
final ch2 = Chapter(id: 102, mangaId: 1, name: 'Chapter 2', url: '/c2');

UChapDataPreload page(Chapter ch, int index, {bool wide = false}) =>
    UChapDataPreload(ch, null, null, null, null, index, null, index)
      ..loadedWidth = wide ? 2000 : 1000
      ..loadedHeight = 1400;

List<UChapDataPreload> chapterPages(Chapter ch, int count, {int? wideAt}) => [
  for (var i = 0; i < count; i++) page(ch, i, wide: i == wideAt),
];

UChapDataPreload transition() => UChapDataPreload.transition(
  currentChapter: ch1,
  nextChapter: ch2,
  mangaName: 'Manga',
  pageIndex: 0,
);

GetChapterPagesModel _model(List<UChapDataPreload> pages) =>
    GetChapterPagesModel(
      path: null,
      pageUrls: [],
      isLocaleList: [],
      archiveImages: [],
      uChapDataPreload: pages,
      localImagePaths: [],
    );

ReaderPageIndexMath doublePage(List<UChapDataPreload> pages) =>
    ReaderPageIndexMath(
      isDoublePageActive: true,
      singleFirst: false,
      pageCount: pages.length,
      pages: pages,
    );

void main() {
  group('page counter in double-page mode', () {
    test('a page of the next chapter is labelled from its own spread', () {
      // Chapter 1 has 5 pages, then the transition, then chapter 2. Chapter
      // 2's page 6 (index 5) used to be looked up at slot 5, the transition,
      // and the counter came out blank.
      final pages = [
        ...chapterPages(ch1, 5),
        transition(),
        ...chapterPages(ch2, 8),
      ];

      final math = doublePage(pages);

      expect(math.chapterPageLabel(5, ch2.id, 8), '5-6');
      expect(math.chapterPageLabel(0, ch2.id, 8), '1-2');
    });

    test('a wide page earlier in the list does not shift the next chapter', () {
      final pages = [
        ...chapterPages(ch1, 6, wideAt: 2),
        transition(),
        ...chapterPages(ch2, 6),
      ];

      // Chapter 1's own spreads are 1-2, 3, 4-5, 6; chapter 2 pairs from 1.
      expect(doublePage(pages).chapterPageLabel(2, ch2.id, 6), '3-4');
    });

    test('single-page mode shows the page number as is', () {
      final pages = chapterPages(ch1, 4);
      final math = ReaderPageIndexMath(
        isDoublePageActive: false,
        singleFirst: false,
        pageCount: pages.length,
        pages: pages,
      );

      expect(math.chapterPageLabel(2, ch1.id, 4), '3');
    });

    test('a page that is not loaded falls back to its number', () {
      expect(
        doublePage(chapterPages(ch1, 4)).chapterPageLabel(9, 999, 4),
        '10',
      );
    });
  });

  group('splitting a wide page', () {
    test('every later page moves one slot down', () {
      final manager = ChapterPreloadManager()..initialize(chapterPages(ch1, 4));
      final wide = manager.pages[1];

      manager.splitPage(
        1,
        UChapDataPreload(ch1, null, null, null, null, 1, null, 1)
          ..srcRect = const Rect.fromLTWH(0, 0, 500, 1400),
        UChapDataPreload(ch1, null, null, null, null, 1, null, 1)
          ..srcRect = const Rect.fromLTWH(500, 0, 500, 1400),
      );

      expect(manager.pages, hasLength(5));
      expect(manager.pages.map((p) => p.pageIndex), [0, 1, 2, 3, 4]);
      // The pages after the split still know which page of the chapter
      // they are.
      expect(manager.pages.map((p) => p.index), [0, 1, 1, 2, 3]);
      expect(manager.pages, isNot(contains(wide)));
    });

    test('the two halves get different widget keys', () {
      final left = UChapDataPreload(ch1, null, null, null, null, 1, null, 1)
        ..srcRect = const Rect.fromLTWH(0, 0, 500, 1400);
      final right = UChapDataPreload(ch1, null, null, null, null, 1, null, 2)
        ..srcRect = const Rect.fromLTWH(500, 0, 500, 1400);

      expect(left.widgetKey(1), isNot(right.widgetKey(2)));
      expect(page(ch1, 1).widgetKey(1), '101-1');
    });
  });

  group('preloading', () {
    test('the next chapter follows a transition page', () async {
      final manager = ChapterPreloadManager()..initialize(chapterPages(ch1, 3));

      final added = await manager.preloadNextChapter(
        _model(chapterPages(ch2, 2)),
        ch1,
      );

      expect(added, isTrue);
      expect(manager.pages[3].isTransitionPage, isTrue);
      expect(manager.pages.sublist(4).map((p) => p.chapter?.id), [102, 102]);
      expect(manager.pages.sublist(4).map((p) => p.pageIndex), [4, 5]);
    });

    test(
      'only the chapters around the current one keep their images',
      () async {
        final ch3 = Chapter(id: 103, mangaId: 1, name: 'Chapter 3', url: '/c3');
        final ch4 = Chapter(id: 104, mangaId: 1, name: 'Chapter 4', url: '/c4');
        final manager = ChapterPreloadManager()
          ..initialize(chapterPages(ch1, 2));
        for (final ch in [ch2, ch3, ch4]) {
          await manager.preloadNextChapter(_model(chapterPages(ch, 2)), ch1);
        }

        final evicted = manager.evictOldChapters(ch3);

        expect(evicted.map((i) => manager.pages[i].chapter?.id).toSet(), {101});
        expect(manager.isChapterEvicted(ch1), isTrue);
        expect(manager.isChapterLoaded(ch2), isTrue);
        expect(manager.isChapterLoaded(ch4), isTrue);
      },
    );
  });
}
