import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/manga/detail/providers/track_state_providers.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/utils/chapter_recognition.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'reader_controller_provider.g.dart';

@riverpod
class CurrentIndex extends _$CurrentIndex {
  @override
  int build(Chapter chapter) {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (incognitoMode) return 0;
    return ref
        .read(readerControllerProvider(chapter: chapter).notifier)
        .getPageIndex();
  }

  setCurrentIndex(int currentIndex) {
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
    _ => BoxFit.cover,
  };
}

@riverpod
class ReaderController extends _$ReaderController {
  @override
  void build({required Chapter chapter}) {}

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
    final personalReaderMode = personalReaderModeList.where(
      (element) => element.mangaId == getManga().id,
    );
    if (personalReaderMode.isNotEmpty) {
      return personalReaderMode.first.readerMode;
    }
    return isar.settings.getSync(227)!.defaultReaderMode;
  }

  (bool, double) autoScrollValues() {
    final autoScrollPagesList = getIsarSetting().autoScrollPages ?? [];
    final autoScrollPages = autoScrollPagesList.where(
      (element) => element.mangaId == getManga().id,
    );
    if (autoScrollPages.isNotEmpty) {
      return (
        autoScrollPages.first.autoScroll ?? false,
        autoScrollPages.first.pageOffset ?? 10,
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
    autoScrollPagesList.add(
      AutoScrollPages()
        ..mangaId = getManga().id
        ..pageOffset = offset
        ..autoScroll = value,
    );
    isar.writeTxnSync(
      () => isar.settings.putSync(
        getIsarSetting()
          ..autoScrollPages = autoScrollPagesList
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  PageMode getPageMode() {
    final personalPageModeList = getIsarSetting().personalPageModeList ?? [];
    final personalPageMode = personalPageModeList.where(
      (element) => element.mangaId == getManga().id,
    );
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
    personalReaderModeLists.add(
      PersonalReaderMode()
        ..mangaId = getManga().id
        ..readerMode = newReaderMode,
    );
    isar.writeTxnSync(
      () => isar.settings.putSync(
        getIsarSetting()
          ..personalReaderModeList = personalReaderModeLists
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  void setPageMode(PageMode newPageMode) {
    List<PersonalPageMode>? personalPageModeLists = [];
    for (var personalPageMode in getIsarSetting().personalPageModeList ?? []) {
      if (personalPageMode.mangaId != getManga().id) {
        personalPageModeLists.add(personalPageMode);
      }
    }
    personalPageModeLists.add(
      PersonalPageMode()
        ..mangaId = getManga().id
        ..pageMode = newPageMode,
    );
    isar.writeTxnSync(
      () => isar.settings.putSync(
        getIsarSetting()
          ..personalPageModeList = personalPageModeLists
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  void setShowPageNumber(bool value) {
    if (!incognitoMode) {
      isar.writeTxnSync(
        () => isar.settings.putSync(
          getIsarSetting()
            ..showPagesNumber = value
            ..updatedAt = DateTime.now().millisecondsSinceEpoch,
        ),
      );
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
    if (incognitoMode) return;
    isar.writeTxnSync(() {
      Manga? manga = chapter.manga.value;
      manga!.lastRead = DateTime.now().millisecondsSinceEpoch;
      manga.updatedAt = DateTime.now().millisecondsSinceEpoch;
      isar.mangas.putSync(manga);
    });
    History? history;

    final empty = isar.historys
        .filter()
        .mangaIdEqualTo(getManga().id)
        .isEmptySync();

    if (empty) {
      history = History(
        mangaId: getManga().id,
        date: DateTime.now().millisecondsSinceEpoch.toString(),
        itemType: getManga().itemType,
        chapterId: chapter.id,
      )..chapter.value = chapter;
    } else {
      history =
          (isar.historys
                .filter()
                .mangaIdEqualTo(getManga().id)
                .findFirstSync())!
            ..chapterId = chapter.id
            ..chapter.value = chapter
            ..date = DateTime.now().millisecondsSinceEpoch.toString();
    }
    isar.writeTxnSync(() {
      history!.updatedAt = DateTime.now().millisecondsSinceEpoch;
      isar.historys.putSync(history);
      history.chapter.saveSync();
    });
  }

  void setChapterBookmarked() {
    if (incognitoMode) return;
    final isBookmarked = getChapterBookmarked();
    final chap = chapter;
    isar.writeTxnSync(() {
      chap.isBookmarked = !isBookmarked;
      chap.updatedAt = DateTime.now().millisecondsSinceEpoch;
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
    final chapters = getManga().getFilteredChapterList();
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
    final chapters = getManga().getFilteredChapterList();
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
        ? getManga().getFilteredChapterList()[prevChapIdx.$1]
        : getManga().chapters.toList().reversed.toList()[prevChapIdx.$1];
  }

  Chapter getNextChapter() {
    final nextChapIdx = getNextChapterIndex();
    return nextChapIdx.$2
        ? getManga().getFilteredChapterList()[nextChapIdx.$1]
        : getManga().chapters.toList().reversed.toList()[nextChapIdx.$1];
  }

  int getChaptersLength(bool isInFilterList) {
    return isInFilterList
        ? getManga().getFilteredChapterList().length
        : getManga().chapters.length;
  }

  int getPageIndex() {
    if (incognitoMode) return 0;
    final chapterPageIndexList = getIsarSetting().chapterPageIndexList ?? [];
    final index = chapterPageIndexList.where(
      (element) => element.chapterId == chapter.id,
    );
    return chapter.isRead!
        ? 0
        : index.isNotEmpty
        ? index.first.index!
        : 0;
  }

  int getPageLength(List incognitoPageLength) {
    if (incognitoMode) return incognitoPageLength.length;
    return getIsarSetting().chapterPageUrlsList!
        .where((element) => element.chapterId == chapter.id)
        .first
        .urls!
        .length;
  }

  void setPageIndex(int newIndex, bool save) {
    if (chapter.isRead!) return;
    if (incognitoMode) return;
    final isRead =
        (getReaderMode() == ReaderMode.verticalContinuous ||
            getReaderMode() == ReaderMode.webtoon)
        ? ((newIndex + 2) == getPageLength([]) - 1)
              ? ((newIndex + 2) == getPageLength([]) - 1)
              : (newIndex + 2) == getPageLength([])
        : (newIndex + 2) == getPageLength([]);
    if (isRead || save) {
      List<ChapterPageIndex>? chapterPageIndexs = [];
      for (var chapterPageIndex
          in getIsarSetting().chapterPageIndexList ?? []) {
        if (chapterPageIndex.chapterId != chapter.id) {
          chapterPageIndexs.add(chapterPageIndex);
        }
      }
      chapterPageIndexs.add(
        ChapterPageIndex()
          ..chapterId = chapter.id
          ..index = isRead ? 0 : newIndex,
      );
      final chap = chapter;
      isar.writeTxnSync(() {
        isar.settings.putSync(
          getIsarSetting()
            ..chapterPageIndexList = chapterPageIndexs
            ..updatedAt = DateTime.now().millisecondsSinceEpoch,
        );
        chap.isRead = isRead;
        chap.lastPageRead = isRead ? '1' : (newIndex + 1).toString();
        chap.updatedAt = DateTime.now().millisecondsSinceEpoch;
        isar.chapters.putSync(chap);
      });
      if (isRead) {
        chapter.updateTrackChapterRead(ref);
      }
    }
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

extension ChapterExtensions on Chapter {
  void updateTrackChapterRead(dynamic ref) {
    if (!(ref is WidgetRef || ref is Ref)) return;
    final updateProgressAfterReading = ref.watch(
      updateProgressAfterReadingStateProvider,
    );
    if (!updateProgressAfterReading) return;
    final manga = this.manga.value!;
    final chapterNumber = ChapterRecognition().parseChapterNumber(
      manga.name!,
      name!,
    );

    final tracks = isar.tracks
        .filter()
        .idIsNotNull()
        .itemTypeEqualTo(manga.itemType)
        .mangaIdEqualTo(manga.id!)
        .findAllSync();

    if (tracks.isEmpty) return;
    for (var track in tracks) {
      final service = isar.trackPreferences
          .filter()
          .syncIdIsNotNull()
          .syncIdEqualTo(track.syncId)
          .findFirstSync();
      if (!(service == null || chapterNumber <= (track.lastChapterRead ?? 0))) {
        if (track.status != TrackStatus.completed) {
          track.lastChapterRead = chapterNumber;
          if (track.lastChapterRead == track.totalChapter &&
              (track.totalChapter ?? 0) > 0) {
            track.status = TrackStatus.completed;
            track.finishedReadingDate = DateTime.now().millisecondsSinceEpoch;
          } else {
            track.status = manga.itemType == ItemType.manga
                ? TrackStatus.reading
                : TrackStatus.watching;
            if (track.lastChapterRead == 1) {
              track.startedReadingDate = DateTime.now().millisecondsSinceEpoch;
            }
          }
        }
        ref
            .read(
              trackStateProvider(
                track: track,
                itemType: manga.itemType,
              ).notifier,
            )
            .updateManga();
      }
    }
  }
}

extension MangaExtensions on Manga {
  List<Chapter> getFilteredChapterList() {
    final data = this.chapters.toList().reversed.toList();
    final filterUnread =
        (isar.settings
                    .getSync(227)!
                    .chapterFilterUnreadList!
                    .where((element) => element.mangaId == id)
                    .toList()
                    .firstOrNull ??
                ChapterFilterUnread(mangaId: id, type: 0))
            .type!;

    final filterBookmarked =
        (isar.settings
                    .getSync(227)!
                    .chapterFilterBookmarkedList!
                    .where((element) => element.mangaId == id)
                    .toList()
                    .firstOrNull ??
                ChapterFilterBookmarked(mangaId: id, type: 0))
            .type!;
    final filterDownloaded =
        (isar.settings
                    .getSync(227)!
                    .chapterFilterDownloadedList!
                    .where((element) => element.mangaId == id)
                    .toList()
                    .firstOrNull ??
                ChapterFilterDownloaded(mangaId: id, type: 0))
            .type!;

    final sortChapter =
        (isar.settings
                    .getSync(227)!
                    .sortChapterList!
                    .where((element) => element.mangaId == id)
                    .toList()
                    .firstOrNull ??
                SortChapter(mangaId: id, index: 1, reverse: false))
            .index;
    final filterScanlator = _getFilterScanlator(this) ?? [];
    List<Chapter>? chapterList;
    chapterList = data
        .where(
          (element) => filterUnread == 1
              ? element.isRead == false
              : filterUnread == 2
              ? element.isRead == true
              : true,
        )
        .where(
          (element) => filterBookmarked == 1
              ? element.isBookmarked == true
              : filterBookmarked == 2
              ? element.isBookmarked == false
              : true,
        )
        .where((element) {
          final modelChapDownload = isar.downloads
              .filter()
              .idEqualTo(element.id)
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
    List<Chapter> chapters = sortChapter == 1
        ? chapterList.reversed.toList()
        : chapterList;
    if (sortChapter == 0) {
      chapters.sort((a, b) {
        return (a.scanlator == null ||
                b.scanlator == null ||
                a.dateUpload == null ||
                b.dateUpload == null)
            ? 0
            : a.scanlator!.compareTo(b.scanlator!) |
                  a.dateUpload!.compareTo(b.dateUpload!);
      });
    } else if (sortChapter == 2) {
      chapters.sort((a, b) {
        return (a.dateUpload == null || b.dateUpload == null)
            ? 0
            : int.parse(a.dateUpload!).compareTo(int.parse(b.dateUpload!));
      });
    } else if (sortChapter == 3) {
      chapters.sort((a, b) {
        return (a.name == null || b.name == null)
            ? 0
            : a.name!.compareTo(b.name!);
      });
    }
    return chapterList;
  }
}

List<String>? _getFilterScanlator(Manga manga) {
  final scanlators = isar.settings.getSync(227)!.filterScanlatorList ?? [];
  final filter = scanlators
      .where((element) => element.mangaId == manga.id)
      .toList();
  return filter.firstOrNull?.scanlators;
}
