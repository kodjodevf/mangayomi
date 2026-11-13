import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/services/sync/sync_transport.dart';
import 'package:mangayomi/src/rust/api/sync_host.dart';

/// A host at one address: answering, refusing, or not there at all.
class _FakeClient implements SyncPeerClient {
  _FakeClient(this.address, this.reachable, {this.status = 200});

  final String address;
  bool reachable;
  final int status;
  var calls = 0;

  @override
  Future<SyncPeerResponse> sendSync({required List<int> body}) async {
    calls++;
    if (!reachable) throw const SocketException('unreachable');
    return SyncPeerResponse(
      status: status,
      body: Uint8List.fromList(utf8.encode(jsonEncode({'at': address}))),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late Map<String, _FakeClient> clients;
  late List<String> reached;

  PeerSyncTransport transport(List<String> addresses) =>
      PeerSyncTransport.trying(
        addresses,
        (address) => clients[address]!,
        onReached: reached.add,
      );

  setUp(() {
    reached = [];
    clients = {
      'home': _FakeClient('home', false),
      'domain': _FakeClient('domain', true),
    };
  });

  test('an address that does not answer gives way to the next', () async {
    final peer = transport(['home', 'domain']);
    expect(await peer.postSync({}), {'at': 'domain'});
    expect(reached, ['domain']);

    // Stays with the one that answered, without trying the other again.
    expect(await peer.postSync({}), {'at': 'domain'});
    expect(clients['home']!.calls, 1);
    expect(reached, ['domain']);
  });

  test('the address that answers first is not reported', () async {
    clients['home']!.reachable = true;
    expect(await transport(['home', 'domain']).postSync({}), {'at': 'home'});
    expect(reached, isEmpty);
    expect(clients['domain']!.calls, 0);
  });

  test('a refusal is the answer: no other address is tried', () async {
    clients['home'] = _FakeClient('home', true, status: 403);
    expect(await transport(['home', 'domain']).postSync({}), isNull);
    expect(clients['domain']!.calls, 0);
  });

  test('when none answers, the failure is thrown', () async {
    clients['domain']!.reachable = false;
    await expectLater(
      transport(['home', 'domain']).postSync({}),
      throwsA(isA<SocketException>()),
    );
  });

  test('the addresses to try put the last one that answered first', () {
    final prefs = SyncPreference(
      server: 'https://10.0.0.2:53319',
      hostFingerprint: 'F',
      hostAddresses: [
        'https://sync.example.com:53319',
        'https://10.0.0.2:53319',
      ],
    );
    expect(prefs.peerAddresses, [
      'https://10.0.0.2:53319',
      'https://sync.example.com:53319',
    ]);
    expect(SyncPreference(server: 'https://a:1').peerAddresses, [
      'https://a:1',
    ]);
    expect(
      SyncPreference.fromJson(prefs.toJson()).hostAddresses,
      prefs.hostAddresses,
    );
  });
}
