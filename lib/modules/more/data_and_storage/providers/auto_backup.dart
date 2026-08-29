import 'dart:io';

import 'package:mangayomi/modules/more/data_and_storage/providers/backup.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path/path.dart' as p;
part 'auto_backup.g.dart';

@riverpod
class BackupFrequencyState extends _$BackupFrequencyState {
  @override
  int build() {
    return settingsRepository.current.backupFrequency ?? 0;
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
    return settingsRepository.current.backupListOptions ??
        [0, 1, 2, 3, 4, 5, 6, 7, 10];
  }

  void set(List<int> values) {
    state = values;
    settingsRepository.update((s) => s.backupListOptions = values);
  }
}

@riverpod
class AutoBackupLocationState extends _$AutoBackupLocationState {
  @override
  (String, String) build() {
    ref.keepAlive();
    _refresh();
    return ("", settingsRepository.current.autoBackupLocation ?? "");
  }

  void set(String location) {
    state = (p.join(_storageProvider!.path, "backup"), location);
    settingsRepository.update((s) => s.autoBackupLocation = location);
  }

  Directory? _storageProvider;

  Future _refresh() async {
    _storageProvider = Platform.isIOS
        ? await StorageProvider().getIosBackupDirectory()
        : await StorageProvider().getDefaultDirectory();
    state = (
      Platform.isIOS
          ? _storageProvider!.path
          : p.join(_storageProvider!.path, "backup"),
      settingsRepository.current.autoBackupLocation ?? "",
    );
  }
}

@riverpod
Future<void> checkAndBackup(Ref ref) async {
  ref.keepAlive();
  final settings = settingsRepository.current;
  final backupFrequency = _duration(settings.backupFrequency);
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
  final duration = _duration(value);
  final now = DateTime.now();
  final startDate = duration != null ? now.add(duration) : null;
  settingsRepository.update(
    (s) => s
      ..backupFrequency = value
      ..startDatebackup = startDate?.millisecondsSinceEpoch,
  );
}
