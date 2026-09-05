import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';

class HistoryRepository {
  History? findByMangaId(int mangaId) =>
      isar.historys.where().mangaIdEqualTo(mangaId).findFirstSync();

  bool isEmptyForManga(int? mangaId) =>
      isar.historys.filter().mangaIdEqualTo(mangaId).isEmptySync();

  History? findFirstByMangaId(int? mangaId) =>
      isar.historys.filter().mangaIdEqualTo(mangaId).findFirstSync();

  History? findByChapterId(int? chapterId) =>
      isar.historys.filter().chapterIdEqualTo(chapterId).findFirstSync();

  List<History> getAll() => isar.historys.filter().idIsNotNull().findAllSync();

  List<History> getChangedSince(int since) => isar.historys
      .filter()
      .updatedAtGreaterThan(since, include: true)
      .findAllSync();

  History? getByClientId(int clientId) => isar.historys
      .filter()
      .clientIdEqualTo(clientId)
      .or()
      .idEqualTo(clientId)
      .findFirstSync();

  // Async twin, for callers already inside an async writeTxn/writeTransactionAsync
  // — Isar rejects a sync findAllSync() call from inside an async transaction.
  Future<List<History>> getAllAsync() =>
      isar.historys.filter().idIsNotNull().findAll();

  Stream<List<History>> watchByItemType(ItemType itemType) => isar.historys
      .filter()
      .idIsNotNull()
      .and()
      .chapter((q) => q.manga((q) => q.itemTypeEqualTo(itemType)))
      .watch(fireImmediately: true);

  // idIsNotNull() removed — every Isar document has a non-null id.
  // The itemType hash-index on History + the link traversal does the filtering.
  Stream<List<History>> watchByItemTypeAndSearch(
    ItemType itemType,
    String search,
  ) => isar.historys
      .filter()
      .chapter(
        (q) => q.manga(
          (q) => q
              .itemTypeEqualTo(itemType)
              .and()
              .nameContains(search, caseSensitive: false),
        ),
      )
      .watch(fireImmediately: true);

  Future<List<Id>> getIdsByItemType(ItemType itemType) => isar.historys
      .filter()
      .chapter((q) => q.manga((q) => q.itemTypeEqualTo(itemType)))
      .idProperty()
      .findAll();

  Future<List<int?>> getReadingTimesByItemType(ItemType itemType) => isar
      .historys
      .filter()
      .itemTypeEqualTo(itemType)
      .readingTimeSecondsProperty()
      .findAll();

  List<History> getAllByMangaId(int? mangaId) =>
      isar.historys.filter().mangaIdEqualTo(mangaId).findAllSync();

  int countByMangaIds(List<int> mangaIds) => isar.historys
      .filter()
      .anyOf(mangaIds, (q, id) => q.mangaIdEqualTo(id))
      .countSync();

  List<History> getAllByMangaIdSortedByDate(int? mangaId) =>
      isar.historys.filter().mangaIdEqualTo(mangaId).sortByDate().findAllSync();

  // Stamps updatedAt for callers that just want to persist a mutated History
  // they already hold, without setting the timestamp themselves. Also saves
  // its chapter link, since every current caller needs that too.
  Future<void> save(History history) => dbWriteQueue.run(() {
    isar.writeTxnSync(() {
      history.updatedAt = DateTime.now().millisecondsSinceEpoch;
      isar.historys.putSync(history);
      history.chapter.saveSync();
    });
  });

  Future<void> deleteAll(List<int> ids) =>
      dbWriteQueue.run(() => isar.writeTxn(() => isar.historys.deleteAll(ids)));

  Future<void> delete(WidgetRef ref, int id) => dbWriteQueue.run(() {
    isar.writeTxnSync(() {
      final clientId = isar.historys.getSync(id)?.clientId;
      isar.historys.deleteSync(id);
      ref
          .read(synchingProvider(syncId: 1).notifier)
          .addChangedPart(
            ActionType.removeHistory,
            id,
            "{}",
            false,
            clientId: clientId,
          );
    });
  });

  // Sync primitives below are for callers already inside a write transaction
  // opened by transaction()/writeTransaction() — they don't queue on their own.

  void deleteSync(int id) => isar.historys.deleteSync(id);

  void putSync(History history) => isar.historys.putSync(history);

  void putAllSync(List<History> histories) =>
      isar.historys.putAllSync(histories);

  void clearSync() => isar.historys.clearSync();

  Future<int> putAsync(History history) => isar.historys.put(history);

  Future<bool> deleteAsync(int id) => isar.historys.delete(id);

  // Escape hatch for history-rooted transactions too specific to name.
  Future<T> transaction<T>(FutureOr<T> Function() body) =>
      dbWriteQueue.run(body);

  // Same, but opens the write transaction too, so callers never touch isar.
  Future<T> writeTransaction<T>(T Function() body) =>
      dbWriteQueue.run(() => isar.writeTxnSync(body));

  Future<T> writeTransactionAsync<T>(Future<T> Function() body) =>
      dbWriteQueue.run(() => isar.writeTxn(body));
}

final historyRepository = HistoryRepository();
