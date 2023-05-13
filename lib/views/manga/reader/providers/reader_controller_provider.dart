import 'dart:developer';

import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
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
  int build(Chapter chapter) {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      return ref
          .read(readerControllerProvider(chapter: chapter).notifier)
          .getPageIndex();
    }
    return 0;
  }

  setCurrentIndex(
    int currentIndex,
  ) {
    state = currentIndex;
  }
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

  ReaderMode getReaderMode() {
    return ref.watch(hiveBoxReaderModeProvider).get(
                "${getSourceName()}/${getMangaName()}-singleMangaReaderModeValue",
                defaultValue: null) !=
            null
        ? ref.watch(hiveBoxReaderModeProvider).get(
              "${getSourceName()}/${getMangaName()}-singleMangaReaderModeValue",
            )!
        : ref.watch(hiveBoxReaderModeProvider).get("globalMangaReaderModeValue",
            defaultValue: ReaderMode.vertical)!;
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
    ref.watch(hiveBoxReaderModeProvider).put(
        "${getSourceName()}/${getMangaName()}-singleMangaReaderModeValue",
        newReaderMode);
  }

  void setShowPageNumber(bool value) {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      ref
          .watch(hiveBoxMangaProvider)
          .put("${getSourceName()}/${getMangaName()}-showPagesNumber", value);
    }
  }

  bool getShowPageNumber() {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      return ref.watch(hiveBoxMangaProvider).get(
          "${getSourceName()}/${getMangaName()}-showPagesNumber",
          defaultValue: true);
    }
    return true;
  }

  void setMangaHistoryUpdate() {
    // log("message");
    final incognitoMode = ref.watch(incognitoModeStateProvider);
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
            date: DateTime.now().millisecondsSinceEpoch.toString())
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

  void setChapterPageLastRead(int pageIndex) {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      final chap = chapter;
      isar.writeTxnSync(() {
        chap.lastPageRead = (pageIndex + 1).toString();
        isar.chapters.putSync(chap);
      });
    }
  }

  void setChapterBookmarked() {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
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

  int getNextChapterIndex() {
    final chapters = getManga().chapters.toList();
    int? index;
    for (var i = 0; i < chapters.length; i++) {
      if (chapters[i].id == chapter.id) {
        index = i + 1;
      }
    }
    return index!;
  }

  int getPrevChapterIndex() {
    final chapters = getManga().chapters.toList();
    int? index;
    for (var i = 0; i < chapters.length; i++) {
      if (chapters[i].id == chapter.id) {
        index = i - 1;
      }
    }
    return index!;
  }

  int getChapterIndex() {
    final chapters = getManga().chapters.toList();
    int? index;
    for (var i = 0; i < chapters.length; i++) {
      if (chapters[i].id == chapter.id) {
        index = i;
      }
    }
    return index!;
  }

  Chapter getNextChapter() {
    return getManga().chapters.toList()[getNextChapterIndex()];
  }

  Chapter getPrevChapter() {
    return getManga().chapters.toList()[getPrevChapterIndex()];
  }

  int getChaptersLength() {
    return getManga().chapters.length;
  }

  int getPageIndex() {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      return chapter.isRead!
          ? 0
          : ref.watch(hiveBoxMangaProvider).get(
              "${getSourceName()}/${getMangaName()}/${getChapterTitle()}-page_index",
              defaultValue: 0);
    }
    return 0;
  }

  int getPageLength(List incognitoPageLength) {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      List<dynamic> page = ref.watch(hiveBoxMangaProvider).get(
            "${getSourceName()}/${getMangaName()}/${getChapterTitle()}-pageurl",
          );
      return page.length;
    }
    return incognitoPageLength.length;
  }

  void setPageIndex(int newIndex) {
    // log(newIndex.toString());
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      ref.watch(hiveBoxMangaProvider).put(
          "${getSourceName()}/${getMangaName()}/${getChapterTitle()}-page_index",
          newIndex);
    }
  }

  String getMangaName() {
    return getManga().name!;
  }

  String getSourceName() {
    return '${getManga().lang}-${getManga().source!}';
  }

  String getChapterTitle() {
    return chapter.name!;
  }
}
