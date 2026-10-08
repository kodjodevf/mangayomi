import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/http/m_client.dart';

void main() {
  test('credentials are redacted whatever their casing', () {
    final redacted = redactHeaders({
      'Authorization': 'Bearer abc',
      'cookie': 'session=1',
      'Set-Cookie': 'session=2',
      'simkl-api-key': 'key',
    });

    expect(redacted.values, everyElement('<redacted>'));
    expect(redacted.keys, contains('Authorization'));
  });

  test('other headers are logged as they are', () {
    final headers = {'User-Agent': 'Mangayomi', 'Referer': 'https://a.b/'};

    expect(redactHeaders(headers), headers);
  });

  test('a printed request line from the worker isolate is redacted too', () {
    final line =
        '----- Request -----\nGET https://a.b/\nheaders: '
        '${{'user-agent': 'UA (KHTML, like Gecko)', 'Authorization': 'Bearer abc', 'cookie': 'a=1; b=2'}}';

    final redacted = redactHeadersInText(line);

    expect(redacted, isNot(contains('Bearer abc')));
    expect(redacted, isNot(contains('a=1')));
    expect(redacted, contains('Authorization: <redacted>'));
    expect(redacted, contains('UA (KHTML, like Gecko)'));
  });
}
