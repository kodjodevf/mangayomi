import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'backup_encryption.g.dart';

@riverpod
class BackupEncryptionEnabled extends _$BackupEncryptionEnabled {
  @override
  bool build() {
    return settingsRepository.current.backupEncryptionEnabled ?? false;
  }

  Future<void> set(bool value) async {
    state = value;
    await settingsRepository.update((s) => s.backupEncryptionEnabled = value);
  }
}
