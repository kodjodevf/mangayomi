import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mangayomi/eval/mihon/service.dart';

void main() {
  test('a generic bridge 403 keeps its actual error', () {
    final response = http.Response(
      '{"error":"HTTP error 403","code":403}',
      403,
    );

    expect(
      () => hasError(response),
      throwsA(
        allOf(
          contains('HTTP error 403'),
          contains('statusCode: 403'),
          isNot(contains('Cloudflare')),
        ),
      ),
    );
  });
}
