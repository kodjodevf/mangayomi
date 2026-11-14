// How a sync request reaches what this device syncs with: the sync server
// over HTTP, a host on another device over mutual TLS, or the host running
// on this very device. Each speaks the same `/api/sync/v1` protocol, so the
// sync itself does not care which.
import 'dart:convert';

import 'package:mangayomi/services/sync/sync_api_client.dart';
import 'package:mangayomi_sync/mangayomi_sync.dart';
import 'package:mangayomi/src/rust/api/sync_host.dart';

abstract interface class SyncTransport {
  /// Whether the other end speaks this build's protocol.
  Future<bool> checkVersion();

  /// The decoded response, or null when the other end refused the request.
  /// Throws when it could not be reached.
  Future<Map<String, dynamic>?> postSync(Map<String, dynamic> body);
}

class HttpSyncTransport implements SyncTransport {
  HttpSyncTransport(this._client, this.server, this.accessToken);

  final SyncApiClient _client;
  final String server;
  final String accessToken;

  @override
  Future<bool> checkVersion() => _client.checkVersion(server);

  @override
  Future<Map<String, dynamic>?> postSync(Map<String, dynamic> body) =>
      _client.postSync(server, accessToken, body);
}

/// A host on another device or a sync server it was paired with, which
/// only answers devices paired with it, reached at the first of its
/// addresses that answers.
class PeerSyncTransport implements SyncTransport {
  /// The host at one address.
  PeerSyncTransport(SyncPeerClient client) : this.trying([''], (_) => client);

  /// The host at [addresses], tried in order, starting each request with
  /// the one that answered last. [onReached] hears of an address that
  /// answered when the one before it did not.
  PeerSyncTransport.trying(this._addresses, this._connect, {this.onReached})
    : assert(_addresses.isNotEmpty);

  final List<String> _addresses;
  final SyncPeerClient Function(String address) _connect;
  final void Function(String address)? onReached;
  final _clients = <String, SyncPeerClient>{};
  var _current = 0;

  /// Host and device are both this app, and the host has no version route:
  /// a mismatch shows as a refused request.
  @override
  Future<bool> checkVersion() async => true;

  @override
  Future<Map<String, dynamic>?> postSync(Map<String, dynamic> body) async {
    final bytes = utf8.encode(jsonEncode(body));
    Object? failure;
    StackTrace? failureStack;
    for (var tried = 0; tried < _addresses.length; tried++) {
      final index = (_current + tried) % _addresses.length;
      final address = _addresses[index];
      final SyncPeerResponse response;
      try {
        response = await (_clients[address] ??= _connect(
          address,
        )).sendSync(body: bytes);
      } catch (error, stack) {
        // Not reachable there, from here: the next address may be. Only
        // the last failure is thrown when none answers. Sending again is
        // safe: the host keeps a row only when newer than its own.
        failure = error;
        failureStack = stack;
        continue;
      }
      if (index != _current) {
        _current = index;
        onReached?.call(address);
      }
      if (response.status != 200) return null;
      return jsonDecode(utf8.decode(response.body)) as Map<String, dynamic>;
    }
    Error.throwWithStackTrace(failure!, failureStack!);
  }
}

/// The host running on this device, called directly.
class LocalSyncTransport implements SyncTransport {
  LocalSyncTransport(this._engine);

  final SyncEngine _engine;

  @override
  Future<bool> checkVersion() async => true;

  @override
  Future<Map<String, dynamic>?> postSync(Map<String, dynamic> body) async {
    // Through JSON, as over the network: the request is then exactly what
    // a device would send, and the response nothing the host still holds.
    final request = jsonDecode(jsonEncode(body));
    return jsonDecode(jsonEncode(_engine.handle(request)))
        as Map<String, dynamic>;
  }
}
