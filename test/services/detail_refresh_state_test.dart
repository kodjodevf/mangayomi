import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/eval/model/m_chapter.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_manga_detail_providers.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';
import 'package:mangayomi/services/get_detail.dart';

MManga _catalog() => MManga(
  name: 'Updated fixture',
  link: '/work',
  chapters: [
    MChapter(name: 'Chapter 2', url: '/chapter/2'),
    MChapter(name: 'Chapter 1', url: '/chapter/1'),
  ],
);

void main() {
  late Directory directory;
  late Isar db;
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final previous = HttpOverrides.current;
    HttpOverrides.global = null;
    try {
      await Isar.initializeIsarCore(download: true);
    } finally {
      HttpOverrides.global = previous;
    }
  });
  setUp(() async {
    directory = await Directory.systemTemp.createTemp('detail-refresh-');
    db = await Isar.open(
      [
        MangaSchema,
        ChapterSchema,
        SettingsSchema,
        SourceSchema,
        UpdateSchema,
        HistorySchema,
        DownloadSchema,
      ],
      directory: directory.path,
      name: 'detail_refresh',
    );
    app.isar = db;
    db.writeTxnSync(() {
      db.settings.putSync(
        Settings()
          ..chapterPageIndexList = [ChapterPageIndex(chapterId: 10, index: 2)],
      );
      db.sources.putSync(
        Source(id: 1, name: 'Fixture', lang: 'en', isAdded: true),
      );
      final manga = Manga(
        id: 1,
        name: 'Fixture',
        sourceId: 1,
        source: 'Fixture',
        lang: 'en',
        link: '/work',
        author: '',
        artist: '',
        genre: [],
        imageUrl: '',
        status: Status.ongoing,
        description: '',
        favorite: true,
      );
      db.mangas.putSync(manga);
      final chapter = Chapter(
        id: 10,
        mangaId: 1,
        name: 'Chapter 1',
        url: '/chapter/1',
      )..manga.value = manga;
      db.chapters.putSync(chapter);
      chapter.manga.saveSync();
    });
  });
  tearDown(() async {
    await dbWriteQueue.run(() {});
    await db.close(deleteFromDisk: true);
    await directory.delete(recursive: true);
  });

  test(
    'concurrent refreshes retain in-flight state and insert each chapter once',
    () async {
      final entered = Completer<void>();
      final response = Completer<MManga>();
      var requests = 0;
      final container = ProviderContainer(
        overrides: [
          getDetailProvider.overrideWith((ref, args) {
            if (++requests == 2) entered.complete();
            return response.future;
          }),
        ],
      );
      addTearDown(container.dispose);
      final a = container.read(
        updateMangaDetailProvider(
          mangaId: 1,
          isInit: false,
          showToast: false,
        ).future,
      );
      final b = container.read(
        updateMangaDetailProvider(
          mangaId: 1,
          isInit: false,
          showToast: true,
        ).future,
      );
      await entered.future.timeout(const Duration(seconds: 5));
      db.writeTxnSync(() {
        db.chapters.putSync(
          db.chapters.getSync(10)!
            ..isRead = true
            ..lastPageRead = '17'
            ..isBookmarked = true,
        );
        db.mangas.putSync(
          db.mangas.getSync(1)!
            ..lastRead = 1234
            ..favorite = false,
        );
        db.settings.putSync(
          db.settings.getSync(227)!
            ..chapterPageIndexList = [
              ChapterPageIndex(chapterId: 10, index: 16),
            ],
        );
      });
      response.complete(_catalog());
      await Future.wait([a, b]);
      expect(db.chapters.countSync(), 2);
      expect(db.updates.countSync(), 1);
      final chapter = db.chapters.getSync(10)!;
      expect(chapter.isRead, true);
      expect(chapter.isBookmarked, true);
      expect(chapter.lastPageRead, '17');
      expect(db.mangas.getSync(1)!.lastRead, 1234);
      expect(db.mangas.getSync(1)!.favorite, false);
      expect(db.settings.getSync(227)!.chapterPageIndexList!.single.index, 16);
    },
  );

  test(
    'duplicate labels do not delete IDs referenced by reading state',
    () async {
      db.writeTxnSync(() {
        final original = db.chapters.getSync(10)!..isBookmarked = true;
        db.chapters.putSync(original);
        final duplicate = Chapter(
          id: 11,
          mangaId: 1,
          name: 'Chapter 1',
          url: '/alternate',
          isRead: true,
          lastPageRead: '8',
        )..manga.value = db.mangas.getSync(1);
        db.chapters.putSync(duplicate);
        duplicate.manga.saveSync();
        final history = History(
          id: 30,
          mangaId: 1,
          chapterId: 10,
          itemType: ItemType.manga,
          date: '1000',
        )..chapter.value = original;
        db.historys.putSync(history);
        history.chapter.saveSync();
        final download = Download(
          id: 11,
          succeeded: 100,
          failed: 0,
          total: 100,
          isDownload: true,
          isStartDownload: false,
        )..chapter.value = duplicate;
        db.downloads.putSync(download);
        download.chapter.saveSync();
      });
      final container = ProviderContainer(
        overrides: [
          getDetailProvider.overrideWith((ref, args) async => _catalog()),
        ],
      );
      addTearDown(container.dispose);
      await container.read(
        updateMangaDetailProvider(
          mangaId: 1,
          isInit: false,
          showToast: false,
        ).future,
      );
      expect(db.chapters.getSync(10)?.isBookmarked, true);
      expect(db.chapters.getSync(11)?.lastPageRead, '8');
      final history = db.historys.getSync(30)!;
      history.chapter.loadSync();
      expect(history.chapter.value?.id, 10);
      final download = db.downloads.getSync(11)!;
      download.chapter.loadSync();
      expect(download.chapter.value?.id, 11);
      expect(download.isDownload, true);
      expect(
        db.settings.getSync(227)!.chapterPageIndexList!.single.chapterId,
        10,
      );
    },
  );

  for (final deleted in [false, true]) {
    test(
      'a pending refresh respects a ${deleted ? 'deleted' : 'rebound'} work',
      () async {
        final entered = Completer<void>();
        final response = Completer<MManga>();
        final container = ProviderContainer(
          overrides: [
            getDetailProvider.overrideWith((ref, args) {
              entered.complete();
              return response.future;
            }),
          ],
        );
        addTearDown(container.dispose);
        final refresh = container.read(
          updateMangaDetailProvider(
            mangaId: 1,
            isInit: false,
            showToast: false,
          ).future,
        );
        await entered.future;
        db.writeTxnSync(() {
          if (deleted) {
            db.mangas.deleteSync(1);
          } else {
            db.mangas.putSync(
              db.mangas.getSync(1)!
                ..link = '/replacement'
                ..sourceId = 2
                ..source = 'Other fixture',
            );
          }
        });
        response.complete(_catalog());
        await refresh;
        expect(db.chapters.countSync(), 1);
        expect(db.updates.countSync(), 0);
        if (deleted) {
          expect(db.mangas.getSync(1), isNull);
        } else {
          expect(db.mangas.getSync(1)!.link, '/replacement');
          expect(db.mangas.getSync(1)!.sourceId, 2);
        }
      },
    );
  }

  test('ordinary refresh still updates metadata without duplicating catalog entries', () async {
    final container = ProviderContainer(
      overrides: [
        getDetailProvider.overrideWith((ref, args) async => _catalog()),
      ],
    );
    addTearDown(container.dispose);
    final provider = updateMangaDetailProvider(
      mangaId: 1,
      isInit: false,
      showToast: false,
    );
    await container.read(provider.future);
    await container.refresh(provider.future);
    expect(db.mangas.getSync(1)!.name, 'Updated fixture');
    expect(db.chapters.countSync(), 2);
    expect(db.updates.countSync(), 1);
  });
}
