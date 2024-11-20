import 'dart:convert';
import 'dart:developer';

import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/changed_items.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/services/sync_server.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'sync_providers.g.dart';

@riverpod
void addUpdatedChapterIndependent(Ref ref,
    Chapter chapter, bool deleted, bool txn) {
  final changedItems = isar.changedItems.getSync(1) ?? ChangedItems();
  bool updated = false;
  changedItems.updatedChapters = changedItems.updatedChapters?.map((e) {
    if (e.chapterId == chapter.id) {
      e.isBookmarked = chapter.isBookmarked;
      e.isRead = chapter.isRead;
      e.lastPageRead = chapter.lastPageRead;
      e.deleted = deleted;
      updated = true;
    }
    return e;
  }).toList();
  if (!updated) {
    final updatedChapter = UpdatedChapter(
        chapterId: chapter.id,
        isBookmarked: chapter.isBookmarked,
        isRead: chapter.isRead,
        lastPageRead: chapter.lastPageRead,
        deleted: deleted);
    changedItems.updatedChapters = changedItems.updatedChapters?.toList()
      ?..add(updatedChapter);
  }
  if (!txn) {
    isar.changedItems.putSync(changedItems);
  } else {
    isar.writeTxnSync(() {
      isar.changedItems.putSync(changedItems);
    });
  }
}

@riverpod
void checkForSyncIndependent(Ref ref, bool silent) {
  ref.read(SyncServerProvider(syncId: 1).notifier).checkForSync(silent);
}

@riverpod
class ChangedItemsManager extends _$ChangedItemsManager {
  @override
  ChangedItems? build({required int? managerId}) {
    return isar.changedItems.getSync(managerId!);
  }

  void cleanChangedItems(bool txn) {
    final changedItems =
        isar.changedItems.getSync(managerId!) ?? ChangedItems(id: managerId);
    changedItems.deletedMangas = [];
    changedItems.updatedChapters = [];
    changedItems.deletedCategories = [];
    if (!txn) {
      isar.changedItems.putSync(changedItems);
    } else {
      isar.writeTxnSync(() {
        isar.changedItems.putSync(changedItems);
      });
    }
  }

  void addDeletedManga(Manga manga, bool txn) {
    final changedItems =
        isar.changedItems.getSync(managerId!) ?? ChangedItems(id: managerId);
    log("DEBUG");
    log(jsonEncode(changedItems));
    final deletedManga = DeletedManga(mangaId: manga.id);
    changedItems.deletedMangas = changedItems.deletedMangas?.toList()
      ?..add(deletedManga);
    if (!txn) {
      isar.changedItems.putSync(changedItems);
    } else {
      isar.writeTxnSync(() {
        isar.changedItems.putSync(changedItems);
      });
    }
  }

  Future addDeletedMangaAsync(Manga manga, bool txn) async {
    final changedItems =
        await isar.changedItems.get(managerId!) ?? ChangedItems(id: managerId);
    final deletedManga = DeletedManga(mangaId: manga.id);
    changedItems.deletedMangas = changedItems.deletedMangas?.toList()
      ?..add(deletedManga);
    if (!txn) {
      await isar.changedItems.put(changedItems);
    } else {
      await isar.writeTxn(() async {
        await isar.changedItems.put(changedItems);
      });
    }
  }

  void addUpdatedChapter(Chapter chapter, bool deleted, bool txn) {
    final changedItems =
        isar.changedItems.getSync(managerId!) ?? ChangedItems(id: managerId);
    bool updated = false;
    changedItems.updatedChapters = changedItems.updatedChapters?.map((e) {
      if (e.chapterId == chapter.id && e.mangaId == chapter.mangaId) {
        e.isBookmarked = chapter.isBookmarked;
        e.isRead = chapter.isRead;
        e.lastPageRead = chapter.lastPageRead;
        e.deleted = deleted;
        updated = true;
      }
      return e;
    }).toList();
    if (!updated) {
      final updatedChapter = UpdatedChapter(
          chapterId: chapter.id,
          mangaId: chapter.mangaId,
          isBookmarked: chapter.isBookmarked,
          isRead: chapter.isRead,
          lastPageRead: chapter.lastPageRead,
          deleted: deleted);
      changedItems.updatedChapters = changedItems.updatedChapters?.toList()
        ?..add(updatedChapter);
    }
    if (!txn) {
      isar.changedItems.putSync(changedItems);
    } else {
      isar.writeTxnSync(() {
        isar.changedItems.putSync(changedItems);
      });
    }
  }

  Future addUpdatedChapterAsync(Chapter chapter, bool deleted, bool txn) async {
    final changedItems =
        await isar.changedItems.get(managerId!) ?? ChangedItems(id: managerId);
    bool updated = false;
    changedItems.updatedChapters = changedItems.updatedChapters?.map((e) {
      if (e.chapterId == chapter.id && e.mangaId == chapter.mangaId) {
        e.isBookmarked = chapter.isBookmarked;
        e.isRead = chapter.isRead;
        e.lastPageRead = chapter.lastPageRead;
        e.deleted = deleted;
        updated = true;
      }
      return e;
    }).toList();
    if (!updated) {
      final updatedChapter = UpdatedChapter(
          chapterId: chapter.id,
          mangaId: chapter.mangaId,
          isBookmarked: chapter.isBookmarked,
          isRead: chapter.isRead,
          lastPageRead: chapter.lastPageRead,
          deleted: deleted);
      changedItems.updatedChapters = changedItems.updatedChapters?.toList()
        ?..add(updatedChapter);
    }
    if (!txn) {
      await isar.changedItems.put(changedItems);
    } else {
      await isar.writeTxn(() async {
        await isar.changedItems.put(changedItems);
      });
    }
  }

  void addDeletedCategory(Category category, bool txn) {
    final changedItems =
        isar.changedItems.getSync(managerId!) ?? ChangedItems(id: managerId);
    final deletedCategory = DeletedCategory(categoryId: category.id);
    changedItems.deletedCategories = changedItems.deletedCategories?.toList()
      ?..add(deletedCategory);
    if (!txn) {
      isar.changedItems.putSync(changedItems);
    } else {
      isar.writeTxnSync(() {
        isar.changedItems.putSync(changedItems);
      });
    }
  }

  Future addDeletedCategoryAsync(Category category, bool txn) async {
    final changedItems =
        await isar.changedItems.get(managerId!) ?? ChangedItems(id: managerId);
    final deletedCategory = DeletedCategory(categoryId: category.id);
    changedItems.deletedCategories = changedItems.deletedCategories?.toList()
      ?..add(deletedCategory);
    if (!txn) {
      await isar.changedItems.put(changedItems);
    } else {
      await isar.writeTxn(() async {
        await isar.changedItems.put(changedItems);
      });
    }
  }
}

@riverpod
class Synching extends _$Synching {
  @override
  SyncPreference? build({required int? syncId}) {
    return isar.syncPreferences.getSync(syncId!);
  }

  void login(SyncPreference syncPreference) {
    isar.writeTxnSync(() {
      isar.syncPreferences.putSync(syncPreference);
    });
  }

  void logout() {
    isar.writeTxnSync(() {
      isar.syncPreferences.deleteSync(syncId!);
    });
  }

  void setLastSync(int timestamp) {
    isar.writeTxnSync(() {
      isar.syncPreferences.putSync(
          isar.syncPreferences.getSync(syncId!)!..lastSync = timestamp);
    });
  }

  void setLastUpload(int timestamp) {
    isar.writeTxnSync(() {
      isar.syncPreferences.putSync(
          isar.syncPreferences.getSync(syncId!)!..lastUpload = timestamp);
    });
  }

  void setLastDownload(int timestamp) {
    isar.writeTxnSync(() {
      isar.syncPreferences.putSync(
          isar.syncPreferences.getSync(syncId!)!..lastDownload = timestamp);
    });
  }

  void setServer(String? server) {
    isar.writeTxnSync(() {
      isar.syncPreferences
          .putSync(isar.syncPreferences.getSync(syncId!)!..server = server);
    });
  }
}

@riverpod
class SyncOnAppLaunchState extends _$SyncOnAppLaunchState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.syncOnAppLaunch ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings!..syncOnAppLaunch = value));
  }
}

@riverpod
class SyncAfterReadingState extends _$SyncAfterReadingState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.syncAfterReading ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings!..syncAfterReading = value));
  }
}
