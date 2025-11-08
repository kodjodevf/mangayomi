import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
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

  void setChapterOffset(double newOffset, double maxOffset, bool save) {
    if (incognitoMode) return;
    final isRead = (newOffset / (maxOffset != 0 ? maxOffset : 1)) >= 0.9;
    if (isRead || save) {
      final ch = chapter;
      isar.writeTxnSync(() {
        ch.isRead = isRead;
        ch.lastPageRead = (maxOffset != 0 ? newOffset / maxOffset : 0)
            .toString();
        ch.updatedAt = DateTime.now().millisecondsSinceEpoch;
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
