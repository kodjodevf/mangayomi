import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/l10n/l10n_delegates.dart';
import 'package:mangayomi/models/backup_password_fallback.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/custom_button.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/models/tracker_library_cache.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/restore.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/db.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/update_repository.dart';
import 'package:mangayomi/router/router.dart';
import 'package:material_ui/material_ui.dart';

class _NoRouterLocation extends RouterCurrentLocationState {
  @override
  String? build() => null;

  @override
  void refresh() {}
}

Future<(BuildContext, WidgetRef)> _pumpShell(WidgetTester tester) async {
  late BuildContext ctx;
  late WidgetRef widgetRef;
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        routerCurrentLocationStateProvider.overrideWith(_NoRouterLocation.new),
      ],
      child: MaterialApp(
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        localizationsDelegates: appLocalizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Consumer(
          builder: (context, ref, _) {
            ctx = context;
            widgetRef = ref;
            return const SizedBox();
          },
        ),
      ),
    ),
  );
  return (ctx, widgetRef);
}

Manga _manga({String name = 'Series', String link = '/series'}) => Manga(
  source: 'src',
  author: '',
  artist: '',
  genre: const [],
  imageUrl: '',
  lang: 'en',
  link: link,
  name: name,
  status: Status.unknown,
  description: '',
  sourceId: 1,
  favorite: true,
);

void main() {
  late Directory directory;
  var backupIndex = 0;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final overrides = HttpOverrides.current;
    HttpOverrides.global = null;
    try {
      await Isar.initializeIsarCore(download: true);
    } finally {
      HttpOverrides.global = overrides;
    }
  });

  setUp(() async {
    directory = Directory.systemTemp.createTempSync('mangayomi_merge_restore');
    isar = await Isar.open(
      [
        MangaSchema,
        ChangedPartSchema,
        ChapterSchema,
        CategorySchema,
        CustomButtonSchema,
        UpdateSchema,
        HistorySchema,
        DownloadSchema,
        SourceSchema,
        SettingsSchema,
        TrackPreferenceSchema,
        TrackSchema,
        SyncPreferenceSchema,
        SourcePreferenceSchema,
        SourcePreferenceStringValueSchema,
        BackupPasswordFallbackSchema,
        TrackerLibraryCacheSchema,
      ],
      directory: directory.path,
      name: 'mangayomi_merge_${directory.path.hashCode}',
    );
    await isar.writeTxn(() async {
      await isar.settings.put(Settings());
    });
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  });

  Future<void> mergeBackup(
    WidgetTester tester,
    WidgetRef ref,
    BuildContext ctx,
    Map<String, dynamic> payload,
  ) async {
    await tester.runAsync(() async {
      backupIndex++;
      final path = '${directory.path}/mangayomi_merge_$backupIndex.backup';
      final archive = Archive()
        ..addFile(
          ArchiveFile.string(
            'mangayomi_merge_$backupIndex.backup.db',
            jsonEncode(payload),
          ),
        );
      File(path).writeAsBytesSync(ZipEncoder().encode(archive));
      await ref.read(
        doRestoreProvider(path: path, context: ctx, merge: true).future,
      );
    });
    BotToast.cleanAll();
    await tester.pumpAndSettle();
  }

  testWidgets(
    'merge restore maps existing chapters by URL, preserves archivePath, adds new chapters, and restores history',
    (tester) async {
      late int existingMangaId;
      late int existingChapterId;
      isar.writeTxnSync(() {
        final existingManga = _manga()..id = 10;
        existingMangaId = isar.mangas.putSync(existingManga);
        final existingChapter = Chapter(
          id: 20,
          mangaId: existingMangaId,
          name: 'Chapter 1',
          url: '/c1',
          isRead: false,
          lastPageRead: '',
          archivePath: '/local/c1.cbz',
          updatedAt: 1000,
        )..manga.value = existingManga;
        existingChapterId = isar.chapters.putSync(existingChapter);
        existingChapter.manga.saveSync();
      });

      final (ctx, ref) = await _pumpShell(tester);
      final backupManga = _manga()..id = 900;
      final backupCh1 = Chapter(
        id: 901,
        mangaId: 900,
        name: 'Chapter 1',
        url: '/c1',
        isRead: true,
        isBookmarked: true,
        lastPageRead: '12',
        archivePath: '/remote/other.cbz',
        updatedAt: 2000,
      );
      final backupCh2 = Chapter(
        id: 902,
        mangaId: 900,
        name: 'Chapter 2',
        url: '/c2',
        isRead: false,
        updatedAt: 2000,
      );
      final backupHistory = History(
        id: 950,
        mangaId: 900,
        chapterId: 901,
        itemType: ItemType.manga,
        date: '2000',
        updatedAt: 2000,
        readingTimeSeconds: 180,
      );

      await mergeBackup(tester, ref, ctx, {
        'version': '2',
        'manga': [backupManga.toJson()],
        'chapters': [backupCh1.toJson(), backupCh2.toJson()],
        'history': [backupHistory.toJson()],
      });

      expect(mangaRepository.getAll(), hasLength(1));
      final chapters = chapterRepository.getAllByMangaId(existingMangaId);
      expect(chapters, hasLength(2));

      final mergedCh1 = chapterRepository.findByIdSync(existingChapterId)!;
      expect(mergedCh1.archivePath, '/local/c1.cbz');
      expect(mergedCh1.isRead, isTrue);
      expect(mergedCh1.isBookmarked, isTrue);
      expect(mergedCh1.lastPageRead, '12');

      final addedCh2 = chapters.singleWhere((c) => c.url == '/c2');
      expect(addedCh2.mangaId, existingMangaId);

      final histories = historyRepository.getAllByMangaId(existingMangaId);
      expect(histories, hasLength(1));
      final restoredHistory = histories.single;
      expect(restoredHistory.chapterId, existingChapterId);
      restoredHistory.chapter.loadSync();
      expect(restoredHistory.chapter.value?.id, existingChapterId);
      expect(restoredHistory.readingTimeSeconds, 180);
    },
  );

  testWidgets(
    'merge restore matches URL-less chapters by name and scanlator without colliding on empty URLs',
    (tester) async {
      late int existingMangaId;
      late int ch1Id;
      late int ch2Id;
      isar.writeTxnSync(() {
        final manga = _manga(name: 'Local', link: '/local')..id = 10;
        existingMangaId = isar.mangas.putSync(manga);
        final ch1 = Chapter(
          id: 21,
          mangaId: existingMangaId,
          name: 'Ch 1',
          url: '',
          scanlator: 'Group A',
        )..manga.value = manga;
        final ch2 = Chapter(
          id: 22,
          mangaId: existingMangaId,
          name: 'Ch 2',
          url: '',
          scanlator: 'Group A',
        )..manga.value = manga;
        ch1Id = isar.chapters.putSync(ch1);
        ch1.manga.saveSync();
        ch2Id = isar.chapters.putSync(ch2);
        ch2.manga.saveSync();
      });

      final (ctx, ref) = await _pumpShell(tester);
      final backupManga = _manga(name: 'Local', link: '/local')..id = 500;
      final backupCh1 = Chapter(
        id: 501,
        mangaId: 500,
        name: 'Ch 1',
        url: null,
        scanlator: 'Group A',
      );
      final backupCh2 = Chapter(
        id: 502,
        mangaId: 500,
        name: 'Ch 2',
        url: '',
        scanlator: 'Group A',
      );
      final backupCh1AltScanlator = Chapter(
        id: 503,
        mangaId: 500,
        name: 'Ch 1',
        url: '',
        scanlator: 'Group B',
      );
      final backupHistory = History(
        id: 550,
        mangaId: 500,
        chapterId: 502,
        itemType: ItemType.manga,
        date: '3000',
        updatedAt: 3000,
      );

      await mergeBackup(tester, ref, ctx, {
        'version': '2',
        'manga': [backupManga.toJson()],
        'chapters': [
          backupCh1.toJson(),
          backupCh2.toJson(),
          backupCh1AltScanlator.toJson(),
        ],
        'history': [backupHistory.toJson()],
      });

      final chapters = chapterRepository.getAllByMangaId(existingMangaId);
      expect(chapters, hasLength(3));
      expect(chapters.map((c) => c.id), containsAll([ch1Id, ch2Id]));
      expect(
        chapters.where((c) => c.name == 'Ch 1' && c.scanlator == 'Group B'),
        hasLength(1),
      );

      final histories = historyRepository.getAllByMangaId(existingMangaId);
      expect(histories, hasLength(1));
      expect(histories.single.chapterId, ch2Id);
    },
  );

  testWidgets(
    'merge restore deduplicates history by newest timestamp, preserves max readingTimeSeconds, and is idempotent',
    (tester) async {
      late int existingMangaId;
      late int ch1Id;
      late int ch2Id;
      isar.writeTxnSync(() {
        final manga = _manga()..id = 10;
        existingMangaId = isar.mangas.putSync(manga);
        final ch1 = Chapter(
          id: 21,
          mangaId: existingMangaId,
          name: 'Ch 1',
          url: '/c1',
        )..manga.value = manga;
        final ch2 = Chapter(
          id: 22,
          mangaId: existingMangaId,
          name: 'Ch 2',
          url: '/c2',
        )..manga.value = manga;
        ch1Id = isar.chapters.putSync(ch1);
        ch1.manga.saveSync();
        ch2Id = isar.chapters.putSync(ch2);
        ch2.manga.saveSync();
        final existingHistory = History(
          id: 30,
          mangaId: existingMangaId,
          chapterId: ch1Id,
          itemType: ItemType.manga,
          date: '2000',
          updatedAt: 2000,
          readingTimeSeconds: 300,
        )..chapter.value = ch1;
        isar.historys.putSync(existingHistory);
        existingHistory.chapter.saveSync();
      });

      final (ctx, ref) = await _pumpShell(tester);
      final backupManga = _manga()..id = 700;
      final backupCh1 = Chapter(
        id: 701,
        mangaId: 700,
        name: 'Ch 1',
        url: '/c1',
      );
      final backupCh2 = Chapter(
        id: 702,
        mangaId: 700,
        name: 'Ch 2',
        url: '/c2',
      );

      // Older backup history does not overwrite newer local chapter/date,
      // while still retaining the larger readingTimeSeconds.
      await mergeBackup(tester, ref, ctx, {
        'version': '2',
        'manga': [backupManga.toJson()],
        'chapters': [backupCh1.toJson(), backupCh2.toJson()],
        'history': [
          History(
            id: 750,
            mangaId: 700,
            chapterId: 702,
            itemType: ItemType.manga,
            date: '1000',
            updatedAt: 1000,
            readingTimeSeconds: 500,
          ).toJson(),
        ],
      });

      var histories = historyRepository.getAllByMangaId(existingMangaId);
      expect(histories, hasLength(1));
      expect(histories.single.chapterId, ch1Id);
      expect(histories.single.date, '2000');
      expect(histories.single.readingTimeSeconds, 500);

      // Newer backup history updates chapter/date in place and keeps max time.
      final newerPayload = {
        'version': '2',
        'manga': [backupManga.toJson()],
        'chapters': [backupCh1.toJson(), backupCh2.toJson()],
        'history': [
          History(
            id: 751,
            mangaId: 700,
            chapterId: 702,
            itemType: ItemType.manga,
            date: '3000',
            updatedAt: 3000,
            readingTimeSeconds: 120,
          ).toJson(),
        ],
      };
      await mergeBackup(tester, ref, ctx, newerPayload);
      await mergeBackup(tester, ref, ctx, newerPayload);

      histories = historyRepository.getAllByMangaId(existingMangaId);
      expect(histories, hasLength(1));
      expect(histories.single.chapterId, ch2Id);
      expect(histories.single.date, '3000');
      expect(histories.single.updatedAt, 3000);
      expect(histories.single.readingTimeSeconds, 500);
    },
  );

  testWidgets(
    'merge restore falls back to History.date when updatedAt is zero',
    (tester) async {
      late int existingMangaId;
      late int ch1Id;
      late int ch2Id;
      isar.writeTxnSync(() {
        final manga = _manga()..id = 10;
        existingMangaId = isar.mangas.putSync(manga);
        final ch1 = Chapter(
          id: 21,
          mangaId: existingMangaId,
          name: 'Ch 1',
          url: '/c1',
        )..manga.value = manga;
        final ch2 = Chapter(
          id: 22,
          mangaId: existingMangaId,
          name: 'Ch 2',
          url: '/c2',
        )..manga.value = manga;
        ch1Id = isar.chapters.putSync(ch1);
        ch1.manga.saveSync();
        ch2Id = isar.chapters.putSync(ch2);
        ch2.manga.saveSync();
        final existingHistory = History(
          id: 30,
          mangaId: existingMangaId,
          chapterId: ch1Id,
          itemType: ItemType.manga,
          date: '2000',
          updatedAt: 0,
        )..chapter.value = ch1;
        isar.historys.putSync(existingHistory);
        existingHistory.chapter.saveSync();
      });

      final (ctx, ref) = await _pumpShell(tester);
      final backupManga = _manga()..id = 710;
      final backupCh1 = Chapter(
        id: 711,
        mangaId: 710,
        name: 'Ch 1',
        url: '/c1',
      );
      final backupCh2 = Chapter(
        id: 712,
        mangaId: 710,
        name: 'Ch 2',
        url: '/c2',
      );

      await mergeBackup(tester, ref, ctx, {
        'version': '2',
        'manga': [backupManga.toJson()],
        'chapters': [backupCh1.toJson(), backupCh2.toJson()],
        'history': [
          History(
            id: 760,
            mangaId: 710,
            chapterId: 712,
            itemType: ItemType.manga,
            date: '3000',
            updatedAt: 0,
          ).toJson(),
        ],
      });

      final histories = historyRepository.getAllByMangaId(existingMangaId);
      expect(histories, hasLength(1));
      expect(histories.single.chapterId, ch2Id);
      expect(histories.single.date, '3000');
    },
  );

  testWidgets(
    'merge restore restores and deduplicates updates for existing manga',
    (tester) async {
      late int existingMangaId;
      isar.writeTxnSync(() {
        final manga = _manga()..id = 10;
        existingMangaId = isar.mangas.putSync(manga);
        final ch1 = Chapter(
          id: 21,
          mangaId: existingMangaId,
          name: 'Ch 1',
          url: '/c1',
        )..manga.value = manga;
        final ch2 = Chapter(
          id: 22,
          mangaId: existingMangaId,
          name: 'Ch 2',
          url: '/c2',
        )..manga.value = manga;
        isar.chapters.putAllSync([ch1, ch2]);
        ch1.manga.saveSync();
        ch2.manga.saveSync();

        final existingUpdate = Update(
          id: 40,
          mangaId: existingMangaId,
          chapterName: 'Ch 1',
          date: '1000',
          updatedAt: 1000,
        )..chapter.value = ch1;
        isar.updates.putSync(existingUpdate);
        existingUpdate.chapter.saveSync();
      });

      final (ctx, ref) = await _pumpShell(tester);
      final backupManga = _manga()..id = 800;
      final backupCh1 = Chapter(
        id: 801,
        mangaId: 800,
        name: 'Ch 1',
        url: '/c1',
      );
      final backupCh2 = Chapter(
        id: 802,
        mangaId: 800,
        name: 'Ch 2',
        url: '/c2',
      );
      final payload = {
        'version': '2',
        'manga': [backupManga.toJson()],
        'chapters': [backupCh1.toJson(), backupCh2.toJson()],
        'updates': [
          Update(
            id: 850,
            mangaId: 800,
            chapterName: 'Ch 1',
            date: '2000',
            updatedAt: 2000,
          ).toJson(),
          Update(
            id: 851,
            mangaId: 800,
            chapterName: 'Ch 2',
            date: '2000',
            updatedAt: 2000,
          ).toJson(),
          Update(
            id: 852,
            mangaId: 800,
            chapterName: null,
            date: '2000',
            updatedAt: 2000,
          ).toJson(),
        ],
      };

      await mergeBackup(tester, ref, ctx, payload);
      await mergeBackup(tester, ref, ctx, payload);

      final updates = updateRepository.getAllByMangaId(existingMangaId);
      expect(updates, hasLength(2));
      final ch1Update = updates.singleWhere((u) => u.chapterName == 'Ch 1');
      expect(ch1Update.date, '2000');
      expect(ch1Update.updatedAt, 2000);
      final ch2Update = updates.singleWhere((u) => u.chapterName == 'Ch 2');
      ch2Update.chapter.loadSync();
      expect(ch2Update.chapter.value?.url, '/c2');
    },
  );
}
