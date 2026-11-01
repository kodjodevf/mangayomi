import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/remote_webview/remote_webview_config.dart';

void main() {
  group('RemoteWebViewConfig', () {
    test('reads what the server sends', () {
      final config = RemoteWebViewConfig.fromJson({
        'userAgent': 'Custom/1.0',
        'javaScriptEnabled': false,
        'interceptRequests': true,
        'overrideUrlLoading': true,
        'javascriptInterfaces': [
          {
            'name': 'android',
            'methods': ['passPayload', ''],
          },
          {'name': '', 'methods': []},
        ],
      });

      expect(config.userAgent, 'Custom/1.0');
      expect(config.javaScriptEnabled, isFalse);
      expect(config.interceptRequests, isTrue);
      expect(config.overrideUrlLoading, isTrue);
      expect(config.javascriptInterfaces, [
        const RemoteJavascriptInterface('android', ['passPayload']),
      ]);
    });

    test('defaults to an Android WebView with nothing overridden', () {
      final config = RemoteWebViewConfig.fromJson({'userAgent': null});

      expect(config, const RemoteWebViewConfig());
      expect(config.userAgent, isNull);
      expect(config.javaScriptEnabled, isTrue);
    });

    test('equal configurations compare equal', () {
      Map<String, dynamic> json() => {
        'interceptRequests': true,
        'javascriptInterfaces': [
          {
            'name': 'android',
            'methods': ['a', 'b'],
          },
        ],
      };

      expect(
        RemoteWebViewConfig.fromJson(json()),
        RemoteWebViewConfig.fromJson(json()),
      );
      expect(
        RemoteWebViewConfig.fromJson(json()),
        isNot(RemoteWebViewConfig.fromJson({'interceptRequests': true})),
      );
    });
  });

  group('androidErrorCode', () {
    test('maps engine errors to WebViewClient.ERROR_* codes', () {
      expect(androidErrorCode(WebResourceErrorType.HOST_LOOKUP), -2);
      expect(androidErrorCode(WebResourceErrorType.CANNOT_CONNECT_TO_HOST), -6);
      expect(androidErrorCode(WebResourceErrorType.TIMEOUT), -8);
      expect(androidErrorCode(WebResourceErrorType.TOO_MANY_REDIRECTS), -9);
      expect(
        androidErrorCode(WebResourceErrorType.SERVER_CERTIFICATE_UNTRUSTED),
        -11,
      );
      expect(androidErrorCode(WebResourceErrorType.BAD_URL), -12);
      expect(androidErrorCode(WebResourceErrorType.FILE_NOT_FOUND), -14);
      expect(androidErrorCode(WebResourceErrorType.UNKNOWN), -1);
    });

    test('drops cancellations, which Android does not report', () {
      expect(androidErrorCode(WebResourceErrorType.CANCELLED), isNull);
      expect(
        androidErrorCode(
          WebResourceErrorType.FRAME_LOAD_INTERRUPTED_BY_POLICY_CHANGE,
        ),
        isNull,
      );
    });
  });

  test('console levels use Android names', () {
    expect(androidConsoleLevel(ConsoleMessageLevel.ERROR), 'ERROR');
    expect(androidConsoleLevel(ConsoleMessageLevel.WARNING), 'WARNING');
    expect(androidConsoleLevel(ConsoleMessageLevel.LOG), 'LOG');
    expect(androidConsoleLevel(null), 'LOG');
  });

  group('buildJavascriptInterfaceScript', () {
    const interfaces = [
      RemoteJavascriptInterface('android', ['passPayload', 'getValue']),
    ];

    String script(JavascriptInterfaceTransport transport) =>
        buildJavascriptInterfaceScript(
          interfaces: interfaces,
          transport: transport,
          sessionId: 'abc',
        );

    test('declares every interface and method', () {
      final source = script(JavascriptInterfaceTransport.prompt);

      expect(
        source,
        contains('[{"name":"android","methods":["passPayload","getValue"]}]'),
      );
      expect(source, contains(javascriptInterfacePromptPrefix));
      expect(source, contains('var mode = "prompt"'));
    });

    test('names the synchronous XHR path of the session', () {
      final source = script(JavascriptInterfaceTransport.syncXhr);

      expect(source, contains('var mode = "xhr"'));
      expect(source, contains(javascriptInterfacePath('abc')));
    });
  });
}
