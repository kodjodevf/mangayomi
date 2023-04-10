import 'package:mangayomi/models/manga_history.dart';
import 'package:mangayomi/models/manga_reader.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
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
    return ref.watch(hiveBoxMangaInfo).get(
        "${mangaReaderModel.modelManga.source}/${mangaReaderModel.modelManga.name}/${mangaReaderModel.modelManga.chapterTitle![mangaReaderModel.index]}-page_index",
        defaultValue: 0);
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
    ref.watch(hiveBoxReaderMode).put(
        "${getSourceName()}/${getMangaName()}-singleMangaReaderModeValue",
        newReaderMode);
  }

  void setShowPageNumber(bool value) {
    ref
        .watch(hiveBoxMangaInfo)
        .put("${getSourceName()}/${getMangaName()}-showPagesNumber", value);
  }

  bool getShowPageNumber() {
    return ref.watch(hiveBoxMangaInfo).get(
        "${getSourceName()}/${getMangaName()}-showPagesNumber",
        defaultValue: true);
  }

  void setMangaHistoryUpdate() {
    ref.watch(hiveBoxMangaHistory).put(
        mangaReaderModel.modelManga.link,
        MangaHistoryModel(
            date: DateTime.now().toString(),
            modelManga: mangaReaderModel.modelManga));
  }

  int getChapterIndex() {
    return mangaReaderModel.index;
  }

  void setChapterIndex() {
    ref.watch(hiveBoxMangaInfo).put(
        "${getSourceName()}/${getMangaName()}-chapter_index",
        mangaReaderModel.index.toString());
  }

  int getPageIndex() {
    return ref.watch(hiveBoxMangaInfo).get(
        "${getSourceName()}/${getMangaName()}/${getChapterTitle()}-page_index",
        defaultValue: 0);
  }

  int getPageLength() {
    final page = ref.watch(hiveBoxMangaInfo).get(
          "${getSourceName()}/${getMangaName()}/${getChapterTitle()}-pageurl",
        ) as List;
    return page.length;
  }

  void setPageIndex(int newIndex) {
    ref.watch(hiveBoxMangaInfo).put(
        "${getSourceName()}/${getMangaName()}/${getChapterTitle()}-page_index",
        newIndex);
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
