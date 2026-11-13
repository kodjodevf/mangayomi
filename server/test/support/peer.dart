// A device, as the server sees one: mutual TLS with its own identity, the
// server's certificate pinned by fingerprint. Plain dart:io, so the tests
// also show the protocol does not need the app's Rust client.
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:mangayomi_sync_server/src/native/api/host.dart';

class TestPeer {
  TestPeer(this.identity, this.port, this.serverFingerprint) {
    final context = SecurityContext(withTrustedRoots: false)
      ..useCertificateChainBytes(utf8.encode(identity.certificatePem))
      ..usePrivateKeyBytes(utf8.encode(identity.privateKeyPem));
    _client = HttpClient(context: context)
      ..badCertificateCallback = (certificate, host, port) =>
          sha256.convert(certificate.der).toString().toUpperCase() ==
          serverFingerprint;
  }

  static Future<TestPeer> create(int port, String serverFingerprint) async =>
      TestPeer(await generateIdentity(), port, serverFingerprint);

  final ServerIdentity identity;
  final int port;
  final String serverFingerprint;
  late final HttpClient _client;

  Future<(int, String)> pair(String code, String name) =>
      _post('/pair', utf8.encode(name), {'x-pairing-code': code});

  Future<(int, String)> sync(Map<String, Object?> body) =>
      _post('/api/sync/v1', utf8.encode(jsonEncode(body)), const {});

  Future<(int, String)> _post(
    String path,
    List<int> body,
    Map<String, String> headers,
  ) async {
    final request = await _client.postUrl(
      Uri(scheme: 'https', host: '127.0.0.1', port: port, path: path),
    );
    headers.forEach(request.headers.set);
    request.add(body);
    final response = await request.close();
    return (response.statusCode, await utf8.decodeStream(response));
  }

  void close() => _client.close(force: true);
}
