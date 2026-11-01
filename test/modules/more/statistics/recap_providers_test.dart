import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/reading_log.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_providers.dart';

const _series = 500;
const _chapters = 60;
const _logRows = 2000;

/// Local time of log row [k]: August–October 2026, spread over days and hours.
DateTime _logTime(int k) =>
    DateTime(2026, 8 + k % 3, 1 + k % 28, k % 24, k % 60);

int _logMangaIndex(int k) => k % _series;

ReadingLogKind _logKind(int k) =>
    k.isEven ? ReadingLogKind.completion : ReadingLogKind.time;

void main() {
  late Directory directory;
  late Isar database;
  late ProviderContainer container;
  late List<int> mangaIds;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('recap-providers-');
    database = await Isar.open(
      [MangaSchema, ChapterSchema, HistorySchema, ReadingLogSchema],
      directory: directory.path,
      name: 'recap_providers_test',
    );
    app.isar = database;
    container = ProviderContainer();

    database.writeTxnSync(() {
      final mangas = [
        for (var i = 0; i < _series; i++)
          Manga(
            source: i < 150 ? 'Asura Scans' : 'Source ${i % 7}',
            author: '',
            artist: '',
            genre: i < 300 ? ['Action', 'Regression'] : ['Romance'],
            imageUrl: null,
            lang: 'en',
            link: '/series/$i',
            name: 'Series $i',
            status: i < 20 ? Status.completed : Status.ongoing,
            description: '',
            sourceId: 1,
            favorite: true,
            dateAdded: DateTime(2024, 1, 1 + i % 28).millisecondsSinceEpoch,
          ),
      ];
      database.mangas.putAllSync(mangas);
      mangaIds = [for (final m in mangas) m.id!];
      database.chapters.putAllSync([
        for (final manga in mangas)
          for (var c = 0; c < _chapters; c++)
            Chapter(
              mangaId: manga.id,
              name: 'Ch $c',
              // The first 20 series are fully read and completed (cleared).
              isRead: mangaIds.indexOf(manga.id!) < 20 || c < _chapters / 2,
            )..manga.value = manga,
      ]);
      database.historys.putAllSync([
        for (var i = 0; i < 400; i++)
          History(
            mangaId: mangas[i].id,
            chapterId: null,
            itemType: ItemType.manga,
            date: '${DateTime(2026, 7, 1, 3).millisecondsSinceEpoch}',
            readingTimeSeconds: 60,
          ),
      ]);
      database.readingLogs.putAllSync([
        for (var k = 0; k < _logRows; k++)
          ReadingLog(
            mangaId: mangaIds[_logMangaIndex(k)],
            itemType: ItemType.manga,
            at: _logTime(k).millisecondsSinceEpoch,
            kind: _logKind(k),
            seconds: _logKind(k) == ReadingLogKind.time ? 30 : 0,
          ),
      ]);
    });
  });

  tearDown(() async {
    container.dispose();
    await database.close(deleteFromDisk: true);
    if (await directory.exists()) await directory.delete(recursive: true);
  });

  test('statusWindow completes under 3 s and matches counts', () async {
    final stopwatch = Stopwatch()..start();
    final data = await container.read(
      statusWindowProvider(itemType: ItemType.manga).future,
    );
    stopwatch.stop();

    expect(stopwatch.elapsed, lessThan(const Duration(seconds: 3)));
    expect(data.units, 20 * _chapters + 480 * _chapters ~/ 2);
    expect(data.libraryCount, _series);
    expect(data.clearedCount, 20);
    expect(data.totalSeconds, 400 * 60);
    expect(data.since, DateTime(2024, 1, 1));
    expect(data.epithet.source, 'Asura Scans');
    expect(data.skills.first.genre, 'Action');
    // Clock comes from the log: every row counted once.
    expect(data.hourHistogram.fold<int>(0, (a, b) => a + b), _logRows);
    // Every read series, for the full list.
    expect(data.bonded, hasLength(_series));
  });

  test('episodeList lists 3 months newest first', () async {
    final list = await container.read(
      episodeListProvider(itemType: ItemType.manga).future,
    );

    expect(list.months.map((m) => m.month), [
      DateTime(2026, 10),
      DateTime(2026, 9),
      DateTime(2026, 8),
    ]);
    final october = list.months.first;
    final octoberRows = [
      for (var k = 0; k < _logRows; k++)
        if (_logTime(k).month == 10) k,
    ];
    expect(
      october.completions,
      octoberRows.where((k) => _logKind(k) == ReadingLogKind.completion).length,
    );
    expect(
      october.seconds,
      30 * octoberRows.where((k) => _logKind(k) == ReadingLogKind.time).length,
    );
    expect(october.coverMangaIds.length, lessThanOrEqualTo(4));
    expect(list.prologue.libraryCount, _series);
  });

  test('episode ignores rows for deleted series', () async {
    final deleted = mangaIds[_logMangaIndex(0)];
    await database.writeTxn(() => database.mangas.delete(deleted));

    final stats = await container.read(
      episodeProvider(itemType: ItemType.manga, year: 2026, month: 8).future,
    );

    final expected = [
      for (var k = 0; k < _logRows; k++)
        if (_logTime(k).month == 8 &&
            _logKind(k) == ReadingLogKind.completion &&
            mangaIds[_logMangaIndex(k)] != deleted)
          k,
    ].length;
    expect(stats.completions, expected);
    expect(stats.month, DateTime(2026, 8));
    expect(stats.previousSeconds, isNull);
    expect(
      (await container.read(
        episodeProvider(itemType: ItemType.manga, year: 2026, month: 9).future,
      )).previousSeconds,
      isNotNull,
    );
  });

  test('finished lists a series only in its last completion month', () async {
    // Series 0 is fully read, with completions in August, September and
    // October: it was caught up in October, not before.
    final caughtUp = mangaIds[0];
    Future<List<int>> finishedIn(int month) async => (await container.read(
      episodeProvider(
        itemType: ItemType.manga,
        year: 2026,
        month: month,
      ).future,
    )).finishedIds;

    expect(await finishedIn(8), isNot(contains(caughtUp)));
    expect(await finishedIn(9), isNot(contains(caughtUp)));
    expect(await finishedIn(10), contains(caughtUp));
  });

  test('clock falls back to History.date when the log is empty', () async {
    await database.writeTxn(() => database.readingLogs.clear());

    final data = await container.read(
      statusWindowProvider(itemType: ItemType.manga).future,
    );

    expect(data.hourHistogram[3], 400);
    expect(data.hourHistogram.fold<int>(0, (a, b) => a + b), 400);
  });

  test(
    'without a History date a bond runs to the newest read chapter',
    () async {
      // Restores before the restore fix left History dated 1970; a read
      // chapter's upload date is the next best sign of when it was read.
      final upload = DateTime(2026, 10, 1).millisecondsSinceEpoch;
      final later = DateTime(2026, 10, 20).millisecondsSinceEpoch;
      final id = mangaIds[450];
      await database.writeTxn(() async {
        final chapters = await database.chapters
            .filter()
            .mangaIdEqualTo(id)
            .findAll();
        for (final chapter in chapters) {
          // Read chapters are the first half; an unread one came out later.
          chapter.dateUpload = chapter.isRead! ? '$upload' : '$later';
        }
        await database.chapters.putAll(chapters);
      });

      final data = await container.read(
        statusWindowProvider(itemType: ItemType.manga).future,
      );

      expect(data.bonded.first.id, id);
      expect(data.bonded.first.lastReadMs, upload);
    },
  );
}
