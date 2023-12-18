import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';

class AnimeStreamController {
  final Chapter episode;
  AnimeStreamController({required this.episode});

  Manga getAnime() {
    return episode.manga.value!;
  }

  final incognitoMode = isar.settings.getSync(227)!.incognitoMode!;

  Settings getIsarSetting() {
    return isar.settings.getSync(227)!;
  }

  (int, bool) getEpisodeIndex() {
    final episodes = _filterAndSortEpisodes();
    int? index;
    for (var i = 0; i < episodes.length; i++) {
      if (episodes[i].id == episode.id) {
        index = i;
      }
    }
    if (index == null) {
      final chapters = getAnime().chapters.toList().reversed.toList();
      for (var i = 0; i < chapters.length; i++) {
        if (chapters[i].id == episode.id) {
          index = i;
        }
      }
      return (index!, false);
    }
    return (index, true);
  }

  (int, bool) getPrevEpisodeIndex() {
    final episodes = _filterAndSortEpisodes();
    int? index;
    for (var i = 0; i < episodes.length; i++) {
      if (episodes[i].id == episode.id) {
        index = i + 1;
      }
    }
    if (index == null) {
      final chapters = getAnime().chapters.toList().reversed.toList();
      for (var i = 0; i < chapters.length; i++) {
        if (chapters[i].id == episode.id) {
          index = i + 1;
        }
      }
      return (index!, false);
    }
    return (index, true);
  }

  (int, bool) getNextEpisodeIndex() {
    final episodes = _filterAndSortEpisodes();
    int? index;
    for (var i = 0; i < episodes.length; i++) {
      if (episodes[i].id == episode.id) {
        index = i - 1;
      }
    }
    if (index == null) {
      final chapters = getAnime().chapters.toList().reversed.toList();
      for (var i = 0; i < chapters.length; i++) {
        if (chapters[i].id == episode.id) {
          index = i - 1;
        }
      }
      return (index!, false);
    }
    return (index, true);
  }

  Chapter getPrevEpisode() {
    final prevEpIdx = getPrevEpisodeIndex();
    return prevEpIdx.$2
        ? _filterAndSortEpisodes()[prevEpIdx.$1]
        : getAnime().chapters.toList().reversed.toList()[prevEpIdx.$1];
  }

  Chapter getNextEpisode() {
    final nextEpIdx = getNextEpisodeIndex();
    return nextEpIdx.$2
        ? _filterAndSortEpisodes()[nextEpIdx.$1]
        : getAnime().chapters.toList().reversed.toList()[nextEpIdx.$1];
  }

  int getEpisodesLength(bool isInFilterList) {
    return isInFilterList
        ? _filterAndSortEpisodes().length
        : getAnime().chapters.length;
  }

  Duration geTCurrentPosition() {
    if (!incognitoMode) {
      String position = episode.lastPageRead ?? "0";
      return Duration(
          milliseconds: episode.isRead!
              ? 0
              : int.parse(position.isEmpty ? "0" : position));
    }
    return Duration.zero;
  }

  void setAnimeHistoryUpdate() {
    if (!incognitoMode) {
      isar.writeTxnSync(() {
        Manga? anime = episode.manga.value;
        anime!.lastRead = DateTime.now().millisecondsSinceEpoch;
        isar.mangas.putSync(anime);
      });
      History? history;

      final empty =
          isar.historys.filter().mangaIdEqualTo(getAnime().id).isEmptySync();

      if (empty) {
        history = History(
            mangaId: getAnime().id,
            date: DateTime.now().millisecondsSinceEpoch.toString(),
            isManga: getAnime().isManga,
            chapterId: episode.id)
          ..chapter.value = episode;
      } else {
        history = (isar.historys
            .filter()
            .mangaIdEqualTo(getAnime().id)
            .findFirstSync())!
          ..chapter.value = episode
          ..date = DateTime.now().millisecondsSinceEpoch.toString();
      }
      isar.writeTxnSync(() {
        isar.historys.putSync(history!);
        history.chapter.saveSync();
      });
    }
  }

  void setCurrentPosition(int duration) {
    if (!episode.isRead!) {
      if (!incognitoMode) {
        final ep = episode;
        isar.writeTxnSync(() {
          ep.lastPageRead = (duration).toString();
          isar.chapters.putSync(ep);
        });
      }
    }
  }

  List<String>? _getFilterScanlator() {
    final scanlators = isar.settings.getSync(227)!.filterScanlatorList ?? [];
    final filter = scanlators
        .where((element) => element.mangaId == getAnime().id)
        .toList();
    return filter.isEmpty ? null : filter.first.scanlators;
  }

  List<Chapter> _filterAndSortEpisodes() {
    final data = _filterAndSortEpisodes();
    final filterUnread = isar.settings
        .getSync(227)!
        .chapterFilterUnreadList!
        .where((element) => element.mangaId == getAnime().id)
        .toList()
        .first
        .type!;

    final filterBookmarked = isar.settings
        .getSync(227)!
        .chapterFilterBookmarkedList!
        .where((element) => element.mangaId == getAnime().id)
        .toList()
        .first
        .type!;
    final filterDownloaded = isar.settings
        .getSync(227)!
        .chapterFilterDownloadedList!
        .where((element) => element.mangaId == getAnime().id)
        .toList()
        .first
        .type!;

    final sortChapter = isar.settings
        .getSync(227)!
        .sortChapterList!
        .where((element) => element.mangaId == getAnime().id)
        .toList()
        .first
        .index;
    final filterScanlator = _getFilterScanlator() ?? [];
    List<Chapter>? chapterList;
    chapterList = data
        .where((element) => filterUnread == 1
            ? element.isRead == false
            : filterUnread == 2
                ? element.isRead == true
                : true)
        .where((element) => filterBookmarked == 1
            ? element.isBookmarked == true
            : filterBookmarked == 2
                ? element.isBookmarked == false
                : true)
        .where((element) {
          final modelChapDownload = isar.downloads
              .filter()
              .idIsNotNull()
              .chapterIdEqualTo(element.id)
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
    List<Chapter> chapters =
        sortChapter == 1 ? chapterList.reversed.toList() : chapterList;
    if (sortChapter == 0) {
      chapters.sort(
        (a, b) {
          return (a.scanlator == null ||
                  b.scanlator == null ||
                  a.dateUpload == null ||
                  b.dateUpload == null)
              ? 0
              : a.scanlator!.compareTo(b.scanlator!) |
                  a.dateUpload!.compareTo(b.dateUpload!);
        },
      );
    } else if (sortChapter == 2) {
      chapters.sort(
        (a, b) {
          return (a.dateUpload == null || b.dateUpload == null)
              ? 0
              : int.parse(a.dateUpload!).compareTo(int.parse(b.dateUpload!));
        },
      );
    } else if (sortChapter == 3) {
      chapters.sort(
        (a, b) {
          return (a.name == null || b.name == null)
              ? 0
              : a.name!.compareTo(b.name!);
        },
      );
    }
    return chapterList;
  }
}
