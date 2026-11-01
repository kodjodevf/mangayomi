import 'package:isar_community/isar.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/reading_log.dart';
import 'package:mangayomi/repositories/db.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';

class ReadingLogRepository {
  Future<void> add(ReadingLog row) => dbWriteQueue.run(
    () => isar.writeTxnSync(() => isar.readingLogs.putSync(row)),
  );

  /// Rows of [itemType] with `at` in [fromMs, toMs).
  Future<List<ReadingLog>> getRange(ItemType itemType, int fromMs, int toMs) =>
      isar.readingLogs
          .where()
          .atBetween(fromMs, toMs, includeUpper: false)
          .filter()
          .itemTypeEqualTo(itemType)
          .findAll();

  Future<List<int>> getAllAt(ItemType itemType) => isar.readingLogs
      .where()
      .itemTypeEqualTo(itemType)
      .sortByAt()
      .atProperty()
      .findAll();

  Future<int?> firstAt(ItemType itemType) => isar.readingLogs
      .where()
      .itemTypeEqualTo(itemType)
      .sortByAt()
      .atProperty()
      .findFirst();

  Future<List<int?>> mangaIdsBefore(ItemType itemType, int ms) => isar
      .readingLogs
      .where()
      .atLessThan(ms)
      .filter()
      .itemTypeEqualTo(itemType)
      .mangaIdProperty()
      .findAll();

  /// Series of [itemType] with a completion at or after [ms].
  Future<Set<int>> mangaIdsCompletedFrom(ItemType itemType, int ms) async => {
    ...(await isar.readingLogs
            .where()
            .atGreaterThan(ms, include: true)
            .filter()
            .itemTypeEqualTo(itemType)
            .kindEqualTo(ReadingLogKind.completion)
            .mangaIdProperty()
            .findAll())
        .whereType<int>(),
  };

  Future<void> deleteByMangaIds(List<int> mangaIds) => dbWriteQueue.run(
    () => isar.writeTxnSync(() => deleteByMangaIdsSync(mangaIds)),
  );

  Future<void> clear() =>
      dbWriteQueue.run(() => isar.writeTxnSync(() => clearSync()));

  /// Points a series' rows at [toId], e.g. after a migration or merge.
  /// Chapter ids go through [chapterRemap]; unmapped ones become null.
  Future<void> moveManga(int fromId, int toId, Map<int, int> chapterRemap) =>
      dbWriteQueue.run(
        () =>
            isar.writeTxnSync(() => moveMangaSync(fromId, toId, chapterRemap)),
      );

  // Sync primitives below are for callers already inside a write transaction.

  void deleteByMangaIdsSync(List<int> mangaIds) {
    if (mangaIds.isEmpty) return;
    isar.readingLogs
        .where()
        .anyOf(mangaIds, (q, id) => q.mangaIdEqualTo(id))
        .deleteAllSync();
  }

  void moveMangaSync(int fromId, int toId, Map<int, int> chapterRemap) {
    final rows = isar.readingLogs.where().mangaIdEqualTo(fromId).findAllSync();
    for (final row in rows) {
      row.mangaId = toId;
      row.chapterId = chapterRemap[row.chapterId];
    }
    isar.readingLogs.putAllSync(rows);
  }

  void clearSync() => isar.readingLogs.clearSync();

  List<ReadingLog> getAllSync() => isar.readingLogs.where().findAllSync();

  void putAllSync(List<ReadingLog> rows) => isar.readingLogs.putAllSync(rows);

  bool existsSync(int mangaId, int? chapterId, int at, ReadingLogKind kind) =>
      isar.readingLogs
          .where()
          .mangaIdEqualTo(mangaId)
          .filter()
          .chapterIdEqualTo(chapterId)
          .atEqualTo(at)
          .kindEqualTo(kind)
          .isNotEmptySync();
}

final readingLogRepository = ReadingLogRepository();
