import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/utils/chapter_recognition.dart';
import 'package:mangayomi/modules/manga/reader/mixins/chapter_reader_settings_mixin.dart';
import 'package:mangayomi/modules/manga/reader/mixins/chapter_controller_mixin.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/downloads/providers/downloads_state_provider.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
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
    final isContinuousLike = getReaderMode().isVerticalContinuous;
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
      final autoReadDuplChap = ref.read(autoReadDuplicateChaptersStateProvider);
      final now = DateTime.now().millisecondsSinceEpoch;
      // When the chapter is finished, mark every other scanlation of the same
      // chapter number as read too, in the same transaction.
      final List<Chapter> siblings = [];
      if (isRead && autoReadDuplChap) {
        final manga = chapter.manga.value;
        if (manga != null) {
          final chapterNumber = ChapterRecognition().parseChapterNumber(
            manga.name!,
            chapter.name!,
          );
          for (final c in manga.chapters) {
            if (c.id == chapter.id || (c.isRead ?? false)) continue;
            final n = ChapterRecognition().parseChapterNumber(
              manga.name!,
              c.name!,
            );
            if (n == chapterNumber) {
              c.isRead = true;
              c.lastPageRead = '1';
              c.updatedAt = now;
              siblings.add(c);
            }
          }
        }
      }
      final chap = chapter;
      isar.writeTxnSync(() {
        isar.settings.putSync(
          getIsarSetting()
            ..chapterPageIndexList = chapterPageIndexs
            ..updatedAt = now,
        );
        chap.isRead = isRead;
        chap.lastPageRead = isRead ? '1' : (newIndex + 1).toString();
        chap.updatedAt = now;
        isar.chapters.putSync(chap);
        if (siblings.isNotEmpty) isar.chapters.putAllSync(siblings);
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
