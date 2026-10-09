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

  group('CloudflareAlertScope', () {
    http.Response challengeResponse([
      String url = 'https://blocked.example/video',
    ]) => http.Response(
      '<html>challenge</html>',
      403,
      headers: {'cf-mitigated': 'challenge'},
      request: http.Request('GET', Uri.parse(url)),
    );

    test(
      'discards a challenged fallback when the operation succeeds',
      () async {
        final shown = <http.BaseResponse>[];
        final scope = CloudflareAlertScope(onShow: shown.add);

        final result = await scope.run<bool>(() async {
          await Future<void>.delayed(Duration.zero);
          await LoggerInterceptor(true)
              .interceptResponse(response: challengeResponse());
          return true;
        }, hasUsableResult: (result) => result);

        expect(result, isTrue);
        expect(shown, isEmpty);
      },
    );

    test('shows the final challenge when no usable result exists', () async {
      final shown = <http.BaseResponse>[];
      final scope = CloudflareAlertScope(onShow: shown.add);

      final result = await scope.run<bool>(() async {
        await LoggerInterceptor(true).interceptResponse(
          response: challengeResponse('https://first-blocked.example/video'),
        );
        await Future<void>.delayed(Duration.zero);
        await LoggerInterceptor(true)
            .interceptResponse(response: challengeResponse());
        return false;
      }, hasUsableResult: (result) => result);

      expect(result, isFalse);
      expect(shown, hasLength(1));
      expect(shown.single.request?.url.host, 'blocked.example');
    });

    test('shows the final challenge when the operation throws', () async {
      final shown = <http.BaseResponse>[];
      final scope = CloudflareAlertScope(onShow: shown.add);

      await expectLater(
        scope.run<void>(() async {
          await Future<void>.delayed(Duration.zero);
          await LoggerInterceptor(true)
              .interceptResponse(response: challengeResponse());
          throw StateError('No playable videos');
        }, hasUsableResult: (_) => false),
        throwsStateError,
      );

      expect(shown, hasLength(1));
      expect(shown.single.request?.url.host, 'blocked.example');
    });

    test('keeps concurrent video lookups isolated', () async {
      final usableShown = <http.BaseResponse>[];
      final failedShown = <http.BaseResponse>[];
      final usableScope = CloudflareAlertScope(onShow: usableShown.add);
      final failedScope = CloudflareAlertScope(onShow: failedShown.add);

      final results = await Future.wait([
        usableScope.run<bool>(() async {
          await Future<void>.delayed(Duration.zero);
          await LoggerInterceptor(true)
              .interceptResponse(response: challengeResponse());
          return true;
        }, hasUsableResult: (result) => result),
        failedScope.run<bool>(() async {
          await LoggerInterceptor(true)
              .interceptResponse(response: challengeResponse());
          await Future<void>.delayed(Duration.zero);
          return false;
        }, hasUsableResult: (result) => result),
      ]);

      expect(results, [true, false]);
      expect(usableShown, isEmpty);
      expect(failedShown, hasLength(1));
    });
  });
}
