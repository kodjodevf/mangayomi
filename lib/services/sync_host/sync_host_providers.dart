import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/sync_host/host_row.dart';
import 'package:mangayomi/services/sync_host/isar_sync_store.dart';
import 'package:mangayomi_sync/mangayomi_sync.dart';

/// What the host stores, in a database of its own next to the library's:
/// the host device syncs its library with it like any other device.
final syncHostEngineProvider = FutureProvider<SyncEngine>((ref) async {
  ref.keepAlive();
  final dir = await StorageProvider().getDatabaseDirectory();
  final db = await Isar.open(
    [HostRowSchema],
    directory: dir!.path,
    name: 'mangayomiSyncHost',
    inspector: false,
  );
  ref.onDispose(db.close);
  return SyncEngine(IsarSyncStore(db));
});
