import 'dart:math';

import 'package:mangayomi_sync/mangayomi_sync.dart';
import 'package:test/test.dart';

void main() {
  final fingerprint = 'AB' * 32;

  test('an invite survives the trip through its link', () {
    final invite = PairingInvite(
      addresses: ['https://192.168.1.20:53319', 'https://100.101.1.2:53319'],
      fingerprint: fingerprint,
      code: 'K7Q2-M9XD-4TPA',
    );
    final parsed = PairingInvite.parse(invite.toLink())!;
    expect(parsed.addresses, invite.addresses);
    expect(parsed.fingerprint, fingerprint);
    expect(parsed.code, invite.code);
  });

  test('a lowercase fingerprint is read as the same one', () {
    final link =
        'mangayomi-sync://pair?u=https://10.0.0.2:53319'
        '&f=${fingerprint.toLowerCase()}&c=ABCDEFGH';
    expect(PairingInvite.parse(link)!.fingerprint, fingerprint);
  });

  for (final (name, link) in [
    (
      'another scheme',
      'https://pair?u=https://10.0.0.2:1&f=$fingerprint&c=ABCDEFGH',
    ),
    (
      'a plain HTTP address',
      'mangayomi-sync://pair?u=http://10.0.0.2:1&f=$fingerprint&c=ABCDEFGH',
    ),
    (
      'an address with a path',
      'mangayomi-sync://pair?u=https://10.0.0.2:1/x&f=$fingerprint&c=ABCDEFGH',
    ),
    (
      'an address with no port',
      'mangayomi-sync://pair?u=https://10.0.0.2&f=$fingerprint&c=ABCDEFGH',
    ),
    (
      'a short fingerprint',
      'mangayomi-sync://pair?u=https://10.0.0.2:1&f=ABCD&c=ABCDEFGH',
    ),
    (
      'a short code',
      'mangayomi-sync://pair?u=https://10.0.0.2:1&f=$fingerprint&c=ABC',
    ),
    ('no address', 'mangayomi-sync://pair?f=$fingerprint&c=ABCDEFGH'),
    ('not a link', 'hello'),
  ]) {
    test('refuses $name', () => expect(PairingInvite.parse(link), isNull));
  }

  test('codes are long, readable and differ', () {
    final codes = {for (var i = 0; i < 200; i++) newPairingCode(Random(i))};
    expect(codes, hasLength(200));
    for (final code in codes) {
      expect(
        code,
        matches(RegExp(r'^[A-HJKMNP-Z2-9]{4}(-[A-HJKMNP-Z2-9]{4}){2}$')),
      );
    }
  });
}
