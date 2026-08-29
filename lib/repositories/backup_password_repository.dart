import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/backup_password_fallback.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';

class BackupPasswordRepository {
  Future<BackupPasswordFallback?> findPlaintextFallback() =>
      isar.backupPasswordFallbacks.filter().idEqualTo(0).findFirst();

  Future<void> savePlaintextFallback(String password) => dbWriteQueue.run(
    () => isar.writeTxn(() async {
      await isar.backupPasswordFallbacks.put(
        BackupPasswordFallback()..password = password,
      );
    }),
  );

  Future<void> clearPlaintextFallback() => dbWriteQueue.run(
    () => isar.writeTxn(() async {
      await isar.backupPasswordFallbacks.delete(0);
    }),
  );
}

final backupPasswordRepository = BackupPasswordRepository();
