// Gathering local changes for an upload, and clearing them once a sync
// confirms they were applied. The mirror direction of SyncEntityApplier:
// local rows -> wire, instead of wire -> local rows.
import 'dart:math';

import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/repositories/category_repository.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/repositories/update_repository.dart';
import 'package:mangayomi/services/sync/sync_wire_types.dart';

// Local reader-only settings that make no sense on another device (paths,
// device-specific proxy/JRE locations). Stripped before upload, and
// preserved (not overwritten) when applying a pulled settings blob - see
// SyncEntityApplier._preserveDeviceLocalSettings.
const _deviceLocalSettingsKeys = {
  'localFolders',
  'namedLocalFolders',
  'downloadLocalFolderName',
  'askDownloadDestination',
  'androidProxyServer',
  'jrePath',
  'extensionServerPath',
};

class ChangedRows {
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> manga;
  final List<Map<String, dynamic>> chapters;
  final List<Map<String, dynamic>> tracks;
  final List<Map<String, dynamic>> histories;
  final List<Map<String, dynamic>> updates;
  final Map<String, dynamic>? deleted;
  final Map<String, dynamic>? settings;
  final List<ActionType> _deletionActionsToClear;

  ChangedRows._({
    required this.categories,
    required this.manga,
    required this.chapters,
    required this.tracks,
    required this.histories,
    required this.updates,
    required this.deleted,
    required this.settings,
    required this._deletionActionsToClear,
  });

  /// Normal incremental sync: rows changed since `since`, every entity,
  /// plus pending local deletions.
  factory ChangedRows.collect(SyncPreference prefs, Synching notifier) {
    final since = prefs.since ?? 0;

    final deleted = <String, List<int>>{};
    final deletionActions = <ActionType>[];
    void collectDeleted(String key, ActionType action) {
      final parts = notifier.getChangedParts([action]);
      final ids = parts.map((p) => p.clientId).nonNulls.toSet().toList();
      if (ids.isNotEmpty) deleted[key] = ids;
      deletionActions.add(action);
    }

    collectDeleted('categories', ActionType.removeCategory);
    collectDeleted('manga', ActionType.removeItem);
    collectDeleted('chapters', ActionType.removeChapter);
    collectDeleted('tracks', ActionType.removeTrack);
    collectDeleted('histories', ActionType.removeHistory);
    collectDeleted('updates', ActionType.removeUpdate);

    Map<String, dynamic>? settingsWire;
    final current = settingsRepository.current;
    if ((current.updatedAt ?? 0) >= since) {
      settingsWire = _settingsToWire(current);
    }

    return ChangedRows._(
      categories: categoryRepository
          .getChangedSince(since)
          .map(_categoryToWire)
          .toList(),
      manga: mangaRepository
          .getChangedSince(since)
          .map((m) => _mangaToWire(m))
          .nonNulls
          .toList(),
      chapters: chapterRepository
          .getChangedSince(since)
          .map((c) => _chapterToWire(c))
          .nonNulls
          .toList(),
      tracks: trackRepository
          .getChangedSince(since)
          .map((t) => _trackToWire(t))
          .nonNulls
          .toList(),
      histories: historyRepository
          .getChangedSince(since)
          .map((h) => _historyToWire(h))
          .nonNulls
          .toList(),
      updates: updateRepository
          .getChangedSince(since)
          .map((u) => _updateToWire(u))
          .nonNulls
          .toList(),
      deleted: deleted.isEmpty ? null : deleted,
      settings: settingsWire,
      deletionActionsToClear: deletionActions,
    );
  }

  /// "Upload only": every local row, every entity, with `updatedAt` forced
  /// so it wins regardless of what the server holds. No deletions - see the
  /// comment on SyncServer._forceUpload for why.
  factory ChangedRows.collectAll({required int forcedUpdatedAt}) {
    final settingsWire = _settingsToWire(
      settingsRepository.current,
      forcedUpdatedAt: forcedUpdatedAt,
    );
    return ChangedRows._(
      categories: categoryRepository.getAll().map(_categoryToWire).toList(),
      manga: mangaRepository
          .getAll()
          .map((m) => _mangaToWire(m, forcedUpdatedAt: forcedUpdatedAt))
          .nonNulls
          .toList(),
      chapters: chapterRepository
          .getAll()
          .map((c) => _chapterToWire(c, forcedUpdatedAt: forcedUpdatedAt))
          .nonNulls
          .toList(),
      tracks: trackRepository
          .getAll()
          .map((t) => _trackToWire(t, forcedUpdatedAt: forcedUpdatedAt))
          .nonNulls
          .toList(),
      histories: historyRepository
          .getAll()
          .map((h) => _historyToWire(h, forcedUpdatedAt: forcedUpdatedAt))
          .nonNulls
          .toList(),
      updates: updateRepository
          .getAll()
          .map((u) => _updateToWire(u, forcedUpdatedAt: forcedUpdatedAt))
          .nonNulls
          .toList(),
      deleted: null,
      settings: settingsWire,
      deletionActionsToClear: const [],
    );
  }

  /// Splits into requests of at most [maxRows] rows per entity. `deleted`
  /// and `settings` ride along on the first request only - real-world
  /// deletion counts and the settings blob are nowhere near large enough to
  /// need batching of their own.
  List<Map<String, dynamic>> chunked(int maxRows) {
    int chunkCountFor(List list) =>
        list.isEmpty ? 0 : (list.length / maxRows).ceil();
    final chunkCount = [
      chunkCountFor(categories),
      chunkCountFor(manga),
      chunkCountFor(chapters),
      chunkCountFor(tracks),
      chunkCountFor(histories),
      chunkCountFor(updates),
    ].reduce(max);
    if (chunkCount == 0) {
      return [
        {
          if (deleted != null) 'deleted': deleted,
          if (settings != null) 'settings': settings,
        },
      ];
    }

    List<Map<String, dynamic>> slice(List<Map<String, dynamic>> list, int i) {
      final start = i * maxRows;
      if (start >= list.length) return const [];
      return list.sublist(start, min(start + maxRows, list.length));
    }

    return List.generate(chunkCount, (i) {
      final fields = <String, dynamic>{
        'categories': slice(categories, i),
        'manga': slice(manga, i),
        'chapters': slice(chapters, i),
        'tracks': slice(tracks, i),
        'histories': slice(histories, i),
        'updates': slice(updates, i),
      };
      if (i == 0) {
        if (deleted != null) fields['deleted'] = deleted;
        if (settings != null) fields['settings'] = settings;
      }
      return fields;
    });
  }

  Future<void> clearUploaded(Synching notifier) async {
    if (_deletionActionsToClear.isEmpty) return;
    await notifier.clearChangedParts(_deletionActionsToClear, true);
  }
}

Map<String, dynamic> _categoryToWire(Category c) => {
  'clientId': c.clientId,
  'name': c.name,
  'forItemType': wireItemTypes[c.forItemType.index],
  'pos': c.pos,
  'hide': c.hide ?? false,
  'shouldUpdate': c.shouldUpdate ?? true,
  'updatedAt': c.updatedAt ?? 0,
};

// Returns null when the row can't be represented on the wire (no clientId
// yet - shouldn't happen once backfill has run, but skip rather than crash
// if it somehow does).
Map<String, dynamic>? _mangaToWire(Manga m, {int? forcedUpdatedAt}) {
  if (m.clientId == null) return null;
  return {
    'clientId': m.clientId,
    'source': m.source,
    'sourceId': m.sourceId,
    'link': m.link,
    'itemType': wireItemTypes[m.itemType.index],
    'name': m.name,
    'imageUrl': m.imageUrl,
    'description': m.description,
    'author': m.author,
    'artist': m.artist,
    'status': wireStatuses[m.status.index],
    'genre': m.genre ?? [],
    'lang': m.lang,
    'lastUpdate': m.lastUpdate,
    'favorite': m.favorite ?? false,
    'dateAdded': m.dateAdded,
    'lastRead': m.lastRead,
    'isLocalArchive': m.isLocalArchive ?? false,
    'customCoverFromTracker': m.customCoverFromTracker,
    'smartUpdateDays': m.smartUpdateDays,
    'categoryClientIds': (m.categories ?? [])
        .map((id) => isar.categorys.getSync(id)?.clientId)
        .nonNulls
        .toList(),
    'updatedAt': forcedUpdatedAt ?? m.updatedAt ?? 0,
  };
}

Map<String, dynamic>? _chapterToWire(Chapter c, {int? forcedUpdatedAt}) {
  final mangaClientId = c.mangaId == null
      ? null
      : mangaRepository.findById(c.mangaId!)?.clientId;
  if (c.clientId == null || mangaClientId == null) return null;
  return {
    'clientId': c.clientId,
    'mangaClientId': mangaClientId,
    'name': c.name,
    'url': c.url,
    'scanlator': c.scanlator,
    'dateUpload': int.tryParse(c.dateUpload ?? ''),
    'isFiller': c.isFiller ?? false,
    'thumbnailUrl': c.thumbnailUrl,
    'description': c.description,
    'downloadSize': int.tryParse(c.downloadSize ?? ''),
    'duration': int.tryParse(c.duration ?? ''),
    'isRead': c.isRead ?? false,
    'isBookmarked': c.isBookmarked ?? false,
    'lastPageRead': c.lastPageRead,
    'updatedAt': forcedUpdatedAt ?? c.updatedAt ?? 0,
  };
}

Map<String, dynamic>? _trackToWire(Track t, {int? forcedUpdatedAt}) {
  final mangaClientId = t.mangaId == null
      ? null
      : mangaRepository.findById(t.mangaId!)?.clientId;
  if (t.clientId == null || mangaClientId == null) return null;
  return {
    'clientId': t.clientId,
    'mangaClientId': mangaClientId,
    'syncId': t.syncId,
    'mediaId': t.mediaId,
    'libraryId': t.libraryId,
    'title': t.title,
    'lastChapterRead': t.lastChapterRead,
    'totalChapter': t.totalChapter,
    'score': t.score,
    'status': wireTrackStatuses[t.status.index],
    'startedReadingDate': t.startedReadingDate,
    'finishedReadingDate': t.finishedReadingDate,
    'trackingUrl': t.trackingUrl,
    'itemType': wireItemTypes[t.itemType.index],
    'updatedAt': forcedUpdatedAt ?? t.updatedAt ?? 0,
  };
}

Map<String, dynamic>? _historyToWire(History h, {int? forcedUpdatedAt}) {
  final mangaClientId = h.mangaId == null
      ? null
      : mangaRepository.findById(h.mangaId!)?.clientId;
  final chapterClientId = h.chapterId == null
      ? null
      : chapterRepository.getByClientId(h.chapterId!)?.clientId ??
            _chapterClientIdByLocalId(h.chapterId!);
  if (h.clientId == null || mangaClientId == null || chapterClientId == null) {
    return null;
  }
  return {
    'clientId': h.clientId,
    'mangaClientId': mangaClientId,
    'chapterClientId': chapterClientId,
    'itemType': wireItemTypes[h.itemType.index],
    'date': int.tryParse(h.date ?? ''),
    'readingTimeSeconds': h.readingTimeSeconds ?? 0,
    'updatedAt': forcedUpdatedAt ?? h.updatedAt ?? 0,
  };
}

Map<String, dynamic>? _updateToWire(Update u, {int? forcedUpdatedAt}) {
  final mangaClientId = u.mangaId == null
      ? null
      : mangaRepository.findById(u.mangaId!)?.clientId;
  if (u.clientId == null || mangaClientId == null) return null;
  return {
    'clientId': u.clientId,
    'mangaClientId': mangaClientId,
    'chapterName': u.chapterName,
    'date': int.tryParse(u.date ?? ''),
    'updatedAt': forcedUpdatedAt ?? u.updatedAt ?? 0,
  };
}

// getByClientId also falls back to matching on the local id (see the
// repositories), so a plain local-id lookup is the same query by another
// name - kept as its own function just for a clearer call site above.
int? _chapterClientIdByLocalId(int localId) =>
    chapterRepository.getByClientId(localId)?.clientId;

Map<String, dynamic> _settingsToWire(
  Settings settings, {
  int? forcedUpdatedAt,
}) {
  final json = settings.toJson();
  json['updatedAt'] = forcedUpdatedAt ?? json['updatedAt'] ?? 0;
  // Session cookies are device/login-specific, never worth syncing.
  json['cookiesList'] = [];
  for (final key in _deviceLocalSettingsKeys) {
    json.remove(key);
  }
  return {'data': json, 'updatedAt': json['updatedAt']};
}
