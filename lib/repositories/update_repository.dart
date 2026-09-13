import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';

class UpdateRepository {
  List<Update> getAll() => isar.updates.filter().idIsNotNull().findAllSync();

  List<Update> getChangedSince(int since) => isar.updates
      .filter()
      .updatedAtGreaterThan(since, include: true)
      .findAllSync();

  Update? getByClientId(int clientId) => isar.updates
      .filter()
      .clientIdEqualTo(clientId)
      .or()
      .idEqualTo(clientId)
      .findFirstSync();

  Update? findByMangaIdAndChapterName(int? mangaId, String? chapterName) => isar
      .updates
      .filter()
      .mangaIdEqualTo(mangaId)
      .chapterNameEqualTo(chapterName)
      .findFirstSync();

  // Async twin, for callers already inside an async writeTxn/writeTransactionAsync
  // — Isar rejects a sync findAllSync() call from inside an async transaction.
  Future<List<Update>> getAllAsync() =>
      isar.updates.filter().idIsNotNull().findAll();

  List<Update> getAllByMangaId(int? mangaId) =>
      isar.updates.filter().mangaIdEqualTo(mangaId).findAllSync();

  Stream<List<Update>> watchByItemType(ItemType itemType) => isar.updates
      .filter()
      .idIsNotNull()
      .chapter((q) => q.manga((q) => q.itemTypeEqualTo(itemType)))
      .watch(fireImmediately: true);

  Future<List<Id>> getIdsByItemType(ItemType itemType) => isar.updates
      .filter()
      .idIsNotNull()
      .chapter((q) => q.manga((q) => q.itemTypeEqualTo(itemType)))
      .idProperty()
      .findAll();

  // Filter unread in the query itself — loading every linked chapter with
  // loadSync() in the builder ran N+1 sync DB reads on the always-mounted nav
  // bar for every update write.
  Stream<List<Update>> watchUnreadExcludingHiddenItemTypes({
    required bool hideManga,
    required bool hideAnime,
    required bool hideNovel,
  }) => isar.updates
      .filter()
      .optional(
        hideManga,
        (q) => q.chapter(
          (c) => c.manga((m) => m.not().itemTypeEqualTo(ItemType.manga)),
        ),
      )
      .optional(
        hideAnime,
        (q) => q.chapter(
          (c) => c.manga((m) => m.not().itemTypeEqualTo(ItemType.anime)),
        ),
      )
      .optional(
        hideNovel,
        (q) => q.chapter(
          (c) => c.manga((m) => m.not().itemTypeEqualTo(ItemType.novel)),
        ),
      )
      .chapter((c) => c.not().isReadEqualTo(true))
      .watch(fireImmediately: true);

  Stream<List<Update>> watchByMangaIds(List<int> mangaIds) => isar.updates
      .filter()
      .anyOf(mangaIds, (q, int id) => q.mangaIdEqualTo(id))
      .watch(fireImmediately: true);

  int countByMangaIds(List<int> mangaIds) => isar.updates
      .filter()
      .anyOf(mangaIds, (q, id) => q.mangaIdEqualTo(id))
      .countSync();

  // Notifies the sync provider for each id first (its own transaction,
  // matching the original two-step shape), then deletes the rows.
  Future<void> deleteAll(WidgetRef ref, List<int> ids) async {
    await dbWriteQueue.run(() {
      isar.writeTxnSync(() {
        for (var id in ids) {
          final clientId = isar.updates.getSync(id)?.clientId;
          ref
              .read(synchingProvider(syncId: 1).notifier)
              .addChangedPart(
                ActionType.removeUpdate,
                id,
                "{}",
                false,
                clientId: clientId,
              );
        }
      });
    });
    await dbWriteQueue.run(
      () => isar.writeTxn(() => isar.updates.deleteAll(ids)),
    );
  }

  // Sync primitive below is for callers already inside a write transaction
  // opened by transaction()/writeTransaction() — it doesn't queue on its own.
  void deleteAllByMangaIdSync(int? mangaId) =>
      isar.updates.where().mangaIdEqualTo(mangaId).deleteAllSync();

  void putSync(Update update) => isar.updates.putSync(update);

  void putAllSync(List<Update> updates) => isar.updates.putAllSync(updates);

  void clearSync() => isar.updates.clearSync();

  Future<void> putAllAsync(List<Update> updates) =>
      isar.updates.putAll(updates);

  Future<int> putAsync(Update update) => isar.updates.put(update);

  Future<bool> deleteAsync(int id) => isar.updates.delete(id);

  // Escape hatch for update-rooted transactions too specific to name.
  Future<T> transaction<T>(FutureOr<T> Function() body) =>
      dbWriteQueue.run(body);

  // Same, but opens the write transaction too, so callers never touch isar.
  Future<T> writeTransaction<T>(T Function() body) =>
      dbWriteQueue.run(() => isar.writeTxnSync(body));

  Future<T> writeTransactionAsync<T>(Future<T> Function() body) =>
      dbWriteQueue.run(() => isar.writeTxn(body));
}

final updateRepository = UpdateRepository();
