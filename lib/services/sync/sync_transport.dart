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

  /// The decoded response. Throws [SyncRefused] when the other end refused
  /// the request, and what reaching it threw when it could not be reached.
  Future<Map<String, dynamic>> postSync(Map<String, dynamic> body);
}

/// The other end answered a sync request with a refusal.
class SyncRefused implements Exception {
  SyncRefused(this.status, [this.reason]);

  /// [status], with the reason the other end gave in [body], if any.
  factory SyncRefused.fromBody(int status, List<int> body) {
    String? reason;
    try {
      final json = jsonDecode(utf8.decode(body));
      if (json is Map && json['error'] is String) reason = json['error'];
    } on FormatException {
      // No JSON: a refusal without a reason, such as an unpaired device's.
    }
    return SyncRefused(status, reason);
  }

  final int status;

  /// What the other end found wrong, such as `manga[39].link`: the row of
  /// the request, by its place, and its field.
  final String? reason;

  /// Whether the other end refused the request itself, not this device.
  bool get invalidRequest => status == 400;

  /// [reason] told with the row it names: `"Title" (link)` for
  /// `manga[39].link`, when [body] holds that manga.
  String describe(Map<String, dynamic> body) {
    final reason = this.reason;
    if (reason == null) return 'HTTP $status';
    final match = RegExp(r'^(\w+)\[(\d+)\]\.(\w+)$').firstMatch(reason);
    if (match == null) return reason;
    final rows = body[match[1]];
    final index = int.parse(match[2]!);
    if (rows is! List || index >= rows.length) return reason;
    final row = rows[index];
    final name = row is Map
        ? (row['name'] ?? row['title'] ?? row['chapterName'])
        : null;
    return name is String && name.isNotEmpty ? '"$name" (${match[3]})' : reason;
  }

  @override
  String toString() =>
      'SyncRefused: HTTP $status${reason == null ? '' : ', $reason'}';
}

class HttpSyncTransport implements SyncTransport {
  HttpSyncTransport(this._client, this.server, this.accessToken);

  final SyncApiClient _client;
  final String server;
  final String accessToken;

  @override
  Future<bool> checkVersion() => _client.checkVersion(server);

  @override
  Future<Map<String, dynamic>> postSync(Map<String, dynamic> body) =>
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
  Future<Map<String, dynamic>> postSync(Map<String, dynamic> body) async {
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
      if (response.status != 200) {
        throw SyncRefused.fromBody(response.status, response.body);
      }
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
  Future<Map<String, dynamic>> postSync(Map<String, dynamic> body) async {
    // Through JSON, as over the network: the request is then exactly what
    // a device would send, and the response nothing the host still holds.
    final request = jsonDecode(jsonEncode(body));
    try {
      return jsonDecode(jsonEncode(_engine.handle(request)))
          as Map<String, dynamic>;
    } on SyncRequestInvalid catch (invalid, stack) {
      // As the host answers another device.
      Error.throwWithStackTrace(SyncRefused(400, invalid.message), stack);
    }
  }
}
