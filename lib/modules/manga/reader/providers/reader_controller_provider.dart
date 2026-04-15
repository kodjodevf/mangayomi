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

    final filterScanlator = _getFilterScanlator(this) ?? [];

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

List<String>? _getFilterScanlator(Manga manga) {
  final scanlators = isar.settings.getSync(227)!.filterScanlatorList ?? [];
  final filter = scanlators
      .where((element) => element.mangaId == manga.id)
      .toList();
  return filter.firstOrNull?.scanlators;
}
