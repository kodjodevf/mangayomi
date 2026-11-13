// The server itself: the Rust host takes the connections and checks who is
// connecting, and each request it lets through is answered here, a sync by
// [SyncEngine] over the SQLite store, a pairing once someone accepts it.
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:mangayomi_sync/mangayomi_sync.dart';

import 'database.dart';
import 'log.dart';
import 'native/api/host.dart';

/// A device that sent the right pairing code, waiting to be let in.
class PendingPairing {
  PendingPairing._(this.id, this.deviceName, this.fingerprint, this.address);

  final String id;
  final String deviceName;
  final String fingerprint;
  final String address;
  final _answer = Completer<bool>();

  Map<String, Object?> toJson() => {
    'id': id,
    'deviceName': deviceName,
    'fingerprint': fingerprint,
    'address': address,
  };
}

sealed class ServerEvent {
  const ServerEvent();
}

class PairingRequested extends ServerEvent {
  const PairingRequested(this.pairing);
  final PendingPairing pairing;
}

class DevicePaired extends ServerEvent {
  const DevicePaired(this.device);
  final PairedDevice device;
}

class PairingRefused extends ServerEvent {
  const PairingRefused(this.pairing);
  final PendingPairing pairing;
}

class DeviceSynced extends ServerEvent {
  const DeviceSynced(this.fingerprint, this.at);
  final String fingerprint;
  final int at;
}

class SyncServer {
  SyncServer._(
    this._host,
    this._database,
    this._engine,
    this.identity,
    this._advertise,
    this._log,
    this._clock,
  );

  static const defaultPort = 53319;

  /// How long a pairing code works.
  static const pairingWindow = Duration(minutes: 5);

  /// How long a device waits for an answer, a pairing included.
  static const responseTimeout = Duration(minutes: 2);

  /// Largest request accepted, as on a device that hosts.
  static const maxBodyBytes = 25 * 1024 * 1024;

  final ServerHost _host;
  final ServerDatabase _database;
  final SyncEngine _engine;
  final ServerIdentity identity;
  final List<String> _advertise;
  final Log _log;
  final int Function() _clock;
  final _events = StreamController<ServerEvent>.broadcast();
  final _pending = <String, PendingPairing>{};
  final _stopped = Completer<void>();
  var _nextPairing = 0;
  PairingInvite? _invite;
  DateTime? _inviteExpires;

  /// Starts listening on [address]:[port] (0 for any free port).
  /// [advertise] are addresses devices reach the server at from elsewhere,
  /// such as `https://sync.example.com:53319`, put first in invites.
  /// Devices on public networks are turned away unless
  /// [allowPublicNetworks].
  static Future<SyncServer> start({
    required ServerDatabase database,
    required ServerIdentity identity,
    String address = '0.0.0.0',
    int port = defaultPort,
    List<String> advertise = const [],
    bool allowPublicNetworks = false,
    Log log = const Log.silent(),
    int Function()? clock,
  }) async {
    final now = clock ?? () => DateTime.now().millisecondsSinceEpoch;
    final host = await ServerHost.start(
      options: HostOptions(
        identity: identity,
        address: address,
        port: port,
        paired: [for (final device in database.devices()) device.fingerprint],
        allowPublicNetworks: allowPublicNetworks,
        maxBodyBytes: maxBodyBytes,
        responseTimeoutSeconds: responseTimeout.inSeconds,
      ),
    );
    final server = SyncServer._(
      host,
      database,
      SyncEngine(database.store, clock: now),
      identity,
      advertise,
      log,
      now,
    );
    // Not cancelled: stopping the host ends the stream from the Rust side.
    host.requests().listen(
      server._onRequest,
      onError: (Object error, StackTrace stack) =>
          log.error('Request stream failed', error, stack),
      onDone: server._stopped.complete,
    );
    log.info(
      'Listening on $address:${host.port()} '
      '(fingerprint ${identity.fingerprint})',
    );
    return server;
  }

  int get port => _host.port();

  Stream<ServerEvent> get events => _events.stream;

  List<PendingPairing> get pending => List.unmodifiable(_pending.values);

  /// The invite while pairing is open.
  PairingInvite? get invite {
    final expires = _inviteExpires;
    if (expires != null && DateTime.now().isAfter(expires)) {
      _invite = _inviteExpires = null;
    }
    return _invite;
  }

  DateTime? get inviteExpires => invite == null ? null : _inviteExpires;

  /// Lets one new device pair for [lasting], with the invite to show it. A
  /// new invite replaces the previous one.
  Future<PairingInvite> openPairing({Duration lasting = pairingWindow}) async {
    final code = newPairingCode();
    _host.openPairing(code: code, lastingSeconds: lasting.inSeconds);
    final local = [
      for (final address in await localAddresses()) 'https://$address:$port',
    ];
    _invite = PairingInvite(
      addresses: [
        ..._advertise,
        for (final address in local)
          if (!_advertise.contains(address)) address,
      ],
      fingerprint: identity.fingerprint,
      code: code,
    );
    _inviteExpires = DateTime.now().add(lasting);
    _log.info('Pairing open for ${lasting.inMinutes} min');
    return _invite!;
  }

  void closePairing() {
    _host.closePairing();
    _invite = _inviteExpires = null;
    for (final pairing in _pending.values.toList()) {
      answer(pairing.id, accept: false);
    }
  }

  /// Answers a pending pairing; false when there is none with [id].
  bool answer(String id, {required bool accept}) {
    final pairing = _pending.remove(id);
    if (pairing == null || pairing._answer.isCompleted) return false;
    pairing._answer.complete(accept);
    return true;
  }

  List<PairedDevice> devices() => _database.devices();

  /// Stops [fingerprint] from syncing, on the spot. False when no such
  /// device was paired.
  bool forget(String fingerprint) {
    _host.revokePeer(fingerprint: fingerprint);
    final removed = _database.removeDevice(fingerprint);
    if (removed) _log.info('Forgot device $fingerprint');
    return removed;
  }

  Future<void> stop() async {
    closePairing();
    await _host.stop();
    await _stopped.future;
    await _events.close();
  }

  Future<void> _onRequest(IncomingRequest request) async {
    Answer response;
    try {
      final deviceName = request.pairingDeviceName;
      response = deviceName != null
          ? await _pair(request, deviceName)
          : _sync(request);
    } catch (error, stack) {
      _log.error('Request from ${request.peerAddress} failed', error, stack);
      response = _plain(500);
    }
    // False when the device gave up waiting: nothing left to do.
    _host.respond(id: request.id, answer: response);
  }

  Answer _sync(IncomingRequest request) {
    final fingerprint = request.peerFingerprint;
    // Forgotten by another process, such as `forget` while this one runs:
    // the database is what says who may sync.
    if (!_database.hasDevice(fingerprint)) {
      _host.revokePeer(fingerprint: fingerprint);
      return _plain(403);
    }
    final Object? json;
    try {
      json = jsonDecode(utf8.decode(request.body));
    } on FormatException {
      return _plain(400);
    }
    try {
      final response = _engine.handle(json);
      final at = _clock();
      _database.deviceSynced(fingerprint, at);
      _events.add(DeviceSynced(fingerprint, at));
      _log.fine('Synced ${request.peerAddress} ($fingerprint)');
      return Answer(
        status: 200,
        body: utf8.encode(jsonEncode(response)),
        approvePeer: false,
      );
    } on SyncRequestInvalid catch (invalid) {
      _log.info(
        'Refused a sync from ${request.peerAddress}: ${invalid.message}',
      );
      return Answer(
        status: 400,
        body: utf8.encode(jsonEncode({'error': invalid.message})),
        approvePeer: false,
      );
    }
  }

  Future<Answer> _pair(IncomingRequest request, String deviceName) async {
    final pairing = PendingPairing._(
      '${++_nextPairing}',
      deviceName.trim(),
      request.peerFingerprint,
      request.peerAddress,
    );
    _pending[pairing.id] = pairing;
    _log.info(
      'Pairing request from "${pairing.deviceName}" at ${pairing.address}',
    );
    _events.add(PairingRequested(pairing));

    final accepted = await pairing._answer.future
        // Answered before the device stops waiting, so it hears the refusal.
        .timeout(
          responseTimeout - const Duration(seconds: 5),
          onTimeout: () {
            _pending.remove(pairing.id);
            return false;
          },
        );
    if (!accepted) {
      _log.info('Pairing with "${pairing.deviceName}" refused');
      _events.add(PairingRefused(pairing));
      return _plain(403);
    }
    // Saved before the host lets it in, so a device it lets in is one it
    // still knows after a restart.
    final device = PairedDevice(
      fingerprint: pairing.fingerprint,
      name: pairing.deviceName,
      pairedAt: _clock(),
    );
    _database.addDevice(device);
    // The code was used: no one else pairs with it.
    _host.closePairing();
    _invite = _inviteExpires = null;
    _log.info('Paired "${device.name}" (${device.fingerprint})');
    _events.add(DevicePaired(device));
    return Answer(status: 200, body: _empty, approvePeer: true);
  }

  static final _empty = Uint8List(0);

  static Answer _plain(int status) =>
      Answer(status: status, body: _empty, approvePeer: false);
}
