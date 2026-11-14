import 'dart:convert';
import 'dart:io';

import 'package:mangayomi_sync_server/src/admin.dart';
import 'package:mangayomi_sync_server/src/admin_client.dart';
import 'package:mangayomi_sync_server/src/data_dir.dart';
import 'package:mangayomi_sync_server/src/database.dart';
import 'package:mangayomi_sync_server/src/native/api/host.dart';
import 'package:mangayomi_sync_server/src/native_library.dart';
import 'package:mangayomi_sync_server/src/sync_server.dart';
import 'package:test/test.dart';

import 'support/peer.dart';

void main() {
  late ServerDatabase database;
  late SyncServer server;
  late AdminServer admin;
  late AdminClient client;

  setUpAll(() => loadNativeLibrary(packageRoot: Directory.current.path));

  setUp(() async {
    database = ServerDatabase.open(':memory:');
    server = await SyncServer.start(
      database: database,
      identity: await generateIdentity(),
      address: '127.0.0.1',
      port: 0,
    );
    admin = await AdminServer.start(
      server: server,
      database: database,
      port: 0,
    );
    client = AdminClient(admin.access);
  });

  tearDown(() async {
    client.close();
    await admin.close();
    await server.stop();
    database.close();
  });

  Future<int> raw(String path, {String? token, String? host}) async {
    final http = HttpClient();
    try {
      final request = await http.getUrl(admin.access.base.replace(path: path));
      if (token != null) request.headers.set('authorization', 'Bearer $token');
      if (host != null) request.headers.host = host;
      final response = await request.close();
      await response.drain<void>();
      return response.statusCode;
    } finally {
      http.close(force: true);
    }
  }

  test('the API wants the token', () async {
    expect(await raw('/api/status'), 401);
    expect(await raw('/api/status', token: 'nope'), 401);
    expect(await raw('/api/status', token: admin.access.token), 200);
  });

  test('another Host is turned away, against DNS rebinding', () async {
    expect(
      await raw('/api/status', token: admin.access.token, host: 'evil.example'),
      421,
    );
    expect(await raw('/', host: 'evil.example'), 421);
    expect(await raw('/'), 200);
  });

  test('a device pairs through the API, then can be forgotten', () async {
    final opened = await client.post('/pairing') as Map<String, dynamic>;
    expect(opened['code'], matches(RegExp(r'^\w{4}-\w{4}-\w{4}$')));
    expect(await raw('/api/pairing/qr.svg', token: admin.access.token), 200);

    final phone = await TestPeer.create(
      server.port,
      server.identity.fingerprint,
    );
    addTearDown(phone.close);
    final pairing = phone.pair(opened['code'] as String, 'Phone');

    Map<String, dynamic> status;
    do {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      status = await client.get('/status') as Map<String, dynamic>;
    } while ((status['pending'] as List).isEmpty);
    final request = (status['pending'] as List).single as Map;
    expect(request['deviceName'], 'Phone');
    await client.post('/pairing/${request['id']}/accept');
    expect((await pairing).$1, 200);

    status = await client.get('/status') as Map<String, dynamic>;
    expect(status['pairing'], isNull, reason: 'the code was used');
    final device = (status['devices'] as List).single as Map;
    expect(device['name'], 'Phone');

    await client.delete('/devices/${device['fingerprint']}');
    expect(await client.get('/devices'), isEmpty);
    await expectLater(
      client.delete('/devices/${device['fingerprint']}'),
      throwsA(isA<AdminError>().having((e) => e.status, 'status', 404)),
    );
  });

  test('closing pairing refuses who is waiting', () async {
    final opened = await client.post('/pairing') as Map<String, dynamic>;
    final phone = await TestPeer.create(
      server.port,
      server.identity.fingerprint,
    );
    addTearDown(phone.close);
    final pairing = phone.pair(opened['code'] as String, 'Phone');
    while (server.pending.isEmpty) {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
    await client.delete('/pairing');
    expect((await pairing).$1, 403);
    expect(server.devices(), isEmpty);
  });

  test('the access file is readable by its owner only', () {
    final dir = Directory.systemTemp.createTempSync('mangayomi-server-');
    addTearDown(() => dir.deleteSync(recursive: true));
    final dataDir = DataDir(dir.path);
    admin.access.write(dataDir);
    final read = AdminAccess.read(dataDir)!;
    expect(read.token, admin.access.token);
    if (!Platform.isWindows) {
      expect(File(dataDir.adminPath).statSync().modeString(), 'rw-------');
    }
    expect(jsonDecode(File(dataDir.adminPath).readAsStringSync()), isA<Map>());
  });
}
