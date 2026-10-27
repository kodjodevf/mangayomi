import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/reading_log.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/modules/anime/providers/anime_player_controller_provider.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/novel/novel_reader_controller_provider.dart';
import 'package:mangayomi/modules/reader_common/mixins/chapter_controller_mixin.dart';
import 'package:mangayomi/repositories/history_repository.dart';

class _Reader with ChapterControllerMixin {
  _Reader(this.chapter, {this.incognito = false});

  @override
  final Chapter chapter;

  final bool incognito;

  @override
  bool get incognitoMode => incognito;
}

void main() {
  late Directory databaseDirectory;
  late Isar database;
  late ProviderContainer container;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    beginReadingSession();
    databaseDirectory = await Directory.systemTemp.createTemp(
      'mangayomi-reading-log-hooks-',
    );
    database = await Isar.open(
      [
        MangaSchema,
        ChapterSchema,
        HistorySchema,
        ReadingLogSchema,
        SettingsSchema,
        SourceSchema,
        TrackSchema,
        SyncPreferenceSchema,
        ChangedPartSchema,
      ],
      directory: databaseDirectory.path,
      name: 'reading_log_hooks_test',
    );
    app.isar = database;
    await database.writeTxn(() => database.settings.put(Settings()));
    container = ProviderContainer();
  });

  tearDown(() async {
    container.dispose();
    await database.close(deleteFromDisk: true);
    if (await databaseDirectory.exists()) {
      await databaseDirectory.delete(recursive: true);
    }
  });

  Future<Chapter> seedChapter({
    ItemType itemType = ItemType.manga,
    bool isRead = false,
  }) async {
    final manga = Manga(
      source: 'Source',
      author: '',
      artist: '',
      genre: const [],
      imageUrl: null,
      lang: 'en',
      link: '/series',
      name: 'Series',
      status: Status.ongoing,
      description: '',
      sourceId: 1,
      itemType: itemType,
      favorite: true,
    );
    await database.writeTxn(() => database.mangas.put(manga));
    final chapter = Chapter(mangaId: manga.id, name: 'Ch 1', isRead: isRead)
      ..manga.value = manga;
    await database.writeTxn(() async {
      await database.chapters.put(chapter);
      await chapter.manga.save();
    });
    return chapter;
  }

  List<ReadingLog> rows(ReadingLogKind kind) => database.readingLogs
      .where()
      .findAllSync()
      .where((r) => r.kind == kind)
      .toList();

  test('time row written for positive seconds', () async {
    final chapter = await seedChapter();

    await _Reader(chapter).setHistoryUpdate(elapsedSeconds: 30);

    final time = rows(ReadingLogKind.time).single;
    expect(time.seconds, 30);
    expect(time.mangaId, chapter.mangaId);
    expect(time.chapterId, chapter.id);
    expect(time.itemType, ItemType.manga);
    expect(
      (await database.historys.where().findFirst())?.readingTimeSeconds,
      30,
    );
  });

  test('no row for zero seconds', () async {
    final chapter = await seedChapter();

    await _Reader(chapter).setHistoryUpdate();

    expect(database.readingLogs.countSync(), 0);
  });

  test('nothing written in incognito', () async {
    final chapter = await seedChapter();
    final reader = _Reader(chapter, incognito: true);

    await reader.setHistoryUpdate(elapsedSeconds: 30);
    await reader.logCompletionOnce();

    expect(database.readingLogs.countSync(), 0);
    expect(database.historys.countSync(), 0);
  });

  test('two quick saves both add their time', () async {
    final chapter = await seedChapter();
    final reader = _Reader(chapter);

    await Future.wait([
      reader.setHistoryUpdate(elapsedSeconds: 5),
      reader.setHistoryUpdate(elapsedSeconds: 7),
    ]);

    expect(
      (await database.historys.where().findFirst())?.readingTimeSeconds,
      12,
    );
    expect(rows(ReadingLogKind.time).map((r) => r.seconds).toList()..sort(), [
      5,
      7,
    ]);
  });

  test('completion logged once even when called twice', () async {
    final chapter = await seedChapter();
    final reader = _Reader(chapter);

    await reader.logCompletionOnce();
    await reader.logCompletionOnce();

    final completion = rows(ReadingLogKind.completion).single;
    expect(completion.chapterId, chapter.id);
    expect(completion.mangaId, chapter.mangaId);
  });

  test('re-reading a read manga chapter logs a completion', () async {
    final chapter = await seedChapter(isRead: true);
    final controller = container.read(
      readerControllerProvider(chapter: chapter).notifier,
    );
    final pages = List.filled(10, '');

    controller.setPageIndex(2, false, pages);
    expect(rows(ReadingLogKind.completion), isEmpty);
    controller.setPageIndex(9, false, pages);
    controller.setPageIndex(8, false, pages);
    controller.setPageIndex(9, false, pages);
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(rows(ReadingLogKind.completion), hasLength(1));
  });

  /// Reaches the last page of [chapter], then releases its controller the
  /// way continuous mode does when the reader scrolls on to the next chapter.
  Future<void> readToEnd(Chapter chapter) async {
    final controller = container.read(
      readerControllerProvider(chapter: chapter).notifier,
    );
    controller.setPageIndex(9, false, List.filled(10, ''));
    await Future<void>.delayed(const Duration(milliseconds: 50));
    controller.keepAliveLink?.close();
    // Let the now-unused controller dispose.
    await Future<void>.delayed(Duration.zero);
  }

  test(
    'continuous mode rebuilding a controller logs no second completion',
    () async {
      // Scrolling back over a chapter boundary disposes and recreates the
      // previous chapter's controller within the same reading session.
      final chapter = await seedChapter();

      await readToEnd(chapter);
      await readToEnd(chapter);

      expect(rows(ReadingLogKind.completion), hasLength(1));
    },
  );

  test('opening the reader again counts a re-read', () async {
    final chapter = await seedChapter();

    await readToEnd(chapter);
    beginReadingSession();
    await readToEnd(chapter);

    expect(rows(ReadingLogKind.completion), hasLength(2));
  });

  test('re-watching a seen episode logs a completion', () async {
    final episode = await seedChapter(itemType: ItemType.anime, isRead: true);
    final controller = container.read(
      animeStreamControllerProvider(episode: episode).notifier,
    );

    controller.setCurrentPosition(
      const Duration(minutes: 24),
      const Duration(minutes: 24),
    );
    controller.setCurrentPosition(
      const Duration(minutes: 24),
      const Duration(minutes: 24),
    );
    await Future<void>.delayed(const Duration(milliseconds: 50));

    final completion = rows(ReadingLogKind.completion).single;
    expect(completion.itemType, ItemType.anime);
  });

  test('re-reading a read novel chapter logs a completion', () async {
    final chapter = await seedChapter(itemType: ItemType.novel, isRead: true);
    final controller = container.read(
      novelReaderControllerProvider(chapter: chapter).notifier,
    );

    controller.setChapterOffset(50, 100, false);
    expect(rows(ReadingLogKind.completion), isEmpty);
    controller.setChapterOffset(95, 100, false);
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(rows(ReadingLogKind.completion), hasLength(1));
  });

  test('clearing history for a series deletes its log rows', () async {
    final chapter = await seedChapter();
    final reader = _Reader(chapter);
    await reader.setHistoryUpdate(elapsedSeconds: 30);
    await reader.logCompletionOnce();
    final history = await database.historys.where().findFirst();

    await historyRepository.delete(history!.id!);

    expect(database.readingLogs.countSync(), 0);
  });

  test('clear all deletes the log rows of those series', () async {
    final chapter = await seedChapter();
    await _Reader(chapter).setHistoryUpdate(elapsedSeconds: 30);
    final ids = await historyRepository.getIdsByItemType(ItemType.manga);

    await historyRepository.deleteAll(ids);

    expect(database.readingLogs.countSync(), 0);
  });
}
