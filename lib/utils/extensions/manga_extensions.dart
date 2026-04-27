import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/utils/chapter_recognition.dart';

extension MangaExtensions on Manga {
  // ── For the READER: always ascending story order, filters applied ──────────
  List<Chapter> getChapterListForReading() {
    final settings = isar.settings.getSync(227)!;

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
    final recognition = ChapterRecognition();
    final mangaTitle = name ?? '';

    // Memoize so each chapter name is parsed at most once during the sort.
    final numCache = <int?, int>{};
    int chapNum(Chapter c) => numCache[c.id] ??= recognition.parseChapterNumber(
      mangaTitle,
      c.name ?? '',
    );

    // Sort by chapter number — DB insertion order is NOT guaranteed to be ascending
    final data = chapters.toList()
      ..sort((a, b) => chapNum(a).compareTo(chapNum(b)));

    final chapterIds = data.map((c) => c.id).whereType<int>().toList();
    final downloadedIds = (filterDownloaded == 0 || chapterIds.isEmpty)
        ? const <int>{}
        : isar.downloads
              .filter()
              .anyOf(chapterIds, (q, id) => q.idEqualTo(id))
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

  // ── For the UI LIST: filters + user-chosen sort + reverse ─────────────────
  List<Chapter> getFilteredChapterList() {
    final settings = isar.settings.getSync(227)!;

    final sortChapterEntry =
        settings.sortChapterList!.where((e) => e.mangaId == id).firstOrNull ??
        SortChapter(mangaId: id, index: 1);
    final sortIndex = sortChapterEntry.index!;
    final reverse = sortChapterEntry.reverse!;

    // Start from the reading list so filter logic lives in one place.
    List<Chapter> list = getChapterListForReading();

    switch (sortIndex) {
      case 0: // by scanlator, then chapter number
        // Cache recognition instance — parseChapterNumber is called O(n log n)
        // times during sort, so avoid constructing it inside the comparator.
        final recognition = ChapterRecognition();
        final mangaTitle = name ?? '';

        // Returns the parsed chapter number for a chapter, used as the primary
        // numeric sort key for cases 0 and 1.
        final numCache = <int?, int>{};
        int chapNum(Chapter c) => numCache[c.id] ??= recognition
            .parseChapterNumber(mangaTitle, c.name ?? '');
        list.sort((a, b) {
          final s = (a.scanlator ?? '').compareTo(b.scanlator ?? '');
          if (s != 0) return s;
          return chapNum(a).compareTo(chapNum(b));
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
        // getChapterListForReading already sorted by chapter number; nothing to do.
        break;
    }

    return reverse ? list : list.reversed.toList();
  }
}
