import 'dart:convert';
import 'dart:io';

import 'package:mangayomi/modules/more/data_and_storage/providers/backup.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path/path.dart' as p;
part 'pre_import_backup.g.dart';

Future<String> createLibrarySafetyBackup() async {
  final dir = await _snapshotDirectory();
  return writeMangayomiBackupZip(
    list: const [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    directory: dir.path,
  );
}

class LibrarySafetySnapshot {
  LibrarySafetySnapshot({
    required this.backupPath,
    required this.createdAt,
    required this.description,
  });

  final String backupPath;
  final int createdAt;
  final String description;

  Map<String, dynamic> toJson() => {
    'backupPath': backupPath,
    'createdAt': createdAt,
    'description': description,
  };

  factory LibrarySafetySnapshot.fromJson(Map<String, dynamic> json) =>
      LibrarySafetySnapshot(
        backupPath: json['backupPath'] as String,
        createdAt: json['createdAt'] as int,
        description: json['description'] as String,
      );
}

Future<void> writeLastLibrarySnapshot(LibrarySafetySnapshot snapshot) async {
  final file = await _snapshotMetaFile();
  await file.writeAsString(jsonEncode(snapshot.toJson()));
}

Future<void> clearLastLibrarySnapshot() async {
  final file = await _snapshotMetaFile();
  if (await file.exists()) await file.delete();
}

@riverpod
Future<LibrarySafetySnapshot?> lastLibrarySnapshot(Ref ref) async {
  final file = await _snapshotMetaFile();
  if (!await file.exists()) return null;
  try {
    final snapshot = LibrarySafetySnapshot.fromJson(
      jsonDecode(await file.readAsString()) as Map<String, dynamic>,
    );
    if (!await File(snapshot.backupPath).exists()) return null;
    return snapshot;
  } catch (_) {
    return null;
  }
}

Future<Directory> _snapshotDirectory() =>
    StorageProvider().createCacheDirectory('pre_import_backup');

Future<File> _snapshotMetaFile() async {
  final dir = await _snapshotDirectory();
  return File(p.join(dir.path, 'last_library_snapshot.json'));
}
