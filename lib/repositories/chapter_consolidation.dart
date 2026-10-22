import 'dart:io';

import 'package:isar_community/isar.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';
import 'package:mangayomi/utils/chapter_recognition.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:path/path.dart' as p;

// Published only after commit, while the shared write queue is still held.
// A stale UI download request can then follow its old ID to the survivor.
final _chapterAliases = Expando<Map<int, int>>();

void publishChapterAliases(Isar database, Map<int, Chapter> canonical) {
  final aliases = _chapterAliases[database] ??= {};
  for (final entry in canonical.entries) {
    if (entry.key != entry.value.id) {
      aliases[entry.key] = entry.value.id!;
    } else {
      aliases.remove(entry.key);
    }
  }
}

int resolveChapterAlias(Isar database, int id) {
  final aliases = _chapterAliases[database] ?? const <int, int>{};
  while (aliases.containsKey(id)) {
    id = aliases[id]!;
  }
  return id;
}

void clearChapterAliases(Isar database) => _chapterAliases[database] = null;

// Readers retain their ID until disposal and queued final writes have drained.
final _readingChapters = Expando<Map<int, int>>();

void Function() retainReadingChapter(Isar database, int id) {
  final readers = _readingChapters[database] ??= {};
  readers[id] = (readers[id] ?? 0) + 1;
  var released = false;
  return () {
    if (released) return;
    released = true;
    dbWriteQueue.run(() {
      final count = readers[id] ?? 0;
      if (count <= 1) {
        readers.remove(id);
      } else {
        readers[id] = count - 1;
      }
    });
  };
}

bool _isReadingChapter(Isar database, int id) =>
    (_readingChapters[database]?[id] ?? 0) > 0;

class ChapterConsolidation {
  ChapterConsolidation(
    this.chapters,
    this.canonicalById,
    this.storageIds,
    this.activeIds, [
    this.updates = const [],
  ]);

  final List<Chapter> chapters;
  // Includes old IDs so the caller can still match every old URL/name alias.
  final Map<int, Chapter> canonicalById;
  final Set<int> storageIds;
  final Set<int> activeIds;
  final List<Update> updates;
}

/// Called inside the catalog's write transaction. No files are moved or deleted.
Future<ChapterConsolidation> consolidateChapterDuplicates(
  Isar database,
  List<Chapter> chapters, {
  required String mangaName,
  required int now,
  required bool Function(int) isScheduled,
  Future<List<Directory>> Function(Chapter, {Settings? settings})?
  resolveDirectories,
}) async {
  final byId = {for (final c in chapters) c.id!: c};
  final downloads = {
    for (final d in (await database.downloads.getAll(
      byId.keys.toList(),
    )).whereType<Download>())
      d.id!: d,
  };
  final activeIds = {
    for (final c in chapters)
      if (_isReadingChapter(database, c.id!) ||
          isScheduled(c.id!) ||
          (downloads[c.id!]?.isStartDownload == true &&
              downloads[c.id!]?.isDownload != true))
        c.id!,
  };
  final storageIds = {
    ...downloads.keys,
    ...activeIds,
    for (final c in chapters)
      if ((c.archivePath ?? '').isNotEmpty) c.id!,
  };
  final settings = await database.settings.get(227);
  final actualPaths = <int, Set<String>>{};
  var unknownStorage = false;
  if (chapters.isNotEmpty) {
    try {
      final first = chapters.first;
      await first.manga.load();
      final entries = <String>{};
      final dirs = resolveDirectories != null
          ? await resolveDirectories(first, settings: settings ?? Settings())
          : const <Directory>[];
      for (final dir in dirs) {
        try {
          entries.addAll(
            dir
                .listSync(followLinks: false)
                .map((e) => p.normalize(e.absolute.path)),
          );
        } on FileSystemException catch (error) {
          if (error.osError?.errorCode == 2 || error.osError?.errorCode == 3) {
            continue;
          }
          rethrow;
        }
      }
      for (final c in chapters) {
        final name = c.name ?? '';
        final (folder, archiveName, archivePath) = _storageIdentity(c);
        final found = entries
            .where(
              (path) => [
                '$name.cbz',
                '$archiveName.cbz',
                folder,
                '$archiveName.mp4',
                '$name.html',
              ].contains(p.basename(path)),
            )
            .toSet();
        if (archivePath.isNotEmpty && File(archivePath).existsSync()) {
          found.add(p.normalize(File(archivePath).absolute.path));
        }
        actualPaths[c.id!] = found;
        if (found.isNotEmpty) storageIds.add(c.id!);
      }
    } catch (_) {
      // An inaccessible/unavailable storage root is not evidence of no files.
      unknownStorage = true;
      storageIds.addAll(byId.keys);
    }
  }
  // Union both keys: A shares a URL with B, and B a label with C, so aliases
  // must all resolve to the same survivor rather than a subsequently deleted B.
  final parents = {for (final id in byId.keys) id: id};
  int root(int id) {
    var target = id;
    while (parents[target] != target) {
      target = parents[target]!;
    }
    while (parents[id] != id) {
      final next = parents[id]!;
      parents[id] = target;
      id = next;
    }
    return target;
  }

  final urls = <String, int>{};
  final labels = <String, int>{};
  final recognition = ChapterRecognition();
  for (final c in chapters) {
    final url = c.url?.trim();
    final label = c.name == null
        ? null
        : recognition.chapterIdentityKey(mangaName, c.name!, c.scanlator ?? '');
    for (final (key, map) in [
      (url == null || url.isEmpty ? null : url.getUrlWithoutDomain, urls),
      (label, labels),
    ]) {
      if (key == null) continue;
      final prior = map[key];
      if (prior != null) parents[root(c.id!)] = root(prior);
      map[key] = c.id!;
    }
  }
  final groups = <int, List<Chapter>>{};
  for (final c in chapters) {
    groups.putIfAbsent(root(c.id!), () => []).add(c);
  }
  final duplicateIds = groups.values
      .where((g) => g.length > 1)
      .expand((g) => g.map((c) => c.id!))
      .toList();
  if (duplicateIds.isEmpty) {
    return ChapterConsolidation(chapters, byId, storageIds, activeIds);
  }
  final histories = await database.historys
      .filter()
      .anyOf(
        duplicateIds,
        (q, id) => q.group(
          (q) => q.chapterIdEqualTo(id).or().chapter((q) => q.idEqualTo(id)),
        ),
      )
      .findAll();
  for (final h in histories) {
    await h.chapter.load();
  }
  final updates = await database.updates
      .filter()
      .anyOf(duplicateIds, (q, id) => q.chapter((q) => q.idEqualTo(id)))
      .findAll();
  for (final u in updates) {
    await u.chapter.load();
  }
  var settingsChanged = false;
  final canonical = Map<int, Chapter>.of(byId);
  final removed = <int>{};
  final movedUpdates = <Update>[];

  for (final group in groups.values.where((g) => g.length > 1)) {
    final ids = group.map((c) => c.id!).toSet();
    // Keep an in-flight worker's ID, path and queue record valid. A later
    // refresh can consolidate once the workers/queued requests have finished.
    if (ids.any(
      (id) =>
          activeIds.contains(id) ||
          isScheduled(id) ||
          _isReadingChapter(database, id),
    )) {
      continue;
    }
    final stored = group.where((c) => storageIds.contains(c.id)).toList();
    final physical = stored
        .where((c) => (actualPaths[c.id]?.isNotEmpty ?? false))
        .map((c) => (actualPaths[c.id]!.toList()..sort()).join('\n'))
        .toSet();
    if (stored.map(_storageIdentity).toSet().length > 1 ||
        physical.length > 1 ||
        (unknownStorage &&
            group
                    .map((c) => (c.name, c.scanlator, c.archivePath))
                    .toSet()
                    .length >
                1)) {
      // Distinct local editions/partial folders cannot be combined by changing
      // database IDs alone. Keep both resources addressable for now.
      continue;
    }
    int downloadRank(Chapter c) => downloads[c.id!]?.isDownload == true
        ? 2
        : storageIds.contains(c.id)
        ? 1
        : 0;
    group.sort((a, b) {
      final rank = downloadRank(b).compareTo(downloadRank(a));
      return rank != 0 ? rank : a.id!.compareTo(b.id!);
    });
    final keep = group.first;
    final historyTimes = <int, int>{};
    for (final h in histories) {
      final id = h.chapterId ?? h.chapter.value?.id;
      if (!ids.contains(id)) continue;
      final timestamp = int.tryParse(h.date ?? '') ?? h.updatedAt ?? 0;
      if (timestamp > (historyTimes[id] ?? 0)) historyTimes[id!] = timestamp;
    }
    final indices = <int, int>{};
    for (final index
        in settings?.chapterPageIndexList ?? <ChapterPageIndex>[]) {
      if (index.chapterId != null && index.index != null) {
        indices.putIfAbsent(index.chapterId!, () => index.index!);
      }
    }
    final progress = group
        .where(
          (c) => (c.lastPageRead ?? '').isNotEmpty || indices.containsKey(c.id),
        )
        .toList();
    progress.sort((a, b) {
      final recent = (historyTimes[b.id] ?? 0).compareTo(
        historyTimes[a.id] ?? 0,
      );
      if (recent != 0) return recent;
      final stamp = (b.updatedAt ?? 0).compareTo(a.updatedAt ?? 0);
      if (stamp != 0) return stamp;
      final page = (double.tryParse(b.lastPageRead ?? '') ?? indices[b.id] ?? 0)
          .compareTo(
            double.tryParse(a.lastPageRead ?? '') ?? indices[a.id] ?? 0,
          );
      return page != 0 ? page : a.id!.compareTo(b.id!);
    });
    final owner = progress.isEmpty ? keep : progress.first;
    final ownerPage = owner.lastPageRead;
    keep
      ..isRead = group.any((c) => c.isRead == true)
      ..isBookmarked = group.any((c) => c.isBookmarked == true)
      ..lastPageRead = ownerPage
      ..updatedAt = now;
    await database.chapters.put(keep);
    for (final c in group) {
      canonical[c.id!] = keep;
    }
    final drops = ids.difference({keep.id!});
    for (final h in histories) {
      if (!ids.contains(h.chapterId) && !ids.contains(h.chapter.value?.id)) {
        continue;
      }
      h
        ..chapterId = keep.id
        ..mangaId = keep.mangaId
        ..updatedAt = now
        ..chapter.value = keep;
      await database.historys.put(h);
      await h.chapter.save();
    }
    for (final u in updates) {
      if (!ids.contains(u.chapter.value?.id)) continue;
      u
        ..chapterName = keep.name
        ..updatedAt = now
        ..chapter.value = keep;
      await database.updates.put(u);
      await u.chapter.save();
      movedUpdates.add(u);
    }
    final records = group
        .map((c) => downloads[c.id])
        .whereType<Download>()
        .toList();
    if (records.isNotEmpty) {
      records.sort((a, b) {
        final complete = (b.isDownload == true ? 1 : 0).compareTo(
          a.isDownload == true ? 1 : 0,
        );
        if (complete != 0) return complete;
        return (b.succeeded ?? 0).compareTo(a.succeeded ?? 0);
      });
      final record = records.first
        ..id = keep.id
        ..chapter.value = keep;
      await database.downloads.put(record);
      await record.chapter.save();
      await database.downloads.deleteAll(drops.toList());
    }
    if (settings != null) {
      final oldIndices = settings.chapterPageIndexList;
      if (oldIndices?.any((i) => ids.contains(i.chapterId)) ?? false) {
        final page = int.tryParse(ownerPage ?? '');
        final index =
            indices[owner.id] ?? (page != null && page > 0 ? page - 1 : null);
        settings.chapterPageIndexList = [
          for (final i in oldIndices!)
            if (!ids.contains(i.chapterId)) i,
          if (index != null) ChapterPageIndex(chapterId: keep.id, index: index),
        ];
        settingsChanged = true;
      }
      final order = settings.downloadQueueOrder;
      if (order?.any(drops.contains) ?? false) {
        settings.downloadQueueOrder = {
          for (final id in order!)
            if (ids.contains(id)) keep.id! else id,
        }.toList();
        settingsChanged = true;
      }
    }
    await database.chapters.deleteAll(drops.toList());
    removed.addAll(drops);
  }
  if (settingsChanged) {
    settings!.updatedAt = now;
    await database.settings.put(settings);
  }
  return ChapterConsolidation(
    chapters.where((c) => !removed.contains(c.id)).toList(),
    canonical,
    unknownStorage
        ? byId.keys.toSet().difference(removed)
        : storageIds.difference(removed),
    activeIds,
    movedUpdates,
  );
}

// Exactly the labels used by the existing folder/CBZ lookup. IDs are not part
// of either filename, so consolidating compatible records needs no file writes.
(String, String, String) _storageIdentity(Chapter c) => (
  '${(c.scanlator ?? '').isEmpty ? '' : '${c.scanlator!.replaceForbiddenCharacters('_')}_'}${(c.name ?? '').replaceForbiddenCharacters('_').trim()}',
  (c.name ?? '').replaceForbiddenCharacters(' '),
  c.archivePath ?? '',
);
