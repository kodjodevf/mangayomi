import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';

/// [track] one chapter or episode further, as reading one would move it: a
/// planned entry becomes in progress, the last one completes it, and the
/// first one or the last one dates it.
///
/// Nothing moves past a known total, nor once the entry is completed.
Track advanceTrack(Track track, ItemType itemType, int now) {
  final read = track.lastChapterRead ?? 0;
  final total = track.totalChapter ?? 0;
  if (track.status == TrackStatus.completed || (total > 0 && read >= total)) {
    return track;
  }
  final isManga = itemType != ItemType.anime;
  track.lastChapterRead = read + 1;
  if (read == 0 && (track.startedReadingDate ?? 0) <= 0) {
    track.startedReadingDate = now;
  }
  if (total > 0 && read + 1 == total) {
    track.status = TrackStatus.completed;
    if ((track.finishedReadingDate ?? 0) <= 0) track.finishedReadingDate = now;
  } else if (track.status == TrackStatus.planToRead ||
      track.status == TrackStatus.planToWatch) {
    track.status = isManga ? TrackStatus.reading : TrackStatus.watching;
  }
  return track;
}
