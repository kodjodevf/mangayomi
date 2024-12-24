import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'novel_reader_controller_provider.g.dart';

@riverpod
class NovelReaderController extends _$NovelReaderController {
  @override
  void build({required Chapter chapter}) {}

  Manga getManga() {
    return chapter.manga.value!;
  }

  Chapter geChapter() {
    return chapter;
  }

  final incognitoMode = isar.settings.getSync(227)!.incognitoMode!;

  Settings getIsarSetting() {
    return isar.settings.getSync(227)!;
  }

  void setMangaHistoryUpdate() {
    if (incognitoMode) return;
    isar.writeTxnSync(() {
      Manga? manga = chapter.manga.value;
      manga!.lastRead = DateTime.now().millisecondsSinceEpoch;
      isar.mangas.putSync(manga);
    });
    History? history;

    final empty =
        isar.historys.filter().mangaIdEqualTo(getManga().id).isEmptySync();

    if (empty) {
      history = History(
          mangaId: getManga().id,
          date: DateTime.now().millisecondsSinceEpoch.toString(),
          itemType: getManga().itemType,
          chapterId: chapter.id)
        ..chapter.value = chapter;
    } else {
      history = (isar.historys
          .filter()
          .mangaIdEqualTo(getManga().id)
          .findFirstSync())!
        ..chapterId = chapter.id
        ..chapter.value = chapter
        ..date = DateTime.now().millisecondsSinceEpoch.toString();
    }
    isar.writeTxnSync(() {
      isar.historys.putSync(history!);
      history.chapter.saveSync();
    });
  }

  void setChapterOffset(double newOffset, double maxOffset, bool save) {
    if (incognitoMode) return;
    final isRead = (newOffset / (maxOffset != 0 ? maxOffset : 1)) >= 0.9;
    if (isRead || save) {
      final ch = chapter;
      isar.writeTxnSync(() {
        ch.isRead = isRead;
        ch.lastPageRead =
            (maxOffset != 0 ? newOffset / maxOffset : 0).toString();
        isar.chapters.putSync(ch);
      });
    }
  }

  void setChapterBookmarked() {
    if (incognitoMode) return;
    final isBookmarked = getChapterBookmarked();
    final chap = chapter;
    isar.writeTxnSync(() {
      chap.isBookmarked = !isBookmarked;
      isar.chapters.putSync(chap);
    });
  }

  bool getChapterBookmarked() {
    return isar.chapters.getSync(chapter.id!)!.isBookmarked!;
  }

  (int, bool) getPrevChapterIndex() {
    final chapters = getManga().getFilteredChapterList();
    int? index;
    for (var i = 0; i < chapters.length; i++) {
      if (chapters[i].id == chapter.id) {
        index = i + 1;
      }
    }
    if (index == null) {
      final chapters = getManga().chapters.toList().toList();
      for (var i = 0; i < chapters.length; i++) {
        if (chapters[i].id == chapter.id) {
          index = i + 1;
        }
      }
      return (index!, false);
    }
    return (index, true);
  }

  (int, bool) getNextChapterIndex() {
    final chapters = getManga().getFilteredChapterList();
    int? index;
    for (var i = 0; i < chapters.length; i++) {
      if (chapters[i].id == chapter.id) {
        index = i - 1;
      }
    }
    if (index == null) {
      final chapters = getManga().chapters.toList().toList();
      for (var i = 0; i < chapters.length; i++) {
        if (chapters[i].id == chapter.id) {
          index = i - 1;
        }
      }
      return (index!, false);
    }
    return (index, true);
  }

  (int, bool) getChapterIndex() {
    final chapters = getManga().getFilteredChapterList();
    int? index;
    for (var i = 0; i < chapters.length; i++) {
      if (chapters[i].id == chapter.id) {
        index = i;
      }
    }
    if (index == null) {
      final chapters = getManga().chapters.toList().toList();
      for (var i = 0; i < chapters.length; i++) {
        if (chapters[i].id == chapter.id) {
          index = i;
        }
      }
      return (index!, false);
    }
    return (index, true);
  }

  Chapter getPrevChapter() {
    final prevChapIdx = getPrevChapterIndex();
    return prevChapIdx.$2
        ? getManga().getFilteredChapterList()[prevChapIdx.$1]
        : getManga().chapters.toList().toList()[prevChapIdx.$1];
  }

  Chapter getNextChapter() {
    final nextChapIdx = getNextChapterIndex();
    return nextChapIdx.$2
        ? getManga().getFilteredChapterList()[nextChapIdx.$1]
        : getManga().chapters.toList().toList()[nextChapIdx.$1];
  }

  int getChaptersLength(bool isInFilterList) {
    return isInFilterList
        ? getManga().getFilteredChapterList().length
        : getManga().chapters.length;
  }

  String getMangaName() {
    return getManga().name!;
  }

  String getSourceName() {
    return getManga().source!;
  }

  String getChapterTitle() {
    return chapter.name!;
  }
}

extension MangaExtensions on Manga {
  List<Chapter> getFilteredChapterList() {
    final data = this.chapters.toList().toList();
    final filterUnread = (isar.settings
                .getSync(227)!
                .chapterFilterUnreadList!
                .where((element) => element.mangaId == id)
                .toList()
                .firstOrNull ??
            ChapterFilterUnread(
              mangaId: id,
              type: 0,
            ))
        .type!;

    final filterBookmarked = (isar.settings
                .getSync(227)!
                .chapterFilterBookmarkedList!
                .where((element) => element.mangaId == id)
                .toList()
                .firstOrNull ??
            ChapterFilterBookmarked(
              mangaId: id,
              type: 0,
            ))
        .type!;
    final filterDownloaded = (isar.settings
                .getSync(227)!
                .chapterFilterDownloadedList!
                .where((element) => element.mangaId == id)
                .toList()
                .firstOrNull ??
            ChapterFilterDownloaded(
              mangaId: id,
              type: 0,
            ))
        .type!;

    final sortChapter = (isar.settings
                .getSync(227)!
                .sortChapterList!
                .where((element) => element.mangaId == id)
                .toList()
                .firstOrNull ??
            SortChapter(
              mangaId: id,
              index: 1,
              reverse: false,
            ))
        .index;
    final filterScanlator = _getFilterScanlator(this) ?? [];
    List<Chapter>? chapterList;
    chapterList = data
        .where((element) => filterUnread == 1
            ? element.isRead == false
            : filterUnread == 2
                ? element.isRead == true
                : true)
        .where((element) => filterBookmarked == 1
            ? element.isBookmarked == true
            : filterBookmarked == 2
                ? element.isBookmarked == false
                : true)
        .where((element) {
          final modelChapDownload = isar.downloads
              .filter()
              .idIsNotNull()
              .chapterIdEqualTo(element.id)
              .findAllSync();
          return filterDownloaded == 1
              ? modelChapDownload.isNotEmpty &&
                  modelChapDownload.first.isDownload == true
              : filterDownloaded == 2
                  ? !(modelChapDownload.isNotEmpty &&
                      modelChapDownload.first.isDownload == true)
                  : true;
        })
        .where((element) => !filterScanlator.contains(element.scanlator))
        .toList();
    List<Chapter> chapters =
        sortChapter == 1 ? chapterList.reversed.toList() : chapterList;
    if (sortChapter == 0) {
      chapters.sort(
        (a, b) {
          return (a.scanlator == null ||
                  b.scanlator == null ||
                  a.dateUpload == null ||
                  b.dateUpload == null)
              ? 0
              : a.scanlator!.compareTo(b.scanlator!) |
                  a.dateUpload!.compareTo(b.dateUpload!);
        },
      );
    } else if (sortChapter == 2) {
      chapters.sort(
        (a, b) {
          return (a.dateUpload == null || b.dateUpload == null)
              ? 0
              : int.parse(a.dateUpload!).compareTo(int.parse(b.dateUpload!));
        },
      );
    } else if (sortChapter == 3) {
      chapters.sort(
        (a, b) {
          return (a.name == null || b.name == null)
              ? 0
              : a.name!.compareTo(b.name!);
        },
      );
    }
    return chapterList;
  }
}

List<String>? _getFilterScanlator(Manga manga) {
  final scanlators = isar.settings.getSync(227)!.filterScanlatorList ?? [];
  final filter =
      scanlators.where((element) => element.mangaId == manga.id).toList();
  return filter.firstOrNull?.scanlators;
}
