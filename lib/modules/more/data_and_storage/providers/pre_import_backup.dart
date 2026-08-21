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
    encrypt: false,
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

const maxLibrarySnapshots = 3;

Future<void> writeLastLibrarySnapshot(LibrarySafetySnapshot snapshot) async {
  final file = await _snapshotMetaFile();
  final current = await _readSnapshots(file);
  final updated = [snapshot, ...current];
  final overflow = updated.length > maxLibrarySnapshots
      ? updated.sublist(maxLibrarySnapshots)
      : const <LibrarySafetySnapshot>[];
  for (final old in overflow) {
    final oldFile = File(old.backupPath);
    if (await oldFile.exists()) await oldFile.delete();
  }
  final kept = updated.take(maxLibrarySnapshots).toList();
  await file.writeAsString(jsonEncode(kept.map((s) => s.toJson()).toList()));
}

Future<void> clearLastLibrarySnapshot() async {
  final file = await _snapshotMetaFile();
  final current = await _readSnapshots(file);
  for (final snapshot in current) {
    final snapshotFile = File(snapshot.backupPath);
    if (await snapshotFile.exists()) await snapshotFile.delete();
  }
  if (await file.exists()) await file.delete();
}

Future<List<LibrarySafetySnapshot>> _readSnapshots(File file) async {
  if (!await file.exists()) return const [];
  try {
    final decoded = jsonDecode(await file.readAsString());
    if (decoded is! List) return const [];
    return decoded
        .cast<Map<String, dynamic>>()
        .map(LibrarySafetySnapshot.fromJson)
        .toList();
  } catch (_) {
    return const [];
  }
}

@riverpod
Future<List<LibrarySafetySnapshot>> lastLibrarySnapshot(Ref ref) async {
  final file = await _snapshotMetaFile();
  final snapshots = await _readSnapshots(file);
  final valid = <LibrarySafetySnapshot>[];
  for (final snapshot in snapshots) {
    if (await File(snapshot.backupPath).exists()) valid.add(snapshot);
  }
  return valid;
}

Future<Directory> _snapshotDirectory() async {
  final storageProvider = StorageProvider();
  final defaultDirectory = await storageProvider.getDefaultDirectory();
  final dirPath = p.join(defaultDirectory!.path, 'pre_import_backup');
  await storageProvider.createDirectorySafely(dirPath);
  return Directory(dirPath);
}

Future<File> _snapshotMetaFile() async {
  final dir = await _snapshotDirectory();
  return File(p.join(dir.path, 'last_library_snapshot.json'));
}
