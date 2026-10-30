import 'dart:convert';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// A JavaScript interface the extension added with `addJavascriptInterface`.
class RemoteJavascriptInterface {
  const RemoteJavascriptInterface(this.name, this.methods);

  final String name;
  final List<String> methods;

  Map<String, Object?> toJson() => {'name': name, 'methods': methods};

  @override
  bool operator ==(Object other) =>
      other is RemoteJavascriptInterface &&
      other.name == name &&
      _listEquals(other.methods, methods);

  @override
  int get hashCode => Object.hash(name, Object.hashAll(methods));
}

/// How the extension's `WebView` is configured, sent by the server with every
/// navigation so the hosted WebView matches it.
class RemoteWebViewConfig {
  const RemoteWebViewConfig({
    this.userAgent,
    this.javaScriptEnabled = true,
    this.domStorageEnabled = true,
    this.loadsImagesAutomatically = true,
    this.blockNetworkImage = false,
    this.mediaPlaybackRequiresUserGesture = true,
    this.interceptRequests = false,
    this.overrideUrlLoading = false,
    this.javascriptInterfaces = const [],
  });

  factory RemoteWebViewConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const RemoteWebViewConfig();
    final interfaces = <RemoteJavascriptInterface>[];
    for (final entry in (json['javascriptInterfaces'] as List?) ?? const []) {
      if (entry is! Map) continue;
      final name = entry['name'];
      if (name is! String || name.isEmpty) continue;
      interfaces.add(
        RemoteJavascriptInterface(name, [
          for (final method in (entry['methods'] as List?) ?? const [])
            if (method is String && method.isNotEmpty) method,
        ]),
      );
    }
    final userAgent = json['userAgent'];
    return RemoteWebViewConfig(
      userAgent: userAgent is String && userAgent.isNotEmpty ? userAgent : null,
      javaScriptEnabled: json['javaScriptEnabled'] as bool? ?? true,
      domStorageEnabled: json['domStorageEnabled'] as bool? ?? true,
      loadsImagesAutomatically:
          json['loadsImagesAutomatically'] as bool? ?? true,
      blockNetworkImage: json['blockNetworkImage'] as bool? ?? false,
      mediaPlaybackRequiresUserGesture:
          json['mediaPlaybackRequiresUserGesture'] as bool? ?? true,
      interceptRequests: json['interceptRequests'] as bool? ?? false,
      overrideUrlLoading: json['overrideUrlLoading'] as bool? ?? false,
      javascriptInterfaces: interfaces,
    );
  }

  /// Set with `WebSettings.setUserAgentString`; null keeps the engine's own.
  final String? userAgent;
  final bool javaScriptEnabled;
  final bool domStorageEnabled;
  final bool loadsImagesAutomatically;
  final bool blockNetworkImage;
  final bool mediaPlaybackRequiresUserGesture;

  /// The extension's `WebViewClient` overrides `shouldInterceptRequest`.
  final bool interceptRequests;

  /// The extension's `WebViewClient` overrides `shouldOverrideUrlLoading`.
  final bool overrideUrlLoading;
  final List<RemoteJavascriptInterface> javascriptInterfaces;

  InAppWebViewSettings toSettings({
    required bool useShouldInterceptRequest,
    List<String> resourceCustomSchemes = const [],
  }) => InAppWebViewSettings(
    userAgent: userAgent ?? '',
    javaScriptEnabled: javaScriptEnabled,
    domStorageEnabled: domStorageEnabled,
    loadsImagesAutomatically: loadsImagesAutomatically,
    blockNetworkImage: blockNetworkImage,
    mediaPlaybackRequiresUserGesture: mediaPlaybackRequiresUserGesture,
    allowsInlineMediaPlayback: true,
    useShouldInterceptRequest: useShouldInterceptRequest,
    useShouldOverrideUrlLoading: overrideUrlLoading,
    useOnLoadResource: true,
    // Android WebViews do not open new windows unless the app opts in.
    supportMultipleWindows: false,
    javaScriptCanOpenWindowsAutomatically: false,
    resourceCustomSchemes: resourceCustomSchemes,
  );

  @override
  bool operator ==(Object other) =>
      other is RemoteWebViewConfig &&
      other.userAgent == userAgent &&
      other.javaScriptEnabled == javaScriptEnabled &&
      other.domStorageEnabled == domStorageEnabled &&
      other.loadsImagesAutomatically == loadsImagesAutomatically &&
      other.blockNetworkImage == blockNetworkImage &&
      other.mediaPlaybackRequiresUserGesture ==
          mediaPlaybackRequiresUserGesture &&
      other.interceptRequests == interceptRequests &&
      other.overrideUrlLoading == overrideUrlLoading &&
      _listEquals(other.javascriptInterfaces, javascriptInterfaces);

  @override
  int get hashCode => Object.hash(
    userAgent,
    javaScriptEnabled,
    domStorageEnabled,
    loadsImagesAutomatically,
    blockNetworkImage,
    mediaPlaybackRequiresUserGesture,
    interceptRequests,
    overrideUrlLoading,
    Object.hashAll(javascriptInterfaces),
  );
}

/// Prefix of the `prompt()` message that carries a JavaScript interface call.
const javascriptInterfacePromptPrefix = '__mangayomi_jsi__:';

/// Path, on the page's own origin, of the synchronous XHR that carries a
/// JavaScript interface call where `prompt()` cannot be answered.
String javascriptInterfacePath(String sessionId) =>
    '/__mangayomi_jsi__/$sessionId';

/// Name of the asynchronous fallback handler.
const javascriptInterfaceHandler = 'mangayomiJavascriptInterface';

/// How a page reaches the extension's JavaScript interfaces.
enum JavascriptInterfaceTransport {
  /// A `prompt()` answered by `onJsPrompt`: synchronous, like Android.
  prompt,

  /// A synchronous XHR answered by `shouldInterceptRequest`: synchronous too.
  syncXhr,

  /// `callHandler`, which returns a Promise. Used when nothing synchronous
  /// is available, and by the other transports when they fail.
  handler,
}

/// The document-start script that defines `window.<name>.<method>()` for every
/// interface, forwarding calls to the extension.
String buildJavascriptInterfaceScript({
  required List<RemoteJavascriptInterface> interfaces,
  required JavascriptInterfaceTransport transport,
  required String sessionId,
}) {
  final declared = jsonEncode([for (final i in interfaces) i.toJson()]);
  final mode = switch (transport) {
    JavascriptInterfaceTransport.prompt => 'prompt',
    JavascriptInterfaceTransport.syncXhr => 'xhr',
    JavascriptInterfaceTransport.handler => 'handler',
  };
  return '''
(function () {
  var interfaces = $declared;
  var mode = ${jsonEncode(mode)};
  var promptPrefix = ${jsonEncode(javascriptInterfacePromptPrefix)};
  var xhrPath = ${jsonEncode(javascriptInterfacePath(sessionId))};
  var handlerName = ${jsonEncode(javascriptInterfaceHandler)};
  var nativePrompt = window.prompt;
  var maxUrlPayload = 1500000;

  function decode(raw) {
    if (raw === null || raw === undefined) {
      throw new Error('Error calling method on JavaScript interface');
    }
    var reply = typeof raw === 'string' ? JSON.parse(raw) : raw;
    if (reply.error !== undefined && reply.error !== null) {
      throw new Error(reply.error);
    }
    return reply.value;
  }

  function viaHandler(payload) {
    var bridge = window.flutter_inappwebview;
    if (!bridge || !bridge.callHandler) {
      return Promise.reject(new Error('JavaScript interface bridge is not ready'));
    }
    return bridge.callHandler(handlerName, payload).then(decode);
  }

  function invoke(name, method, args) {
    var payload = JSON.stringify({ name: name, method: method, args: args });
    if (mode === 'prompt') {
      return decode(nativePrompt.call(window, promptPrefix + payload, ''));
    }
    if (mode === 'xhr' && location.origin && location.origin !== 'null' &&
        payload.length < maxUrlPayload) {
      try {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', location.origin + xhrPath + '?call=' + encodeURIComponent(payload), false);
        xhr.send(null);
        if (xhr.status === 200) return decode(xhr.responseText);
      } catch (e) {}
    }
    return viaHandler(payload);
  }

  interfaces.forEach(function (entry) {
    var target = {};
    entry.methods.forEach(function (method) {
      target[method] = function () {
        return invoke(entry.name, method, Array.prototype.slice.call(arguments));
      };
    });
    try {
      Object.defineProperty(window, entry.name, { value: target, configurable: true, writable: true });
    } catch (e) {
      window[entry.name] = target;
    }
  });
})();
''';
}

/// Android's `WebViewClient.ERROR_*` code for an engine error, or null for
/// errors Android does not report (a navigation the page or client cancelled).
int? androidErrorCode(WebResourceErrorType? type) {
  if (type == null) return -1;
  if (type == WebResourceErrorType.CANCELLED ||
      type == WebResourceErrorType.FRAME_LOAD_INTERRUPTED_BY_POLICY_CHANGE) {
    return null;
  }
  for (final entry in _androidErrorCodes.entries) {
    if (entry.value.any((candidate) => candidate == type)) return entry.key;
  }
  return -1;
}

final Map<int, List<WebResourceErrorType>> _androidErrorCodes = {
  // ERROR_HOST_LOOKUP
  -2: [
    WebResourceErrorType.HOST_LOOKUP,
    WebResourceErrorType.NOT_CONNECTED_TO_INTERNET,
    WebResourceErrorType.INTERNATIONAL_ROAMING_OFF,
    WebResourceErrorType.DATA_NOT_ALLOWED,
  ],
  // ERROR_UNSUPPORTED_AUTH_SCHEME
  -3: [WebResourceErrorType.UNSUPPORTED_AUTH_SCHEME],
  // ERROR_AUTHENTICATION
  -4: [
    WebResourceErrorType.USER_AUTHENTICATION_REQUIRED,
    WebResourceErrorType.USER_AUTHENTICATION_FAILED,
    WebResourceErrorType.USER_CANCELLED_AUTHENTICATION,
  ],
  // ERROR_PROXY_AUTHENTICATION
  -5: [
    WebResourceErrorType.PROXY_AUTHENTICATION,
    WebResourceErrorType.VALID_PROXY_AUTHENTICATION_REQUIRED,
  ],
  // ERROR_CONNECT
  -6: [
    WebResourceErrorType.CANNOT_CONNECT_TO_HOST,
    WebResourceErrorType.SERVER_UNREACHABLE,
    WebResourceErrorType.CONNECTION_ABORTED,
    WebResourceErrorType.RESET,
    WebResourceErrorType.NETWORK_CONNECTION_LOST,
    WebResourceErrorType.CALL_IS_ACTIVE,
  ],
  // ERROR_IO
  -7: [
    WebResourceErrorType.IO,
    WebResourceErrorType.BAD_SERVER_RESPONSE,
    WebResourceErrorType.CANNOT_PARSE_RESPONSE,
    WebResourceErrorType.CANNOT_DECODE_CONTENT_DATA,
    WebResourceErrorType.CANNOT_DECODE_RAW_DATA,
    WebResourceErrorType.ZERO_BYTE_RESOURCE,
    WebResourceErrorType.DATA_LENGTH_EXCEEDS_MAXIMUM,
    WebResourceErrorType.REQUEST_BODY_STREAM_EXHAUSTED,
    WebResourceErrorType.RESOURCE_UNAVAILABLE,
  ],
  // ERROR_TIMEOUT
  -8: [WebResourceErrorType.TIMEOUT],
  // ERROR_REDIRECT_LOOP
  -9: [
    WebResourceErrorType.TOO_MANY_REDIRECTS,
    WebResourceErrorType.REDIRECT_FAILED,
    WebResourceErrorType.REDIRECT_TO_NON_EXISTENT_LOCATION,
  ],
  // ERROR_UNSUPPORTED_SCHEME
  -10: [
    WebResourceErrorType.UNSUPPORTED_SCHEME,
    WebResourceErrorType.CANNOT_SHOW_URI,
  ],
  // ERROR_FAILED_SSL_HANDSHAKE
  -11: [
    WebResourceErrorType.FAILED_SSL_HANDSHAKE,
    WebResourceErrorType.SECURE_CONNECTION_FAILED,
    WebResourceErrorType.SERVER_CERTIFICATE_BAD_IDENTITY,
    WebResourceErrorType.SERVER_CERTIFICATE_HAS_BAD_DATE,
    WebResourceErrorType.SERVER_CERTIFICATE_HAS_UNKNOWN_ROOT,
    WebResourceErrorType.SERVER_CERTIFICATE_NOT_YET_VALID,
    WebResourceErrorType.SERVER_CERTIFICATE_REVOKED,
    WebResourceErrorType.SERVER_CERTIFICATE_UNTRUSTED,
    WebResourceErrorType.CLIENT_CERTIFICATE_REJECTED,
    WebResourceErrorType.CLIENT_CERTIFICATE_REQUIRED,
    WebResourceErrorType.TLS_CERTIFICATE_GENERIC_ERROR,
    WebResourceErrorType.APP_TRANSPORT_SECURITY_REQUIRES_SECURE_CONNECTION,
  ],
  // ERROR_BAD_URL
  -12: [
    WebResourceErrorType.BAD_URL,
    WebResourceErrorType.CANNOT_USE_RESTRICTED_PORT,
  ],
  // ERROR_FILE
  -13: [
    WebResourceErrorType.GENERIC_FILE_ERROR,
    WebResourceErrorType.CANNOT_OPEN_FILE,
    WebResourceErrorType.CANNOT_CLOSE_FILE,
    WebResourceErrorType.CANNOT_CREATE_FILE,
    WebResourceErrorType.CANNOT_MOVE_FILE,
    WebResourceErrorType.CANNOT_REMOVE_FILE,
    WebResourceErrorType.CANNOT_WRITE_TO_FILE,
    WebResourceErrorType.FILE_IS_DIRECTORY,
    WebResourceErrorType.NO_PERMISSIONS_TO_READ_FILE,
  ],
  // ERROR_FILE_NOT_FOUND
  -14: [WebResourceErrorType.FILE_NOT_FOUND],
  // ERROR_TOO_MANY_REQUESTS
  -15: [WebResourceErrorType.TOO_MANY_REQUESTS],
  // ERROR_UNSAFE_RESOURCE
  -16: [WebResourceErrorType.UNSAFE_RESOURCE],
};

/// Android's `ConsoleMessage.MessageLevel` name for an engine level.
String androidConsoleLevel(ConsoleMessageLevel? level) {
  if (level == ConsoleMessageLevel.ERROR) return 'ERROR';
  if (level == ConsoleMessageLevel.WARNING) return 'WARNING';
  if (level == ConsoleMessageLevel.DEBUG) return 'DEBUG';
  if (level == ConsoleMessageLevel.TIP) return 'TIP';
  return 'LOG';
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
