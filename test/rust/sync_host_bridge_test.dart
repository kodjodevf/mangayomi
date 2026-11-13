import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/src/rust/api/sync_host.dart';
import 'package:mangayomi/src/rust/frb_generated.dart';

/// The sync host and its client through the real bridge: pairing, then a
/// sync, between two identities on this machine.
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

  setUpAll(() async {
    if (skip != null) return;
    await RustLib.init(
      externalLibrary: ExternalLibrary.open(library.absolute.path),
    );
  });

  test('a device pairs with the host, then syncs', () async {
    final hostIdentity = await syncGenerateIdentity();
    final deviceIdentity = await syncGenerateIdentity();
    expect(
      syncFingerprintOfCertificate(certificatePem: hostIdentity.certificatePem),
      hostIdentity.fingerprint,
    );

    final host = await SyncHost.start(
      config: SyncHostConfig(
        identity: hostIdentity,
        address: '127.0.0.1',
        port: 0,
        paired: const [],
        allowPublicNetworks: false,
        maxBodyBytes: 1 << 20,
        responseTimeoutSeconds: 10,
      ),
    );
    final seen = <SyncHostRequest>[];
    final ended = Completer<void>();
    host.requests().listen(onDone: ended.complete, (request) {
      seen.add(request);
      final body = switch (request.kind) {
        SyncHostRequestKind_Sync() => request.body,
        SyncHostRequestKind_Pair() => utf8.encode('{}'),
      };
      host.respond(
        id: request.id,
        response: SyncHostResponse(status: 200, body: body, approvePeer: true),
      );
    });

    try {
      final client = SyncPeerClient(
        identity: deviceIdentity,
        baseUrl: 'https://127.0.0.1:${host.port()}',
        hostFingerprint: hostIdentity.fingerprint,
        timeoutSeconds: 10,
      );

      // Not paired, and no window open: turned away at the handshake.
      await expectLater(
        client.sendSync(body: utf8.encode('{}')),
        throwsA(anything),
      );

      host.openPairing(code: 'K7Q2-M9XD-4TPA', lastingSeconds: 60);
      final paired = await client.pair(
        code: 'K7Q2-M9XD-4TPA',
        deviceName: 'Test phone',
      );
      expect(paired.status, 200);
      expect(host.pairedPeers(), contains(deviceIdentity.fingerprint));

      final synced = await client.sendSync(body: utf8.encode('{"since":0}'));
      expect(synced.status, 200);
      expect(utf8.decode(synced.body), '{"since":0}');

      expect(seen, hasLength(2));
      expect(
        seen.first.kind,
        const SyncHostRequestKind.pair(deviceName: 'Test phone'),
      );
      expect(seen.last.peerFingerprint, deviceIdentity.fingerprint);
    } finally {
      await host.stop();
      // Stopping ends the stream of requests.
      await ended.future.timeout(const Duration(seconds: 5));
    }
  }, skip: skip);
}
