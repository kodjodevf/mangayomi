// The server's admin API and page, for the user running it: open pairing,
// accept a device, see and forget devices. Only on this machine's loopback,
// only with the token in admin.json (readable by that user alone), and only
// under a Host it expects, so a web page cannot reach it through a DNS name
// it points at 127.0.0.1.
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'admin_page.dart';
import 'data_dir.dart';
import 'database.dart';
import 'log.dart';
import 'qr_render.dart';
import 'sync_server.dart';

const serverVersion = '0.1.0';

/// Where a running server's admin API is, and the token it takes.
class AdminAccess {
  const AdminAccess({required this.port, required this.token});

  final int port;
  final String token;

  Uri get base => Uri(scheme: 'http', host: '127.0.0.1', port: port);

  /// The page, the token in the fragment: a browser never sends it to the
  /// server or puts it in a log.
  Uri get pageUrl => base.replace(path: '/', fragment: 'token=$token');

  static AdminAccess? read(DataDir dir) {
    final file = File(dir.adminPath);
    if (!file.existsSync()) return null;
    final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    return AdminAccess(
      port: json['port'] as int,
      token: json['token'] as String,
    );
  }

  void write(DataDir dir) =>
      writePrivate(dir.adminPath, jsonEncode({'port': port, 'token': token}));
}

class AdminServer {
  AdminServer._(
    this._http,
    this.access,
    this._server,
    this._database,
    this._log,
  );

  static const defaultPort = 53320;

  final HttpServer _http;
  final AdminAccess access;
  final SyncServer _server;
  final ServerDatabase _database;
  final Log _log;

  static Future<AdminServer> start({
    required SyncServer server,
    required ServerDatabase database,
    int port = defaultPort,
    String? token,
    Log log = const Log.silent(),
  }) async {
    final http = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
    final access = AdminAccess(port: http.port, token: token ?? _newToken());
    final admin = AdminServer._(http, access, server, database, log);
    http.listen(admin._handle);
    log.info('Admin page on ${access.base}');
    return admin;
  }

  Future<void> close() => _http.close(force: true);

  static String _newToken() {
    final random = Random.secure();
    return base64Url
        .encode([for (var i = 0; i < 32; i++) random.nextInt(256)])
        .replaceAll('=', '');
  }

  Future<void> _handle(HttpRequest request) async {
    final response = request.response;
    response.headers
      ..set('cache-control', 'no-store')
      ..set('x-content-type-options', 'nosniff')
      ..set('referrer-policy', 'no-referrer');
    try {
      if (!_hostAllowed(request.headers.host, request.headers.port)) {
        return await _send(response, 421, {'error': 'Unexpected host'});
      }
      final path = request.uri.path;
      if (request.method == 'GET' && path == '/') {
        response.headers
          ..contentType = ContentType.html
          ..set('x-frame-options', 'DENY')
          ..set(
            'content-security-policy',
            "default-src 'none'; script-src 'unsafe-inline'; "
                "style-src 'unsafe-inline'; img-src data:; connect-src 'self'; "
                "frame-ancestors 'none'",
          );
        response.write(adminPage);
        return await response.close();
      }
      if (!path.startsWith('/api/')) {
        return await _send(response, 404, {'error': 'Not found'});
      }
      if (!_authorized(request.headers.value('authorization'))) {
        return await _send(response, 401, {'error': 'Missing or wrong token'});
      }
      await _api(request, path.substring('/api'.length));
    } catch (error, stack) {
      _log.error('Admin request ${request.uri.path} failed', error, stack);
      // Shown to the user running the server, who is the only one here.
      await _send(response, 500, {'error': '$error'});
    }
  }

  bool _hostAllowed(String? host, int? port) =>
      (host == '127.0.0.1' || host == 'localhost') && port == access.port;

  bool _authorized(String? header) {
    const prefix = 'Bearer ';
    if (header == null || !header.startsWith(prefix)) return false;
    return _constantTimeEquals(header.substring(prefix.length), access.token);
  }

  static bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }

  Future<void> _api(HttpRequest request, String path) async {
    final response = request.response;
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();
    switch ((request.method, segments)) {
      case ('GET', ['status']):
        return _send(response, 200, _status());
      case ('POST', ['pairing']):
        final minutes = int.tryParse(
          request.uri.queryParameters['minutes'] ?? '',
        );
        await _server.openPairing(
          lasting: Duration(minutes: (minutes ?? 5).clamp(1, 30)),
        );
        return _send(response, 200, _pairing()!);
      case ('DELETE', ['pairing']):
        _server.closePairing();
        return _send(response, 200, {'closed': true});
      case ('GET', ['pairing', 'qr.svg']):
        final invite = _server.invite;
        if (invite == null) {
          return _send(response, 404, {'error': 'Pairing is closed'});
        }
        response.headers.contentType = ContentType('image', 'svg+xml');
        response.write(qrForSvg(invite.toLink()));
        return response.close();
      case ('POST', ['pairing', final id, final verdict])
          when verdict == 'accept' || verdict == 'refuse':
        final answered = _server.answer(id, accept: verdict == 'accept');
        return answered
            ? _send(response, 200, {'answered': true})
            : _send(response, 404, {'error': 'No such pairing request'});
      case ('GET', ['devices']):
        return _send(response, 200, _devices());
      case ('DELETE', ['devices', final fingerprint]):
        return _server.forget(fingerprint.toUpperCase())
            ? _send(response, 200, {'forgotten': true})
            : _send(response, 404, {'error': 'No such device'});
      default:
        return _send(response, 404, {'error': 'Not found'});
    }
  }

  Map<String, Object?> _status() {
    final counts = _database.counts();
    return {
      'version': serverVersion,
      'fingerprint': _server.identity.fingerprint,
      'port': _server.port,
      'rows': counts.rows,
      'tombstones': counts.tombstones,
      'devices': _devices(),
      'pairing': _pairing(),
      'pending': [for (final pairing in _server.pending) pairing.toJson()],
    };
  }

  Map<String, Object?>? _pairing() {
    final invite = _server.invite;
    if (invite == null) return null;
    return {
      'link': invite.toLink(),
      'code': invite.code,
      'addresses': invite.addresses,
      'expiresAt': _server.inviteExpires?.millisecondsSinceEpoch,
    };
  }

  List<Map<String, Object?>> _devices() => [
    for (final device in _server.devices()) device.toJson(),
  ];

  static Future<void> _send(HttpResponse response, int status, Object body) {
    response
      ..statusCode = status
      ..headers.contentType = ContentType.json
      ..write(jsonEncode(body));
    return response.close();
  }
}
