import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mangayomi/services/http/m_client.dart';

void main() {
  group('isCloudflare', () {
    test('does not mistake an ordinary proxied 403 for a challenge', () {
      final response = http.Response(
        'Forbidden',
        403,
        headers: {'server': 'cloudflare'},
      );

      expect(isCloudflare(response), isFalse);
    });

    test('does not mistake an ordinary proxied 503 for a challenge', () {
      final response = http.Response(
        'Temporarily unavailable',
        503,
        headers: {'server': 'cloudflare-nginx'},
      );

      expect(isCloudflare(response), isFalse);
    });

    test('recognizes the official challenge response header', () {
      final response = http.Response(
        '<html>challenge</html>',
        403,
        headers: {'cf-mitigated': 'challenge', 'content-type': 'text/html'},
      );

      expect(isCloudflare(response), isTrue);
    });

    test('normalizes challenge header casing and whitespace', () {
      final response = http.Response(
        '<html>challenge</html>',
        503,
        headers: {'Cf-Mitigated': ' Challenge '},
      );

      expect(isCloudflare(response), isTrue);
    });

    test('does not require a Server header when challenge is explicit', () {
      final response = http.Response(
        '<html>challenge</html>',
        403,
        headers: {'cf-mitigated': 'challenge'},
      );

      expect(isCloudflare(response), isTrue);
    });

    test('rejects non-challenge cf-mitigated values', () {
      final response = http.Response(
        'Forbidden',
        403,
        headers: {'cf-mitigated': 'block'},
      );

      expect(isCloudflare(response), isFalse);
    });
  });
}
