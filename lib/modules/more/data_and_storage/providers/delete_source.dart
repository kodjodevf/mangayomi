import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/utils/isar_txn_retry.dart';

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

List<LibrarySourceGroup> librarySourceGroups() {
  final counts = <String, LibrarySourceGroup>{};
  for (final m in isar.mangas.where().findAllSync()) {
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

List<Manga> mangaForGroup(LibrarySourceGroup group) {
  return isar.mangas.where().findAllSync().where((m) {
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
    required this.trackCount,
  });

  final int mangaCount;
  final int chapterCount;
  final int historyCount;
  final int updateCount;
  final int trackCount;
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
  final trackCount = mangaIds.isEmpty
      ? 0
      : isar.tracks
            .filter()
            .anyOf(mangaIds, (q, id) => q.mangaIdEqualTo(id))
            .countSync();
  return DeleteSourceCounts(
    mangaCount: mangaList.length,
    chapterCount: chapterCount,
    historyCount: historyCount,
    updateCount: updateCount,
    trackCount: trackCount,
  );
}

Future<void> deleteSourceLibrary(
  List<Manga> mangaList,
  LibrarySourceGroup group, {
  bool alsoRemoveExtension = false,
}) async {
  await writeTxnSyncWithRetry(() {
    for (final manga in mangaList) {
      final chapterIds = isar.chapters
          .filter()
          .mangaIdEqualTo(manga.id)
          .findAllSync()
          .map((c) => c.id!)
          .toList();
      if (chapterIds.isNotEmpty) {
        isar.downloads.deleteAllSync(chapterIds);
        isar.chapters.deleteAllSync(chapterIds);
      }
    }
    final mangaIds = mangaList.map((m) => m.id!).toList();
    if (mangaIds.isNotEmpty) {
      isar.historys
          .filter()
          .anyOf(mangaIds, (q, id) => q.mangaIdEqualTo(id))
          .deleteAllSync();
      isar.updates
          .filter()
          .anyOf(mangaIds, (q, id) => q.mangaIdEqualTo(id))
          .deleteAllSync();
      isar.tracks
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

class DuplicateSourceCluster {
  DuplicateSourceCluster(this.groups);

  final List<LibrarySourceGroup> groups;
}

String _normalizeSourceName(String name) =>
    name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

bool _looksLikeSameSource(LibrarySourceGroup a, LibrarySourceGroup b) {
  if (a.itemType != b.itemType) return false;
  final na = _normalizeSourceName(a.sourceName);
  final nb = _normalizeSourceName(b.sourceName);
  if (na.isEmpty || nb.isEmpty) return false;
  if (na == nb) return true;
  if (na.length >= 4 && nb.contains(na)) return true;
  if (nb.length >= 4 && na.contains(nb)) return true;
  return false;
}

List<DuplicateSourceCluster> findDuplicateSourceClusters() {
  final groups = librarySourceGroups();
  final n = groups.length;
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
      if (_looksLikeSameSource(groups[i], groups[j])) union(i, j);
    }
  }
  final clusters = <int, List<LibrarySourceGroup>>{};
  for (var i = 0; i < n; i++) {
    clusters.putIfAbsent(find(i), () => []).add(groups[i]);
  }
  return clusters.values
      .where((g) => g.length > 1)
      .map(DuplicateSourceCluster.new)
      .toList();
}

Future<void> mergeSourceGroups(
  LibrarySourceGroup primary,
  List<LibrarySourceGroup> others,
) async {
  await writeTxnSyncWithRetry(() {
    for (final other in others) {
      for (final manga in mangaForGroup(other)) {
        manga.source = primary.sourceName;
        manga.sourceId = primary.sourceId;
        manga.lang = primary.lang;
        isar.mangas.putSync(manga);
      }
    }
  });
}
