import 'dart:async';

import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';

class DownloadRepository {
  Future<List<int>> getAllIds() =>
      isar.downloads.where().idProperty().findAll();

  List<Download> getAll() =>
      isar.downloads.filter().idIsNotNull().findAllSync();

  Download? getByChapterId(int? chapterId) =>
      isar.downloads.filter().idEqualTo(chapterId).findFirstSync();

  Download? getById(int id) => isar.downloads.getSync(id);

  Stream<List<Download>> watchByChapterId(int? chapterId) => isar.downloads
      .filter()
      .idEqualTo(chapterId)
      .watch(fireImmediately: true);

  List<int> getDownloadedIdsAmong(List<int> chapterIds) => isar.downloads
      .where()
      .anyOf(chapterIds, (q, id) => q.idEqualTo(id))
      .filter()
      .isDownloadEqualTo(true)
      .findAllSync()
      .map((d) => d.id!)
      .toList();

  Future<int> countDownloadedByFavoriteItemType(ItemType itemType) => isar
      .downloads
      .filter()
      .chapter(
        (q) =>
            q.manga((m) => m.favoriteEqualTo(true).itemTypeEqualTo(itemType)),
      )
      .isDownloadEqualTo(true)
      .count();

  Stream<List<Download>> watchDownloaded() =>
      isar.downloads.where().isDownloadEqualTo(true).watch(fireImmediately: true);

  Stream<List<Download>> watchPendingStarted() => isar.downloads
      .filter()
      .idIsNotNull()
      .isDownloadEqualTo(false)
      .isStartDownloadEqualTo(true)
      .watch(fireImmediately: true);

  Future<List<Download>> getPendingStarted() => isar.downloads
      .filter()
      .idIsNotNull()
      .isDownloadEqualTo(false)
      .isStartDownloadEqualTo(true)
      .findAll();

  // No updatedAt stamping - Download has no such field.
  Future<void> save(Download download) => dbWriteQueue.run(
    () => isar.writeTxnSync(() => isar.downloads.putSync(download)),
  );

  Future<void> delete(int id) => dbWriteQueue.run(
    () => isar.writeTxnSync(() => isar.downloads.deleteSync(id)),
  );

  Future<void> deleteAll(List<int> ids) => dbWriteQueue.run(() {
    isar.writeTxnSync(() {
      for (final id in ids) {
        isar.downloads.deleteSync(id);
      }
    });
  });

  // Escape hatch for download-rooted read transactions too specific to name.
  Future<T> transaction<T>(T Function() body) =>
      dbWriteQueue.run(() => isar.txnSync(body));

  // Sync primitives below are for callers already inside a write transaction
  // opened by another repository's transaction()/writeTransaction() (e.g.
  // restoreRepository) — they don't queue on their own.
  void putAllSync(List<Download> downloads) =>
      isar.downloads.putAllSync(downloads);

  void clearSync() => isar.downloads.clearSync();
}

final downloadRepository = DownloadRepository();
