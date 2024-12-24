import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/services/trackers/anilist.dart';
import 'package:mangayomi/services/trackers/kitsu.dart';
import 'package:mangayomi/services/trackers/myanimelist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'track_state_providers.g.dart';

@riverpod
class TrackState extends _$TrackState {
  @override
  Track build({Track? track, required ItemType? itemType}) {
    return track!;
  }

  Future updateManga() async {
    Track? updateTrack;
    updateTrack = await switch (track!.syncId) {
      1 => switch (itemType) {
          ItemType.manga => ref
              .read(myAnimeListProvider(
                      syncId: track!.syncId!, itemType: itemType)
                  .notifier)
              .updateManga(track!),
          _ => ref
              .read(myAnimeListProvider(
                      syncId: track!.syncId!, itemType: itemType)
                  .notifier)
              .updateAnime(track!),
        },
      2 => switch (itemType) {
          ItemType.manga => ref
              .read(anilistProvider(syncId: track!.syncId!, itemType: itemType)
                  .notifier)
              .updateLibManga(track!),
          _ => ref
              .read(anilistProvider(syncId: track!.syncId!, itemType: itemType)
                  .notifier)
              .updateLibAnime(track!),
        },
      _ => switch (itemType) {
          ItemType.manga => ref
              .read(kitsuProvider(syncId: track!.syncId!, itemType: itemType)
                  .notifier)
              .updateLibManga(track!),
          _ => ref
              .read(kitsuProvider(syncId: track!.syncId!, itemType: itemType)
                  .notifier)
              .updateLibAnime(track!),
        },
    };

    ref
        .read(tracksProvider(syncId: track!.syncId!).notifier)
        .updateTrackManga(updateTrack, itemType!);
  }

  int getScoreMaxValue() {
    int? maxValue;
    if (track!.syncId == 1 || track!.syncId == 3) {
      maxValue = 10;
    } else if (track!.syncId == 2) {
      maxValue = ref
          .read(anilistProvider(syncId: track!.syncId!, itemType: itemType)
              .notifier)
          .getScoreValue()
          .$1;
    }
    return maxValue!;
  }

  String getTextMapper(String numberText) {
    if (track!.syncId == 1 || track!.syncId == 3) {
    } else if (track!.syncId == 2) {
      numberText = ref
          .read(anilistProvider(syncId: 2, itemType: itemType).notifier)
          .displayScore(int.parse(numberText));
    }
    return numberText;
  }

  int getScoreStep() {
    int? step;
    if (track!.syncId == 1 || track!.syncId == 3) {
      step = 1;
    } else if (track!.syncId == 2) {
      step = ref
          .read(anilistProvider(syncId: track!.syncId!, itemType: itemType)
              .notifier)
          .getScoreValue()
          .$2;
    }
    return step!;
  }

  String displayScore(int score) {
    String? result;
    if (track!.syncId == 1 || track!.syncId == 3) {
      result = score.toString();
    } else if (track!.syncId == 2) {
      result = ref
          .read(anilistProvider(syncId: 2, itemType: itemType).notifier)
          .displayScore(score);
    }
    return result!;
  }

  bool get _isManga => itemType == ItemType.manga;

  Future setTrackSearch(
      TrackSearch trackSearch, int mangaId, int syncId) async {
    Track? findManga;
    final track = Track(
        mangaId: mangaId,
        score: 0,
        syncId: syncId,
        mediaId: trackSearch.mediaId,
        trackingUrl: trackSearch.trackingUrl,
        title: trackSearch.title,
        lastChapterRead: 0,
        totalChapter: trackSearch.totalChapter,
        status: TrackStatus.planToRead,
        startedReadingDate: 0,
        finishedReadingDate: 0);

    if (syncId == 1) {
      findManga = await ref
          .read(
              myAnimeListProvider(syncId: syncId, itemType: itemType).notifier)
          .findManga(track);
    } else if (syncId == 2) {
      findManga = _isManga
          ? await ref
              .read(
                  anilistProvider(syncId: syncId, itemType: itemType).notifier)
              .findLibManga(track)
          : await ref
              .read(
                  anilistProvider(syncId: syncId, itemType: itemType).notifier)
              .findLibAnime(track);
      findManga ??= _isManga
          ? await ref
              .read(
                  anilistProvider(syncId: syncId, itemType: itemType).notifier)
              .addLibManga(track)
          : await ref
              .read(
                  anilistProvider(syncId: syncId, itemType: itemType).notifier)
              .addLibAnime(track);
    } else if (syncId == 3) {
      findManga = _isManga
          ? await ref
              .read(kitsuProvider(syncId: syncId, itemType: itemType).notifier)
              .addLibManga(track)
          : await ref
              .read(kitsuProvider(syncId: syncId, itemType: itemType).notifier)
              .addLibAnime(track);
    }

    ref
        .read(tracksProvider(syncId: syncId).notifier)
        .updateTrackManga(findManga!, itemType!);
  }

  List<TrackStatus> getStatusList() {
    List<TrackStatus> statusList = [];
    List<TrackStatus> list = [];
    if (track!.syncId == 1) {
      statusList = _isManga
          ? ref
              .read(myAnimeListProvider(
                      syncId: track!.syncId!, itemType: itemType)
                  .notifier)
              .myAnimeListStatusListManga
          : ref
              .read(myAnimeListProvider(
                      syncId: track!.syncId!, itemType: itemType)
                  .notifier)
              .myAnimeListStatusListAnime;
    } else if (track!.syncId == 2) {
      statusList = _isManga
          ? ref
              .read(anilistProvider(syncId: track!.syncId!, itemType: itemType)
                  .notifier)
              .aniListStatusListManga
          : ref
              .read(anilistProvider(syncId: track!.syncId!, itemType: itemType)
                  .notifier)
              .aniListStatusListAnime;
    } else if (track!.syncId == 3) {
      statusList = _isManga
          ? ref
              .read(kitsuProvider(syncId: track!.syncId!, itemType: itemType)
                  .notifier)
              .kitsuStatusListManga
          : ref
              .read(kitsuProvider(syncId: track!.syncId!, itemType: itemType)
                  .notifier)
              .kitsuStatusListAnime;
    }
    for (var element in TrackStatus.values) {
      if (statusList.contains(element)) {
        list.add(element);
      }
    }
    return list;
  }

  Future<Track?> findManga() async {
    Track? findManga;
    if (track!.syncId == 1) {
      findManga = await ref
          .read(myAnimeListProvider(syncId: track!.syncId!, itemType: itemType)
              .notifier)
          .findManga(track!);
    } else if (track!.syncId == 2) {
      findManga = _isManga
          ? await ref
              .read(anilistProvider(syncId: track!.syncId!, itemType: itemType)
                  .notifier)
              .findLibManga(track!)
          : await ref
              .read(anilistProvider(syncId: track!.syncId!, itemType: itemType)
                  .notifier)
              .findLibAnime(track!);
    } else if (track!.syncId == 3) {
      findManga = _isManga
          ? await ref
              .read(kitsuProvider(syncId: track!.syncId!, itemType: itemType)
                  .notifier)
              .findLibManga(track!)
          : await ref
              .read(kitsuProvider(syncId: track!.syncId!, itemType: itemType)
                  .notifier)
              .findLibAnime(track!);
    }
    return findManga;
  }

  Future<List<TrackSearch>?> search(String query) async {
    List<TrackSearch>? tracks;
    if (track!.syncId == 1) {
      tracks = await ref
          .read(myAnimeListProvider(syncId: track!.syncId!, itemType: itemType)
              .notifier)
          .search(query);
    } else if (track!.syncId == 2) {
      tracks = _isManga
          ? await ref
              .read(anilistProvider(syncId: track!.syncId!, itemType: itemType)
                  .notifier)
              .search(query)
          : await ref
              .read(anilistProvider(syncId: track!.syncId!, itemType: itemType)
                  .notifier)
              .searchAnime(query);
    } else if (track!.syncId == 3) {
      tracks = _isManga
          ? await ref
              .read(kitsuProvider(syncId: track!.syncId!, itemType: itemType)
                  .notifier)
              .search(query)
          : await ref
              .read(kitsuProvider(syncId: track!.syncId!, itemType: itemType)
                  .notifier)
              .searchAnime(query);
    }
    return tracks;
  }
}
