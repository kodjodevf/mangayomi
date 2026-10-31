import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/providers/track_providers.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'base_tracker.dart';
part 'local_tracker.g.dart';

/// A tracker kept on this device only (#52): status, progress, score and
/// dates for a series, with no account and nothing sent anywhere.
///
/// It is turned on in the tracking settings, where the other trackers are
/// signed into, and then sits beside them in every series' tracking sheet.
/// Its entries point at the series itself rather than at a site's page.
@riverpod
class LocalTracker extends _$LocalTracker implements BaseTracker {
  @override
  void build({
    required int syncId,
    required ItemType? itemType,
    required dynamic widgetRef,
  }) {}

  Tracks get _tracks => widgetRef.read(tracksProvider(syncId: syncId).notifier);

  /// Turns it on: there is nothing to sign into, only the row that says it
  /// is in use.
  void enable() => _tracks.login(TrackPreference(syncId: syncId));

  /// Turns it off. What it holds stays, and is back when it is turned on.
  void disable() => _tracks.logout();

  @override
  Future<bool> checkRefresh() async {
    _tracks.setRefreshing(false);
    return true;
  }

  @override
  Future<Track?> findLibItem(Track track, bool isManga) async =>
      _withSeriesLength(track);

  @override
  Future<Track> update(Track track, bool isManga) async => _withSeriesLength(
    stampLocalTrackDates(track, DateTime.now().millisecondsSinceEpoch),
  );

  Track _withSeriesLength(Track track) {
    final manga = track.mangaId == null
        ? null
        : mangaRepository.findById(track.mangaId!);
    if (manga != null) {
      track.totalChapter = localSeriesLength(
        manga.status,
        manga.chapters.countSync(),
      );
    }
    return track;
  }

  /// Read by kind rather than [isManga], which is false for a novel too.
  @override
  List<TrackStatus> statusList(bool isManga) =>
      localTrackStatuses(itemType != ItemType.anime);

  @override
  Future<List<TrackSearch>> search(String query, bool isManga) async {
    final needle = query.trim().toLowerCase();
    return [
      for (final track in _held())
        if ((track.title ?? '').toLowerCase().contains(needle))
          localTrackSearch(track, _cover(track)),
    ];
  }

  /// Nothing to discover: it only knows what was put in it.
  @override
  Future<List<TrackSearch>> fetchGeneralData({
    bool isManga = true,
    String rankingType = '',
  }) async => const [];

  @override
  Future<List<TrackSearch>> fetchUserData({bool isManga = true}) async => [
    for (final track in _held()) localTrackSearch(track, _cover(track)),
  ];

  /// The entries under one [status], for the tracker library's shelves.
  List<TrackSearch> byStatus(TrackStatus status) => [
    for (final track in _held())
      if (track.status == status) localTrackSearch(track, _cover(track)),
  ];

  List<Track> _held() =>
      trackRepository.getBySyncIdAndItemType(syncId, itemType ?? ItemType.manga)
        ..sort((a, b) => (b.updatedAt ?? 0).compareTo(a.updatedAt ?? 0));

  String? _cover(Track track) {
    final manga = track.mangaId == null
        ? null
        : mangaRepository.findById(track.mangaId!);
    return manga?.customCoverFromTracker ?? manga?.imageUrl;
  }

  @override
  (int, int) getScoreValue() => (10, 1);

  @override
  String displayScore(int score) => '$score';
}

/// The statuses a local entry can take: those of the online trackers, plus
/// reading again.
List<TrackStatus> localTrackStatuses(bool isManga) => [
  isManga ? TrackStatus.reading : TrackStatus.watching,
  TrackStatus.completed,
  TrackStatus.onHold,
  TrackStatus.dropped,
  isManga ? TrackStatus.planToRead : TrackStatus.planToWatch,
  isManga ? TrackStatus.reReading : TrackStatus.reWatching,
];

/// How many chapters or episodes a series has, as far as the device knows:
/// the count once it is finished, and 0 — unknown — while it still runs,
/// so progress is not capped at what has come out so far.
int localSeriesLength(Status status, int chapterCount) =>
    status == Status.completed || status == Status.publishingFinished
    ? chapterCount
    : 0;

/// Fills in the start and finish dates an online tracker would set on its
/// side: started when the first chapter is counted, finished when the entry
/// is marked completed. A date already there is left alone.
Track stampLocalTrackDates(Track track, int now) {
  if ((track.startedReadingDate ?? 0) <= 0 &&
      ((track.lastChapterRead ?? 0) > 0 ||
          track.status == TrackStatus.completed)) {
    track.startedReadingDate = now;
  }
  if ((track.finishedReadingDate ?? 0) <= 0 &&
      track.status == TrackStatus.completed) {
    track.finishedReadingDate = now;
  }
  return track;
}

/// A new local entry for [manga], planned until something is read.
Track newLocalTrack(Manga manga, int chapterCount) {
  final isManga = manga.itemType != ItemType.anime;
  return Track(
    mangaId: manga.id,
    mediaId: manga.id,
    syncId: TrackerProviders.local.syncId,
    title: manga.name,
    score: 0,
    lastChapterRead: 0,
    totalChapter: localSeriesLength(manga.status, chapterCount),
    status: isManga ? TrackStatus.planToRead : TrackStatus.planToWatch,
    startedReadingDate: 0,
    finishedReadingDate: 0,
    itemType: manga.itemType,
  );
}

/// A local entry as the tracker library shows it; [TrackSearch.mediaId] is
/// the series' own id.
TrackSearch localTrackSearch(Track track, String? coverUrl) => TrackSearch(
  mediaId: track.mangaId,
  syncId: track.syncId,
  title: track.title,
  lastChapterRead: track.lastChapterRead,
  totalChapter: track.totalChapter,
  score: (track.score ?? 0) > 0 ? track.score!.toDouble() : null,
  status: track.status.name,
  startedReadingDate: track.startedReadingDate,
  finishedReadingDate: track.finishedReadingDate,
  trackingUrl: '',
  coverUrl: coverUrl ?? '',
);
