import 'dart:io';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auto_backup.g.dart';

@riverpod
class BackupFrequencyState extends _$BackupFrequencyState {
  @override
  int build() {
    return isar.settings.getSync(227)!.backupFrequency ?? 0;
  }

  void set(int value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings!..backupFrequency = value));
  }
}

@riverpod
class BackupFrequencyOptionsState extends _$BackupFrequencyOptionsState {
  @override
  List<int> build() {
    return isar.settings.getSync(227)!.backupFrequencyOptions ?? [];
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
    _storageProvider = await StorageProvider().getDefaultDirectory();
    final settings = isar.settings.getSync(227);
    state =
        ("${_storageProvider!.path}backup", settings!.autoBackupLocation ?? "");
  }
}

//  this.personalPageModeList,
//       this.backupFrequency,
//       this.backupFrequencyOptions,
//       this.autoBackupLocation,
//       this.startDatebackup
