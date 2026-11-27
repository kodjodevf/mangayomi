import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/models/backup_password_fallback.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/custom_button.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/models/tracker_library_cache.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/backup.dart';
import 'package:mangayomi/repositories/db.dart';
import 'package:mangayomi/services/backup_password_storage.dart';

class _FakeZipFileEncoder implements ZipFileEncoder {
  _FakeZipFileEncoder({
    this.failOnCreate = false,
    this.failOnAddFile = false,
    this.failOnClose = false,
  });

  final bool failOnCreate;
  final bool failOnAddFile;
  final bool failOnClose;

  var createCalls = 0;
  var addFileCalls = 0;
  var closeCalls = 0;
  String? createdZipPath;

  @override
  void create(String zipPath, {int? level, DateTime? modified}) {
    createCalls++;
    if (failOnCreate) {
      throw const FileSystemException('create failed');
    }
    createdZipPath = zipPath;
    File(zipPath).writeAsBytesSync(const [1, 2, 3]);
  }

  @override
  Future<void> addFile(File file, [String? filename, int? level]) async {
    addFileCalls++;
    if (failOnAddFile) {
      throw const FileSystemException('addFile failed');
    }
  }

  @override
  Future<void> close() async {
    closeCalls++;
    if (failOnClose) {
      throw const FileSystemException('close failed');
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

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
    directory = Directory.systemTemp.createTempSync('backup_zip_cleanup');
    isar = await Isar.open(
      [
        MangaSchema,
        ChangedPartSchema,
        ChapterSchema,
        CategorySchema,
        CustomButtonSchema,
        UpdateSchema,
        HistorySchema,
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
      name: 'backup_zip_cleanup_${directory.path.hashCode}',
    );
    await isar.writeTxn(() async {
      await isar.settings.put(Settings());
    });
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  });

  List<FileSystemEntity> leftoverDbFiles() =>
      directory.listSync().where((e) => e.path.endsWith('.backup.db')).toList();

  List<FileSystemEntity> leftoverZipFiles() =>
      directory.listSync().where((e) => e.path.endsWith('.backup')).toList();

  test('cleans up plaintext .backup.db (including encrypted backup password) and partial zip when addFile fails', () async {
    await isar.writeTxn(() async {
      await isar.settings.put(Settings()..backupEncryptionEnabled = true);
    });
    await BackupPasswordStorage.savePlaintextFallback('top-secret-password');

    late _FakeZipFileEncoder fakeEncoder;
    await expectLater(
      writeMangayomiBackupZip(
        list: const [0],
        directory: directory.path,
        encrypt: true,
        zipEncoderFactory: ({String? password}) {
          expect(password, 'top-secret-password');
          return fakeEncoder = _FakeZipFileEncoder(failOnAddFile: true);
        },
      ),
      throwsA(
        isA<FileSystemException>().having(
          (e) => e.message,
          'message',
          'addFile failed',
        ),
      ),
    );

    expect(fakeEncoder.createCalls, 1);
    expect(fakeEncoder.addFileCalls, 1);
    expect(fakeEncoder.closeCalls, 1);
    expect(leftoverDbFiles(), isEmpty);
    expect(leftoverZipFiles(), isEmpty);
  });

  test('cleans up .backup.db without calling close when ZipFileEncoder.create fails', () async {
    late _FakeZipFileEncoder fakeEncoder;
    await expectLater(
      writeMangayomiBackupZip(
        list: const [0],
        directory: directory.path,
        encrypt: false,
        zipEncoderFactory: ({String? password}) =>
            fakeEncoder = _FakeZipFileEncoder(failOnCreate: true),
      ),
      throwsA(
        isA<FileSystemException>().having(
          (e) => e.message,
          'message',
          'create failed',
        ),
      ),
    );

    expect(fakeEncoder.createCalls, 1);
    expect(fakeEncoder.closeCalls, 0);
    expect(leftoverDbFiles(), isEmpty);
    expect(leftoverZipFiles(), isEmpty);
  });

  test('cleans up .backup.db and partial zip and avoids double-close when close fails', () async {
    late _FakeZipFileEncoder fakeEncoder;
    await expectLater(
      writeMangayomiBackupZip(
        list: const [0],
        directory: directory.path,
        encrypt: false,
        zipEncoderFactory: ({String? password}) =>
            fakeEncoder = _FakeZipFileEncoder(failOnClose: true),
      ),
      throwsA(
        isA<FileSystemException>().having(
          (e) => e.message,
          'message',
          'close failed',
        ),
      ),
    );

    expect(fakeEncoder.closeCalls, 1);
    expect(leftoverDbFiles(), isEmpty);
    expect(leftoverZipFiles(), isEmpty);
  });

  test(
    'awaits deletion of .backup.db before returning on successful backup',
    () async {
      final zipPath = await writeMangayomiBackupZip(
        list: const [0],
        directory: directory.path,
        encrypt: false,
      );

      expect(File(zipPath).existsSync(), isTrue);
      expect(leftoverDbFiles(), isEmpty);
      expect(leftoverZipFiles().map((e) => e.path), [zipPath]);
    },
  );
}
