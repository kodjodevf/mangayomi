import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/models/tracker_library_cache.dart';
import 'package:mangayomi/repositories/tracker_library_cache_repository.dart';

void main() {
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
    directory = Directory.systemTemp.createTempSync('tracker_library_cache');
    isar = await Isar.open(
      [TrackerLibraryCacheSchema],
      directory: directory.path,
      name: 'tracker_library_cache_${directory.path.hashCode}',
    );
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  });

  test('a section reads back every field it was cached with', () async {
    await trackerLibraryCacheRepository.put('2-anime-Watching', [
      TrackSearch(
        mediaId: 42,
        syncId: 2,
        title: 'Title',
        lastChapterRead: 3,
        totalChapter: 12,
        score: 8.5,
        status: 'watching',
        trackingUrl: 'https://tracker/42',
        coverUrl: 'https://tracker/42.jpg',
        summary: 'Summary',
        publishingStatus: 'Airing',
        publishingType: 'TV',
        startDate: '2026-01-01',
      ),
    ]);

    final tracks = await trackerLibraryCacheRepository.get('2-anime-Watching');

    expect(tracks, hasLength(1));
    final track = tracks!.single;
    expect(track.mediaId, 42);
    expect(track.score, 8.5);
    expect(track.summary, 'Summary');
    expect(track.publishingType, 'TV');
    expect(track.startDate, '2026-01-01');
  });

  test('an uncached section reads back as null', () async {
    expect(await trackerLibraryCacheRepository.get('2-anime-Missing'), isNull);
  });

  test('caching a section again replaces its entries', () async {
    await trackerLibraryCacheRepository.put('2-anime-Watching', [
      TrackSearch(title: 'Old'),
    ]);
    await trackerLibraryCacheRepository.put('2-anime-Watching', [
      TrackSearch(title: 'New'),
    ]);

    final tracks = await trackerLibraryCacheRepository.get('2-anime-Watching');

    expect(tracks!.map((t) => t.title), ['New']);
  });

  test('a refresh clears only that tracker and item type', () async {
    await trackerLibraryCacheRepository.put('2-anime-Watching', []);
    await trackerLibraryCacheRepository.put('2-anime-Planned', []);
    await trackerLibraryCacheRepository.put('2-manga-Reading', []);
    await trackerLibraryCacheRepository.put('3-anime-Watching', []);

    await trackerLibraryCacheRepository.deleteByPrefix('2-anime-');

    expect(await trackerLibraryCacheRepository.get('2-anime-Watching'), isNull);
    expect(await trackerLibraryCacheRepository.get('2-anime-Planned'), isNull);
    expect(await trackerLibraryCacheRepository.get('2-manga-Reading'), isEmpty);
    expect(
      await trackerLibraryCacheRepository.get('3-anime-Watching'),
      isEmpty,
    );
  });
}
