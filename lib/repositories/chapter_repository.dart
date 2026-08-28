import 'dart:async';

import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';

class ChapterRepository {
  Chapter getById(int id) => isar.chapters.getSync(id)!;

  Future<Chapter?> findById(int id) => isar.chapters.get(id);

  Chapter? findByIdSync(int id) => isar.chapters.getSync(id);

  Chapter? findByMangaIdAndName(int? mangaId, String? name) => isar.chapters
      .filter()
      .mangaIdEqualTo(mangaId)
      .nameEqualTo(name)
      .findFirstSync();

  Future<Chapter?> findByMangaIdAndNameAsync(int? mangaId, String? name) => isar
      .chapters
      .filter()
      .mangaIdEqualTo(mangaId)
      .nameEqualTo(name)
      .findFirst();

  List<Chapter> getAll() => isar.chapters.filter().idIsNotNull().findAllSync();

  // Async twin, for callers already inside an async writeTxn/writeTransactionAsync
  // — Isar rejects a sync findAllSync() call from inside an async transaction.
  Future<List<Chapter>> getAllAsync() =>
      isar.chapters.filter().idIsNotNull().findAll();

  Future<List<Chapter>> getAllByMangaIds(Iterable<int?> mangaIds) => isar
      .chapters
      .filter()
      .anyOf(mangaIds, (q, id) => q.mangaIdEqualTo(id))
      .findAll();

  List<Chapter?> getAllByIds(List<int> ids) => isar.chapters.getAllSync(ids);

  List<Chapter> getAllByMangaId(int? mangaId) =>
      isar.chapters.filter().mangaIdEqualTo(mangaId).findAllSync();

  Chapter? findLatestByMangaId(int? mangaId) => isar.chapters
      .filter()
      .mangaIdEqualTo(mangaId)
      .sortByDateUploadDesc()
      .findFirstSync();

  int countByMangaId(int? mangaId) =>
      isar.chapters.filter().mangaIdEqualTo(mangaId).countSync();

  Future<int> countByMangaIdAsync(int? mangaId) =>
      isar.chapters.filter().mangaIdEqualTo(mangaId).count();

  Future<int> countUnreadByMangaId(int? mangaId) => isar.chapters
      .filter()
      .mangaIdEqualTo(mangaId)
      .isReadEqualTo(false)
      .count();

  Future<int> countByFavoriteItemType(ItemType itemType) => isar.chapters
      .filter()
      .manga((q) => q.favoriteEqualTo(true).itemTypeEqualTo(itemType))
      .count();

  Future<int> countReadByFavoriteItemType(ItemType itemType) => isar.chapters
      .filter()
      .manga((q) => q.favoriteEqualTo(true).itemTypeEqualTo(itemType))
      .isReadEqualTo(true)
      .count();

  int countByMangaIds(List<int> mangaIds) => isar.chapters
      .filter()
      .anyOf(mangaIds, (q, id) => q.mangaIdEqualTo(id))
      .countSync();

  // Composite-index where() lookup: every chapter for a manga, any isRead value.
  List<Chapter> getAllByMangaIdIndex(int? mangaId) =>
      isar.chapters.where().mangaIdEqualToAnyIsRead(mangaId).findAllSync();

  Stream<List<Chapter>> watchByMangaId(int mangaId) => isar.chapters
      .filter()
      .manga((q) => q.idEqualTo(mangaId))
      .watch(fireImmediately: true);

  // Stamps updatedAt for callers that just want to persist a mutated Chapter
  // they already hold, without setting the timestamp themselves.
  Future<void> save(Chapter chapter) => dbWriteQueue.run(() {
    isar.writeTxnSync(() {
      chapter.updatedAt = DateTime.now().millisecondsSinceEpoch;
      isar.chapters.putSync(chapter);
    });
  });

  Future<void> putAll(List<Chapter> chapters) => dbWriteQueue.run(
    () => isar.writeTxnSync(() => isar.chapters.putAllSync(chapters)),
  );

  // Same transaction as putAll, plus the parent Manga (e.g. bumping its
  // updatedAt/read state alongside a batch of chapter changes).
  Future<void> putAllWithManga(List<Chapter> chapters, Manga manga) =>
      dbWriteQueue.run(() {
        isar.writeTxnSync(() {
          isar.chapters.putAllSync(chapters);
          isar.mangas.putSync(manga);
        });
      });

  Future<void> deleteAll(List<int> ids) =>
      dbWriteQueue.run(() => isar.writeTxn(() => isar.chapters.deleteAll(ids)));

  // Sync primitives below are for callers already inside a write transaction
  // opened by transaction()/writeTransaction() — they don't queue on their own.

  void deleteSync(int id) => isar.chapters.deleteSync(id);

  int putSync(Chapter chapter) => isar.chapters.putSync(chapter);

  void putAllSync(List<Chapter> chapters) => isar.chapters.putAllSync(chapters);

  void clearSync() => isar.chapters.clearSync();

  Future<int> putAsync(Chapter chapter) => isar.chapters.put(chapter);

  Future<bool> deleteAsync(int id) => isar.chapters.delete(id);

  Future<void> putAllAsync(List<Chapter> chapters) => isar.chapters.putAll(chapters);

  Future<void> deleteAllAsync(List<int> ids) => isar.chapters.deleteAll(ids);

  // Escape hatch for chapter-rooted transactions too specific to name
  // (linking a fresh batch to their manga, page-index + sibling-chapter
  // combined writes, etc.) — still queued through dbWriteQueue, just without
  // inventing a one-call-site method for each shape.
  Future<T> transaction<T>(FutureOr<T> Function() body) =>
      dbWriteQueue.run(body);

  // Same, but opens the write transaction too, so callers never touch isar.
  Future<T> writeTransaction<T>(T Function() body) =>
      dbWriteQueue.run(() => isar.writeTxnSync(body));

  Future<T> writeTransactionAsync<T>(Future<T> Function() body) =>
      dbWriteQueue.run(() => isar.writeTxn(body));
}

final chapterRepository = ChapterRepository();
