import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/services/sync_host/host_row.dart';
import 'package:mangayomi/services/sync_host/isar_sync_store.dart';
import 'package:mangayomi_sync/testing.dart';

void main() {
  late Directory dir;
  late Isar db;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  syncStoreSuite(
    test: test,
    setUp: setUp,
    tearDown: tearDown,
    openStore: () async {
      dir = await Directory.systemTemp.createTemp('mangayomi-sync-store-');
      db = await Isar.open([HostRowSchema], directory: dir.path, name: 'host');
      return IsarSyncStore(db);
    },
    closeStore: (_) async {
      await db.close(deleteFromDisk: true);
      await dir.delete(recursive: true);
    },
  );
}
