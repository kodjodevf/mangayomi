import 'package:archive/archive.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'backup_compression.g.dart';

@riverpod
class BackupCompressionLevel extends _$BackupCompressionLevel {
  @override
  int build() {
    return settingsRepository.current.backupCompressionLevel ??
        DeflateLevel.defaultCompression;
  }

  void update(int value) => state = value;

  Future<void> set(int value) async {
    state = value;
    await settingsRepository.update((s) => s.backupCompressionLevel = value);
  }
}
