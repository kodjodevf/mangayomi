import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'backup_encryption.g.dart';

@riverpod
class BackupEncryptionEnabled extends _$BackupEncryptionEnabled {
  @override
  bool build() {
    return isar.settings.getSync(227)?.backupEncryptionEnabled ?? false;
  }

  Future<void> set(bool value) async {
    state = value;
    final settings = isar.settings.getSync(227);
    if (settings == null) return;

    settings.backupEncryptionEnabled = value;

    await isar.writeTxn(() async {
      await isar.settings.put(settings);
    });
  }
}
