import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';

/// Shared navigation and history logic used by [ReaderController],
/// [NovelReaderController], and [AnimeStreamController].
///
/// Concrete classes must satisfy the single abstract member [chapter].
/// The Riverpod-generated base class already exposes the build parameter as a
/// getter, so no extra boilerplate is needed in normal cases.
///
/// [incognitoMode] and [getIsarSetting] are concrete in the mixin but can be
/// overridden — [ReaderController] overrides [getIsarSetting] to add caching.
mixin ChapterControllerMixin {
  // ---------------------------------------------------------------------------
  // Contract – provided by the Riverpod-generated superclass
  // ---------------------------------------------------------------------------

  /// The current chapter or episode.
  Chapter get chapter;

  // ---------------------------------------------------------------------------
  // Basic helpers
  // ---------------------------------------------------------------------------

  Manga getManga() => chapter.manga.value!;

  // Declared as a getter so concrete classes can override with a `final` field
  // (which is more efficient since incognito status never changes mid-session).
  bool get incognitoMode => isar.settings.getSync(227)!.incognitoMode!;

  Settings getIsarSetting() => isar.settings.getSync(227)!;

  String getMangaName() => getManga().name!;
  String getSourceName() => getManga().source!;
  String getChapterTitle() => chapter.name!;

  // ---------------------------------------------------------------------------
  // Chapter / episode navigation
  // ---------------------------------------------------------------------------

  (int, bool) getChapterIndex() => _chapterIndexWithOffset(0);
  (int, bool) getPrevChapterIndex() => _chapterIndexWithOffset(1);
  (int, bool) getNextChapterIndex() => _chapterIndexWithOffset(-1);

  /// Finds this [chapter] in either the filtered list or the raw list and
  /// returns [index + offset]. The boolean indicates whether the filtered list
  /// was used (true) or the full reversed list (false).
  (int, bool) _chapterIndexWithOffset(int offset) {
    final manga = getManga();

    int? findIn(List<Chapter> list) {
      for (var i = 0; i < list.length; i++) {
        if (list[i].id == chapter.id) return i + offset;
      }
      return null;
    }

    final index = findIn(manga.getFilteredChapterList());
    if (index != null) return (index, true);

    final all = manga.chapters.toList().reversed.toList();
    return (findIn(all)!, false);
  }

  Chapter _chapterWithOffset(int offset) {
    final idx = _chapterIndexWithOffset(offset);
    return idx.$2
        ? getManga().getFilteredChapterList()[idx.$1]
        : getManga().chapters.toList().reversed.toList()[idx.$1];
  }

  Chapter getPrevChapter() => _chapterWithOffset(1);
  Chapter getNextChapter() => _chapterWithOffset(-1);

  int getChaptersLength(bool isInFilterList) => isInFilterList
      ? getManga().getFilteredChapterList().length
      : getManga().chapters.length;

  // ---------------------------------------------------------------------------
  // History
  // ---------------------------------------------------------------------------

  /// Writes a history entry for the current chapter/episode and bumps the
  /// parent manga/anime's [lastRead] timestamp.
  ///
  /// [elapsedSeconds] accumulates watch/reading time; pass 0 to skip that
  /// field (the caller is responsible for tracking wall-clock deltas).
  void setHistoryUpdate({int elapsedSeconds = 0}) {
    if (incognitoMode) return;
    final manga = getManga();

    isar.writeTxnSync(() {
      final m = chapter.manga.value!;
      m.lastRead = DateTime.now().millisecondsSinceEpoch;
      m.updatedAt = DateTime.now().millisecondsSinceEpoch;
      isar.mangas.putSync(m);
    });

    final isEmpty = isar.historys
        .filter()
        .mangaIdEqualTo(manga.id)
        .isEmptySync();

    final History history;
    if (isEmpty) {
      history = History(
        mangaId: manga.id,
        date: DateTime.now().millisecondsSinceEpoch.toString(),
        itemType: manga.itemType,
        chapterId: chapter.id,
      )..chapter.value = chapter;
    } else {
      history = isar.historys.filter().mangaIdEqualTo(manga.id).findFirstSync()!
        ..chapterId = chapter.id
        ..chapter.value = chapter
        ..date = DateTime.now().millisecondsSinceEpoch.toString();
    }

    isar.writeTxnSync(() {
      history.updatedAt = DateTime.now().millisecondsSinceEpoch;
      if (elapsedSeconds > 0) {
        history.readingTimeSeconds =
            (history.readingTimeSeconds ?? 0) + elapsedSeconds;
      }
      isar.historys.putSync(history);
      history.chapter.saveSync();
    });
  }
}
