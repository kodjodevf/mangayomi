// HTTP transport for the sync-server's `/api/sync/v1` protocol. See
// docs/sync_api.md in the sync-server repo for the wire contract this
// implements: one combined endpoint, incremental (only what changed since
// `since`), newest-write-wins per row by `updatedAt`, deletions sent as an
// explicit list rather than inferred from what's missing from a response.
//
// Deliberately knows nothing about Isar or Riverpod - it only turns
// (server, token, body) into a decoded JSON response or null, so it can be
// exercised without a database or a widget tree.
import 'dart:convert';

import 'package:http/http.dart' as http;

class SyncApiClient {
  SyncApiClient(this._http);

  final http.Client _http;

  /// The highest protocol version this build speaks. Sent nowhere - the
  /// server advertises what it supports via GET /api/version and this is
  /// just checked against that list.
  static const supportedProtocolVersion = '1';

  Future<bool> checkVersion(String server) async {
    try {
      final response = await _http
          .get(Uri.parse('$server/api/version'))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return false;
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final supported = (body['supported'] as List?)?.cast<String>() ?? [];
      return supported.contains(supportedProtocolVersion);
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> postSync(
    String server,
    String accessToken,
    Map<String, dynamic> body,
  ) async {
    final response = await _http.post(
      Uri.parse('$server/api/sync/v1'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'id=$accessToken',
      },
      body: jsonEncode(body),
    );
    if (response.statusCode != 200) return null;
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Map<String, String?>? decodeCursors(Object? raw) {
    if (raw is! Map) return null;
    return raw.map((key, value) => MapEntry(key as String, value as String?));
  }
}
