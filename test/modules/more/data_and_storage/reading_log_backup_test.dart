import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/backup_password_fallback.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/custom_button.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/reading_log.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/models/tracker_library_cache.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/backup.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/mangayomi_restore_service.dart';

final _refProvider = Provider<Ref>((ref) => ref);

Manga _manga(String name, {int? id}) => Manga(
  id: id ?? Isar.autoIncrement,
  source: 'src',
  author: '',
  artist: '',
  genre: const [],
  imageUrl: '',
  lang: 'en',
  link: '/$name',
  name: name,
  status: Status.unknown,
  description: '',
  sourceId: 1,
  favorite: true,
);

Chapter _chapter(int mangaId, String url, {int? id}) => Chapter(
  id: id ?? Isar.autoIncrement,
  mangaId: mangaId,
  name: url,
  url: url,
);

ReadingLog _log(
  int? mangaId,
  int? chapterId,
  int at, {
  ReadingLogKind kind = ReadingLogKind.completion,
  int seconds = 0,
}) => ReadingLog(
  mangaId: mangaId,
  chapterId: chapterId,
  itemType: ItemType.manga,
  at: at,
  kind: kind,
  seconds: seconds,
);

List<ReadingLog> _rows() =>
    isar.readingLogs.where().findAllSync()..sort((a, b) => a.at - b.at);

void main() {
  late Directory directory;
  late ProviderContainer container;

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
    directory = Directory.systemTemp.createTempSync('reading_log_backup');
    isar = await Isar.open(
      [
        MangaSchema,
        ChangedPartSchema,
        ChapterSchema,
        CategorySchema,
        CustomButtonSchema,
        UpdateSchema,
        HistorySchema,
        ReadingLogSchema,
        DownloadSchema,
        SourceSchema,
        SettingsSchema,
        TrackPreferenceSchema,
        TrackSchema,
        SyncPreferenceSchema,
        SourcePreferenceSchema,
        SourcePreferenceStringValueSchema,
        BackupPasswordFallbackSchema,
        TrackerLibraryCacheSchema,
      ],
      directory: directory.path,
      name: 'reading_log_backup_${directory.path.hashCode}',
    );
    isar.writeTxnSync(() => isar.settings.putSync(Settings()));
    container = ProviderContainer();
  });

  tearDown(() async {
    container.dispose();
    await isar.close(deleteFromDisk: true);
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  });

  Future<Map<String, dynamic>> backupWith(List<int> options) async {
    final zipPath = await writeMangayomiBackupZip(
      list: options,
      directory: directory.path,
      encrypt: false,
    );
    final archive = ZipDecoder().decodeBytes(File(zipPath).readAsBytesSync());
    final db = archive.files.firstWhere((f) => f.name.endsWith('.backup.db'));
    return jsonDecode(utf8.decode(db.content as List<int>))
        as Map<String, dynamic>;
  }

  Future<void> restore(Map<String, dynamic> backup, {bool merge = false}) =>
      MangayomiRestoreService.restore(
        container.read(_refProvider),
        backup,
        full: false,
        merge: merge,
      );

  test('backup includes readingLog under history option', () async {
    isar.writeTxnSync(() {
      final id = isar.mangas.putSync(_manga('A'));
      isar.readingLogs.putAllSync([
        _log(id, null, 1000),
        _log(id, null, 2000, kind: ReadingLogKind.time, seconds: 90),
      ]);
    });

    final withHistory = await backupWith([0, 4]);
    final rows = withHistory['readingLog'] as List;
    expect(rows, hasLength(2));
    expect(
      rows.map((r) => (r['at'], r['kind'], r['seconds'])),
      containsAll([(1000, 1, 0), (2000, 0, 90)]),
    );

    final withoutHistory = await backupWith([0]);
    expect(withoutHistory.containsKey('readingLog'), isFalse);
  });

  test('replace restore restores rows', () async {
    isar.writeTxnSync(() {
      final id = isar.mangas.putSync(_manga('Old'));
      isar.readingLogs.putSync(_log(id, null, 1));
    });

    await restore({
      'version': '2',
      'manga': [_manga('A', id: 10).toJson()],
      'chapters': [_chapter(10, '/A/1', id: 20).toJson()],
      'history': <dynamic>[],
      'readingLog': [
        _log(10, 20, 5000).toJson()..['id'] = 7,
        // Its series isn't in the backup.
        _log(99, null, 6000).toJson()..['id'] = 8,
      ],
    });

    final rows = _rows();
    expect(rows, hasLength(1));
    expect(rows.single.id, 7);
    expect(rows.single.mangaId, 10);
    expect(rows.single.chapterId, 20);
    expect(rows.single.at, 5000);
  });

  test('merge restore remaps ids and skips duplicates', () async {
    late int aId;
    late int a1Id;
    isar.writeTxnSync(() {
      aId = isar.mangas.putSync(_manga('A'));
      final a1 = _chapter(aId, '/A/1');
      a1Id = isar.chapters.putSync(a1);
      isar.readingLogs.putSync(_log(aId, a1Id, 1000));
    });

    await restore({
      'version': '2',
      'manga': [_manga('A', id: 100).toJson(), _manga('B', id: 101).toJson()],
      'chapters': [
        _chapter(100, '/A/1', id: 200).toJson(),
        _chapter(101, '/B/1', id: 201).toJson(),
      ],
      'readingLog': [
        // Already here: same series, chapter, time and kind.
        _log(100, 200, 1000).toJson(),
        _log(100, 200, 2000, kind: ReadingLogKind.time, seconds: 60).toJson(),
        _log(101, 201, 3000).toJson(),
        // Series not in the backup.
        _log(999, null, 4000).toJson(),
      ],
    }, merge: true);

    final rows = _rows();
    expect(rows.map((r) => r.at), [1000, 2000, 3000]);
    expect(rows[1].mangaId, aId);
    expect(rows[1].chapterId, a1Id);
    expect(rows[1].seconds, 60);

    final b = isar.mangas.filter().linkEqualTo('/B').findFirstSync()!;
    final b1 = isar.chapters.filter().urlEqualTo('/B/1').findFirstSync()!;
    expect(rows[2].mangaId, b.id);
    expect(rows[2].chapterId, b1.id);
  });

  test('backup without readingLog key restores fine', () async {
    late int keptId;
    isar.writeTxnSync(() {
      keptId = isar.mangas.putSync(_manga('A'));
      isar.readingLogs.putSync(_log(keptId, null, 1000));
    });
    final oldBackup = {
      'version': '2',
      'manga': [_manga('A', id: 10).toJson()],
      'chapters': [_chapter(10, '/A/1', id: 20).toJson()],
      'history': [
        History(
          itemType: ItemType.manga,
          chapterId: 20,
          mangaId: 10,
          date: '5000',
        ).toJson()..['id'] = 30,
      ],
    };

    await restore(oldBackup, merge: true);
    expect(_rows().map((r) => r.at), [1000]);

    await restore(oldBackup);
    expect(isar.historys.countSync(), 1);
    expect(_rows(), isEmpty);
  });
}
