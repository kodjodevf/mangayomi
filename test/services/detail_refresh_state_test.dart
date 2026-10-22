// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:archive/archive.dart';
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
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/modules/manga/download/providers/download_provider.dart';
import 'package:mangayomi/modules/manga/download/providers/download_gate.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/novel/novel_reader_controller_provider.dart';
import 'package:mangayomi/modules/anime/providers/anime_player_controller_provider.dart';
import 'package:mangayomi/modules/reader_common/mixins/chapter_controller_mixin.dart';
import 'package:mangayomi/services/chapter_cache.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';
import 'package:mangayomi/services/downloaded_chapter.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class _FixturePaths extends PathProviderPlatform {
  _FixturePaths(this.path);
  final String path;
  @override
  Future<String?> getApplicationDocumentsPath() async => path;
}

final _image = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAIAAACQkWg2AAAAI0lEQVR4nGP8//8/AymAiSTVDKMaiANMRKqDg1ENxACSQwkAVW0DHeN02ZEAAAAASUVORK5CYII=',
);

Future<File> _archive(Directory root, String name) async {
  final file = File(
    p.join(
      root.path,
      'Mangayomi',
      'downloads',
      'Manga',
      'Fixture (EN)',
      'Fixture',
      '$name.cbz',
    ),
  );
  await file.parent.create(recursive: true);
  await file.writeAsBytes(
    ZipEncoder().encode(
      Archive()..addFile(ArchiveFile('001.png', _image.length, _image)),
    ),
  );
  return file;
}

Future<File> _page(Directory root, String name) async {
  final file = File(
    p.join(
      root.path,
      'Mangayomi',
      'downloads',
      'Manga',
      'Fixture (EN)',
      'Fixture',
      name,
      '${padIndex(0)}.png',
    ),
  );
  await file.parent.create(recursive: true);
  await file.writeAsBytes(_image);
  return file;
}

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
  late PathProviderPlatform previousPaths;
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
    previousPaths = PathProviderPlatform.instance;
    PathProviderPlatform.instance = _FixturePaths(directory.path);
    ChapterCache().customCacheDir = Directory(p.join(directory.path, 'cache'));
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
    for (final id in [10, 11, 12]) {
      unscheduleDownload(id);
    }
    await dbWriteQueue.run(() {});
    await db.close(deleteFromDisk: true);
    await directory.delete(recursive: true);
    ChapterCache().customCacheDir = null;
    PathProviderPlatform.instance = previousPaths;
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

  test('duplicate labels merge references and leave one chapter', () async {
    db.writeTxnSync(() {
      final original = db.chapters.getSync(10)!
        ..isBookmarked = true
        ..lastPageRead = '3';
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
    expect(db.chapters.getSync(10), isNull);
    expect(db.chapters.countSync(), 2); // One survivor plus the new Chapter 2.
    expect(db.chapters.getSync(11)?.isBookmarked, true);
    expect(db.chapters.getSync(11)?.isRead, true);
    expect(db.chapters.getSync(11)?.lastPageRead, '3');
    final history = db.historys.getSync(30)!;
    history.chapter.loadSync();
    expect(history.chapterId, 11);
    expect(history.chapter.value?.id, 11);
    final download = db.downloads.getSync(11)!;
    download.chapter.loadSync();
    expect(download.chapter.value?.id, 11);
    expect(download.isDownload, true);
    expect(
      db.settings.getSync(227)!.chapterPageIndexList!.single.chapterId,
      11,
    );
  });

  for (final asArchive in [true, false]) {
    test(
      'downloaded ${asArchive ? 'CBZ' : 'page folder'} survives renaming and offline reading',
      () async {
        final file = await (asArchive
            ? _archive(directory, 'Chapter 1')
            : _page(directory, 'Chapter 1'));
        final bytes = await file.readAsBytes();
        db.writeTxnSync(() {
          final original = db.chapters.getSync(10)!
            ..lastPageRead = '12'
            ..isBookmarked = true;
          db.chapters.putSync(original);
          final duplicate = Chapter(
            id: 11,
            mangaId: 1,
            name: 'Chapter 1',
            url: '/alternate',
            lastPageRead: '3',
          )..manga.value = db.mangas.getSync(1);
          db.chapters.putSync(duplicate);
          duplicate.manga.saveSync();
          for (final (id, chapter, date) in [
            (30, original, '1000'),
            (31, duplicate, '2000'),
          ]) {
            final history = History(
              id: id,
              mangaId: 1,
              chapterId: chapter.id,
              itemType: ItemType.manga,
              date: date,
            )..chapter.value = chapter;
            db.historys.putSync(history);
            history.chapter.saveSync();
          }
          final update = Update(
            id: 40,
            mangaId: 1,
            chapterName: original.name,
            date: '1000',
          )..chapter.value = original;
          db.updates.putSync(update);
          update.chapter.saveSync();
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
          db.settings.putSync(
            db.settings.getSync(227)!
              ..chapterPageIndexList = [
                ChapterPageIndex(chapterId: 10, index: 11),
                ChapterPageIndex(chapterId: 11, index: 2),
              ],
          );
        });
        final container = ProviderContainer(
          overrides: [
            getDetailProvider.overrideWith(
              (ref, args) async => MManga(
                name: 'Renamed work',
                link: '/work',
                chapters: [
                  MChapter(name: 'Chapter 1 revised', url: '/canonical'),
                ],
              ),
            ),
          ],
        );
        addTearDown(container.dispose);
        final refresh = updateMangaDetailProvider(
          mangaId: 1,
          isInit: false,
          showToast: false,
        );
        await container.read(refresh.future);
        await container.refresh(
          refresh.future,
        ); // Idempotent; old aliases do not reappear.
        expect(db.chapters.countSync(), 1);
        final survivor = db.chapters.getSync(11)!;
        survivor.manga.loadSync();
        expect(survivor.name, 'Chapter 1');
        expect(survivor.manga.value!.name, 'Fixture');
        expect(survivor.url, '/canonical');
        expect(
          survivor.lastPageRead,
          '3',
        ); // Newest history wins over the furthest page.
        expect(survivor.isBookmarked, true);
        expect(db.historys.countSync(), 2);
        for (final history in db.historys.where().findAllSync()) {
          history.chapter.loadSync();
          expect(history.chapterId, 11);
          expect(history.chapter.value?.id, 11);
        }
        final update = db.updates.getSync(40)!;
        update.chapter.loadSync();
        expect(update.chapter.value?.id, 11);
        final index = db.settings.getSync(227)!.chapterPageIndexList!.single;
        expect((index.chapterId, index.index), (11, 2));
        expect(await file.readAsBytes(), bytes);
        db.writeTxnSync(() => db.sources.clearSync());
        final pages = await container.read(
          getChapterPagesProvider(chapter: survivor).future,
        );
        if (asArchive) {
          expect(pages.archiveImages.single, _image);
        } else {
          expect(
            await File(p.join(pages.path!.path, '${padIndex(0)}.png'))
                .readAsBytes(),
            _image,
          );
        }
        expect(pages.isLocaleList, [true]);
      },
    );
  }

  for (final complete in [false, true]) {
    test(
      '${complete ? 'completed' : 'paused'} downloads outrank failures and retain queue order/files',
      () async {
        final partial = await _page(directory, 'Chapter 1');
        final bytes = await partial.readAsBytes();
        db.writeTxnSync(() {
          final manga = db.mangas.getSync(1)!;
          final duplicate = Chapter(
            id: 11,
            mangaId: 1,
            name: 'Chapter 1',
            url: '/alternate',
          )..manga.value = manga;
          db.chapters.putSync(duplicate);
          duplicate.manga.saveSync();
          for (final (id, succeeded) in [(10, 40), (11, complete ? 100 : 70)]) {
            final record = Download(
              id: id,
              succeeded: succeeded,
              failed: complete && id == 11 ? 0 : 1,
              total: 100,
              isDownload: complete && id == 11,
              isStartDownload: false,
            )..chapter.value = db.chapters.getSync(id);
            db.downloads.putSync(record);
            record.chapter.saveSync();
          }
          db.settings.putSync(
            db.settings.getSync(227)!..downloadQueueOrder = [11, 99, 10, 88],
          );
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
        final survivor = complete ? 11 : 10;
        final dropped = complete ? 10 : 11;
        expect(db.chapters.getSync(dropped), isNull);
        expect(db.downloads.getSync(dropped), isNull);
        final download = db.downloads.getSync(survivor)!;
        download.chapter.loadSync();
        expect(download.succeeded, complete ? 100 : 70);
        expect(download.isDownload, complete);
        expect(download.failed, complete ? 0 : 1);
        expect(download.chapter.value?.id, survivor);
        expect(download.isStartDownload, false);
        expect(db.settings.getSync(227)!.downloadQueueOrder, [
          survivor,
          99,
          88,
        ]);
        expect(await partial.readAsBytes(), bytes);
      },
    );
  }

  test(
    'transitive URL/label aliases and link-only history point to one survivor',
    () async {
      db.writeTxnSync(() {
        db.chapters.putSync(db.chapters.getSync(10)!..scanlator = 'A');
        for (final (id, url) in [(11, '/chapter/1'), (12, '/alias')]) {
          final chapter = Chapter(
            id: id,
            mangaId: 1,
            name: 'Chapter 1',
            url: url,
            scanlator: 'B',
            lastPageRead: '4',
          )..manga.value = db.mangas.getSync(1);
          db.chapters.putSync(chapter);
          chapter.manga.saveSync();
        }
        final history = History(
          id: 30,
          mangaId: 1,
          chapterId: null,
          itemType: ItemType.manga,
          date: '2000',
        )..chapter.value = db.chapters.getSync(12);
        db.historys.putSync(history);
        history.chapter.saveSync();
        final update = Update(
          id: 40,
          mangaId: 1,
          chapterName: 'Chapter 1',
          date: '2000',
        )..chapter.value = db.chapters.getSync(12);
        db.updates.putSync(update);
        update.chapter.saveSync();
        db.settings.putSync(
          db.settings.getSync(227)!
            ..chapterPageIndexList = [
              ChapterPageIndex(chapterId: 12, index: 3),
            ],
        );
      });
      final container = ProviderContainer(
        overrides: [
          getDetailProvider.overrideWith(
            (ref, args) async => MManga(
              name: 'Fixture',
              link: '/work',
              chapters: [
                MChapter(
                  name: 'Chapter 1 revised',
                  url: '/alias',
                  scanlator: 'B',
                ),
              ],
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      final refresh = updateMangaDetailProvider(
        mangaId: 1,
        isInit: false,
        showToast: false,
      );
      await container.read(refresh.future);
      await container.refresh(refresh.future);
      expect(db.chapters.countSync(), 1);
      expect(db.chapters.getSync(10)!.lastPageRead, '4');
      final history = db.historys.getSync(30)!;
      history.chapter.loadSync();
      expect((history.chapterId, history.chapter.value?.id), (10, 10));
      final update = db.updates.getSync(40)!;
      update.chapter.loadSync();
      expect(
        (update.chapterName, update.chapter.value?.id),
        ('Chapter 1 revised', 10),
      );
      expect(
        db.settings.getSync(227)!.chapterPageIndexList!.single.chapterId,
        10,
      );
    },
  );

  for (final scheduled in [false, true]) {
    test(
      '${scheduled ? 'scheduled' : 'queued'} downloads defer cleanup until safe',
      () async {
        db.writeTxnSync(() {
          final duplicate = Chapter(
            id: 11,
            mangaId: 1,
            name: 'Chapter 1',
            url: '/alternate',
          )..manga.value = db.mangas.getSync(1);
          db.chapters.putSync(duplicate);
          duplicate.manga.saveSync();
          final record = Download(
            id: 11,
            succeeded: 35,
            failed: 0,
            total: 100,
            isDownload: false,
            isStartDownload: !scheduled,
          )..chapter.value = duplicate;
          db.downloads.putSync(record);
          record.chapter.saveSync();
        });
        if (scheduled) expect(scheduleDownload(11), true);
        final container = ProviderContainer(
          overrides: [
            getDetailProvider.overrideWith((ref, args) async => _catalog()),
          ],
        );
        addTearDown(container.dispose);
        final refresh = updateMangaDetailProvider(
          mangaId: 1,
          isInit: false,
          showToast: false,
        );
        await container.read(refresh.future);
        expect(db.chapters.getSync(10), isNotNull);
        expect(db.chapters.getSync(11), isNotNull);
        expect(db.downloads.getSync(11)!.succeeded, 35);
        unscheduleDownload(11);
        db.writeTxnSync(
          () => db.downloads.putSync(
            db.downloads.getSync(11)!..isStartDownload = false,
          ),
        );
        await container.refresh(refresh.future);
        expect(db.chapters.getSync(10), isNull);
        expect(db.chapters.getSync(11), isNotNull);
        expect(db.downloads.getSync(11)!.succeeded, 35);
      },
    );
  }

  test('distinct stored editions remain separately addressable with untouched files', () async {
    final a = await _archive(directory, 'Local A');
    final b = await _archive(directory, 'Local B');
    final bytesA = await a.readAsBytes(), bytesB = await b.readAsBytes();
    db.writeTxnSync(() {
      db.chapters.putSync(db.chapters.getSync(10)!..name = 'Local A');
      final duplicate = Chapter(
        id: 11,
        mangaId: 1,
        name: 'Local B',
        url: '/chapter/1',
      )..manga.value = db.mangas.getSync(1);
      db.chapters.putSync(duplicate);
      duplicate.manga.saveSync();
      for (final id in [10, 11]) {
        final record = Download(
          id: id,
          succeeded: 100,
          failed: 0,
          total: 100,
          isDownload: true,
          isStartDownload: false,
        )..chapter.value = db.chapters.getSync(id);
        db.downloads.putSync(record);
        record.chapter.saveSync();
      }
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
    for (final id in [10, 11]) {
      final chapter = db.chapters.getSync(id)!;
      chapter.manga.loadSync();
      expect((await findDownloadedChapter(chapter))?.archive, isNotNull);
      expect(db.downloads.getSync(id)!.isDownload, true);
    }
    expect(await a.readAsBytes(), bytesA);
    expect(await b.readAsBytes(), bytesB);
  });

  test(
    'a failed transaction rolls back every reference transfer and deletion',
    () async {
      db.writeTxnSync(() {
        final duplicate = Chapter(
          id: 11,
          mangaId: 1,
          name: 'Chapter 1',
          url: '/alternate',
          isRead: true,
          isBookmarked: true,
          lastPageRead: '5',
        )..manga.value = db.mangas.getSync(1);
        db.chapters.putSync(duplicate);
        duplicate.manga.saveSync();
        final history = History(
          id: 30,
          mangaId: 1,
          chapterId: 11,
          itemType: ItemType.manga,
          date: '1000',
        )..chapter.value = duplicate;
        db.historys.putSync(history);
        history.chapter.saveSync();
      });
      await expectLater(
        chapterRepository.writeTransactionAsync(() async {
          await chapterRepository.consolidateDuplicatesAsync(
            await chapterRepository.getAllByMangaIds([1]),
            mangaName: 'Fixture',
            now: 5000,
            isScheduled: (_) => false,
          );
          throw StateError('fixture rollback');
        }),
        throwsStateError,
      );
      expect(db.chapters.countSync(), 2);
      expect(db.chapters.getSync(10)!.isBookmarked, false);
      expect(db.chapters.getSync(11)!.lastPageRead, '5');
      final history = db.historys.getSync(30)!;
      history.chapter.loadSync();
      expect((history.chapterId, history.chapter.value?.id), (11, 11));
      expect(
        db.settings.getSync(227)!.chapterPageIndexList!.single.chapterId,
        10,
      );
    },
  );

  test(
    'a download arriving after the merge guard follows the committed survivor',
    () async {
      final stale = db.chapters.getSync(10)!;
      db.writeTxnSync(() {
        final duplicate = Chapter(
          id: 11,
          mangaId: 1,
          name: 'Chapter 1',
          url: '/alternate',
        )..manga.value = db.mangas.getSync(1);
        db.chapters.putSync(duplicate);
        duplicate.manga.saveSync();
        final record = Download(
          id: 11,
          succeeded: 100,
          failed: 0,
          total: 100,
          isDownload: true,
          isStartDownload: false,
        )..chapter.value = duplicate;
        db.downloads.putSync(record);
        record.chapter.saveSync();
      });
      final guarded = Completer<void>(), commit = Completer<void>();
      final aliases = <int, Chapter>{};
      final transaction = mangaRepository.writeTransactionAsync(() async {
        final consolidated = await chapterRepository.consolidateDuplicatesAsync(
          await chapterRepository.getAllByMangaIds([1]),
          mangaName: 'Fixture',
          now: 5000,
          isScheduled: isDownloadScheduled,
        );
        aliases.addAll(consolidated.canonicalById);
        guarded.complete();
        await commit.future; // Guard and mutations have run, but not committed.
      }, afterCommit: () => chapterRepository.publishAliases(aliases));
      final container = ProviderContainer();
      addTearDown(container.dispose);
      Future<void>? download;
      try {
        await guarded.future;
        download = container.read(
          downloadChapterProvider(chapter: stale).future,
        );
        await Future<void>.delayed(Duration.zero);
        expect(isDownloadScheduled(10), false);
        commit.complete();
        await transaction;
        await download!.timeout(const Duration(seconds: 5));
        expect(db.chapters.getSync(10), isNull);
        expect(db.downloads.getSync(10), isNull);
        final record = db.downloads.getSync(11)!;
        record.chapter.loadSync();
        expect(record.isDownload, true);
        expect(record.chapter.value?.id, 11);
        expect(isDownloadScheduled(10), false);
      } finally {
        if (!commit.isCompleted) commit.complete();
        await transaction;
        await download?.timeout(const Duration(seconds: 5));
      }
    },
  );

  test(
    'an open reader keeps its ID until final progress and history are saved',
    () async {
      final openChapter = db.chapters.getSync(10)!;
      db.writeTxnSync(() {
        final duplicate = Chapter(
          id: 11,
          mangaId: 1,
          name: 'Chapter 1',
          url: '/alternate',
        )..manga.value = db.mangas.getSync(1);
        db.chapters.putSync(duplicate);
        duplicate.manga.saveSync();
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
      final reader = container.read(
        readerControllerProvider(chapter: openChapter).notifier,
      );
      final refresh = updateMangaDetailProvider(
        mangaId: 1,
        isInit: false,
        showToast: false,
      );
      try {
        await container.read(refresh.future);
        expect(db.chapters.getSync(10), isNotNull);
        expect(db.chapters.getSync(11), isNotNull);
        reader.setPageIndex(7, true, List.filled(30, 'page'));
        await dbWriteQueue.run(() {});
        expect(db.chapters.getSync(10)!.lastPageRead, '8');
      } catch (_) {
        container.dispose();
        rethrow;
      }
      final next = ProviderContainer(
        overrides: [
          getDetailProvider.overrideWith((ref, args) async => _catalog()),
        ],
      );
      addTearDown(next.dispose);
      // A reader's dispose starts an async history save and closes its provider
      // without awaiting it. Put refresh between that save's two queued writes.
      final entered = Completer<void>(), release = Completer<void>();
      final blocker = dbWriteQueue.run(() async {
        entered.complete();
        await release.future;
      });
      await entered.future;
      final historySave = reader.setHistoryUpdate();
      container.dispose();
      final duringClose = next.read(refresh.future);
      await Future<void>.delayed(Duration.zero);
      release.complete();
      await blocker;
      await duringClose;
      await historySave;
      await dbWriteQueue.run(() {});
      expect(db.chapters.getSync(10), isNotNull);
      await next.refresh(refresh.future);
      expect(db.chapters.getSync(10), isNull);
      expect(db.chapters.getSync(11)!.lastPageRead, '8');
      expect(db.downloads.getSync(11)!.isDownload, true);
      final index = db.settings.getSync(227)!.chapterPageIndexList!.single;
      expect((index.chapterId, index.index), (11, 7));
      final history = db.historys.where().findFirstSync()!;
      history.chapter.loadSync();
      expect((history.chapterId, history.chapter.value?.id), (11, 11));
    },
  );

  for (final kind in ['manga', 'novel', 'anime']) {
    test(
      '$kind opening a stale chapter follows the survivor for history',
      () async {
        final stale = db.chapters.getSync(10)!;
        db.writeTxnSync(() {
          final duplicate = Chapter(
            id: 11,
            mangaId: 1,
            name: 'Chapter 1',
            url: '/alternate',
          )..manga.value = db.mangas.getSync(1);
          db.chapters.putSync(duplicate);
          duplicate.manga.saveSync();
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
        expect(db.chapters.getSync(10), isNull);
        final ChapterControllerMixin controller = switch (kind) {
          'novel' => container.read(
            novelReaderControllerProvider(chapter: stale).notifier,
          ),
          'anime' => container.read(
            animeStreamControllerProvider(episode: stale).notifier,
          ),
          _ => container.read(
            readerControllerProvider(chapter: stale).notifier,
          ),
        };
        expect(controller.chapter.id, 11);
        await controller.setHistoryUpdate();
        expect(db.chapters.getSync(10), isNull);
        final history = db.historys.where().findFirstSync()!;
        history.chapter.loadSync();
        expect((history.chapterId, history.chapter.value?.id), (11, 11));
        expect(db.downloads.getSync(11)!.isDownload, true);
      },
    );
  }

  for (final markedB in [false, true]) {
    test(
      'unrecorded archives stay addressable (${markedB ? 'one marker' : 'no markers'})',
      () async {
        final a = await _archive(directory, 'Local A'),
            b = await _archive(directory, 'Local B');
        final bytesA = await a.readAsBytes(), bytesB = await b.readAsBytes();
        db.writeTxnSync(() {
          db.chapters.putSync(db.chapters.getSync(10)!..name = 'Local A');
          final other = Chapter(
            id: 11,
            mangaId: 1,
            name: 'Local B',
            url: '/chapter/1',
          )..manga.value = db.mangas.getSync(1);
          db.chapters.putSync(other);
          other.manga.saveSync();
          if (markedB) {
            final record = Download(
              id: 11,
              succeeded: 100,
              failed: 0,
              total: 100,
              isDownload: true,
              isStartDownload: false,
            )..chapter.value = other;
            db.downloads.putSync(record);
            record.chapter.saveSync();
          }
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
        for (final id in [10, 11]) {
          final chapter = db.chapters.getSync(id)!;
          chapter.manga.loadSync();
          expect((await findDownloadedChapter(chapter))?.archive, isNotNull);
        }
        expect(await a.readAsBytes(), bytesA);
        expect(await b.readAsBytes(), bytesB);
      },
    );
  }

  test(
    'different raw archive names never collapse through a shared sanitized name',
    () async {
      final a = await _archive(directory, 'Chapter:1'),
          b = await _archive(directory, 'Chapter?1');
      final bytesA = await a.readAsBytes(), bytesB = await b.readAsBytes();
      db.writeTxnSync(() {
        db.chapters.putSync(db.chapters.getSync(10)!..name = 'Chapter:1');
        final other = Chapter(
          id: 11,
          mangaId: 1,
          name: 'Chapter?1',
          url: '/chapter/1',
        )..manga.value = db.mangas.getSync(1);
        db.chapters.putSync(other);
        other.manga.saveSync();
        for (final id in [10, 11]) {
          final record = Download(
            id: id,
            succeeded: 100,
            failed: 0,
            total: 100,
            isDownload: true,
            isStartDownload: false,
          )..chapter.value = db.chapters.getSync(id);
          db.downloads.putSync(record);
          record.chapter.saveSync();
        }
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
      for (final id in [10, 11]) {
        final chapter = db.chapters.getSync(id)!;
        chapter.manga.loadSync();
        expect((await findDownloadedChapter(chapter))?.archive, isNotNull);
      }
      expect(await a.readAsBytes(), bytesA);
      expect(await b.readAsBytes(), bytesB);
    },
    skip: Platform.isWindows
        ? 'Raw colon/question-mark filenames cannot exist on Windows'
        : false,
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
