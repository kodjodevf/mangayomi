import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/repositories/update_repository.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';

class MangaRepository {
  Manga getById(int id) => isar.mangas.getSync(id)!;

  Manga? findById(int id) => isar.mangas.getSync(id);

  Future<Manga?> findByIdAsync(int id) => isar.mangas.get(id);

  Future<Manga?> findLocalArchiveByName(String? name) => isar.mangas
      .filter()
      .isLocalArchiveEqualTo(true)
      .sourceEqualTo("local")
      .nameEqualTo(name)
      .findFirst();

  Future<bool> isEmptyByLangNameSource(String? lang, String? name, String? source) =>
      isar.mangas
          .filter()
          .langEqualTo(lang)
          .nameEqualTo(name)
          .sourceEqualTo(source)
          .isEmpty();

  Future<List<Manga>> findAllByLangNameSource(
    String? lang,
    String? name,
    String? source,
  ) => isar.mangas
      .filter()
      .langEqualTo(lang)
      .nameEqualTo(name)
      .sourceEqualTo(source)
      .findAll();

  List<Manga> getAll() => isar.mangas.where().findAllSync();

  // Async twin, for callers already inside an async writeTxn/writeTransactionAsync
  // — Isar rejects a sync findAllSync() call from inside an async transaction.
  Future<List<Manga>> getAllAsync() => isar.mangas.where().findAll();

  Future<List<Manga>> getAllLocal() => isar.mangas
      .filter()
      .sourceEqualTo("local")
      .or()
      .linkContains("Mangayomi/local")
      .or()
      .linkContains("Mangayomi\\local")
      .findAll();

  List<Manga?> getAllByIds(List<int> ids) => isar.mangas.getAllSync(ids);

  Stream<List<int>> watchIdsByItemTypeAndSearch(
    ItemType itemType,
    String search,
  ) => isar.mangas
      .filter()
      .itemTypeEqualTo(itemType)
      .nameContains(search, caseSensitive: false)
      .idProperty()
      .watch(fireImmediately: true);

  List<Manga> getNonFavorites() =>
      isar.mangas.filter().favoriteEqualTo(false).findAllSync();

  List<Manga> getByItemTypeNames(Iterable<ItemType?> itemTypes) => isar.mangas
      .filter()
      .anyOf(
        itemTypes,
        (q, element) =>
            element == null ? q.idIsNull() : q.itemTypeEqualTo(element),
      )
      .findAllSync();

  List<Manga> getLocalArchive() =>
      isar.mangas.filter().isLocalArchiveEqualTo(true).findAllSync();

  List<Manga> getBySourceLocalOrArchive() => isar.mangas
      .filter()
      .sourceEqualTo("local")
      .or()
      .sourceEqualTo("archive")
      .findAllSync();

  Future<List<Manga>> getLocalByItemTypeSortedByDateAdded(
    ItemType itemType,
    int offset,
    int limit,
  ) => isar.mangas
      .filter()
      .itemTypeEqualTo(itemType)
      .group(
        (q) => q
            .sourceEqualTo("local")
            .or()
            .linkContains("Mangayomi/local")
            .or()
            .linkContains("Mangayomi\\local"),
      )
      .sortByDateAddedDesc()
      .offset(offset)
      .limit(limit)
      .findAll();

  Future<List<Manga>> getLocalByItemTypeSortedByName(
    ItemType itemType,
    int offset,
    int limit,
  ) => isar.mangas
      .filter()
      .itemTypeEqualTo(itemType)
      .group(
        (q) => q
            .sourceEqualTo("local")
            .or()
            .linkContains("Mangayomi/local")
            .or()
            .linkContains("Mangayomi\\local"),
      )
      .sortByName()
      .offset(offset)
      .limit(limit)
      .findAll();

  Future<List<Manga>> searchLocalByItemType(
    ItemType itemType,
    String query,
    int offset,
    int limit,
  ) => isar.mangas
      .filter()
      .itemTypeEqualTo(itemType)
      .group(
        (q) => q
            .sourceEqualTo("local")
            .or()
            .linkContains("Mangayomi/local")
            .or()
            .linkContains("Mangayomi\\local"),
      )
      .nameContains(query, caseSensitive: false)
      .offset(offset)
      .limit(limit)
      .findAll();

  List<Manga> getFavorites() =>
      isar.mangas.filter().favoriteEqualTo(true).findAllSync();

  int countFavorites() =>
      isar.mangas.filter().favoriteEqualTo(true).countSync();

  List<Manga> getByItemType(ItemType itemType) =>
      isar.mangas.filter().itemTypeEqualTo(itemType).findAllSync();

  Future<int> countFavoritesByItemType(ItemType itemType) => isar.mangas
      .filter()
      .favoriteEqualTo(true)
      .itemTypeEqualTo(itemType)
      .count();

  Future<List<int>> getCompletedFavoriteIds(ItemType itemType) => isar.mangas
      .filter()
      .favoriteEqualTo(true)
      .itemTypeEqualTo(itemType)
      .statusEqualTo(Status.completed)
      .idProperty()
      .findAll();

  Future<List<Manga>> getFavoritesNonLocalArchiveByItemType(
    ItemType itemType,
  ) => isar.mangas
      .filter()
      .idIsNotNull()
      .favoriteEqualTo(true)
      .itemTypeEqualTo(itemType)
      .isLocalArchiveEqualTo(false)
      .findAll();

  List<Manga> getFavoritesNonLocalArchive() => isar.mangas
      .filter()
      .idIsNotNull()
      .favoriteEqualTo(true)
      .isLocalArchiveEqualTo(false)
      .findAllSync();

  List<Manga> getFavoritesByItemTypeIdNotNull(ItemType itemType) => isar.mangas
      .filter()
      .idIsNotNull()
      .favoriteEqualTo(true)
      .and()
      .itemTypeEqualTo(itemType)
      .findAllSync();

  List<Manga> getFavoritesByItemType(ItemType itemType) => isar.mangas
      .filter()
      .favoriteEqualTo(true)
      .itemTypeEqualTo(itemType)
      .findAllSync();

  Stream<List<Manga>> watchCalendarFavorites(ItemType itemType) => isar.mangas
      .where()
      .favoriteItemTypeEqualTo(true, itemType)
      .filter()
      .anyOf([
        Status.ongoing,
        Status.unknown,
        Status.publishingFinished,
      ], (q, status) => q.statusEqualTo(status))
      .smartUpdateDaysIsNotNull()
      .smartUpdateDaysGreaterThan(0)
      .watch(fireImmediately: true);

  Stream<List<Manga>> watchByLangNameSource(
    String? lang,
    String? name,
    String? source,
  ) => isar.mangas
      .filter()
      .langEqualTo(lang)
      .nameEqualTo(name)
      .sourceEqualTo(source)
      .watch(fireImmediately: true);

  Stream<List<Manga>> watchBySourceAndLang(String? source, String? lang) =>
      isar.mangas
          .filter()
          .sourceEqualTo(source)
          .langEqualTo(lang)
          .watch(fireImmediately: true);

  Stream<Manga?> watchById(int id) =>
      isar.mangas.watchObject(id, fireImmediately: true);

  // Same query isar_providers.dart already runs; relocated, not changed.
  Stream<List<Manga>> watchFavorites(ItemType itemType, {int? categoryId}) {
    final base = isar.mangas.where().favoriteItemTypeEqualTo(true, itemType);
    return categoryId == null
        ? base.watch(fireImmediately: true)
        : base
              .filter()
              .categoriesIsNotEmpty()
              .categoriesElementEqualTo(categoryId)
              .watch(fireImmediately: true);
  }

  // Same query isar_providers.dart already runs; relocated, not changed.
  Stream<List<Manga>> watchFavoritesWithoutCategories(ItemType itemType) {
    return isar.mangas
        .where()
        .favoriteItemTypeEqualTo(true, itemType)
        .filter()
        .group((q) => q.categoriesIsEmpty().or().categoriesIsNull())
        .watch(fireImmediately: true);
  }

  // Local archives get fully wiped (via wipeManga); everything else just unfavorites.
  Future<void> removeFromLibrary(WidgetRef ref, Manga manga) =>
      dbWriteQueue.run(() {
        isar.writeTxnSync(() {
          if (manga.isLocalArchive ?? false) {
            wipeManga(ref, manga);
          } else {
            manga.favorite = false;
            manga.updatedAt = DateTime.now().millisecondsSinceEpoch;
            isar.mangas.putSync(manga);
          }
        });
      });

  Future<void> putAll(List<Manga> mangas) =>
      dbWriteQueue.run(() => isar.writeTxn(() => isar.mangas.putAll(mangas)));

  // Stamps updatedAt for callers that just want to persist a mutated Manga
  // they already hold, without setting the timestamp themselves.
  Future<void> save(Manga manga) => dbWriteQueue.run(() {
    isar.writeTxnSync(() {
      manga.updatedAt = DateTime.now().millisecondsSinceEpoch;
      isar.mangas.putSync(manga);
    });
  });

  // Plain put, no updatedAt stamping — for callers that already set it (or
  // deliberately don't) and need the generated id back.
  Future<int> put(Manga manga) => dbWriteQueue.run(() {
    late final int id;
    isar.writeTxnSync(() {
      id = isar.mangas.putSync(manga);
    });
    return id;
  });

  Future<void> delete(int id) =>
      dbWriteQueue.run(() => isar.writeTxn(() => isar.mangas.delete(id)));

  // Sync primitive below is for callers already inside a write transaction
  // opened by transaction()/writeTransaction() — it doesn't queue on its own.
  int putSync(Manga manga) => isar.mangas.putSync(manga);

  void putAllSync(List<Manga> mangas) => isar.mangas.putAllSync(mangas);

  void clearSync() => isar.mangas.clearSync();

  Future<int> putAsync(Manga manga) => isar.mangas.put(manga);

  Future<bool> deleteAsync(int id) => isar.mangas.delete(id);

  // Escape hatch for manga-rooted transactions too specific to name (diffing
  // a source refresh against existing chapters, importing a new manga with
  // its first batch of chapters, etc.) — still queued through dbWriteQueue,
  // just without inventing a one-call-site method for each shape.
  Future<T> transaction<T>(FutureOr<T> Function() body) =>
      dbWriteQueue.run(body);

  // Same, but opens the write transaction too, so callers never touch isar.
  Future<T> writeTransaction<T>(T Function() body) =>
      dbWriteQueue.run(() => isar.writeTxnSync(body));

  // Async variant, for bodies that need to await other async isar calls
  // inside the same transaction.
  Future<T> writeTransactionAsync<T>(Future<T> Function() body) =>
      dbWriteQueue.run(() => isar.writeTxn(body));

  // Queued, transacted wipeManga for callers with a batch of mangas and no
  // other work to fold into the same transaction.
  Future<void> wipeMangas(WidgetRef ref, List<Manga> mangas) =>
      dbWriteQueue.run(() {
        isar.writeTxnSync(() {
          for (final manga in mangas) {
            wipeManga(ref, manga);
          }
        });
      });

  // Deletes every Isar record tied to a manga: history, updates, downloads,
  // chapters, and the manga itself. Notifies the sync provider so the removal
  // propagates. Must run inside an already-open write transaction.
  void wipeManga(WidgetRef ref, Manga manga) {
    final provider = ref.read(synchingProvider(syncId: 1).notifier);
    final histories = isar.historys
        .where()
        .mangaIdEqualTo(manga.id)
        .findAllSync();
    for (var history in histories) {
      isar.historys.deleteSync(history.id!);
      provider.addChangedPart(
        ActionType.removeHistory,
        history.id,
        "{}",
        false,
      );
    }

    final updates = isar.updates.where().mangaIdEqualTo(manga.id).findAllSync();
    for (var update in updates) {
      isar.updates.deleteSync(update.id!);
      provider.addChangedPart(ActionType.removeUpdate, update.id, "{}", false);
    }

    for (var chapter in manga.chapters) {
      isar.downloads.deleteSync(chapter.id!);
      isar.chapters.deleteSync(chapter.id!);
      provider.addChangedPart(
        ActionType.removeChapter,
        chapter.id,
        "{}",
        false,
      );
    }
    isar.mangas.deleteSync(manga.id!);
    provider.addChangedPart(ActionType.removeItem, manga.id, "{}", false);
  }

  // Bulk-drops every manga in mangaList along with their chapters, and
  // (unless kept) history/downloads too, then optionally removes the source
  // itself. Downloaded files are deleted by the caller first, since that's
  // disk I/O rather than a DB write.
  Future<void> deleteLibrarySourceGroup(
    List<Manga> mangaList, {
    int? removeSourceId,
    bool keepHistory = false,
    bool keepDownloads = false,
  }) => dbWriteQueue.run(() {
    isar.writeTxnSync(() {
      for (final manga in mangaList) {
        final chapterIds = chapterRepository
            .getAllByMangaId(manga.id)
            .map((c) => c.id!)
            .toList();
        if (chapterIds.isNotEmpty) {
          if (!keepDownloads) isar.downloads.deleteAllSync(chapterIds);
          isar.chapters.deleteAllSync(chapterIds);
        }
      }
      final mangaIds = mangaList.map((m) => m.id!).toList();
      if (mangaIds.isNotEmpty) {
        if (!keepHistory) {
          isar.historys
              .filter()
              .anyOf(mangaIds, (q, id) => q.mangaIdEqualTo(id))
              .deleteAllSync();
        }
        isar.updates
            .filter()
            .anyOf(mangaIds, (q, id) => q.mangaIdEqualTo(id))
            .deleteAllSync();
        isar.mangas.deleteAllSync(mangaIds);
      }
      if (removeSourceId != null) {
        isar.sources.deleteSync(removeSourceId);
      }
    });
  });

  // Folds each of `others` into `primary`: chapters/history/updates/tracks
  // that don't already exist on primary (matched by chapter url, then track
  // syncId) are reassigned to it, duplicates are dropped in favour of
  // primary's copy (keeping read state if only the dropped copy had it), and
  // each of `others` is deleted once its rows are gone.
  Future<void> mergeGroup(Manga primary, List<Manga> others) =>
      dbWriteQueue.run(() {
        isar.writeTxnSync(() {
          final primaryByUrl = <String, Chapter>{
            for (final c in chapterRepository.getAllByMangaId(primary.id))
              ?_chapterDedupKey(c): c,
          };

          for (final other in others) {
            final otherId = other.id!;
            final otherChapters = chapterRepository.getAllByMangaId(otherId);

            final remap = <int, Chapter>{};
            final chaptersToDelete = <int>[];
            final chaptersToUpdate = <Chapter>[];

            for (final chapter in otherChapters) {
              final key = _chapterDedupKey(chapter);
              final existing = key != null ? primaryByUrl[key] : null;
              if (existing != null) {
                final otherHasState =
                    (chapter.isRead ?? false) ||
                    (chapter.lastPageRead ?? '').isNotEmpty;
                final existingHasState =
                    (existing.isRead ?? false) ||
                    (existing.lastPageRead ?? '').isNotEmpty;
                if (otherHasState && !existingHasState) {
                  existing.isRead = chapter.isRead;
                  existing.lastPageRead = chapter.lastPageRead;
                  chaptersToUpdate.add(existing);
                }
                remap[chapter.id!] = existing;
                chaptersToDelete.add(chapter.id!);
              } else {
                chapter.mangaId = primary.id;
                chapter.manga.value = primary;
                isar.chapters.putSync(chapter);
                chapter.manga.saveSync();
                if (key != null) primaryByUrl[key] = chapter;
                remap[chapter.id!] = chapter;
              }
            }
            if (chaptersToUpdate.isNotEmpty) {
              isar.chapters.putAllSync(chaptersToUpdate);
            }

            final historyEntries = historyRepository.getAllByMangaId(otherId);
            for (final h in historyEntries) {
              final kept = h.chapterId != null ? remap[h.chapterId] : null;
              if (kept == null) {
                isar.historys.deleteSync(h.id!);
                continue;
              }
              h.mangaId = primary.id;
              h.chapterId = kept.id;
              h.chapter.value = kept;
              isar.historys.putSync(h);
              h.chapter.saveSync();
            }

            final updateEntries = updateRepository.getAllByMangaId(otherId);
            for (final u in updateEntries) {
              u.chapter.loadSync();
              final oldChapter = u.chapter.value;
              final kept = oldChapter != null ? remap[oldChapter.id] : null;
              if (kept == null) {
                isar.updates.deleteSync(u.id!);
                continue;
              }
              u.mangaId = primary.id;
              u.chapter.value = kept;
              isar.updates.putSync(u);
              u.chapter.saveSync();
            }

            final primarySyncIds = trackRepository
                .getAllByMangaId(primary.id)
                .map((t) => t.syncId)
                .toSet();
            for (final t in trackRepository.getAllByMangaId(otherId)) {
              if (t.syncId != null && primarySyncIds.contains(t.syncId)) {
                isar.tracks.deleteSync(t.id!);
              } else {
                t.mangaId = primary.id;
                isar.tracks.putSync(t);
                primarySyncIds.add(t.syncId);
              }
            }

            if (chaptersToDelete.isNotEmpty) {
              isar.downloads.deleteAllSync(chaptersToDelete);
              isar.chapters.deleteAllSync(chaptersToDelete);
            }
            isar.mangas.deleteSync(otherId);
          }
        });
      });
}

String? _chapterDedupKey(Chapter c) =>
    (c.url ?? '').isNotEmpty ? c.url!.getUrlWithoutDomain : null;

final mangaRepository = MangaRepository();
