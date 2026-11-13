import 'dart:io';

import 'package:mangayomi_sync/mangayomi_sync.dart';
import 'package:mangayomi_sync/testing.dart';
import 'package:mangayomi_sync_server/src/database.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';

void main() {
  group('SQLite store', () {
    late ServerDatabase database;
    syncStoreSuite(
      test: test,
      setUp: setUp,
      tearDown: tearDown,
      openStore: () => (database = ServerDatabase.open(':memory:')).store,
      closeStore: (_) => database.close(),
    );
  });

  test('devices are kept, renamed on re-pairing, and removed', () {
    final db = ServerDatabase.open(':memory:');
    addTearDown(db.close);
    db.addDevice(
      const PairedDevice(fingerprint: 'A', name: 'Phone', pairedAt: 1),
    );
    db.addDevice(
      const PairedDevice(fingerprint: 'B', name: 'Tab', pairedAt: 2),
    );
    db.addDevice(
      const PairedDevice(fingerprint: 'A', name: 'Pixel', pairedAt: 3),
    );
    db.deviceSynced('B', 9);
    expect(
      [for (final d in db.devices()) (d.name, d.lastSyncAt)],
      [('Tab', 9), ('Pixel', null)],
    );
    expect(db.removeDevice('A'), isTrue);
    expect(db.removeDevice('A'), isFalse);
    expect(db.devices().single.fingerprint, 'B');
  });

  test('a backup is a working copy, taken while open', () {
    final dir = Directory.systemTemp.createTempSync('mangayomi-server-');
    addTearDown(() => dir.deleteSync(recursive: true));
    final db = ServerDatabase.open('${dir.path}/sync.db');
    final engine = SyncEngine(db.store);
    engine.handle({
      'categories': [
        {'clientId': 1, 'name': 'Read', 'forItemType': 'MANGA', 'updatedAt': 1},
      ],
    });
    db.backupTo('${dir.path}/backup.db');
    db.close();

    final copy = ServerDatabase.open('${dir.path}/backup.db');
    addTearDown(copy.close);
    final pulled = SyncEngine(copy.store).handle({'since': 0});
    expect((pulled['categories'] as List).single['name'], 'Read');
    expect(copy.counts(), (rows: 1, tombstones: 0));
  });

  test('a database from a newer server is not opened', () {
    final dir = Directory.systemTemp.createTempSync('mangayomi-server-');
    addTearDown(() => dir.deleteSync(recursive: true));
    final path = '${dir.path}/sync.db';
    ServerDatabase.open(path).close();
    // Bump the version as a newer server would.
    final raw = sqlite3.open(path)..execute('PRAGMA user_version = 99');
    raw.close();
    expect(() => ServerDatabase.open(path), throwsStateError);
  });
}
