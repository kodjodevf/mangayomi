import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/remote_webview/remote_webview_channel.dart';

void main() {
  late List<Map<String, dynamic>> sent;
  late RemoteWebViewChannel channel;

  setUp(() {
    sent = [];
    channel = RemoteWebViewChannel(
      send: (text) => sent.add(jsonDecode(text) as Map<String, dynamic>),
    );
  });

  test('a request completes with the matching response', () async {
    final result = channel.request('shouldInterceptRequest', {'session': 's'});
    final id = sent.single['id'];
    expect(sent.single['method'], 'shouldInterceptRequest');

    channel.receive(jsonEncode({'type': 'res', 'id': id, 'result': true}));

    expect(await result, isTrue);
  });

  test('an error response fails the request', () async {
    final result = channel.request('javascriptInterface', {'session': 's'});
    channel.receive(
      jsonEncode({'type': 'res', 'id': sent.single['id'], 'error': 'boom'}),
    );

    await expectLater(
      result,
      throwsA(
        isA<RemoteWebViewException>().having(
          (e) => e.message,
          'message',
          'boom',
        ),
      ),
    );
  });

  test(
    'server requests are answered with the handler result or error',
    () async {
      channel.onRequest = (method, params) async {
        if (method == 'loadUrl') return params['url'];
        throw RemoteWebViewException('cannot $method');
      };

      channel.receive(
        jsonEncode({
          'type': 'req',
          'id': 4,
          'method': 'loadUrl',
          'params': {'url': 'https://example.org'},
        }),
      );
      channel.receive(
        jsonEncode({'type': 'req', 'id': 5, 'method': 'explode', 'params': {}}),
      );
      await pumpEventQueue();

      expect(sent, [
        {'type': 'res', 'id': 4, 'result': 'https://example.org'},
        {'type': 'res', 'id': 5, 'error': 'cannot explode'},
      ]);
    },
  );

  test('events carry no id and expect no answer', () {
    channel.event('pageFinished', {'session': 's', 'url': 'https://a.b'});

    expect(sent.single, {
      'type': 'evt',
      'method': 'pageFinished',
      'params': {'session': 's', 'url': 'https://a.b'},
    });
  });

  test('closing fails pending requests and drops later messages', () async {
    final pending = channel.request('evaluateJavascript', {'session': 's'});

    channel.close('gone');
    channel.event('pageStarted', {'session': 's'});

    await expectLater(pending, throwsA(isA<RemoteWebViewException>()));
    expect(sent, hasLength(1));
    await expectLater(
      channel.request('loadUrl', {}),
      throwsA(isA<RemoteWebViewException>()),
    );
  });

  test('malformed frames are ignored', () {
    channel.receive('not json');
    channel.receive(jsonEncode({'type': 'res', 'id': 99, 'result': 1}));

    expect(sent, isEmpty);
  });
}
