import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/remote_webview/remote_webview_host.dart';

class _Headers implements HttpHeaders {
  _Headers(this._values);

  final Map<String, String> _values;

  @override
  String? value(String name) => _values[name.toLowerCase()];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  const token = '0123456789abcdef';

  test('accepts the extension server presenting the token', () {
    expect(
      RemoteWebViewHost.isAuthorized(
        _Headers({RemoteWebViewHost.tokenHeader: token}),
        token,
      ),
      isTrue,
    );
  });

  test('refuses a wrong or missing token', () {
    expect(
      RemoteWebViewHost.isAuthorized(
        _Headers({RemoteWebViewHost.tokenHeader: 'nope'}),
        token,
      ),
      isFalse,
    );
    expect(RemoteWebViewHost.isAuthorized(_Headers({}), token), isFalse);
    expect(
      RemoteWebViewHost.isAuthorized(
        _Headers({RemoteWebViewHost.tokenHeader: ''}),
        '',
      ),
      isFalse,
    );
  });

  test('refuses web pages even with the token', () {
    expect(
      RemoteWebViewHost.isAuthorized(
        _Headers({
          RemoteWebViewHost.tokenHeader: token,
          'origin': 'https://evil.example',
        }),
        token,
      ),
      isFalse,
    );
  });

  test(
    'the handshake negotiates no compression, which OkHttp would refuse',
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(() => server.close(force: true));
      server.listen(
        (request) => RemoteWebViewHost.accept(request, token: token),
      );

      // The handshake OkHttp sends, offering permessage-deflate.
      final socket = await Socket.connect('127.0.0.1', server.port);
      addTearDown(socket.destroy);
      socket.write(
        'GET ${RemoteWebViewHost.path} HTTP/1.1\r\n'
        'Host: 127.0.0.1:${server.port}\r\n'
        'Connection: Upgrade\r\n'
        'Upgrade: websocket\r\n'
        'Sec-WebSocket-Key: ${base64.encode(List.filled(16, 7))}\r\n'
        'Sec-WebSocket-Version: 13\r\n'
        'Sec-WebSocket-Extensions: permessage-deflate\r\n'
        '${RemoteWebViewHost.tokenHeader}: $token\r\n'
        '\r\n',
      );
      final received = StringBuffer();
      await for (final chunk in socket) {
        received.write(latin1.decode(chunk));
        // The hello frame follows the response headers.
        if (received.toString().contains('"hello"')) break;
      }
      final [head, ...] = received.toString().split('\r\n\r\n');

      expect(head, startsWith('HTTP/1.1 101'));
      expect(head.toLowerCase(), isNot(contains('sec-websocket-extensions')));
    },
  );
}
