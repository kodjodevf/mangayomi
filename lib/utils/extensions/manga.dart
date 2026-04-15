import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';

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
    final filter = scanlators.where((e) => e.mangaId == id).toList();
    final filterScanlator = filter.firstOrNull?.scanlators ?? [];

    // Canonical ascending order (ch1 ... chN) — reader always moves forward.
    final data = chapters
        .toList(); // keep DB/insertion order, assumed ascending

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
        SortChapter(mangaId: id, index: 1, reverse: false);
    final sortIndex = sortChapterEntry.index!;
    final reverse = sortChapterEntry.reverse!;

    // Start from the reading list so filter logic lives in one place.
    List<Chapter> list = getChapterListForReading();

    switch (sortIndex) {
      case 0: // by scanlator, then date
        list.sort((a, b) {
          if (a.scanlator == null || b.scanlator == null) return 0;
          final s = a.scanlator!.compareTo(b.scanlator!);
          if (s != 0) return s;
          if (a.dateUpload == null || b.dateUpload == null) return 0;
          return int.parse(a.dateUpload!).compareTo(int.parse(b.dateUpload!));
        });
      case 1: // by chapter number - reading list is already ascending
        break;
      case 2: // by upload date
        list.sort((a, b) {
          if (a.dateUpload == null || b.dateUpload == null) return 0;
          return int.parse(a.dateUpload!).compareTo(int.parse(b.dateUpload!));
        });
      case 3: // by name
        list.sort((a, b) {
          if (a.name == null || b.name == null) return 0;
          return a.name!.compareTo(b.name!);
        });
    }

    return reverse ? list.reversed.toList() : list;
  }
}
