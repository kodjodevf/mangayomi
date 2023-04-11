import 'dart:developer';

import 'package:mangayomi/models/manga_history.dart';
import 'package:mangayomi/models/manga_reader.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/views/more/settings/providers/incognito_mode_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive/hive.dart';
part 'reader_controller_provider.g.dart';

@HiveType(typeId: 5)
enum ReaderMode {
  @HiveField(1)
  vertical,
  @HiveField(2)
  ltr,
  @HiveField(3)
  rtl,
  @HiveField(4)
  verticalContinuous,
  @HiveField(5)
  webtoon
}

@riverpod
class CurrentIndex extends _$CurrentIndex {
  @override
  int build(MangaReaderModel mangaReaderModel) {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      return ref.watch(hiveBoxMangaInfo).get(
          "${mangaReaderModel.modelManga.source}/${mangaReaderModel.modelManga.name}/${mangaReaderModel.modelManga.chapterTitle![mangaReaderModel.index]}-page_index",
          defaultValue: 0);
    }
    return 0;
  }

  setCurrentIndex(int currentIndex) {
    state = currentIndex;
  }
}

@riverpod
class ReaderController extends _$ReaderController {
  @override
  void build({required MangaReaderModel mangaReaderModel}) {}

  ModelManga getModelManga() {
    return mangaReaderModel.modelManga;
  }

  ReaderMode getReaderMode() {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      return ref.watch(hiveBoxReaderMode).get(
                  "${getSourceName()}/${getMangaName()}-singleMangaReaderModeValue",
                  defaultValue: null) !=
              null
          ? ref.watch(hiveBoxReaderMode).get(
                "${getSourceName()}/${getMangaName()}-singleMangaReaderModeValue",
              )!
          : ref
              .watch(hiveBoxReaderMode)
              .get("globalMangaReaderModeValue", defaultValue: ReaderMode.ltr)!;
    }
    return ReaderMode.vertical;
  }

  String getReaderModeValue(ReaderMode readerMode) {
    return readerMode == ReaderMode.vertical
        ? 'Vertical'
        : readerMode == ReaderMode.verticalContinuous
            ? 'Verical continuous'
            : readerMode == ReaderMode.ltr
                ? 'Left to Right'
                : readerMode == ReaderMode.rtl
                    ? 'Right to Left'
                    : 'Webtoon';
  }

  void setReaderMode(ReaderMode newReaderMode) {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      ref.watch(hiveBoxReaderMode).put(
          "${getSourceName()}/${getMangaName()}-singleMangaReaderModeValue",
          newReaderMode);
    }
  }

  void setShowPageNumber(bool value) {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      ref
          .watch(hiveBoxMangaInfo)
          .put("${getSourceName()}/${getMangaName()}-showPagesNumber", value);
    }
  }

  bool getShowPageNumber() {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      return ref.watch(hiveBoxMangaInfo).get(
          "${getSourceName()}/${getMangaName()}-showPagesNumber",
          defaultValue: true);
    }
    return true;
  }

  void setMangaHistoryUpdate() {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      ref.watch(hiveBoxMangaHistory).put(
          mangaReaderModel.modelManga.link,
          MangaHistoryModel(
              date: DateTime.now().toString(),
              modelManga: mangaReaderModel.modelManga));
    }
  }

  int getChapterIndex() {
    return mangaReaderModel.index;
  }

  void setChapterIndex() {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      ref.watch(hiveBoxMangaInfo).put(
          "${getSourceName()}/${getMangaName()}-chapter_index",
          mangaReaderModel.index.toString());
    }
  }

  int getPageIndex() {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      return ref.watch(hiveBoxMangaInfo).get(
          "${getSourceName()}/${getMangaName()}/${getChapterTitle()}-page_index",
          defaultValue: 0);
    }
    return 0;
  }

  int getPageLength(List incognitoPageLength) {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      List<dynamic> page = ref.watch(hiveBoxMangaInfo).get(
            "${getSourceName()}/${getMangaName()}/${getChapterTitle()}-pageurl",
          );
      return page.length;
    }
    return incognitoPageLength.length;
  }

  void setPageIndex(int newIndex) {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      ref.watch(hiveBoxMangaInfo).put(
          "${getSourceName()}/${getMangaName()}/${getChapterTitle()}-page_index",
          newIndex);
    }
  }

  String getMangaName() {
    return mangaReaderModel.modelManga.name!;
  }

  String getSourceName() {
    return mangaReaderModel.modelManga.source!;
  }

  String getChapterTitle() {
    return mangaReaderModel.modelManga.chapterTitle![mangaReaderModel.index];
  }
}
