import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'reader_controller_provider.g.dart';

@riverpod
class CurrentIndex extends _$CurrentIndex {
  @override
  int build(Chapter chapter) {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      return ReaderController(chapter: chapter).getPageIndex();
    }
    return 0;
  }

  setCurrentIndex(
    int currentIndex,
  ) {
    state = currentIndex;
  }
}

BoxFit getBoxFit(ScaleType scaleType) {
  return switch (scaleType) {
    ScaleType.fitHeight => BoxFit.fitHeight,
    ScaleType.fitWidth => BoxFit.fitWidth,
    ScaleType.fitScreen => BoxFit.contain,
    ScaleType.originalSize => BoxFit.cover,
    ScaleType.smartFit => BoxFit.contain,
    _ => BoxFit.fill
  };
}

class ReaderController {
  final Chapter chapter;
  ReaderController({required this.chapter});

  Manga getManga() {
    return chapter.manga.value!;
  }

  Chapter geChapter() {
    return chapter;
  }

  final incognitoMode = isar.settings.getSync(227)!.incognitoMode!;
  ReaderMode getReaderMode() {
    final personalReaderModeList =
        getIsarSetting().personalReaderModeList ?? [];
    final personalReaderMode = personalReaderModeList
        .where((element) => element.mangaId == getManga().id);
    if (personalReaderMode.isNotEmpty) {
      return personalReaderMode.first.readerMode;
    }
    return isar.settings.getSync(227)!.defaultReaderMode;
  }

  (bool, double) autoScrollValues() {
    final autoScrollPagesList = getIsarSetting().autoScrollPages ?? [];
    final autoScrollPages = autoScrollPagesList
        .where((element) => element.mangaId == getManga().id);
    if (autoScrollPages.isNotEmpty) {
      return (
        autoScrollPages.first.autoScroll ?? false,
        autoScrollPages.first.pageOffset ?? 10
      );
    }
    return (false, 10);
  }

  void setAutoScroll(bool value, double offset) {
    List<AutoScrollPages>? autoScrollPagesList = [];
    for (var autoScrollPages in getIsarSetting().autoScrollPages ?? []) {
      if (autoScrollPages.mangaId != getManga().id) {
        autoScrollPagesList.add(autoScrollPages);
      }
    }
    autoScrollPagesList.add(AutoScrollPages()
      ..mangaId = getManga().id
      ..pageOffset = offset
      ..autoScroll = value);
    isar.writeTxnSync(() => isar.settings
        .putSync(getIsarSetting()..autoScrollPages = autoScrollPagesList));
  }

  PageMode getPageMode() {
    final personalPageModeList = getIsarSetting().personalPageModeList ?? [];
    final personalPageMode = personalPageModeList
        .where((element) => element.mangaId == getManga().id);
    if (personalPageMode.isNotEmpty) {
      return personalPageMode.first.pageMode;
    }
    return PageMode.onePage;
  }

  void setReaderMode(ReaderMode newReaderMode) {
    List<PersonalReaderMode>? personalReaderModeLists = [];
    for (var personalReaderMode
        in getIsarSetting().personalReaderModeList ?? []) {
      if (personalReaderMode.mangaId != getManga().id) {
        personalReaderModeLists.add(personalReaderMode);
      }
    }
    personalReaderModeLists.add(PersonalReaderMode()
      ..mangaId = getManga().id
      ..readerMode = newReaderMode);
    isar.writeTxnSync(() => isar.settings.putSync(
        getIsarSetting()..personalReaderModeList = personalReaderModeLists));
  }

  void setPageMode(PageMode newPageMode) {
    List<PersonalPageMode>? personalPageModeLists = [];
    for (var personalPageMode in getIsarSetting().personalPageModeList ?? []) {
      if (personalPageMode.mangaId != getManga().id) {
        personalPageModeLists.add(personalPageMode);
      }
    }
    personalPageModeLists.add(PersonalPageMode()
      ..mangaId = getManga().id
      ..pageMode = newPageMode);
    isar.writeTxnSync(() => isar.settings.putSync(
        getIsarSetting()..personalPageModeList = personalPageModeLists));
  }

  void setShowPageNumber(bool value) {
    if (!incognitoMode) {
      isar.writeTxnSync(() =>
          isar.settings.putSync(getIsarSetting()..showPagesNumber = value));
    }
  }

  Settings getIsarSetting() {
    return isar.settings.getSync(227)!;
  }

  bool getShowPageNumber() {
    if (!incognitoMode) {
      return getIsarSetting().showPagesNumber!;
    }
    return true;
  }

  void setMangaHistoryUpdate() {
    if (!incognitoMode) {
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
            isManga: getManga().isManga,
            chapterId: chapter.id)
          ..chapter.value = chapter;
      } else {
        history = (isar.historys
            .filter()
            .mangaIdEqualTo(getManga().id)
            .findFirstSync())!
          ..chapter.value = chapter
          ..date = DateTime.now().millisecondsSinceEpoch.toString();
      }
      isar.writeTxnSync(() {
        isar.historys.putSync(history!);
        history.chapter.saveSync();
      });
    }
  }

  void setChapterBookmarked() {
    if (!incognitoMode) {
      final isBookmarked = getChapterBookmarked();
      final chap = chapter;
      isar.writeTxnSync(() {
        chap.isBookmarked = !isBookmarked;
        isar.chapters.putSync(chap);
      });
    }
  }

  bool getChapterBookmarked() {
    return isar.chapters.getSync(chapter.id!)!.isBookmarked!;
  }

  (int, bool) getPrevChapterIndex() {
    final chapters = _filterAndSortChapters();
    int? index;
    for (var i = 0; i < chapters.length; i++) {
      if (chapters[i].id == chapter.id) {
        index = i + 1;
      }
    }
    if (index == null) {
      final chapters = getManga().chapters.toList().reversed.toList();
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
    final chapters = _filterAndSortChapters();
    int? index;
    for (var i = 0; i < chapters.length; i++) {
      if (chapters[i].id == chapter.id) {
        index = i - 1;
      }
    }
    if (index == null) {
      final chapters = getManga().chapters.toList().reversed.toList();
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
    final chapters = _filterAndSortChapters();
    int? index;
    for (var i = 0; i < chapters.length; i++) {
      if (chapters[i].id == chapter.id) {
        index = i;
      }
    }
    if (index == null) {
      final chapters = getManga().chapters.toList().reversed.toList();
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
        ? _filterAndSortChapters()[prevChapIdx.$1]
        : getManga().chapters.toList().reversed.toList()[prevChapIdx.$1];
  }

  Chapter getNextChapter() {
    final nextChapIdx = getNextChapterIndex();
    return nextChapIdx.$2
        ? _filterAndSortChapters()[nextChapIdx.$1]
        : getManga().chapters.toList().reversed.toList()[nextChapIdx.$1];
  }

  int getChaptersLength(bool isInFilterList) {
    return isInFilterList
        ? _filterAndSortChapters().length
        : getManga().chapters.length;
  }

  int getPageIndex() {
    final chapterPageIndexList = getIsarSetting().chapterPageIndexList ?? [];
    final index = chapterPageIndexList
        .where((element) => element.chapterId == chapter.id);
    if (!incognitoMode) {
      return chapter.isRead!
          ? 0
          : index.isNotEmpty
              ? index.first.index!
              : 0;
    }
    return 0;
  }

  int getPageLength(List incognitoPageLength) {
    if (!incognitoMode) {
      return getIsarSetting()
          .chapterPageUrlsList!
          .where((element) => element.chapterId == chapter.id)
          .first
          .urls!
          .length;
    }
    return incognitoPageLength.length;
  }

  void setPageIndex(int newIndex) {
    if (!chapter.isRead!) {
      if (!incognitoMode) {
        List<ChapterPageIndex>? chapterPageIndexs = [];
        for (var chapterPageIndex
            in getIsarSetting().chapterPageIndexList ?? []) {
          if (chapterPageIndex.chapterId != chapter.id) {
            chapterPageIndexs.add(chapterPageIndex);
          }
        }
        chapterPageIndexs.add(ChapterPageIndex()
          ..chapterId = chapter.id
          ..index = newIndex);
        final chap = chapter;
        final isRead = (newIndex + 1) == getPageLength([]);
        isar.writeTxnSync(() {
          isar.settings.putSync(
              getIsarSetting()..chapterPageIndexList = chapterPageIndexs);
          chap.isRead = isRead;
          chap.lastPageRead = isRead ? '1' : (newIndex + 1).toString();
          isar.chapters.putSync(chap);
        });
      }
    }
  }

  List<String>? _getFilterScanlator() {
    final scanlators = isar.settings.getSync(227)!.filterScanlatorList ?? [];
    final filter = scanlators
        .where((element) => element.mangaId == getManga().id)
        .toList();
    return filter.isEmpty ? null : filter.first.scanlators;
  }

  List<Chapter> _filterAndSortChapters() {
    final data = getManga().chapters.toList().reversed.toList();
    final filterUnread = isar.settings
        .getSync(227)!
        .chapterFilterUnreadList!
        .where((element) => element.mangaId == getManga().id)
        .toList()
        .first
        .type!;

    final filterBookmarked = isar.settings
        .getSync(227)!
        .chapterFilterBookmarkedList!
        .where((element) => element.mangaId == getManga().id)
        .toList()
        .first
        .type!;
    final filterDownloaded = isar.settings
        .getSync(227)!
        .chapterFilterDownloadedList!
        .where((element) => element.mangaId == getManga().id)
        .toList()
        .first
        .type!;

    final sortChapter = isar.settings
        .getSync(227)!
        .sortChapterList!
        .where((element) => element.mangaId == getManga().id)
        .toList()
        .first
        .index;
    final filterScanlator = _getFilterScanlator() ?? [];
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
