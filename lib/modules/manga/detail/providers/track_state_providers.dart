import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/services/myanimelist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'track_state_providers.g.dart';

@riverpod
class TrackState extends _$TrackState {
  @override
  Track build({Track? track}) {
    return track!;
  }

  Future updateItem() async {
    final updateTrack = await ref
        .read(myAnimeListProvider(syncId: 1).notifier)
        .updateItem(track!);

    ref
        .read(tracksProvider(syncId: track!.syncId!).notifier)
        .updateTrackManga(updateTrack);
  }

  Future setTrackSearch(
      TrackSearch trackSearch, int mangaId, int syncId) async {
        
    final track = Track(
        mangaId: mangaId,
        score: 0,
        mediaId: trackSearch.mediaId,
        trackingUrl: trackSearch.trackingUrl,
        title: trackSearch.title,
        lastChapterRead: 0,
        totalChapter: 0,
        status: TrackStatus.planToRead,
        startedReadingDate: 0,
        finishedReadingDate: 0);
    final findTrack = await ref
        .read(myAnimeListProvider(syncId: 1).notifier)
        .findListItem(track);

    ref
        .read(tracksProvider(syncId: syncId).notifier)
        .updateTrackManga(findTrack);
  }

  List<TrackStatus> getStatusList() {
    List<TrackStatus> statusList = [];
    List<TrackStatus> list = [];
    if (track!.syncId == 1) {
      statusList = ref
          .read(myAnimeListProvider(syncId: 1).notifier)
          .myAnimeListStatusList;
    }
    for (var element in TrackStatus.values) {
      if (statusList.contains(element)) {
        list.add(element);
      }
    }
    return list;
  }
}
