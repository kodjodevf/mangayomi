import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
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

  int getEpisodeIndex() {
    final chapters = getAnime().chapters.toList();
    int? index;
    for (var i = 0; i < chapters.length; i++) {
      if (chapters[i].id == episode.id) {
        index = i;
      }
    }
    return index!;
  }

  int getPrevEpisodeIndex() {
    final episodes = getAnime().chapters.toList();
    int? index;
    for (var i = 0; i < episodes.length; i++) {
      if (episodes[i].id == episode.id) {
        index = i + 1;
      }
    }
    return index!;
  }

  int getNextEpisodeIndex() {
    final episodes = getAnime().chapters.toList();
    int? index;
    for (var i = 0; i < episodes.length; i++) {
      if (episodes[i].id == episode.id) {
        index = i - 1;
      }
    }
    return index!;
  }

  Chapter getPrevEpisode() {
    return getAnime().chapters.toList()[getPrevEpisodeIndex()];
  }

  Chapter getNextEpisode() {
    return getAnime().chapters.toList()[getNextEpisodeIndex()];
  }

  int getEpisodesLength() {
    return getAnime().chapters.length;
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
            date: DateTime.now().millisecondsSinceEpoch.toString())
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
}
