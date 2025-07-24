import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/modules/tracker_library/tracker_library_screen.dart';
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

  dynamic getNotifier(int syncId) {
    return switch (syncId) {
      1 => ref.read(
        myAnimeListProvider(syncId: syncId, itemType: itemType).notifier,
      ),
      2 => ref.read(
        anilistProvider(syncId: syncId, itemType: itemType).notifier,
      ),
      3 => ref.read(kitsuProvider(syncId: syncId, itemType: itemType).notifier),
      _ => throw Exception('Unsupported syncId: $syncId'),
    };
  }

  void writeBack(Track t) {
    ref
        .read(tracksProvider(syncId: t.syncId!).notifier)
        .updateTrackManga(t, itemType!);
  }

  Future updateManga() async {
    final syncId = track!.syncId!;
    Track updateTrack = await getNotifier(syncId).update(track!, _isManga);
    writeBack(updateTrack);
  }

  int getScoreMaxValue() {
    final syncId = track!.syncId!;
    if (syncId == 2) {
      final tracker = getNotifier(syncId);
      return tracker.getScoreValue().$1;
    } else {
      return 10;
    }
  }

  String getTextMapper(String numberText) {
    final syncId = track!.syncId!;
    if (syncId == 2) {
      final tracker = getNotifier(syncId);
      return tracker.displayScore(int.parse(numberText));
    } else {
      return numberText;
    }
  }

  int getScoreStep() {
    final syncId = track!.syncId!;
    if (syncId == 2) {
      final tracker = getNotifier(syncId);
      return tracker.getScoreValue().$2;
    } else {
      return 1;
    }
  }

  String displayScore(int score) {
    final syncId = track!.syncId!;
    if (syncId == 2) {
      final tracker = getNotifier(syncId);
      return tracker.displayScore(score);
    } else {
      return score.toString();
    }
  }

  bool get _isManga => itemType == ItemType.manga;

  Future setTrackSearch(
    TrackSearch trackSearch,
    int mangaId,
    int syncId,
  ) async {
    Track? findManga;
    final newTrack = Track(
      mangaId: mangaId,
      score: 0,
      syncId: syncId,
      mediaId: trackSearch.mediaId,
      trackingUrl: trackSearch.trackingUrl,
      title: trackSearch.title,
      lastChapterRead: 0,
      totalChapter: trackSearch.totalChapter,
      status: _isManga ? TrackStatus.planToRead : TrackStatus.planToWatch,
      startedReadingDate: 0,
      finishedReadingDate: 0,
    );
    final tracker = getNotifier(syncId);

    if (syncId == 1) {
      findManga = await tracker.findLibItem(newTrack, _isManga);
    } else if (syncId == 2) {
      findManga = await tracker.findLibItem(newTrack, _isManga);
      findManga ??= await tracker.update(newTrack, _isManga);
    } else if (syncId == 3) {
      findManga = await tracker.update(newTrack, _isManga);
    }
    writeBack(findManga!);
  }

  List<TrackStatus> getStatusList() {
    List<TrackStatus> list = [];
    final syncId = track!.syncId!;
    final tracker = getNotifier(syncId);
    List<TrackStatus> statusList = tracker.statusList(_isManga);
    for (var element in TrackStatus.values) {
      if (statusList.contains(element)) {
        list.add(element);
      }
    }
    return list;
  }

  Future<Track?> findManga() async {
    final syncId = track!.syncId!;
    final tracker = getNotifier(syncId);
    return await tracker.findLibItem(track!, _isManga);
  }

  Future<List<TrackSearch>?> search(String query) async {
    final syncId = track!.syncId!;
    final tracker = getNotifier(syncId);
    return await tracker.search(query, _isManga);
  }

  Future<List<TrackSearch>?> fetchGeneralData({String? rankingType}) async {
    final syncId = track!.syncId!;
    final tracker = getNotifier(syncId);
    return rankingType != null
        ? await tracker.fetchGeneralData(
            isManga: _isManga,
            rankingType: rankingType,
          )
        : await tracker.fetchGeneralData(isManga: _isManga);
  }

  Future<List<TrackSearch>?> fetchUserData() async {
    final syncId = track!.syncId!;
    final tracker = getNotifier(syncId);
    return await tracker.fetchUserData(isManga: _isManga);
  }
}

@riverpod
class LastTrackerLibraryLocationState
    extends _$LastTrackerLibraryLocationState {
  @override
  (int, bool) build() {
    final value = isar.settings.getSync(227)!.lastTrackerLibraryLocation;
    if (value != null) {
      final data = value.split(",");
      return (int.parse(data[0]), bool.parse(data[1]));
    }
    return (TrackerProviders.myAnimeList.syncId, false);
  }

  void set((int, bool) value) {
    final settings = isar.settings.getSync(227);
    final val = "${value.$1},${value.$2}";
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..lastTrackerLibraryLocation = val
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
