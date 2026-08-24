import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/isar_txn_retry.dart';
import 'package:mangayomi/utils/utils.dart';

class LibrarySourceGroup {
  LibrarySourceGroup({
    required this.sourceId,
    required this.sourceName,
    required this.lang,
    required this.itemType,
    required this.mangaCount,
  });

  final int? sourceId;
  final String sourceName;
  final String? lang;
  final ItemType itemType;
  final int mangaCount;
}

List<LibrarySourceGroup> librarySourceGroups({bool favoritesOnly = false}) {
  final counts = <String, LibrarySourceGroup>{};
  final mangas = favoritesOnly
      ? isar.mangas.filter().favoriteEqualTo(true).findAllSync()
      : isar.mangas.where().findAllSync();
  for (final m in mangas) {
    final key = "${m.sourceId}|${m.source}|${m.lang}|${m.itemType.index}";
    final existing = counts[key];
    counts[key] = LibrarySourceGroup(
      sourceId: m.sourceId,
      sourceName: m.source ?? "Unknown",
      lang: m.lang,
      itemType: m.itemType,
      mangaCount: (existing?.mangaCount ?? 0) + 1,
    );
  }
  final list = counts.values.toList()
    ..sort((a, b) => b.mangaCount.compareTo(a.mangaCount));
  return list;
}

/// Library source groups whose extension isn't actually installed - e.g. a
/// restored backup bound entries to a source that was only ever browsed
/// (never installed) on this device, or the extension was uninstalled since.
List<LibrarySourceGroup> librarySourceGroupsMissingSource() {
  return librarySourceGroups(favoritesOnly: true).where((g) {
    return getSource(
          g.lang ?? '',
          g.sourceName,
          g.sourceId,
          installedOnly: true,
        ) ==
        null;
  }).toList();
}

List<Manga> mangaForGroup(LibrarySourceGroup group, {bool favoritesOnly = false}) {
  return isar.mangas.where().findAllSync().where((m) {
    if (favoritesOnly && !(m.favorite ?? false)) return false;
    if (m.itemType != group.itemType) return false;
    if (group.sourceId != null) return m.sourceId == group.sourceId;
    return m.sourceId == null &&
        m.source == group.sourceName &&
        m.lang == group.lang;
  }).toList();
}

class DeleteSourceCounts {
  DeleteSourceCounts({
    required this.mangaCount,
    required this.chapterCount,
    required this.historyCount,
    required this.updateCount,
  });

  final int mangaCount;
  final int chapterCount;
  final int historyCount;
  final int updateCount;
}

DeleteSourceCounts previewDeleteSource(List<Manga> mangaList) {
  final mangaIds = mangaList.map((m) => m.id!).toList();
  final chapterCount = mangaIds.isEmpty
      ? 0
      : isar.chapters
            .filter()
            .anyOf(mangaIds, (q, id) => q.mangaIdEqualTo(id))
            .countSync();
  final historyCount = mangaIds.isEmpty
      ? 0
      : isar.historys
            .filter()
            .anyOf(mangaIds, (q, id) => q.mangaIdEqualTo(id))
            .countSync();
  final updateCount = mangaIds.isEmpty
      ? 0
      : isar.updates
            .filter()
            .anyOf(mangaIds, (q, id) => q.mangaIdEqualTo(id))
            .countSync();
  return DeleteSourceCounts(
    mangaCount: mangaList.length,
    chapterCount: chapterCount,
    historyCount: historyCount,
    updateCount: updateCount,
  );
}

Future<void> deleteSourceLibrary(
  List<Manga> mangaList,
  LibrarySourceGroup group, {
  bool alsoRemoveExtension = false,
  bool keepHistory = false,
  bool keepDownloads = false,
}) async {
  if (!keepDownloads) {
    for (final manga in mangaList) {
      final chapters = isar.chapters
          .filter()
          .mangaIdEqualTo(manga.id)
          .findAllSync();
      for (final chapter in chapters) {
        chapter.manga.value = manga;
        await chapter.deleteDownloadedFiles();
      }
    }
  }
  await writeTxnSyncWithRetry(() {
    for (final manga in mangaList) {
      final chapterIds = isar.chapters
          .filter()
          .mangaIdEqualTo(manga.id)
          .findAllSync()
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
    if (alsoRemoveExtension && group.sourceId != null) {
      isar.sources.deleteSync(group.sourceId!);
    }
  });
}

// Groups items into clusters of 2+ using union-find, joining any pair that
// `matches` reports as equivalent (so equivalence doesn't need to be
// transitive across the whole set — A~B and B~C is enough to cluster A,B,C
// together even if A and C alone wouldn't match).
List<List<T>> _clusterByPairwiseMatch<T>(
  List<T> items,
  bool Function(T a, T b) matches,
) {
  final n = items.length;
  final parent = List.generate(n, (i) => i);
  int find(int x) {
    while (parent[x] != x) {
      parent[x] = parent[parent[x]];
      x = parent[x];
    }
    return x;
  }

  void union(int x, int y) {
    final rx = find(x), ry = find(y);
    if (rx != ry) parent[rx] = ry;
  }

  for (var i = 0; i < n; i++) {
    for (var j = i + 1; j < n; j++) {
      if (matches(items[i], items[j])) union(i, j);
    }
  }
  final clusters = <int, List<T>>{};
  for (var i = 0; i < n; i++) {
    clusters.putIfAbsent(find(i), () => []).add(items[i]);
  }
  return clusters.values.where((g) => g.length > 1).toList();
}

class DuplicateMangaCluster {
  DuplicateMangaCluster(this.mangaList);

  final List<Manga> mangaList;
}

String _normalizeMangaTitle(String name) =>
    name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

bool _looksLikeSameManga(Manga a, Manga b) {
  final ta = _normalizeMangaTitle(a.name ?? '');
  final tb = _normalizeMangaTitle(b.name ?? '');
  return ta.isNotEmpty && ta == tb;
}

List<DuplicateMangaCluster> findDuplicateMangaClusters(List<Manga> mangaList) {
  return _clusterByPairwiseMatch(mangaList, _looksLikeSameManga)
      .map(DuplicateMangaCluster.new)
      .toList();
}

class MergeMangaPreview {
  MergeMangaPreview({
    required this.totalChapters,
    required this.duplicateChapters,
    required this.duplicateTracks,
  });

  final int totalChapters;
  final int duplicateChapters;
  final int duplicateTracks;

  int get keptChapters => totalChapters - duplicateChapters;
}

String? _chapterDedupKey(Chapter c) =>
    (c.url ?? '').isNotEmpty ? c.url!.getUrlWithoutDomain : null;

MergeMangaPreview previewMergeManga(Manga primary, List<Manga> others) {
  final seenUrlKeys = <String>{
    for (final c in isar.chapters.filter().mangaIdEqualTo(primary.id).findAllSync())
      ?_chapterDedupKey(c),
  };
  var totalChapters = 0;
  var duplicateChapters = 0;
  for (final other in others) {
    for (final c
        in isar.chapters.filter().mangaIdEqualTo(other.id).findAllSync()) {
      totalChapters++;
      final key = _chapterDedupKey(c);
      if (key == null) continue;
      if (!seenUrlKeys.add(key)) duplicateChapters++;
    }
  }

  final seenSyncIds = <int?>{
    for (final t in isar.tracks.filter().mangaIdEqualTo(primary.id).findAllSync())
      t.syncId,
  };
  var duplicateTracks = 0;
  for (final other in others) {
    for (final t
        in isar.tracks.filter().mangaIdEqualTo(other.id).findAllSync()) {
      if (t.syncId != null && !seenSyncIds.add(t.syncId)) duplicateTracks++;
    }
  }

  return MergeMangaPreview(
    totalChapters: totalChapters,
    duplicateChapters: duplicateChapters,
    duplicateTracks: duplicateTracks,
  );
}

Future<void> mergeMangaGroup(Manga primary, List<Manga> others) async {
  final primaryUrlKeys = <String>{
    for (final c in isar.chapters.filter().mangaIdEqualTo(primary.id).findAllSync())
      ?_chapterDedupKey(c),
  };
  for (final other in others) {
    for (final chapter in isar.chapters
        .filter()
        .mangaIdEqualTo(other.id)
        .findAllSync()) {
      final key = _chapterDedupKey(chapter);
      if (key != null && primaryUrlKeys.contains(key)) {
        chapter.manga.value = other;
        await chapter.deleteDownloadedFiles();
      }
    }
  }

  await writeTxnSyncWithRetry(() {
    final primaryByUrl = <String, Chapter>{
      for (final c in isar.chapters
          .filter()
          .mangaIdEqualTo(primary.id)
          .findAllSync())
        ?_chapterDedupKey(c): c,
    };

    for (final other in others) {
      final otherId = other.id!;
      final otherChapters = isar.chapters
          .filter()
          .mangaIdEqualTo(otherId)
          .findAllSync();

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

      final historyEntries = isar.historys
          .filter()
          .mangaIdEqualTo(otherId)
          .findAllSync();
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

      final updateEntries = isar.updates
          .filter()
          .mangaIdEqualTo(otherId)
          .findAllSync();
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

      final primarySyncIds = isar.tracks
          .filter()
          .mangaIdEqualTo(primary.id)
          .findAllSync()
          .map((t) => t.syncId)
          .toSet();
      for (final t in isar.tracks
          .filter()
          .mangaIdEqualTo(otherId)
          .findAllSync()) {
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
}
