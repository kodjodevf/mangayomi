import 'dart:io';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/backup.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
part 'auto_backup.g.dart';

@riverpod
class BackupFrequencyState extends _$BackupFrequencyState {
  @override
  int build() {
    return isar.settings.getSync(227)!.backupFrequency ?? 0;
  }

  void set(int value) {
    state = value;
    _setBackupFrequency(value);
  }
}

@riverpod
class BackupFrequencyOptionsState extends _$BackupFrequencyOptionsState {
  @override
  List<int> build() {
    return isar.settings.getSync(227)!.backupListOptions ??
        [0, 1, 2, 3, 4, 5, 6, 7, 10];
  }

  void set(List<int> values) {
    final settings = isar.settings.getSync(227);
    state = values;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..backupListOptions = values
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class AutoBackupLocationState extends _$AutoBackupLocationState {
  @override
  (String, String) build() {
    _refresh();
    return ("", isar.settings.getSync(227)!.autoBackupLocation ?? "");
  }

  void set(String location) {
    final settings = isar.settings.getSync(227);
    state = (p.join(_storageProvider!.path, "backup"), location);
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..autoBackupLocation = location
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  Directory? _storageProvider;

  Future _refresh() async {
    _storageProvider = Platform.isIOS
        ? await StorageProvider().getIosBackupDirectory()
        : await StorageProvider().getDefaultDirectory();
    final settings = isar.settings.getSync(227);
    state = (
      Platform.isIOS
          ? _storageProvider!.path
          : p.join(_storageProvider!.path, "backup"),
      settings!.autoBackupLocation ?? "",
    );
  }
}

@riverpod
Future<void> checkAndBackup(Ref ref) async {
  final settings = isar.settings.getSync(227);
  final backupFrequency = _duration(settings!.backupFrequency);
  if (backupFrequency == null || settings.startDatebackup == null) return;

  final startDatebackup = DateTime.fromMillisecondsSinceEpoch(
    settings.startDatebackup!,
  );
  if (!DateTime.now().isAfter(startDatebackup)) return;
  _setBackupFrequency(settings.backupFrequency!);
  final storageProvider = StorageProvider();
  final backupLocation = ref.read(autoBackupLocationStateProvider).$2;
  Directory? backupDirectory;
  if (Platform.isIOS) {
    backupDirectory = await (storageProvider.getIosBackupDirectory());
  } else {
    final defaultDirectory = await storageProvider.getDefaultDirectory();
    backupDirectory = Directory(
      backupLocation.isEmpty
          ? p.join(defaultDirectory!.path, "backup")
          : backupLocation,
    );
  }
  await storageProvider.createDirectorySafely(backupDirectory!.path);
  ref.read(
    doBackUpProvider(
      list: ref.read(backupFrequencyOptionsStateProvider),
      path: backupDirectory.path,
      context: null,
    ),
  );
}

Duration? _duration(int? backupFrequency) {
  return switch (backupFrequency) {
    1 => const Duration(hours: 6),
    2 => const Duration(hours: 12),
    3 => const Duration(days: 1),
    4 => const Duration(days: 2),
    5 => const Duration(days: 7),
    _ => null,
  };
}

void _setBackupFrequency(int value) {
  final settings = isar.settings.getSync(227);
  final duration = _duration(value);
  final now = DateTime.now();
  final startDate = duration != null ? now.add(duration) : null;
  isar.writeTxnSync(
    () => isar.settings.putSync(
      settings!
        ..backupFrequency = value
        ..startDatebackup = startDate?.millisecondsSinceEpoch
        ..updatedAt = DateTime.now().millisecondsSinceEpoch,
    ),
  );
}
