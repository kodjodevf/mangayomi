import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/services/trackers/anilist.dart';
import 'package:mangayomi/services/trackers/myanimelist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'track_state_providers.g.dart';

@riverpod
class TrackState extends _$TrackState {
  @override
  Track build({Track? track}) {
    return track!;
  }

  Future updateManga() async {
    Track? updateTrack;
    if (track!.syncId == 1) {
      updateTrack = await ref
          .read(myAnimeListProvider(syncId: track!.syncId!).notifier)
          .updateManga(track!);
    } else if (track!.syncId == 2) {
      updateTrack = await ref
          .read(anilistProvider(syncId: track!.syncId!).notifier)
          .updateLibManga(track!);
    }

    ref
        .read(tracksProvider(syncId: track!.syncId!).notifier)
        .updateTrackManga(updateTrack!);
  }

  int getScoreMaxValue() {
    int? maxValue;
    if (track!.syncId == 1) {
      maxValue = 10;
    } else if (track!.syncId == 2) {
      maxValue = ref
          .read(anilistProvider(syncId: track!.syncId!).notifier)
          .getScoreValue()
          .$1;
    }
    return maxValue!;
  }

  String getTextMapper(String numberText) {
    if (track!.syncId == 1) {
    } else {
      numberText = ref
          .read(anilistProvider(syncId: 2).notifier)
          .displayScore(int.parse(numberText));
    }
    return numberText;
  }

  int getScoreStep() {
    int? step;
    if (track!.syncId == 1) {
      step = 1;
    } else if (track!.syncId == 2) {
      step = ref
          .read(anilistProvider(syncId: track!.syncId!).notifier)
          .getScoreValue()
          .$2;
    }
    return step!;
  }

  String displayScore(int score) {
    String? result;
    if (track!.syncId == 1) {
      result = score.toString();
    } else {
      result =
          ref.read(anilistProvider(syncId: 2).notifier).displayScore(score);
    }
    return result;
  }

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
        totalChapter: 0,
        status: TrackStatus.planToRead,
        startedReadingDate: 0,
        finishedReadingDate: 0);
    if (syncId == 1) {
      findManga = await ref
          .read(myAnimeListProvider(syncId: syncId).notifier)
          .findManga(track);
    } else if (syncId == 2) {
      findManga = findManga = await ref
          .read(anilistProvider(syncId: syncId).notifier)
          .findLibManga(track);
      if (findManga == null) {
        await ref
            .read(anilistProvider(syncId: syncId).notifier)
            .addLibManga(track);
        findManga = await ref
            .read(anilistProvider(syncId: syncId).notifier)
            .findLibManga(track);
      }
    }
    ref
        .read(tracksProvider(syncId: syncId).notifier)
        .updateTrackManga(findManga!);
  }

  List<TrackStatus> getStatusList() {
    List<TrackStatus> statusList = [];
    List<TrackStatus> list = [];
    if (track!.syncId == 1) {
      statusList = ref
          .read(myAnimeListProvider(syncId: track!.syncId!).notifier)
          .myAnimeListStatusList;
    } else if (track!.syncId == 2) {
      statusList = ref
          .read(anilistProvider(syncId: track!.syncId!).notifier)
          .aniListStatusList;
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
          .read(myAnimeListProvider(syncId: track!.syncId!).notifier)
          .findManga(track!);
    } else if (track!.syncId == 2) {
      findManga = findManga = await ref
          .read(anilistProvider(syncId: track!.syncId!).notifier)
          .findLibManga(track!);
    }
    return findManga;
  }

  Future<List<TrackSearch>?> search(String query) async {
    List<TrackSearch>? tracks;
    if (track!.syncId == 1) {
      tracks = await ref
          .read(myAnimeListProvider(syncId: track!.syncId!).notifier)
          .search(query);
    } else if (track!.syncId == 2) {
      tracks = await ref
          .read(anilistProvider(syncId: track!.syncId!).notifier)
          .search(query);
    }
    return tracks;
  }
}
