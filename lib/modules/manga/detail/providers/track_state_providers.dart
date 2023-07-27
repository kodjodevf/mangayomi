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
  Track build({Track? track, required bool? isManga}) {
    return track!;
  }

  Future updateManga() async {
    Track? updateTrack;
    if (track!.syncId == 1) {
      updateTrack = isManga!
          ? await ref
              .read(
                  myAnimeListProvider(syncId: track!.syncId!, isManga: isManga)
                      .notifier)
              .updateManga(track!)
          : await ref
              .read(
                  myAnimeListProvider(syncId: track!.syncId!, isManga: isManga)
                      .notifier)
              .updateAnime(track!);
    } else if (track!.syncId == 2) {
      updateTrack = isManga!
          ? await ref
              .read(anilistProvider(syncId: track!.syncId!, isManga: isManga)
                  .notifier)
              .updateLibManga(track!)
          : await ref
              .read(anilistProvider(syncId: track!.syncId!, isManga: isManga)
                  .notifier)
              .updateLibAnime(track!);
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
          .read(anilistProvider(syncId: track!.syncId!, isManga: isManga)
              .notifier)
          .getScoreValue()
          .$1;
    }
    return maxValue!;
  }

  String getTextMapper(String numberText) {
    if (track!.syncId == 1) {
    } else {
      numberText = ref
          .read(anilistProvider(syncId: 2, isManga: isManga).notifier)
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
          .read(anilistProvider(syncId: track!.syncId!, isManga: isManga)
              .notifier)
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
      result = ref
          .read(anilistProvider(syncId: 2, isManga: isManga).notifier)
          .displayScore(score);
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
          .read(myAnimeListProvider(syncId: syncId, isManga: isManga).notifier)
          .findManga(track);
    } else if (syncId == 2) {
      findManga = isManga!
          ? await ref
              .read(anilistProvider(syncId: syncId, isManga: isManga).notifier)
              .findLibManga(track)
          : await ref
              .read(anilistProvider(syncId: syncId, isManga: isManga).notifier)
              .findLibAnime(track);
      if (findManga == null) {
        findManga = isManga!
            ? await ref
                .read(
                    anilistProvider(syncId: syncId, isManga: isManga).notifier)
                .addLibManga(track)
            : await ref
                .read(
                    anilistProvider(syncId: syncId, isManga: isManga).notifier)
                .addLibAnime(track);
        findManga = isManga!
            ? await ref
                .read(
                    anilistProvider(syncId: syncId, isManga: isManga).notifier)
                .findLibManga(track)
            : await ref
                .read(
                    anilistProvider(syncId: syncId, isManga: isManga).notifier)
                .findLibAnime(track);
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
      statusList = isManga!
          ? ref
              .read(
                  myAnimeListProvider(syncId: track!.syncId!, isManga: isManga)
                      .notifier)
              .myAnimeListStatusListManga
          : ref
              .read(
                  myAnimeListProvider(syncId: track!.syncId!, isManga: isManga)
                      .notifier)
              .myAnimeListStatusListAnime;
    } else if (track!.syncId == 2) {
      statusList = isManga!
          ? ref
              .read(anilistProvider(syncId: track!.syncId!, isManga: isManga)
                  .notifier)
              .aniListStatusListManga
          : ref
              .read(anilistProvider(syncId: track!.syncId!, isManga: isManga)
                  .notifier)
              .aniListStatusListAnime;
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
          .read(myAnimeListProvider(syncId: track!.syncId!, isManga: isManga)
              .notifier)
          .findManga(track!);
    } else if (track!.syncId == 2) {
      findManga = isManga!
          ? await ref
              .read(anilistProvider(syncId: track!.syncId!, isManga: isManga)
                  .notifier)
              .findLibManga(track!)
          : await ref
              .read(anilistProvider(syncId: track!.syncId!, isManga: isManga)
                  .notifier)
              .findLibAnime(track!);
    }
    return findManga;
  }

  Future<List<TrackSearch>?> search(String query) async {
    List<TrackSearch>? tracks;
    if (track!.syncId == 1) {
      tracks = await ref
          .read(myAnimeListProvider(syncId: track!.syncId!, isManga: isManga)
              .notifier)
          .search(query);
    } else if (track!.syncId == 2) {
      tracks = isManga!
          ? await ref
              .read(anilistProvider(syncId: track!.syncId!, isManga: isManga)
                  .notifier)
              .search(query)
          : await ref
              .read(anilistProvider(syncId: track!.syncId!, isManga: isManga)
                  .notifier)
              .searchAnime(query);
    }
    return tracks;
  }
}
