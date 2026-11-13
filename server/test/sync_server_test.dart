import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mangayomi_sync_server/src/database.dart';
import 'package:mangayomi_sync_server/src/native/api/host.dart';
import 'package:mangayomi_sync_server/src/native_library.dart';
import 'package:mangayomi_sync_server/src/sync_server.dart';
import 'package:test/test.dart';

import 'support/peer.dart';

/// The status, or -1 when the server would not even complete the handshake.
Future<int> statusOrRefused(Future<(int, String)> request) async {
  try {
    return (await request).$1;
  } on IOException {
    return -1;
  }
}

void main() {
  late ServerDatabase database;
  late SyncServer server;
  final peers = <TestPeer>[];

  setUpAll(() => loadNativeLibrary(packageRoot: Directory.current.path));

  setUp(() async {
    database = ServerDatabase.open(':memory:');
    server = await SyncServer.start(
      database: database,
      identity: await generateIdentity(),
      address: '127.0.0.1',
      port: 0,
    );
  });

  tearDown(() async {
    for (final peer in peers) {
      peer.close();
    }
    peers.clear();
    await server.stop();
    database.close();
  });

  Future<PairingRequested> requested() async =>
      await server.events.firstWhere((e) => e is PairingRequested)
          as PairingRequested;

  Future<TestPeer> peer() async {
    final peer = await TestPeer.create(
      server.port,
      server.identity.fingerprint,
    );
    peers.add(peer);
    return peer;
  }

  /// Pairs a new device, accepting it as soon as it asks.
  Future<TestPeer> paired(String name) async {
    final invite = await server.openPairing();
    final device = await peer();
    final accepted = requested().then(
      (event) => server.answer(event.pairing.id, accept: true),
    );
    final (status, _) = await device.pair(invite.code, name);
    expect(status, 200);
    expect(await accepted, isTrue);
    return device;
  }

  Map<String, Object?> category(int id, String name, int updatedAt) => {
    'clientId': id,
    'name': name,
    'forItemType': 'MANGA',
    'updatedAt': updatedAt,
  };

  test('a device that is not paired cannot sync', () async {
    final stranger = await peer();
    await expectLater(stranger.sync({'since': 0}), throwsA(anything));
  });

  test('a paired device syncs, and another sees its changes', () async {
    final phone = await paired('Phone');
    final tablet = await paired('Tablet');
    expect([for (final d in server.devices()) d.name], ['Phone', 'Tablet']);

    final (status, _) = await phone.sync({
      'categories': [category(1, 'Reading', 10)],
    });
    expect(status, 200);

    final (_, body) = await tablet.sync({'since': 0});
    final response = jsonDecode(body) as Map<String, dynamic>;
    expect((response['categories'] as List).single['name'], 'Reading');
    expect(database.devices().first.lastSyncAt, isNotNull);
  });

  test('a refused pairing leaves the device out', () async {
    final invite = await server.openPairing();
    final device = await peer();
    unawaited(
      requested().then(
        (event) => server.answer(event.pairing.id, accept: false),
      ),
    );
    final (status, _) = await device.pair(invite.code, 'Unknown');
    expect(status, 403);
    expect(server.devices(), isEmpty);
  });

  test('a wrong code does not pair', () async {
    await server.openPairing();
    final device = await peer();
    final (status, _) = await device.pair('AAAA-AAAA-AAAA', 'Guess');
    expect(status, 401);
    expect(server.pending, isEmpty);
  });

  test('a code pairs one device only', () async {
    final invite = await server.openPairing();
    final first = await peer();
    unawaited(
      requested().then(
        (event) => server.answer(event.pairing.id, accept: true),
      ),
    );
    expect((await first.pair(invite.code, 'First')).$1, 200);
    final second = await peer();
    // Turned away at the handshake or with a status: either way, out.
    expect(
      await statusOrRefused(second.pair(invite.code, 'Second')),
      isNot(200),
    );
    expect(server.devices().single.name, 'First');
  });

  test('a forgotten device is cut off at once', () async {
    final phone = await paired('Phone');
    expect((await phone.sync({'since': 0})).$1, 200);
    expect(server.forget(phone.identity.fingerprint), isTrue);
    expect(await statusOrRefused(phone.sync({'since': 0})), anyOf(403, -1));
  });

  test(
    'a device removed from the database by another process is refused',
    () async {
      final phone = await paired('Phone');
      database.removeDevice(phone.identity.fingerprint);
      expect((await phone.sync({'since': 0})).$1, 403);
    },
  );

  test('an invalid request is refused with the reason', () async {
    final phone = await paired('Phone');
    final (status, body) = await phone.sync({
      'categories': [category(0, 'Bad', 1)],
    });
    expect(status, 400);
    expect(jsonDecode(body)['error'], isA<String>());
  });

  test('devices paired before a restart still sync', () async {
    final dir = Directory.systemTemp.createTempSync('mangayomi-server-');
    addTearDown(() => dir.deleteSync(recursive: true));
    await server.stop();
    database.close();

    final identity = await generateIdentity();
    database = ServerDatabase.open('${dir.path}/sync.db');
    server = await SyncServer.start(
      database: database,
      identity: identity,
      address: '127.0.0.1',
      port: 0,
    );
    final phone = await paired('Phone');
    await server.stop();
    database.close();

    database = ServerDatabase.open('${dir.path}/sync.db');
    server = await SyncServer.start(
      database: database,
      identity: identity,
      address: '127.0.0.1',
      port: 0,
    );
    final again = TestPeer(phone.identity, server.port, identity.fingerprint);
    peers.add(again);
    expect((await again.sync({'since': 0})).$1, 200);
  });
}
