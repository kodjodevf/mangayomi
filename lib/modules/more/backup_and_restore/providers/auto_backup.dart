import 'dart:io';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/backup_and_restore/providers/backup.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    return isar.settings.getSync(227)!.backupFrequencyOptions ?? [0, 1, 2, 3];
  }

  void set(List<int> values) {
    final settings = isar.settings.getSync(227);
    state = values;
    isar.writeTxnSync(() =>
        isar.settings.putSync(settings!..backupFrequencyOptions = values));
  }
}

@riverpod
class AutoBackupLocationState extends _$AutoBackupLocationState {
  @override
  (String, String) build() {
    return ("", isar.settings.getSync(227)!.autoBackupLocation ?? "");
  }

  void set(String location) {
    final settings = isar.settings.getSync(227);
    state = ("${_storageProvider!.path}backup", location);
    isar.writeTxnSync(
        () => isar.settings.putSync(settings!..autoBackupLocation = location));
  }

  Directory? _storageProvider;

  Future refresh() async {
    _storageProvider = Platform.isIOS
        ? await StorageProvider().getIosBackupDirectory()
        : await StorageProvider().getDefaultDirectory();
    final settings = isar.settings.getSync(227);
    state = (
      Platform.isIOS
          ? _storageProvider!.path
          : "${_storageProvider!.path}backup/",
      settings!.autoBackupLocation ?? ""
    );
  }
}

@riverpod
Future<void> checkAndBackup(Ref ref) async {
  final settings = isar.settings.getSync(227);
  if (settings!.backupFrequency != null) {
    final backupFrequency = _duration(settings.backupFrequency);
    if (backupFrequency != null) {
      if (settings.startDatebackup != null) {
        final startDatebackup =
            DateTime.fromMillisecondsSinceEpoch(settings.startDatebackup!);
        if (DateTime.now().isAfter(startDatebackup)) {
          _setBackupFrequency(settings.backupFrequency!);
          final storageProvider = StorageProvider();
          await storageProvider.requestPermission();
          final defaulteDirectory = await storageProvider.getDefaultDirectory();
          final backupLocation = ref.watch(autoBackupLocationStateProvider).$2;
          Directory? backupDirectory;
          backupDirectory = Directory(backupLocation.isEmpty
              ? "${defaulteDirectory!.path}backup/"
              : backupLocation);
          if (Platform.isIOS) {
            backupDirectory = await (storageProvider.getIosBackupDirectory());
          }
          if (!(await backupDirectory!.exists())) {
            backupDirectory.create();
          }
          ref.watch(doBackUpProvider(
              list: ref.watch(backupFrequencyOptionsStateProvider),
              path: backupDirectory.path,
              context: null));
        }
      }
    }
  }
}

Duration? _duration(int? backupFrequency) {
  return switch (backupFrequency) {
    1 => const Duration(hours: 6),
    2 => const Duration(hours: 12),
    3 => const Duration(days: 1),
    4 => const Duration(days: 2),
    5 => const Duration(days: 7),
    _ => null
  };
}

void _setBackupFrequency(int value) {
  final settings = isar.settings.getSync(227);
  final duration = _duration(value);
  final now = DateTime.now();
  final startDate = duration != null ? now.add(duration) : null;
  isar.writeTxnSync(() => isar.settings.putSync(settings!
    ..backupFrequency = value
    ..startDatebackup = startDate?.millisecondsSinceEpoch));
}
