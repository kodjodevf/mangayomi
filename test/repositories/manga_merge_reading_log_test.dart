import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/reading_log.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/repositories/manga_repository.dart';

Manga _manga(String link) => Manga(
  source: 'src',
  author: '',
  artist: '',
  genre: const [],
  imageUrl: '',
  lang: 'en',
  link: link,
  name: 'Series',
  status: Status.ongoing,
  description: '',
  sourceId: 1,
  favorite: true,
);

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
    directory = Directory.systemTemp.createTempSync('merge_log');
    isar = await Isar.open(
      [
        MangaSchema,
        ChapterSchema,
        HistorySchema,
        ReadingLogSchema,
        UpdateSchema,
        TrackSchema,
        ChangedPartSchema,
        SyncPreferenceSchema,
        DownloadSchema,
        SourceSchema,
      ],
      directory: directory.path,
      name: 'merge_log_${directory.path.hashCode}',
    );
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  });

  test('merging duplicates moves the reading log to the kept series', () async {
    final primary = _manga('/a');
    final other = _manga('/b');
    late Chapter primaryChapter;
    late Chapter otherOnly;
    isar.writeTxnSync(() {
      isar.mangas.putAllSync([primary, other]);
      primaryChapter = Chapter(mangaId: primary.id, name: 'Ch 1', url: '/1')
        ..manga.value = primary;
      final otherDuplicate = Chapter(mangaId: other.id, name: 'Ch 1', url: '/1')
        ..manga.value = other;
      otherOnly = Chapter(mangaId: other.id, name: 'Ch 2', url: '/2')
        ..manga.value = other;
      isar.chapters.putAllSync([primaryChapter, otherDuplicate, otherOnly]);
      for (final c in [primaryChapter, otherDuplicate, otherOnly]) {
        c.manga.saveSync();
      }
      isar.readingLogs.putAllSync([
        ReadingLog(
          mangaId: other.id,
          chapterId: otherDuplicate.id,
          itemType: ItemType.manga,
          at: 1,
          kind: ReadingLogKind.completion,
        ),
        ReadingLog(
          mangaId: other.id,
          chapterId: otherOnly.id,
          itemType: ItemType.manga,
          at: 2,
          kind: ReadingLogKind.completion,
        ),
      ]);
    });

    await mangaRepository.mergeGroup(primary, [other]);

    final rows = isar.readingLogs.where().sortByAt().findAllSync();
    expect(rows.map((r) => (r.mangaId, r.chapterId)), [
      (primary.id, primaryChapter.id),
      (primary.id, otherOnly.id),
    ]);
  });

  // Isar can hand a deleted series' id to the next one added, so log rows
  // left behind would be credited to an unrelated series.
  group('deleting a series removes its reading log', () {
    late Manga gone;
    late Manga kept;

    setUp(() {
      gone = _manga('/gone');
      kept = _manga('/kept');
      isar.writeTxnSync(() {
        isar.mangas.putAllSync([gone, kept]);
        isar.readingLogs.putAllSync([
          for (final m in [gone, kept])
            ReadingLog(
              mangaId: m.id,
              itemType: ItemType.manga,
              at: 1000,
              kind: ReadingLogKind.completion,
            ),
        ]);
      });
    });

    List<int?> loggedIds() =>
        isar.readingLogs.where().mangaIdProperty().findAllSync();

    test('wipe', () async {
      await mangaRepository.wipeMangas([gone]);
      expect(loggedIds(), [kept.id]);
    });

    test('source group delete, even when keeping history', () async {
      await mangaRepository.deleteLibrarySourceGroup([gone], keepHistory: true);
      expect(loggedIds(), [kept.id]);
    });

    test('single delete', () async {
      await mangaRepository.delete(gone.id!);
      expect(loggedIds(), [kept.id]);
    });
  });
}
