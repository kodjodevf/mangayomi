import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
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
    final personalReaderMode = getIsarSetting()
        .personalReaderModeList!
        .where((element) => element.mangaId == getManga().id);
    if (personalReaderMode.isNotEmpty) {
      return personalReaderMode.first.readerMode;
    }
    return isar.settings.getSync(227)!.defaultReaderMode;
  }

  void setReaderMode(ReaderMode newReaderMode) {
    List<PersonalReaderMode>? personalReaderModeLists = [];
    for (var personalReaderMode in getIsarSetting().personalReaderModeList!) {
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

  void setShowPageNumber(bool value) {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      isar.writeTxnSync(() =>
          isar.settings.putSync(getIsarSetting()..showPagesNumber = value));
    }
  }

  Settings getIsarSetting() {
    return isar.settings.getSync(227)!;
  }

  bool getShowPageNumber() {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      return getIsarSetting().showPagesNumber!;
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
        chap.isRead = (pageIndex + 1) == getPageLength([]);
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
    final index = getIsarSetting()
        .chapterPageIndexList!
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
    final incognitoMode = ref.watch(incognitoModeStateProvider);
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
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      List<ChapterPageIndex>? chapterPageIndexs = [];
      for (var chapterPageIndex in getIsarSetting().chapterPageIndexList!) {
        if (chapterPageIndex.chapterId != chapter.id) {
          chapterPageIndexs.add(chapterPageIndex);
        }
      }
      chapterPageIndexs.add(ChapterPageIndex()
        ..chapterId = chapter.id
        ..index = newIndex);
      isar.writeTxnSync(() => isar.settings
          .putSync(getIsarSetting()..chapterPageIndexList = chapterPageIndexs));
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
