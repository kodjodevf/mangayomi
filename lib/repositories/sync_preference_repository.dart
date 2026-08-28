import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';

class SyncPreferenceRepository {
  SyncPreference? getById(int id) => isar.syncPreferences.getSync(id);

  Stream<List<SyncPreference>> watchAllWithSyncId() => isar.syncPreferences
      .filter()
      .syncIdIsNotNull()
      .watch(fireImmediately: true);

  // No updatedAt stamping - SyncPreference is local-only (never synced
  // itself), so it has no such field.
  Future<void> save(SyncPreference preference) => dbWriteQueue.run(
    () => isar.writeTxnSync(() => isar.syncPreferences.putSync(preference)),
  );
}

final syncPreferenceRepository = SyncPreferenceRepository();
