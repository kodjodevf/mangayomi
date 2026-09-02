import 'dart:async';

import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';

class SettingsRepository {
  Settings get current => isar.settings.getSync(227)!;

  Settings? get currentOrNull => isar.settings.getSync(227);

  Future<Settings?> get currentAsync => isar.settings.get(227);

  List<Settings> getAll() => isar.settings.filter().idIsNotNull().findAllSync();

  Stream<Settings> watch() => isar.settings
      .where()
      .idEqualTo(227)
      .watch(fireImmediately: true)
      .map((l) => l.first);

  Future<void> update(void Function(Settings s) mutate) => dbWriteQueue.run(() {
    isar.writeTxnSync(() {
      // A damaged/partially-created database must not turn every settings
      // control into a null-check crash. Recreate the singleton row with its
      // model defaults and apply the requested change in the same transaction.
      final s = currentOrNull ?? Settings();
      mutate(s);
      s.updatedAt = DateTime.now().millisecondsSinceEpoch;
      isar.settings.putSync(s);
    });
  });

  // For callers that already hold the Settings instance to mutate (e.g. a family
  // provider's cached param) rather than wanting a freshly-fetched one.
  Future<void> save(Settings s) => dbWriteQueue.run(() {
    isar.writeTxnSync(() {
      s.updatedAt = DateTime.now().millisecondsSinceEpoch;
      isar.settings.putSync(s);
    });
  });

  // Sync primitive below is for callers already inside a write transaction
  // opened by transaction()/writeTransaction() — it doesn't queue on its own.
  void putSync(Settings s) => isar.settings.putSync(s);

  Future<int> putAsync(Settings s) => isar.settings.put(s);

  void putAllSync(List<Settings> settingsList) =>
      isar.settings.putAllSync(settingsList);

  void clearSync() => isar.settings.clearSync();

  // Escape hatch for Settings-rooted transactions too specific to name
  // (e.g. first-run seeding).
  Future<T> transaction<T>(FutureOr<T> Function() body) =>
      dbWriteQueue.run(body);

  // Same, but opens the write transaction too, so callers never touch isar.
  Future<T> writeTransaction<T>(T Function() body) =>
      dbWriteQueue.run(() => isar.writeTxnSync(body));

  Future<T> writeTransactionAsync<T>(Future<T> Function() body) =>
      dbWriteQueue.run(() => isar.writeTxn(body));
}

final settingsRepository = SettingsRepository();
