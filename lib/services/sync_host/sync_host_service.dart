// This device as a sync host: the Rust side takes the connections, checks
// who is connecting and the pairing code, and hands each request here, where
// [SyncEngine] answers it. Devices sync with it as they would with the
// sync server.
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:mangayomi_sync/mangayomi_sync.dart';
import 'package:mangayomi/services/sync_host/sync_secrets.dart';
import 'package:mangayomi/src/rust/api/sync_host.dart';
import 'package:mangayomi/utils/error_toast.dart';

/// A device that sent the right pairing code, waiting for the user to let
/// it in.
class PairingRequest {
  const PairingRequest({
    required this.deviceName,
    required this.fingerprint,
    required this.address,
  });

  final String deviceName;
  final String fingerprint;
  final String address;
}

class SyncHostService {
  SyncHostService._(
    this._host,
    this._engine,
    this._secrets,
    this._approve,
    this.identity, {
    this.onPaired,
    this.onSynced,
  });

  /// The port tried first, unless the host listened on another before.
  static const defaultPort = 53319;

  /// How long a pairing code works.
  static const pairingWindow = Duration(minutes: 5);

  /// How long a device waits for an answer: for a pairing, the user has
  /// to accept it on the host in that time.
  static const responseTimeout = Duration(minutes: 2);

  /// Largest request accepted, as on the sync server.
  static const maxBodyBytes = 25 * 1024 * 1024;

  final SyncHost _host;
  final SyncEngine _engine;
  final SyncSecrets _secrets;
  final Future<bool> Function(PairingRequest request) _approve;
  final SyncIdentity identity;

  /// Called once a device is paired and saved.
  final void Function(PairedDevice device)? onPaired;

  /// Called after a device's sync request was applied.
  final void Function()? onSynced;
  final _stopped = Completer<void>();

  /// Starts listening on every network of this device. [approve] decides
  /// whether a device that sent the right pairing code may sync from now on.
  static Future<SyncHostService> start({
    required SyncEngine engine,
    required SyncSecrets secrets,
    required Future<bool> Function(PairingRequest request) approve,
    void Function(PairedDevice device)? onPaired,
    void Function()? onSynced,
    bool allowPublicNetworks = false,
  }) async {
    final identity = await secrets.identity();
    final paired = [
      for (final device in await secrets.pairedDevices()) device.fingerprint,
    ];
    final preferred = await secrets.hostPort() ?? defaultPort;

    Future<SyncHost> listen(int port) => SyncHost.start(
      config: SyncHostConfig(
        identity: identity,
        address: '0.0.0.0',
        port: port,
        paired: paired,
        allowPublicNetworks: allowPublicNetworks,
        maxBodyBytes: maxBodyBytes,
        responseTimeoutSeconds: responseTimeout.inSeconds,
      ),
    );

    SyncHost host;
    try {
      host = await listen(preferred);
    } catch (error, stack) {
      // Taken by something else: any free port will do, though devices
      // paired before will not find the host there until they pair again.
      recordError(error, stack: stack, source: 'sync_host');
      host = await listen(0);
    }
    if (host.port() != preferred) await secrets.saveHostPort(host.port());

    final service = SyncHostService._(
      host,
      engine,
      secrets,
      approve,
      identity,
      onPaired: onPaired,
      onSynced: onSynced,
    );
    // Not cancelled: stopping the host ends the stream from the Rust side,
    // and cancelling it from here first would wait on that end for good.
    host.requests().listen(
      service._onRequest,
      onError: (Object error, StackTrace stack) =>
          recordError(error, stack: stack, source: 'sync_host'),
      onDone: service._stopped.complete,
    );
    return service;
  }

  int get port => _host.port();

  /// Lets one new device pair for [pairingWindow], with the invite to show
  /// it. A new invite replaces the previous one.
  Future<PairingInvite> openPairing() async {
    final code = newPairingCode();
    _host.openPairing(code: code, lastingSeconds: pairingWindow.inSeconds);
    return PairingInvite(
      addresses: [
        for (final address in await localAddresses()) 'https://$address:$port',
      ],
      fingerprint: identity.fingerprint,
      code: code,
    );
  }

  void closePairing() => _host.closePairing();

  /// Stops [fingerprint] from syncing, on the spot.
  Future<void> forget(String fingerprint) async {
    _host.revokePeer(fingerprint: fingerprint);
    await _secrets.removePairedDevice(fingerprint);
  }

  Future<void> stop() async {
    await _host.stop();
    await _stopped.future;
  }

  Future<void> _onRequest(SyncHostRequest request) async {
    SyncHostResponse response;
    try {
      response = switch (request.kind) {
        SyncHostRequestKind_Sync() => _sync(request.body),
        SyncHostRequestKind_Pair(:final deviceName) => await _pair(
          request,
          deviceName,
        ),
      };
    } catch (error, stack) {
      recordError(error, stack: stack, source: 'sync_host');
      response = _plain(500);
    }
    // False when the device gave up waiting: nothing left to do.
    _host.respond(id: request.id, response: response);
  }

  SyncHostResponse _sync(Uint8List body) {
    final Object? json;
    try {
      json = jsonDecode(utf8.decode(body));
    } on FormatException {
      return _plain(400);
    }
    try {
      final response = _engine.handle(json);
      onSynced?.call();
      return SyncHostResponse(
        status: 200,
        body: utf8.encode(jsonEncode(response)),
        approvePeer: false,
      );
    } on SyncRequestInvalid catch (invalid) {
      return SyncHostResponse(
        status: 400,
        body: utf8.encode(jsonEncode({'error': invalid.message})),
        approvePeer: false,
      );
    }
  }

  Future<SyncHostResponse> _pair(
    SyncHostRequest request,
    String deviceName,
  ) async {
    final accepted = await _approve(
      PairingRequest(
        deviceName: deviceName,
        fingerprint: request.peerFingerprint,
        address: request.peerAddress,
      ),
    );
    if (!accepted) return _plain(403);
    // Saved before the host lets it in, so a device it lets in is one it
    // still knows after a restart.
    final device = PairedDevice(
      fingerprint: request.peerFingerprint,
      name: deviceName,
      pairedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await _secrets.addPairedDevice(device);
    onPaired?.call(device);
    return SyncHostResponse(status: 200, body: Uint8List(0), approvePeer: true);
  }

  static SyncHostResponse _plain(int status) =>
      SyncHostResponse(status: status, body: Uint8List(0), approvePeer: false);
}
