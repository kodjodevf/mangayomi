import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/services/trackers/track_progress.dart';

Track _track({
  TrackStatus status = TrackStatus.reading,
  int read = 0,
  int total = 0,
}) => Track(
  status: status,
  lastChapterRead: read,
  totalChapter: total,
  startedReadingDate: 0,
  finishedReadingDate: 0,
);

void main() {
  test('the first one starts a planned entry and dates it', () {
    final t = advanceTrack(
      _track(status: TrackStatus.planToRead),
      ItemType.manga,
      1000,
    );
    expect(t.lastChapterRead, 1);
    expect(t.status, TrackStatus.reading);
    expect(t.startedReadingDate, 1000);
  });

  test('a planned anime is being watched, not read', () {
    final t = advanceTrack(
      _track(status: TrackStatus.planToWatch),
      ItemType.anime,
      1000,
    );
    expect(t.status, TrackStatus.watching);
  });

  test('the last one completes it and dates the finish', () {
    final t = advanceTrack(_track(read: 9, total: 10), ItemType.manga, 1000);
    expect(t.lastChapterRead, 10);
    expect(t.status, TrackStatus.completed);
    expect(t.finishedReadingDate, 1000);
  });

  test('nothing moves past the total or once completed', () {
    expect(
      advanceTrack(
        _track(read: 10, total: 10),
        ItemType.manga,
        1,
      ).lastChapterRead,
      10,
    );
    expect(
      advanceTrack(
        _track(status: TrackStatus.completed, read: 3),
        ItemType.manga,
        1,
      ).lastChapterRead,
      3,
    );
  });

  test('on hold stays on hold; an unknown total never completes', () {
    final t = advanceTrack(
      _track(status: TrackStatus.onHold, read: 4),
      ItemType.manga,
      1,
    );
    expect(t.lastChapterRead, 5);
    expect(t.status, TrackStatus.onHold);
    expect(t.startedReadingDate, 0);
  });
}
