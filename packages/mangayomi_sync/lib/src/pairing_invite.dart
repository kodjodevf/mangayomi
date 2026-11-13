// What a host shows a new device, as a QR code or a link to copy: where to
// reach it, the fingerprint of its certificate, and a one-time code. The
// fingerprint is what makes the connection safe: the device trusts the
// host it scanned and no other, whatever answers at that address.
import 'dart:io';
import 'dart:math';

class PairingInvite {
  const PairingInvite({
    required this.addresses,
    required this.fingerprint,
    required this.code,
  });

  static const scheme = 'mangayomi-sync';

  /// `https://ip:port`, best first: a host may be on several networks.
  final List<String> addresses;
  final String fingerprint;
  final String code;

  String toLink() => Uri(
    scheme: scheme,
    host: 'pair',
    queryParameters: {'u': addresses, 'f': fingerprint, 'c': code},
  ).toString();

  /// The invite in [link], or null when it is not one.
  static PairingInvite? parse(String link) {
    final uri = Uri.tryParse(link.trim());
    if (uri == null || uri.scheme != scheme || uri.host != 'pair') return null;
    final params = uri.queryParametersAll;
    final addresses = [
      for (final address in params['u'] ?? const <String>[])
        if (_isHostAddress(address)) address,
    ];
    final fingerprint = params['f']?.firstOrNull?.toUpperCase();
    final code = params['c']?.firstOrNull;
    if (addresses.isEmpty ||
        fingerprint == null ||
        !RegExp(r'^[0-9A-F]{64}$').hasMatch(fingerprint) ||
        code == null ||
        code.length < 6) {
      return null;
    }
    return PairingInvite(
      addresses: addresses,
      fingerprint: fingerprint,
      code: code,
    );
  }

  static bool _isHostAddress(String address) {
    final uri = Uri.tryParse(address);
    return uri != null &&
        uri.scheme == 'https' &&
        uri.host.isNotEmpty &&
        uri.hasPort &&
        (uri.path.isEmpty || uri.path == '/') &&
        !uri.hasQuery &&
        uri.userInfo.isEmpty;
  }
}

/// Letters and digits that read and type without confusion: no 0/O, 1/I/L.
const _codeAlphabet = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';

/// A one-time pairing code, `XXXX-XXXX-XXXX`: about 59 bits, while the host
/// takes at most 5 wrong codes before it stops listening for one.
String newPairingCode([Random? random]) {
  random ??= Random.secure();
  final chars = [
    for (var i = 0; i < 12; i++)
      _codeAlphabet[random.nextInt(_codeAlphabet.length)],
  ].join();
  return '${chars.substring(0, 4)}-${chars.substring(4, 8)}-'
      '${chars.substring(8)}';
}

/// The addresses other devices on this device's networks can reach it at,
/// private networks first, then Tailscale's.
Future<List<String>> localAddresses() async {
  final interfaces = await NetworkInterface.list(
    type: InternetAddressType.IPv4,
  );
  final private = <String>[];
  final tailscale = <String>[];
  for (final interface in interfaces) {
    for (final address in interface.addresses) {
      final bytes = address.rawAddress;
      if (_isPrivate(bytes)) private.add(address.address);
      if (bytes[0] == 100 && bytes[1] & 0xC0 == 64) {
        tailscale.add(address.address);
      }
    }
  }
  return [...private, ...tailscale];
}

bool _isPrivate(List<int> b) =>
    b[0] == 10 ||
    (b[0] == 172 && b[1] >= 16 && b[1] <= 31) ||
    (b[0] == 192 && b[1] == 168);
