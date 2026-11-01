import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/reading_log.dart';
import 'package:mangayomi/repositories/reading_log_repository.dart';

ReadingLog _row(
  int mangaId,
  int at, {
  int? chapterId,
  ItemType itemType = ItemType.manga,
  ReadingLogKind kind = ReadingLogKind.completion,
  int seconds = 0,
}) => ReadingLog(
  mangaId: mangaId,
  chapterId: chapterId,
  itemType: itemType,
  at: at,
  kind: kind,
  seconds: seconds,
);

void main() {
  late Directory directory;

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
    directory = Directory.systemTemp.createTempSync('reading_log');
    isar = await Isar.open(
      [ReadingLogSchema],
      directory: directory.path,
      name: 'reading_log_${directory.path.hashCode}',
    );
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  });

  test('getRange is half-open and per type', () async {
    await readingLogRepository.add(_row(1, 100));
    await readingLogRepository.add(_row(1, 200));
    await readingLogRepository.add(_row(2, 150, itemType: ItemType.anime));

    final rows = await readingLogRepository.getRange(ItemType.manga, 100, 200);

    expect(rows.map((r) => r.at), [100]);
    expect(await readingLogRepository.getAllAt(ItemType.manga), [100, 200]);
    expect(await readingLogRepository.firstAt(ItemType.anime), 150);
    expect(await readingLogRepository.firstAt(ItemType.novel), isNull);
  });

  test('mangaIdsBefore returns only earlier rows', () async {
    await readingLogRepository.add(_row(1, 100));
    await readingLogRepository.add(_row(2, 300));

    expect(await readingLogRepository.mangaIdsBefore(ItemType.manga, 300), [1]);
  });

  test('deleteByMangaIds removes only those series', () async {
    await readingLogRepository.add(_row(1, 100));
    await readingLogRepository.add(_row(2, 200));
    await readingLogRepository.add(_row(3, 300));

    await readingLogRepository.deleteByMangaIds([1, 3]);

    expect(readingLogRepository.getAllSync().map((r) => r.mangaId), [2]);
    await readingLogRepository.clear();
    expect(readingLogRepository.getAllSync(), isEmpty);
  });

  test('moveManga remaps series and chapters', () async {
    await readingLogRepository.add(_row(1, 100, chapterId: 10));
    await readingLogRepository.add(_row(1, 200, chapterId: 11));
    await readingLogRepository.add(_row(2, 300, chapterId: 20));

    await readingLogRepository.moveManga(1, 5, {10: 50});

    final rows = readingLogRepository.getAllSync()
      ..sort((a, b) => a.at.compareTo(b.at));
    expect(rows.map((r) => (r.mangaId, r.chapterId)), [
      (5, 50),
      (5, null),
      (2, 20),
    ]);
  });

  test('existsSync matches series, chapter, time and kind', () async {
    await readingLogRepository.add(_row(1, 100, chapterId: 10));

    expect(
      readingLogRepository.existsSync(1, 10, 100, ReadingLogKind.completion),
      isTrue,
    );
    expect(
      readingLogRepository.existsSync(1, 10, 100, ReadingLogKind.time),
      isFalse,
    );
  });

  test('toJson/fromJson round-trips every field', () {
    final row = _row(
      4,
      1234,
      chapterId: 9,
      itemType: ItemType.novel,
      kind: ReadingLogKind.time,
      seconds: 61,
    )..id = 7;

    final copy = ReadingLog.fromJson(row.toJson());

    expect(copy.toJson(), row.toJson());
    expect(copy.id, 7);
    expect(copy.mangaId, 4);
    expect(copy.chapterId, 9);
    expect(copy.itemType, ItemType.novel);
    expect(copy.at, 1234);
    expect(copy.kind, ReadingLogKind.time);
    expect(copy.seconds, 61);
  });
}
