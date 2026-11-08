import 'dart:convert';
import 'dart:io';

import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/eval/javascript/http.dart';

/// #1130: `put`, `delete` and `patch` all sent a POST, so a source couldn't
/// reach an endpoint that only takes one of them.
void main() {
  late HttpServer server;
  late String url;
  // What the server last received, as "METHOD body".
  late String received;

  setUp(() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));
    url = 'http://${server.address.address}:${server.port}/';
    server.listen((request) async {
      final body = await utf8.decoder.bind(request).join();
      received = '${request.method} $body'.trim();
      await request.response.close();
    });
  });

  /// Runs `new Client().<call>` as a source would.
  Future<void> call(String call) async {
    final runtime = getJavascriptRuntime();
    JsHttpClient(runtime).init();
    final evaluated = await runtime.evaluateAsync('''
      (async () => {
        const client = new Client({"useDartHttpClient": true});
        const res = await client.$call;
        return res.statusCode.toString();
      })()
    ''');
    final result = await runtime.handlePromise(evaluated);
    expect(result.isError, isFalse, reason: result.stringResult);
    expect(result.stringResult, '200');
  }

  for (final (method, name) in [
    ('POST', 'post'),
    ('PUT', 'put'),
    ('DELETE', 'delete'),
    ('PATCH', 'patch'),
  ]) {
    test('$name sends a $method with its body', () async {
      await call('$name("$url", {"Content-Type": "text/plain"}, "hello")');
      expect(received, '$method hello');
    });

    test('$name sends a $method with a JSON body', () async {
      await call(
        '$name("$url", {"Content-Type": "application/json"}, '
        '{"action": "favorite"})',
      );
      expect(received, '$method {"action":"favorite"}');
    });
  }
}
