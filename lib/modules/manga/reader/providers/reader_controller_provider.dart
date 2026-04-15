import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/modules/manga/reader/mixins/chapter_reader_settings_mixin.dart';
import 'package:mangayomi/modules/manga/reader/mixins/chapter_controller_mixin.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/manga/detail/providers/track_state_providers.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/downloads/providers/downloads_state_provider.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/utils/chapter_recognition.dart';
import 'package:mangayomi/utils/extensions/chapter.dart';
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

  void setCurrentIndex(int currentIndex) {
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
class ReaderController extends _$ReaderController
    with ChapterControllerMixin, ChapterReaderSettingsMixin {
  @override
  KeepAliveLink build({required Chapter chapter}) {
    _keepAliveLink = ref.keepAlive();
    return _keepAliveLink!;
  }

  KeepAliveLink? _keepAliveLink;
  KeepAliveLink? get keepAliveLink => _keepAliveLink;

  // Keep incognitoMode as a final field so it is read from Isar only once.
  @override
  final bool incognitoMode = isar.settings.getSync(227)!.incognitoMode!;

  // Override getIsarSetting to add per-instance caching; callers that mutate
  // settings must call _invalidateSettingsCache() afterwards.
  Settings? _cachedSettings;
  @override
  void onSettingsMutated() => _cachedSettings = null;

  @override
  Settings getIsarSetting() => _cachedSettings ??= isar.settings.getSync(227)!;

  // ---------------------------------------------------------------------------
  // Reader-specific settings
  // ---------------------------------------------------------------------------

  ReaderMode getReaderMode() {
    final personalReaderModeList =
        getIsarSetting().personalReaderModeList ?? [];
    final personalReaderMode = personalReaderModeList.where(
      (element) => element.mangaId == getManga().id,
    );
    if (personalReaderMode.isNotEmpty) {
      return personalReaderMode.first.readerMode;
    }
    return getIsarSetting().defaultReaderMode;
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
    onSettingsMutated();
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
    onSettingsMutated();
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
      onSettingsMutated();
    }
  }

  bool getShowPageNumber() {
    if (!incognitoMode) return getIsarSetting().showPagesNumber!;
    return true;
  }

  // ---------------------------------------------------------------------------
  // Page tracking
  // ---------------------------------------------------------------------------

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
    final urls = getIsarSetting().chapterPageUrlsList!
        .where((element) => element.chapterId == chapter.id)
        .firstOrNull
        ?.urls;
    if (urls == null || urls.isEmpty) return incognitoPageLength.length;
    return urls.length;
  }

  int? _lastSavedIndex;
  void setPageIndex(int newIndex, bool save) {
    if (chapter.isRead! || incognitoMode) return;
    if (!save && newIndex == _lastSavedIndex) return;
    _lastSavedIndex = newIndex;
    final isContinuousLike =
        getReaderMode() == ReaderMode.verticalContinuous ||
        getReaderMode() == ReaderMode.webtoon;
    final isRead = isContinuousLike
        ? (newIndex + 2) >= getPageLength([]) - 1
        : (newIndex + 2) >= getPageLength([]);
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
      onSettingsMutated();
      if (isRead) {
        chapter.updateTrackChapterRead(ref);
        if (ref.read(deleteDownloadAfterReadingStateProvider)) {
          chapter.deleteDownloadedFiles();
        }
      }
    }
  }
}

extension ChapterExtensions on Chapter {
  void updateTrackChapterRead(dynamic ref) {
    if (!(ref is WidgetRef || ref is Ref)) return;
    final updateProgressAfterReading = ref.read(
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
                widgetRef: ref,
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
    final settings = isar.settings.getSync(227)!;
    final filterUnread =
        (settings.chapterFilterUnreadList!
                    .where((element) => element.mangaId == id)
                    .toList()
                    .firstOrNull ??
                ChapterFilterUnread(mangaId: id, type: 0))
            .type!;

    final filterBookmarked =
        (settings.chapterFilterBookmarkedList!
                    .where((element) => element.mangaId == id)
                    .toList()
                    .firstOrNull ??
                ChapterFilterBookmarked(mangaId: id, type: 0))
            .type!;
    final filterDownloaded =
        (settings.chapterFilterDownloadedList!
                    .where((element) => element.mangaId == id)
                    .toList()
                    .firstOrNull ??
                ChapterFilterDownloaded(mangaId: id, type: 0))
            .type!;

    final sortChapter =
        (settings.sortChapterList!
                    .where((element) => element.mangaId == id)
                    .toList()
                    .firstOrNull ??
                SortChapter(mangaId: id, index: 1, reverse: false))
            .index;
    final filterScanlator = _getFilterScanlator(this) ?? [];
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
          if (filterDownloaded == 0) return true;
          final isDownloaded = downloadedIds.contains(element.id);
          return filterDownloaded == 1 ? isDownloaded : !isDownloaded;
        })
        .where((element) => !filterScanlator.contains(element.scanlator))
        .toList();
    List<Chapter> chapters = sortChapter == 0
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
    return chapters;
  }
}

List<String>? _getFilterScanlator(Manga manga) {
  final scanlators = isar.settings.getSync(227)!.filterScanlatorList ?? [];
  final filter = scanlators
      .where((element) => element.mangaId == manga.id)
      .toList();
  return filter.firstOrNull?.scanlators;
}
