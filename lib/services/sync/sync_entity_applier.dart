// Applying a sync response's pulled entities to local storage. Additive
// only: a row absent from a page never means "delete this", only
// `tombstones` does. Order matters - categories before manga (manga's
// category links reference them), manga before chapters/tracks/histories/
// updates (they all reference a manga by clientId).
//
// Deliberately knows nothing about theme/locale/app-state providers: it
// reports whether incoming settings were actually applied (a wire payload
// can arrive even when the local copy is already newer) and leaves it to
// the caller - which already deals in Riverpod state - to decide what to
// invalidate.
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/repositories/category_repository.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/repositories/update_repository.dart';
import 'package:mangayomi/services/sync/sync_wire_types.dart';

class SyncEntityApplier {
  const SyncEntityApplier();

  // Isar requires every write - even a single put() - to run inside an
  // explicit transaction; it does not open one on its own the way some other
  // embedded databases do. Kept fully synchronous (writeTxnSync + putSync/
  // deleteSync throughout, no await anywhere in the callback) rather than
  // async writeTxn: a sync transaction is one uninterrupted call with no
  // event-loop turn in the middle, so there's no window for it to overlap
  // with anything else. One page's whole apply is one transaction, not one
  // per row, so a page of a few thousand rows doesn't cost a few thousand
  // separate commits. Routed through dbWriteQueue like every other write
  // path in the app, so it still queues behind other writes instead of
  // colliding with them.
  ///
  /// Returns true if incoming settings were actually written (i.e. they
  /// were newer than the local copy), so the caller can invalidate whatever
  /// depends on them.
  Future<bool> apply(Map<String, dynamic> response) async {
    var settingsChanged = false;
    await dbWriteQueue.run(() {
      isar.writeTxnSync(() {
        final remaps = _MangaChapterRemaps(
          manga: (response['mangaClientIdRemap'] as Map?)?.map(
            (k, v) => MapEntry(int.parse(k as String), v as int),
          ),
          chapter: (response['chapterClientIdRemap'] as Map?)?.map(
            (k, v) => MapEntry(int.parse(k as String), v as int),
          ),
        );
        if (remaps.manga != null) _applyMangaRemap(remaps.manga!);
        if (remaps.chapter != null) _applyChapterRemap(remaps.chapter!);

        for (final row in (response['categories'] as List? ?? [])) {
          _applyCategory(row as Map<String, dynamic>);
        }
        for (final row in (response['manga'] as List? ?? [])) {
          _applyManga(row as Map<String, dynamic>);
        }
        for (final row in (response['chapters'] as List? ?? [])) {
          _applyChapter(row as Map<String, dynamic>);
        }
        for (final row in (response['tracks'] as List? ?? [])) {
          _applyTrack(row as Map<String, dynamic>);
        }
        for (final row in (response['histories'] as List? ?? [])) {
          _applyHistory(row as Map<String, dynamic>);
        }
        for (final row in (response['updates'] as List? ?? [])) {
          _applyUpdate(row as Map<String, dynamic>);
        }
        if (response['settings'] != null) {
          settingsChanged = _applySettings(
            response['settings'] as Map<String, dynamic>,
          );
        }

        final tombstones = response['tombstones'] as Map<String, dynamic>?;
        if (tombstones != null) _applyTombstones(tombstones);
      });
    });
    return settingsChanged;
  }

  // A manga upload matched a title another device already established under
  // a different clientId. Adopt the server's canonical id locally so this
  // device stops uploading it as a new duplicate every sync from now on.
  void _applyMangaRemap(Map<int, int> remap) {
    for (final entry in remap.entries) {
      final manga = mangaRepository.getByClientId(entry.key);
      if (manga != null) {
        manga.clientId = entry.value;
        mangaRepository.putSync(manga);
      }
    }
  }

  void _applyChapterRemap(Map<int, int> remap) {
    for (final entry in remap.entries) {
      final chapter = chapterRepository.getByClientId(entry.key);
      if (chapter != null) {
        chapter.clientId = entry.value;
        chapterRepository.putSync(chapter);
      }
    }
  }

  void _applyCategory(Map<String, dynamic> wire) {
    final incoming = wire['updatedAt'] as int;
    final existing = categoryRepository.getByClientId(wire['clientId'] as int);
    if (existing != null && (existing.updatedAt ?? 0) >= incoming) return;
    final category =
        existing ?? Category(name: '', forItemType: ItemType.manga);
    category
      ..clientId = wire['clientId'] as int
      ..name = wire['name'] as String
      ..forItemType = itemTypeFromWire(wire['forItemType'] as String)
      ..pos = wire['pos'] as int?
      ..hide = wire['hide'] as bool?
      ..shouldUpdate = wire['shouldUpdate'] as bool?
      ..updatedAt = incoming;
    categoryRepository.putSync(category);
  }

  void _applyManga(Map<String, dynamic> wire) {
    final incoming = wire['updatedAt'] as int;
    final clientId = wire['clientId'] as int;
    var existing = mangaRepository.getByClientId(clientId);
    // Not known by clientId yet: this device may have added the same title
    // on its own before ever syncing. Fall back to a natural-key match so it
    // adopts that row instead of creating a duplicate.
    existing ??= mangaRepository.findByLinkAndItemType(
      (wire['link'] as String?) ?? '',
      itemTypeFromWire(wire['itemType'] as String),
    );
    if (existing != null && (existing.updatedAt ?? 0) >= incoming) return;

    final categoryClientIds = (wire['categoryClientIds'] as List?)?.cast<int>();
    final localCategoryIds = categoryClientIds
        ?.map((id) => categoryRepository.getByClientId(id)?.id)
        .nonNulls
        .toList();

    final manga =
        existing ??
        Manga(
          source: null,
          author: null,
          artist: null,
          genre: null,
          imageUrl: null,
          lang: null,
          link: null,
          name: null,
          status: Status.unknown,
          description: null,
          sourceId: null,
        );
    manga
      ..clientId = clientId
      ..source = wire['source'] as String?
      ..sourceId = wire['sourceId'] as int?
      ..link = wire['link'] as String?
      ..itemType = itemTypeFromWire(wire['itemType'] as String)
      ..name = wire['name'] as String?
      ..imageUrl = wire['imageUrl'] as String?
      ..description = wire['description'] as String?
      ..author = wire['author'] as String?
      ..artist = wire['artist'] as String?
      ..status = statusFromWire(wire['status'] as String?)
      ..genre = (wire['genre'] as List?)?.cast<String>()
      ..lang = wire['lang'] as String?
      ..lastUpdate = wire['lastUpdate'] as int?
      ..favorite = wire['favorite'] as bool?
      ..dateAdded = wire['dateAdded'] as int?
      ..lastRead = wire['lastRead'] as int?
      ..isLocalArchive = wire['isLocalArchive'] as bool?
      ..customCoverFromTracker = wire['customCoverFromTracker'] as String?
      ..smartUpdateDays = wire['smartUpdateDays'] as int?
      ..updatedAt = incoming;
    if (localCategoryIds != null) manga.categories = localCategoryIds;
    mangaRepository.putSync(manga);
  }

  void _applyChapter(Map<String, dynamic> wire) {
    final incoming = wire['updatedAt'] as int;
    final clientId = wire['clientId'] as int;
    final mangaLocal = mangaRepository.getByClientId(
      wire['mangaClientId'] as int,
    );
    if (mangaLocal == null) return; // orphaned reference, nothing to attach to

    var existing = chapterRepository.getByClientId(clientId);
    existing ??= chapterRepository.findByUrlAndMangaId(
      (wire['url'] as String?) ?? '',
      mangaLocal.id!,
    );
    if (existing != null && (existing.updatedAt ?? 0) >= incoming) return;

    final chapter =
        existing ??
        Chapter(mangaId: mangaLocal.id, name: wire['name'] as String?);
    chapter
      ..clientId = clientId
      ..mangaId = mangaLocal.id
      ..name = wire['name'] as String?
      ..url = wire['url'] as String?
      ..scanlator = wire['scanlator'] as String?
      ..dateUpload = (wire['dateUpload'] as int?)?.toString() ?? ''
      ..isFiller = wire['isFiller'] as bool?
      ..thumbnailUrl = wire['thumbnailUrl'] as String?
      ..description = wire['description'] as String?
      ..downloadSize = (wire['downloadSize'] as int?)?.toString()
      ..duration = (wire['duration'] as int?)?.toString()
      ..isRead = wire['isRead'] as bool?
      ..isBookmarked = wire['isBookmarked'] as bool?
      ..lastPageRead = wire['lastPageRead'] as String?
      ..manga.value = mangaLocal
      ..updatedAt = incoming;
    chapterRepository.putSync(chapter);
    chapter.manga.saveSync();
  }

  void _applyTrack(Map<String, dynamic> wire) {
    final incoming = wire['updatedAt'] as int;
    final clientId = wire['clientId'] as int;
    final mangaLocal = mangaRepository.getByClientId(
      wire['mangaClientId'] as int,
    );
    if (mangaLocal == null) return;

    var existing = trackRepository.getByClientId(clientId);
    existing ??= trackRepository.findBySyncIdAndMangaId(
      wire['syncId'] as int?,
      mangaLocal.id,
    );
    if (existing != null && (existing.updatedAt ?? 0) >= incoming) return;

    final track =
        existing ??
        Track(status: trackStatusFromWire(wire['status'] as String?));
    track
      ..clientId = clientId
      ..mangaId = mangaLocal.id
      ..syncId = wire['syncId'] as int?
      ..mediaId = wire['mediaId'] as int?
      ..libraryId = wire['libraryId'] as int?
      ..title = wire['title'] as String?
      ..lastChapterRead = wire['lastChapterRead'] as int?
      ..totalChapter = wire['totalChapter'] as int?
      ..score = wire['score'] as int?
      ..status = trackStatusFromWire(wire['status'] as String?)
      ..startedReadingDate = wire['startedReadingDate'] as int?
      ..finishedReadingDate = wire['finishedReadingDate'] as int?
      ..trackingUrl = wire['trackingUrl'] as String?
      ..itemType = itemTypeFromWire(wire['itemType'] as String)
      ..updatedAt = incoming;
    isar.tracks.putSync(track);
  }

  void _applyHistory(Map<String, dynamic> wire) {
    final incoming = wire['updatedAt'] as int;
    final clientId = wire['clientId'] as int;
    final mangaLocal = mangaRepository.getByClientId(
      wire['mangaClientId'] as int,
    );
    final chapterLocal = chapterRepository.getByClientId(
      wire['chapterClientId'] as int,
    );
    if (mangaLocal == null || chapterLocal == null) return;

    var existing = historyRepository.getByClientId(clientId);
    existing ??= historyRepository.findByChapterId(chapterLocal.id);
    if (existing != null && (existing.updatedAt ?? 0) >= incoming) return;

    final history =
        existing ??
        History(
          itemType: itemTypeFromWire(wire['itemType'] as String),
          chapterId: chapterLocal.id,
          mangaId: mangaLocal.id,
          date: null,
        );
    history
      ..clientId = clientId
      ..mangaId = mangaLocal.id
      ..chapterId = chapterLocal.id
      ..itemType = itemTypeFromWire(wire['itemType'] as String)
      ..date = (wire['date'] as int?)?.toString() ?? ''
      ..readingTimeSeconds = wire['readingTimeSeconds'] as int?
      ..chapter.value = chapterLocal
      ..updatedAt = incoming;
    historyRepository.putSync(history);
    history.chapter.saveSync();
  }

  void _applyUpdate(Map<String, dynamic> wire) {
    final incoming = wire['updatedAt'] as int;
    final clientId = wire['clientId'] as int;
    final mangaLocal = mangaRepository.getByClientId(
      wire['mangaClientId'] as int,
    );
    if (mangaLocal == null) return;

    var existing = updateRepository.getByClientId(clientId);
    existing ??= updateRepository.findByMangaIdAndChapterName(
      mangaLocal.id,
      wire['chapterName'] as String?,
    );
    if (existing != null && (existing.updatedAt ?? 0) >= incoming) return;

    final update =
        existing ??
        Update(
          mangaId: mangaLocal.id,
          chapterName: wire['chapterName'] as String?,
          date: null,
        );
    update
      ..clientId = clientId
      ..mangaId = mangaLocal.id
      ..chapterName = wire['chapterName'] as String?
      ..date = (wire['date'] as int?)?.toString() ?? ''
      ..updatedAt = incoming;
    final chapterLocal = chapterRepository.findByUrlAndMangaId(
      '',
      mangaLocal.id!,
    );
    if (chapterLocal == null) {
      updateRepository.putSync(update);
    } else {
      updateRepository.putSync(update..chapter.value = chapterLocal);
      update.chapter.saveSync();
    }
  }

  /// Returns true if the incoming settings were newer than the local copy
  /// and therefore actually applied.
  bool _applySettings(Map<String, dynamic> wire) {
    final incomingUpdatedAt = wire['updatedAt'] as int;
    final oldSettings = settingsRepository.current;
    if ((oldSettings.updatedAt ?? 0) >= incomingUpdatedAt) return false;
    final data = Map<String, dynamic>.from(wire['data'] as Map);
    data['updatedAt'] = incomingUpdatedAt;
    final settings = Settings.fromJson(data);
    settingsRepository.putSync(
      _preserveDeviceLocalSettings(settings, oldSettings)
        ..cookiesList = oldSettings.cookiesList,
    );
    return true;
  }

  // Deleted on the server by another device (or an admin). Deletes the same
  // row locally too, straight through the collection - no need to record
  // this back into ChangedPart, it's not this device's outgoing change.
  void _applyTombstones(Map<String, dynamic> tombstones) {
    for (final clientId in (tombstones['categories'] as List? ?? [])) {
      final row = categoryRepository.getByClientId(clientId as int);
      if (row != null) isar.categorys.deleteSync(row.id!);
    }
    for (final clientId in (tombstones['manga'] as List? ?? [])) {
      final row = mangaRepository.getByClientId(clientId as int);
      if (row != null) isar.mangas.deleteSync(row.id!);
    }
    for (final clientId in (tombstones['chapters'] as List? ?? [])) {
      final row = chapterRepository.getByClientId(clientId as int);
      if (row != null) isar.chapters.deleteSync(row.id!);
    }
    for (final clientId in (tombstones['tracks'] as List? ?? [])) {
      final row = trackRepository.getByClientId(clientId as int);
      if (row != null) isar.tracks.deleteSync(row.id!);
    }
    for (final clientId in (tombstones['histories'] as List? ?? [])) {
      final row = historyRepository.getByClientId(clientId as int);
      if (row != null) isar.historys.deleteSync(row.id!);
    }
    for (final clientId in (tombstones['updates'] as List? ?? [])) {
      final row = updateRepository.getByClientId(clientId as int);
      if (row != null) isar.updates.deleteSync(row.id!);
    }
  }
}

class _MangaChapterRemaps {
  final Map<int, int>? manga;
  final Map<int, int>? chapter;
  _MangaChapterRemaps({this.manga, this.chapter});
}

Settings _preserveDeviceLocalSettings(Settings incoming, Settings current) {
  return incoming
    ..id = current.id
    ..localFolders = current.localFolders
    ..namedLocalFolders = current.namedLocalFolders
    ..downloadLocalFolderName = current.downloadLocalFolderName
    ..askDownloadDestination = current.askDownloadDestination
    ..androidProxyServer = current.androidProxyServer
    ..jrePath = current.jrePath
    ..extensionServerPath = current.extensionServerPath;
}
