import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mangayomi/services/http/m_client.dart' show webViewEnvironment;
import 'package:mangayomi/services/remote_webview/darwin_request_interceptor.dart';
import 'package:mangayomi/services/remote_webview/remote_webview_channel.dart';
import 'package:mangayomi/services/remote_webview/remote_webview_config.dart';
import 'package:mangayomi/utils/log/log.dart';

/// One `android.webkit.WebView` of an extension, hosted here as a headless
/// WebView.
///
/// Commands from the extension server drive it; its lifecycle goes back as
/// events in the order the engine produced them. The decisions Android makes
/// synchronously — `shouldInterceptRequest`, `shouldOverrideUrlLoading` and
/// JavaScript interface calls — hold the page until the extension answers.
class RemoteWebViewSession {
  RemoteWebViewSession({
    required this.id,
    required this._channel,
    this.onClosed,
  });

  final String id;
  final RemoteWebViewChannel _channel;

  /// Called once the WebView went away on its own (its process died).
  final void Function(RemoteWebViewSession session)? onClosed;

  static const _decisionTimeout = Duration(seconds: 30);

  HeadlessInAppWebView? _webView;
  InAppWebViewController? _controller;
  Future<InAppWebViewController>? _creating;
  RemoteWebViewConfig _config = const RemoteWebViewConfig();
  bool _nativeInterception = false;
  bool _disposed = false;

  /// The navigation this session started itself. Android does not consult
  /// `shouldOverrideUrlLoading` for `loadUrl`, only for what follows it.
  String? _programmaticUrl;

  /// Keeps events in engine order even when building one awaits (cookies).
  Future<void> _events = Future.value();

  static bool get _isApple => Platform.isIOS || Platform.isMacOS;

  JavascriptInterfaceTransport get _javascriptTransport {
    // Apple's WKUIDelegate and Android answer prompt() synchronously; WebView2
    // has no prompt callback in the plugin but intercepts requests.
    if (_isApple || Platform.isAndroid) {
      return JavascriptInterfaceTransport.prompt;
    }
    if (Platform.isWindows) return JavascriptInterfaceTransport.syncXhr;
    return JavascriptInterfaceTransport.handler;
  }

  /// Runs a command from the extension server.
  Future<Object?> handle(String method, Map<String, dynamic> params) async {
    if (_disposed) throw RemoteWebViewException('WebView was destroyed');
    switch (method) {
      case 'loadUrl':
        final url = params['url'] as String;
        final controller = await _prepare(params);
        _programmaticUrl = url;
        await controller.loadUrl(
          urlRequest: URLRequest(
            url: WebUri(url),
            headers: _stringMap(params['headers']),
          ),
        );
        return null;
      case 'postUrl':
        final url = params['url'] as String;
        final controller = await _prepare(params);
        _programmaticUrl = url;
        await controller.postUrl(
          url: WebUri(url),
          postData: base64Decode(params['body'] as String? ?? ''),
        );
        return null;
      case 'loadData':
        final controller = await _prepare(params);
        final baseUrl = params['baseUrl'] as String?;
        final historyUrl = params['historyUrl'] as String?;
        _programmaticUrl = baseUrl;
        await controller.loadData(
          data: params['data'] as String? ?? '',
          mimeType: params['mimeType'] as String? ?? 'text/html',
          encoding: params['encoding'] as String? ?? 'utf-8',
          baseUrl: WebUri(baseUrl ?? 'about:blank'),
          historyUrl: historyUrl == null ? null : WebUri(historyUrl),
        );
        return null;
      case 'evaluateJavascript':
        // Runs on the current page: a configuration change only applies to
        // the next navigation, as on Android.
        final controller =
            _controller ??
            await (_creating ?? _configured(_configFrom(params)));
        final result = await controller.evaluateJavascript(
          source: params['script'] as String? ?? '',
        );
        // Android hands back the value JSON-encoded ("null" when there is none).
        try {
          return jsonEncode(result);
        } catch (_) {
          return jsonEncode(result?.toString());
        }
      case 'stopLoading':
        await _controller?.stopLoading();
        return null;
      case 'reload':
        await _controller?.reload();
        return null;
      case 'goBack':
        await _controller?.goBack();
        return null;
      case 'goForward':
        await _controller?.goForward();
        return null;
      default:
        throw RemoteWebViewException('Unknown WebView command $method');
    }
  }

  /// Native `shouldInterceptRequest` for iOS and macOS, see
  /// [DarwinRequestInterceptor]. Returns null to load from the network.
  Future<Map<String, Object?>?> interceptForDarwin(
    Map<String, dynamic> request,
  ) async {
    if (_disposed || !_config.interceptRequests) return null;
    final result = await _ask('shouldInterceptRequest', {
      'url': request['url'],
      'method': request['method'] ?? 'GET',
      'headers': _stringMap(request['headers']),
      'isForMainFrame': request['isForMainFrame'] ?? false,
      'isRedirect': false,
      'hasGesture': false,
    });
    if (result is! Map) return null;
    return {
      'statusCode': (result['statusCode'] as num?)?.toInt() ?? 200,
      'reasonPhrase': result['reasonPhrase'] as String? ?? 'OK',
      'mimeType': result['mimeType'],
      'encoding': result['encoding'],
      'headers': _stringMap(result['headers']),
      'body': base64Decode(result['body'] as String? ?? ''),
    };
  }

  Future<void> dispose() async {
    _disposed = true;
    await _disposeWebView();
  }

  // ---------------------------------------------------------------------------
  // WebView lifecycle
  // ---------------------------------------------------------------------------

  /// The WebView configured as the command asks, creating it when needed.
  Future<InAppWebViewController> _prepare(Map<String, dynamic> params) async {
    final config = _configFrom(params);
    if (params['cookies'] case final List cookies when cookies.isNotEmpty) {
      // Cookies need a WebView on Windows, so they go in after creation.
      final controller = await _configured(config);
      await _installCookies(controller, cookies, params['url'] as String?);
      return controller;
    }
    return _configured(config);
  }

  RemoteWebViewConfig _configFrom(Map<String, dynamic> params) =>
      params.containsKey('config')
      ? RemoteWebViewConfig.fromJson(
          (params['config'] as Map?)?.cast<String, dynamic>(),
        )
      : _config;

  Future<InAppWebViewController> _configured(RemoteWebViewConfig config) async {
    final creating = _creating;
    if (creating != null) return creating;
    final existing = _controller;
    if (existing != null) {
      if (config == _config) return existing;
      // Request interception is fixed when a WebView is created; a change only
      // happens before a navigation, so starting over loses nothing.
      if (config.interceptRequests != _config.interceptRequests ||
          config.overrideUrlLoading != _config.overrideUrlLoading) {
        await _disposeWebView();
      } else {
        _config = config;
        await existing.setSettings(settings: _settings(config));
        await existing.removeAllUserScripts();
        final scripts = _userScripts(config);
        if (scripts.isNotEmpty) {
          await existing.addUserScripts(userScripts: scripts);
        }
        return existing;
      }
    }
    final future = _create(config);
    _creating = future;
    try {
      return await future;
    } finally {
      _creating = null;
    }
  }

  Future<InAppWebViewController> _create(RemoteWebViewConfig config) async {
    _config = config;
    _nativeInterception =
        _isApple &&
        config.interceptRequests &&
        await DarwinRequestInterceptor.available;
    final created = Completer<InAppWebViewController>();
    final webView = HeadlessInAppWebView(
      webViewEnvironment: webViewEnvironment,
      initialSettings: _settings(config),
      initialUserScripts: UnmodifiableListView(_userScripts(config)),
      onWebViewCreated: (controller) {
        _controller = controller;
        controller.addJavaScriptHandler(
          handlerName: javascriptInterfaceHandler,
          callback: (args) =>
              _callInterface(args.isEmpty ? null : args.first?.toString()),
        );
        if (!created.isCompleted) created.complete(controller);
      },
      onLoadStart: (controller, url) =>
          _emit('pageStarted', () async => {'url': url?.toString()}),
      onLoadStop: (controller, url) => _emit(
        'pageFinished',
        () async => {
          'url': url?.toString(),
          'cookies': await _cookies(controller, url),
        },
      ),
      onProgressChanged: (controller, progress) =>
          _emit('progressChanged', () async => {'progress': progress}),
      onTitleChanged: (controller, title) =>
          _emit('receivedTitle', () async => {'title': title ?? ''}),
      onReceivedError: (controller, request, error) {
        final code = androidErrorCode(error.type);
        if (code == null) return;
        _emit(
          'receivedError',
          () async => {
            ..._request(request),
            'errorCode': code,
            'description': error.description,
          },
        );
      },
      onReceivedHttpError: (controller, request, response) => _emit(
        'receivedHttpError',
        () async => {
          ..._request(request),
          'statusCode': response.statusCode,
          'reasonPhrase': response.reasonPhrase,
          'responseHeaders': response.headers ?? const {},
          'mimeType': response.contentType,
          'encoding': response.contentEncoding,
        },
      ),
      onConsoleMessage: (controller, message) => _emit(
        'consoleMessage',
        () async => {
          'message': message.message,
          'level': androidConsoleLevel(message.messageLevel),
        },
      ),
      onLoadResource: (controller, resource) =>
          _emit('loadResource', () async => {'url': resource.url?.toString()}),
      onUpdateVisitedHistory: (controller, url, isReload) => _emit(
        'updateVisitedHistory',
        () async => {
          'url': url?.toString(),
          'isReload': isReload ?? false,
          'canGoBack': await controller.canGoBack(),
          'canGoForward': await controller.canGoForward(),
        },
      ),
      shouldOverrideUrlLoading: (controller, action) =>
          _shouldOverrideUrlLoading(action),
      shouldInterceptRequest: (controller, request) =>
          _shouldInterceptRequest(request),
      onJsPrompt: (controller, request) async {
        final message = request.message ?? '';
        if (message.startsWith(javascriptInterfacePromptPrefix)) {
          return JsPromptResponse(
            handledByClient: true,
            action: JsPromptResponseAction.CONFIRM,
            value: await _callInterface(
              message.substring(javascriptInterfacePromptPrefix.length),
            ),
          );
        }
        // A headless Android WebView has no dialog to show.
        return JsPromptResponse(
          handledByClient: true,
          action: JsPromptResponseAction.CANCEL,
        );
      },
      onJsAlert: (controller, request) async =>
          JsAlertResponse(handledByClient: true),
      onJsConfirm: (controller, request) async => JsConfirmResponse(
        handledByClient: true,
        action: JsConfirmResponseAction.CANCEL,
      ),
      onRenderProcessGone: (controller, detail) =>
          _renderProcessGone(detail.didCrash),
      onWebContentProcessDidTerminate: (controller) => _renderProcessGone(true),
      onProcessFailed: (controller, detail) => _renderProcessGone(true),
    );
    _webView = webView;
    await webView.run();
    return created.future.timeout(const Duration(seconds: 20));
  }

  InAppWebViewSettings _settings(RemoteWebViewConfig config) =>
      config.toSettings(
        // Windows always intercepts: it has no onLoadResource, and its
        // JavaScript interfaces answer through intercepted requests.
        useShouldInterceptRequest:
            Platform.isWindows ||
            (Platform.isAndroid && config.interceptRequests),
        resourceCustomSchemes: _nativeInterception
            ? [DarwinRequestInterceptor.markerScheme(id)]
            : const [],
      );

  List<UserScript> _userScripts(RemoteWebViewConfig config) => [
    if (config.javascriptInterfaces.isNotEmpty)
      UserScript(
        source: buildJavascriptInterfaceScript(
          interfaces: config.javascriptInterfaces,
          transport: _javascriptTransport,
          sessionId: id,
        ),
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
        forMainFrameOnly: false,
      ),
  ];

  Future<void> _disposeWebView() async {
    final webView = _webView;
    _webView = null;
    _controller = null;
    if (webView == null) return;
    try {
      await webView.dispose();
    } catch (error) {
      _log('Could not dispose a remote WebView: $error');
    }
  }

  void _renderProcessGone(bool didCrash) {
    _emit('renderProcessGone', () async => {'didCrash': didCrash});
    unawaited(
      _disposeWebView().then((_) {
        _emit('sessionClosed', () async => {});
        onClosed?.call(this);
      }),
    );
  }

  // ---------------------------------------------------------------------------
  // Decisions the extension makes synchronously
  // ---------------------------------------------------------------------------

  Future<NavigationActionPolicy> _shouldOverrideUrlLoading(
    NavigationAction action,
  ) async {
    if (!_config.overrideUrlLoading) return NavigationActionPolicy.ALLOW;
    final request = action.request;
    final url = request.url;
    final isForMainFrame = action.isForMainFrame;
    final isRedirect = action.isRedirect ?? false;
    final scheme = url?.scheme ?? '';
    // Mirrors when Android asks: not for its own loadUrl/postUrl, not for POST,
    // not for http(s) subframes, never for about:blank.
    if (isForMainFrame && !isRedirect && url?.toString() == _programmaticUrl) {
      _programmaticUrl = null;
      return NavigationActionPolicy.ALLOW;
    }
    if ((request.method ?? 'GET').toUpperCase() == 'POST' ||
        scheme == 'about' ||
        (!isForMainFrame && (scheme == 'http' || scheme == 'https'))) {
      return NavigationActionPolicy.ALLOW;
    }
    final cancel = await _ask('shouldOverrideUrlLoading', {
      'url': url?.toString(),
      'method': request.method ?? 'GET',
      'headers': request.headers ?? const {},
      'isForMainFrame': isForMainFrame,
      'isRedirect': isRedirect,
      'hasGesture': action.hasGesture ?? false,
    });
    return cancel == true
        ? NavigationActionPolicy.CANCEL
        : NavigationActionPolicy.ALLOW;
  }

  Future<WebResourceResponse?> _shouldInterceptRequest(
    WebResourceRequest request,
  ) async {
    final url = request.url;
    if (_config.javascriptInterfaces.isNotEmpty &&
        url.path == javascriptInterfacePath(id)) {
      final reply = await _callInterface(url.queryParameters['call']);
      return WebResourceResponse(
        contentType: 'application/json',
        contentEncoding: 'utf-8',
        data: utf8.encode(reply),
        statusCode: 200,
        reasonPhrase: 'OK',
        headers: {'Cache-Control': 'no-store'},
      );
    }
    if (Platform.isWindows) {
      _emit('loadResource', () async => {'url': url.toString()});
    }
    if (!_config.interceptRequests) return null;
    final result = await _ask('shouldInterceptRequest', _request(request));
    if (result is! Map) return null;
    return WebResourceResponse(
      contentType: result['mimeType'] as String?,
      contentEncoding: result['encoding'] as String?,
      data: base64Decode(result['body'] as String? ?? ''),
      statusCode: (result['statusCode'] as num?)?.toInt() ?? 200,
      reasonPhrase: result['reasonPhrase'] as String? ?? 'OK',
      headers: _stringMap(result['headers']),
    );
  }

  /// Runs a JavaScript interface call and returns the reply the page decodes.
  Future<String> _callInterface(String? payload) async {
    try {
      final call = jsonDecode(payload ?? '') as Map<String, dynamic>;
      final result = await _channel.request('javascriptInterface', {
        'session': id,
        'name': call['name'],
        'method': call['method'],
        'args': call['args'] ?? const [],
      });
      return jsonEncode(result ?? const {'value': null});
    } catch (error) {
      return jsonEncode({
        'error': error is RemoteWebViewException
            ? error.message
            : error.toString(),
      });
    }
  }

  /// Asks the extension and waits for its answer; null when it cannot answer.
  Future<Object?> _ask(String method, Map<String, Object?> params) async {
    try {
      return await _channel
          .request(method, {'session': id, ...params})
          .timeout(_decisionTimeout);
    } catch (error) {
      _log('Extension did not answer $method: $error');
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  void _emit(String method, Future<Map<String, Object?>> Function() params) {
    _events = _events.then((_) async {
      if (_channel.isClosed) return;
      try {
        _channel.event(method, {'session': id, ...await params()});
      } catch (error) {
        _log('Could not report $method: $error');
      }
    });
  }

  Map<String, Object?> _request(WebResourceRequest request) => {
    'url': request.url.toString(),
    'method': request.method ?? 'GET',
    'headers': request.headers ?? const {},
    'isForMainFrame': request.isForMainFrame ?? false,
    'isRedirect': request.isRedirect ?? false,
    'hasGesture': request.hasGesture ?? false,
  };

  CookieManager get _cookieManager =>
      CookieManager.instance(webViewEnvironment: webViewEnvironment);

  Future<void> _installCookies(
    InAppWebViewController controller,
    List cookies,
    String? url,
  ) async {
    if (url == null) return;
    final uri = WebUri(url);
    if (uri.scheme != 'http' && uri.scheme != 'https') return;
    for (final cookie in cookies) {
      if (cookie is! Map) continue;
      final name = cookie['name'] as String?;
      if (name == null || name.isEmpty) continue;
      final domain = cookie['domain'] as String?;
      try {
        await _cookieManager.setCookie(
          url: uri,
          name: name,
          value: cookie['value']?.toString() ?? '',
          path: cookie['path'] as String? ?? '/',
          // A host-only cookie must not become a domain cookie.
          domain: domain != null && domain.startsWith('.') ? domain : null,
          expiresDate: (cookie['expiresDate'] as num?)?.toInt(),
          isSecure: cookie['isSecure'] as bool?,
          isHttpOnly: cookie['isHttpOnly'] as bool?,
          webViewController: controller,
        );
      } catch (error) {
        _log('Could not install cookie $name: $error');
      }
    }
  }

  Future<List<Map<String, Object?>>> _cookies(
    InAppWebViewController controller,
    WebUri? url,
  ) async {
    if (url == null || (url.scheme != 'http' && url.scheme != 'https')) {
      return const [];
    }
    try {
      final cookies = await _cookieManager.getCookies(
        url: url,
        webViewController: controller,
      );
      return [
        for (final cookie in cookies)
          {
            'name': cookie.name,
            'value': cookie.value?.toString() ?? '',
            'domain': cookie.domain,
            'path': cookie.path ?? '/',
            'expiresDate': cookie.expiresDate,
            'isSecure': cookie.isSecure,
            'isHttpOnly': cookie.isHttpOnly,
          },
      ];
    } catch (error) {
      _log('Could not read cookies for $url: $error');
      return const [];
    }
  }

  static Map<String, String> _stringMap(Object? value) {
    if (value is! Map) return const {};
    return {
      for (final entry in value.entries)
        if (entry.key != null && entry.value != null)
          entry.key.toString(): entry.value.toString(),
    };
  }

  static void _log(String message) {
    Logger.add(LoggerLevel.warning, '[RemoteWebView] $message');
    if (kDebugMode) debugPrint('[RemoteWebView] $message');
  }
}
