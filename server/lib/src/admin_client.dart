// The commands' way into a running server: its admin API, found through
// admin.json in the data directory.
import 'dart:convert';
import 'dart:io';

import 'admin.dart';

class AdminClient {
  AdminClient(this.access);

  final AdminAccess access;
  final _http = HttpClient()..connectionTimeout = const Duration(seconds: 3);

  Future<Object?> get(String path) => _call('GET', path);
  Future<Object?> post(String path) => _call('POST', path);
  Future<Object?> delete(String path) => _call('DELETE', path);

  /// Whether a server answers there.
  Future<bool> reachable() async {
    try {
      await get('/status');
      return true;
    } on IOException {
      return false;
    }
  }

  Future<Object?> _call(String method, String path) async {
    final request = await _http.openUrl(
      method,
      access.base.replace(path: '/api$path'),
    );
    request.headers.set('authorization', 'Bearer ${access.token}');
    final response = await request.close();
    final body = await utf8.decodeStream(response);
    final json = body.isEmpty ? null : jsonDecode(body);
    if (response.statusCode >= 400) {
      throw AdminError(
        response.statusCode,
        json is Map ? '${json['error']}' : body,
      );
    }
    return json;
  }

  void close() => _http.close(force: true);
}

class AdminError implements Exception {
  const AdminError(this.status, this.message);
  final int status;
  final String message;

  @override
  String toString() => message;
}
