import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/utils/chapter_recognition.dart';

/// Sort/identity keys that only bucket by season if numbering actually
/// repeats across seasons (a real reset) — otherwise chapters key by raw
/// number. Precise (not truncated) so split chapters (12, 12.1, 12.5, ...)
/// sort and dedup correctly instead of colliding at the same integer. A
/// null value means the name had no detectable number at all (e.g.
/// "Special") — distinct from a genuine chapter 0, so callers know not to
/// treat every such chapter as a duplicate of every other one.
Map<int?, double?> _chapterSortKeys(
  String mangaTitle,
  List<Chapter> chapterList,
) {
  final recognition = ChapterRecognition();
  final raw = <int?, (int, double?)>{
    for (final c in chapterList)
      c.id: recognition.rawSeasonAndNumber(mangaTitle, c.name ?? ''),
  };
  final episodeToSeasons = <double, Set<int>>{};
  for (final pair in raw.values) {
    if (pair.$2 == null) continue;
    episodeToSeasons.putIfAbsent(pair.$2!, () => {}).add(pair.$1);
  }
  // A single collision is more likely a stray "S1-5 Recap"-style title
  // falsely matching the season regex than a real reset — require several
  // before trusting it, since a genuine per-season reset repeats numbers
  // across many chapters, not just one.
  final collisions = episodeToSeasons.values
      .where((seasons) => seasons.length > 1)
      .length;
  final resets = collisions >= 3;
  return {
    for (final entry in raw.entries)
      entry.key: switch (entry.value.$2) {
        null => null,
        final ep => resets
            ? (entry.value.$1 > 0 ? entry.value.$1 * 100000 + ep : ep)
            : ep,
      },
  };
}

extension MangaExtensions on Manga {
  /// Number of unread chapters, excluding chapters from scanlators the user has
  /// filtered out for this manga. Mirrors the chapter list's scanlator filter,
  /// so the library "unread" badge and the unread sort reflect what the user
  /// actually sees rather than counting duplicate chapters from hidden
  /// scanlators (#796).
  int unreadChaptersCount(Settings settings) {
    final filter = settings.filterScanlatorList
        ?.where((e) => e.mangaId == id)
        .firstOrNull
        ?.scanlators;
    if (filter == null || filter.isEmpty) {
      return chapters.where((c) => !(c.isRead ?? false)).length;
    }
    return chapters
        .where((c) => !(c.isRead ?? false) && !filter.contains(c.scanlator))
        .length;
  }

  /// Filtered chapters respecting the user's active filters (unread,
  /// bookmarked, downloaded, scanlator). Sorted by chapter number ascending.
  /// Base list — no user-chosen sort, no deduplication.
  List<Chapter> getFilteredChapters([Settings? settingsOverride]) {
    final settings = settingsOverride ?? isar.settings.getSync(227)!;

    final filterUnread =
        (settings.chapterFilterUnreadList!
                    .where((e) => e.mangaId == id)
                    .firstOrNull ??
                ChapterFilterUnread(mangaId: id, type: 0))
            .type!;

    final filterBookmarked =
        (settings.chapterFilterBookmarkedList!
                    .where((e) => e.mangaId == id)
                    .firstOrNull ??
                ChapterFilterBookmarked(mangaId: id, type: 0))
            .type!;

    final filterDownloaded =
        (settings.chapterFilterDownloadedList!
                    .where((e) => e.mangaId == id)
                    .firstOrNull ??
                ChapterFilterDownloaded(mangaId: id, type: 0))
            .type!;

    final scanlators = settings.filterScanlatorList ?? [];
    final filter = scanlators.where((e) => e.mangaId == id);
    final filterScanlator = filter.firstOrNull?.scanlators ?? [];

    final data = chapters.toList();
    final sortKeys = _chapterSortKeys(name ?? '', data);
    data.sort(
      (a, b) => (sortKeys[a.id] ?? 0).compareTo(sortKeys[b.id] ?? 0),
    );

    final chapterIds = data.map((c) => c.id).whereType<int>().toList();
    final downloadedIds = (filterDownloaded == 0 || chapterIds.isEmpty)
        ? const <int>{}
        : isar.downloads
              .where()
              .anyOf(chapterIds, (q, id) => q.idEqualTo(id))
              .filter()
              .isDownloadEqualTo(true)
              .findAllSync()
              .map((d) => d.id!)
              .toSet();

    return data
        .where(
          (e) => filterUnread == 1
              ? e.isRead == false
              : filterUnread == 2
              ? e.isRead == true
              : true,
        )
        .where(
          (e) => filterBookmarked == 1
              ? e.isBookmarked == true
              : filterBookmarked == 2
              ? e.isBookmarked == false
              : true,
        )
        .where((e) {
          if (filterDownloaded == 0) return true;
          final dl = downloadedIds.contains(e.id);
          return filterDownloaded == 1 ? dl : !dl;
        })
        .where((e) => !filterScanlator.contains(e.scanlator))
        .toList();
  }

  /// Filtered chapters for display in the chapter list UI: same filters as
  /// [getFilteredChapters] with the user's chosen sort order and direction applied.
  List<Chapter> getSortedFilteredChapters() {
    final settings = isar.settings.getSync(227)!;

    final sortChapterEntry =
        settings.sortChapterList!.where((e) => e.mangaId == id).firstOrNull ??
        SortChapter(mangaId: id, index: 1);
    final sortIndex = sortChapterEntry.index!;
    final reverse = sortChapterEntry.reverse!;

    // Build on getFilteredChapters so filter logic lives in one place.
    List<Chapter> list = getFilteredChapters(settings);

    switch (sortIndex) {
      case 0: // by scanlator, then chapter number
        final sortKeys = _chapterSortKeys(name ?? '', chapters.toList());
        list.sort((a, b) {
          final s = (a.scanlator ?? '').compareTo(b.scanlator ?? '');
          if (s != 0) return s;
          return (sortKeys[a.id] ?? 0).compareTo(sortKeys[b.id] ?? 0);
        });
        break;
      case 2: // by upload date
        list.sort((a, b) {
          if (a.dateUpload == null || b.dateUpload == null) return 0;
          return (int.tryParse(a.dateUpload!) ?? 0).compareTo(
            int.tryParse(b.dateUpload!) ?? 0,
          );
        });
        break;
      case 3: // by name
        list.sort((a, b) {
          if (a.name == null || b.name == null) return 0;
          return a.name!.compareTo(b.name!);
        });
        break;
      case 1:
      default:
        // getFilteredChapters already sorted by chapter number; nothing to do.
        break;
    }

    return reverse ? list : list.reversed.toList();
  }

  /// Filtered chapters ready for sequential reading: same filters as
  /// [getFilteredChapters] but with duplicate chapter numbers collapsed to a
  /// single entry so the reader advances to the next story chapter rather than
  /// another scanlator's copy of the same one. Chapters with no detectable
  /// number (key is null — e.g. "Special") are never collapsed: there is no
  /// reliable way to tell them apart, so treating them all as duplicates
  /// would silently drop real chapters instead of just scanlator copies.
  List<Chapter> getChapterListForReading() {
    final list = getFilteredChapters();
    final sortKeys = _chapterSortKeys(name ?? '', list);
    final seen = <double>{};
    return list.where((c) {
      final key = sortKeys[c.id];
      return key == null || seen.add(key);
    }).toList();
  }
}
