import 'dart:io';

import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/services/sync/sync_transport.dart';
import 'package:mangayomi/services/sync_host/host_row.dart';
import 'package:mangayomi/services/sync_host/isar_sync_store.dart';
import 'package:mangayomi_sync/mangayomi_sync.dart';
import 'package:mangayomi/services/sync_host/peer_pairing.dart';
import 'package:mangayomi/services/sync_host/sync_host_service.dart';
import 'package:mangayomi/services/sync_host/sync_secrets.dart';
import 'package:mangayomi/src/rust/api/sync_host.dart';
import 'package:mangayomi/src/rust/frb_generated.dart';

class _MemoryStore implements SecretStore {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;

  @override
  Future<void> delete(String key) async => values.remove(key);
}

/// The host service and a device, through the real bridge and TLS: the
/// device pairs from an invite, then syncs, and stops being able to once
/// the host forgets it.
///
/// Needs the crate built for this machine first (`cargo build --lib` in
/// rust/); skipped when it is not.
void main() {
  final library = File(switch (Platform.operatingSystem) {
    'macos' => 'rust/target/debug/librust_lib_mangayomi.dylib',
    'linux' => 'rust/target/debug/librust_lib_mangayomi.so',
    _ => 'rust/target/debug/rust_lib_mangayomi.dll',
  });
  final skip = library.existsSync()
      ? null
      : 'Build the Rust crate first: cargo build --lib in rust/';

  late Directory dir;
  late Isar db;

  setUpAll(() async {
    if (skip != null) return;
    await RustLib.init(
      externalLibrary: ExternalLibrary.open(library.absolute.path),
    );
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('mangayomi-sync-service-');
    db = await Isar.open([HostRowSchema], directory: dir.path, name: 'host');
  });

  tearDown(() async {
    await db.close(deleteFromDisk: true);
    await dir.delete(recursive: true);
  });

  Future<(SyncHostService, SyncSecrets)> startHost(
    Future<bool> Function(PairingRequest) approve,
  ) async {
    // Port 0: any free one, never the real default.
    final secrets = SyncSecrets(_MemoryStore()..values['sync_host_port'] = '0');
    final service = await SyncHostService.start(
      engine: SyncEngine(IsarSyncStore(db)),
      secrets: secrets,
      approve: approve,
    );
    return (service, secrets);
  }

  PairingInvite onLoopback(SyncHostService host, PairingInvite invite) =>
      PairingInvite(
        addresses: ['https://127.0.0.1:${host.port}'],
        fingerprint: invite.fingerprint,
        code: invite.code,
      );

  test('a device pairs from the invite, syncs, then is forgotten', () async {
    PairingRequest? asked;
    final (host, hostSecrets) = await startHost((request) async {
      asked = request;
      return true;
    });
    addTearDown(host.stop);

    final deviceSecrets = SyncSecrets(_MemoryStore());
    final invite = onLoopback(host, await host.openPairing());
    expect(invite.fingerprint, host.identity.fingerprint);

    final paired = await pairWithHost(
      invite,
      secrets: deviceSecrets,
      deviceName: 'Test phone',
    );
    expect(paired.outcome, PeerPairingOutcome.paired);
    expect(paired.server, invite.addresses.single);

    final deviceIdentity = await deviceSecrets.identity();
    expect(asked?.deviceName, 'Test phone');
    expect(asked?.fingerprint, deviceIdentity.fingerprint);
    expect(
      [for (final d in await hostSecrets.pairedDevices()) d.fingerprint],
      [deviceIdentity.fingerprint],
    );

    final transport = PeerSyncTransport(
      SyncPeerClient(
        identity: deviceIdentity,
        baseUrl: paired.server!,
        hostFingerprint: invite.fingerprint,
        timeoutSeconds: 10,
      ),
    );
    await transport.postSync({
      'since': 0,
      'manga': [
        {
          'clientId': 1,
          'source': 'Demo',
          'link': '/t',
          'itemType': 'MANGA',
          'name': 'Title',
          'updatedAt': 1,
        },
      ],
    });
    // The host device itself, syncing with its own host.
    final local = await LocalSyncTransport(SyncEngine(IsarSyncStore(db)))
        .postSync({});
    expect((local!['manga'] as List).single['name'], 'Title');

    // An invalid request is refused, not a crash of the host.
    expect(await transport.postSync({'manga': 'x'}), isNull);

    // Refused at once, on the connection already open as on a new one.
    await host.forget(deviceIdentity.fingerprint);
    expect(await transport.postSync({}), isNull);
    await expectLater(
      PeerSyncTransport(
        SyncPeerClient(
          identity: deviceIdentity,
          baseUrl: paired.server!,
          hostFingerprint: invite.fingerprint,
          timeoutSeconds: 10,
        ),
      ).postSync({}),
      throwsA(anything),
    );
    expect(await hostSecrets.pairedDevices(), isEmpty);
  }, skip: skip);

  test('a device the host user turns down is not let in', () async {
    final (host, hostSecrets) = await startHost((_) async => false);
    addTearDown(host.stop);
    final invite = onLoopback(host, await host.openPairing());

    final result = await pairWithHost(
      invite,
      secrets: SyncSecrets(_MemoryStore()),
      deviceName: 'Stranger',
    );
    expect(result.outcome, PeerPairingOutcome.refused);
    expect(await hostSecrets.pairedDevices(), isEmpty);
  }, skip: skip);

  test('a wrong code, or a host that is not the invited one', () async {
    final (host, _) = await startHost((_) async => true);
    addTearDown(host.stop);
    final invite = onLoopback(host, await host.openPairing());
    final device = SyncSecrets(_MemoryStore());

    final wrongCode = await pairWithHost(
      PairingInvite(
        addresses: invite.addresses,
        fingerprint: invite.fingerprint,
        code: 'WRONG-CODE',
      ),
      secrets: device,
      deviceName: 'Phone',
    );
    expect(wrongCode.outcome, PeerPairingOutcome.wrongCode);

    final impostor = await pairWithHost(
      PairingInvite(
        addresses: invite.addresses,
        fingerprint: 'AB' * 32,
        code: invite.code,
      ),
      secrets: device,
      deviceName: 'Phone',
    );
    expect(impostor.outcome, PeerPairingOutcome.unreachable);

    // The code was never sent to the wrong host, so it still works.
    final paired = await pairWithHost(
      invite,
      secrets: device,
      deviceName: 'Phone',
    );
    expect(paired.outcome, PeerPairingOutcome.paired);
  }, skip: skip);

  test('a host restarted keeps its identity and its paired devices', () async {
    final store = _MemoryStore()..values['sync_host_port'] = '0';
    final secrets = SyncSecrets(store);
    final first = await SyncHostService.start(
      engine: SyncEngine(IsarSyncStore(db)),
      secrets: secrets,
      approve: (_) async => true,
    );
    final invite = onLoopback(first, await first.openPairing());
    final device = SyncSecrets(_MemoryStore());
    await pairWithHost(invite, secrets: device, deviceName: 'Phone');
    await first.stop();

    final second = await SyncHostService.start(
      engine: SyncEngine(IsarSyncStore(db)),
      secrets: secrets,
      approve: (_) async => false,
    );
    addTearDown(second.stop);
    expect(second.identity.fingerprint, first.identity.fingerprint);

    final response = await PeerSyncTransport(
      SyncPeerClient(
        identity: await device.identity(),
        baseUrl: 'https://127.0.0.1:${second.port}',
        hostFingerprint: second.identity.fingerprint,
        timeoutSeconds: 10,
      ),
    ).postSync({});
    expect(response?['hasMore'], isFalse);
  }, skip: skip);
}
