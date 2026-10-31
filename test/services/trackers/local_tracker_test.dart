import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/services/trackers/local_tracker.dart';

Manga _manga(String name, {Status status = Status.ongoing}) => Manga(
  source: 'test',
  author: '',
  artist: '',
  genre: const [],
  imageUrl: 'https://example.org/$name.jpg',
  lang: 'en',
  link: '/$name',
  name: name,
  status: status,
  description: '',
  sourceId: 1,
);

void main() {
  group('series length', () {
    test('is the chapter count once the series is finished', () {
      expect(localSeriesLength(Status.completed, 42), 42);
      expect(localSeriesLength(Status.publishingFinished, 12), 12);
    });

    test('is unknown while it still runs, so progress is not capped', () {
      expect(localSeriesLength(Status.ongoing, 42), 0);
      expect(localSeriesLength(Status.onHiatus, 42), 0);
      expect(localSeriesLength(Status.unknown, 42), 0);
    });
  });

  group('dates', () {
    Track track({
      TrackStatus status = TrackStatus.reading,
      int read = 0,
      int started = 0,
      int finished = 0,
    }) => Track(
      status: status,
      lastChapterRead: read,
      startedReadingDate: started,
      finishedReadingDate: finished,
    );

    test('nothing read and nothing finished leaves both empty', () {
      final t = stampLocalTrackDates(
        track(status: TrackStatus.planToRead),
        1000,
      );
      expect(t.startedReadingDate, 0);
      expect(t.finishedReadingDate, 0);
    });

    test('the first chapter counted starts it', () {
      final t = stampLocalTrackDates(track(read: 1), 1000);
      expect(t.startedReadingDate, 1000);
      expect(t.finishedReadingDate, 0);
    });

    test('completing it finishes it, and starts it if it never was', () {
      final t = stampLocalTrackDates(
        track(status: TrackStatus.completed),
        1000,
      );
      expect(t.startedReadingDate, 1000);
      expect(t.finishedReadingDate, 1000);
    });

    test('a date already set is kept', () {
      final t = stampLocalTrackDates(
        track(status: TrackStatus.completed, read: 5, started: 7, finished: 9),
        1000,
      );
      expect(t.startedReadingDate, 7);
      expect(t.finishedReadingDate, 9);
    });
  });

  test('statuses follow the kind', () {
    expect(localTrackStatuses(true), contains(TrackStatus.reading));
    expect(localTrackStatuses(true), contains(TrackStatus.reReading));
    expect(localTrackStatuses(true), isNot(contains(TrackStatus.watching)));
    expect(localTrackStatuses(false), contains(TrackStatus.watching));
    expect(localTrackStatuses(false), contains(TrackStatus.planToWatch));
    expect(localTrackStatuses(false), isNot(contains(TrackStatus.reading)));
  });

  test('a new entry points at the series and is planned', () {
    final manga = _manga('Finished', status: Status.completed)
      ..id = 7
      ..itemType = ItemType.novel;
    final track = newLocalTrack(manga, 30);
    expect(track.syncId, TrackerProviders.local.syncId);
    expect(track.mangaId, 7);
    expect(track.mediaId, 7);
    expect(track.title, 'Finished');
    expect(track.totalChapter, 30);
    expect(track.itemType, ItemType.novel);
    // A novel is read, not watched.
    expect(track.status, TrackStatus.planToRead);

    final anime = _manga('Show')
      ..id = 8
      ..itemType = ItemType.anime;
    expect(newLocalTrack(anime, 3).status, TrackStatus.planToWatch);
    expect(newLocalTrack(anime, 3).totalChapter, 0);
  });

  test('the library shows an entry with its series id and cover', () {
    final search = localTrackSearch(
      Track(
        mangaId: 7,
        syncId: TrackerProviders.local.syncId,
        title: 'T',
        status: TrackStatus.onHold,
        lastChapterRead: 3,
        totalChapter: 10,
        score: 0,
      ),
      'cover.jpg',
    );
    expect(search.mediaId, 7);
    expect(search.coverUrl, 'cover.jpg');
    expect(search.status, 'onHold');
    // No score given is not a score of 0.
    expect(search.score, isNull);
  });

  group('database', () {
    late Directory directory;

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final overrides = HttpOverrides.current;
      HttpOverrides.global = null;
      try {
        await Isar.initializeIsarCore(download: true);
      } finally {
        HttpOverrides.global = overrides;
      }
    });

    setUp(() async {
      directory = Directory.systemTemp.createTempSync('local_tracker');
      isar = await Isar.open(
        [
          MangaSchema,
          ChapterSchema,
          SettingsSchema,
          SourceSchema,
          DownloadSchema,
          TrackSchema,
        ],
        directory: directory.path,
        name: 'local_tracker_${directory.path.hashCode}',
      );
    });

    tearDown(() async {
      await isar.close(deleteFromDisk: true);
      if (directory.existsSync()) directory.deleteSync(recursive: true);
    });

    test('cleaning the database keeps what the local tracker holds', () {
      final kept = _manga('Kept')..favorite = false;
      final dropped = _manga('Dropped')..favorite = false;
      final inLibrary = _manga('Library')..favorite = true;
      final onlineOnly = _manga('Online')..favorite = false;
      isar.writeTxnSync(() {
        isar.mangas.putAllSync([kept, dropped, inLibrary, onlineOnly]);
        isar.tracks.putAllSync([
          newLocalTrack(kept, 0),
          Track(
            mangaId: onlineOnly.id,
            mediaId: 99,
            syncId: TrackerProviders.anilist.syncId,
            status: TrackStatus.reading,
          ),
        ]);
      });

      final names = mangaRepository.getNonFavorites().map((m) => m.name);
      expect(names, unorderedEquals(['Dropped', 'Online']));
    });

    test('entries are read by tracker and kind', () {
      final manga = _manga('M')..favorite = true;
      final anime = _manga('A')
        ..favorite = true
        ..itemType = ItemType.anime;
      isar.writeTxnSync(() {
        isar.mangas.putAllSync([manga, anime]);
        isar.tracks.putAllSync([
          newLocalTrack(manga, 0),
          newLocalTrack(anime, 0),
        ]);
      });
      final local = TrackerProviders.local.syncId;
      expect(
        trackRepository
            .getBySyncIdAndItemType(local, ItemType.anime)
            .map((t) => t.title),
        ['A'],
      );
      expect(trackRepository.mangaIdsBySyncId(local), {manga.id, anime.id});
    });
  });
}
