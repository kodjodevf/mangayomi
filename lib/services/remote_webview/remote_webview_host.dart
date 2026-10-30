import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mangayomi/services/remote_webview/darwin_request_interceptor.dart';
import 'package:mangayomi/services/remote_webview/remote_webview_channel.dart';
import 'package:mangayomi/services/remote_webview/remote_webview_session.dart';
import 'package:mangayomi/utils/log/log.dart';

/// Hosts the WebViews of extensions running in the extension server.
///
/// The server connects with a WebSocket to `/remote_webview` on the local
/// webview server, presenting the per-launch token it received with every
/// extension call. Each `android.webkit.WebView` it creates becomes a
/// [RemoteWebViewSession] here.
class RemoteWebViewHost {
  RemoteWebViewHost._(this._socket) {
    _channel = RemoteWebViewChannel(send: _socket.add)..onRequest = _handle;
  }

  /// Protocol spoken with the server's `RemoteWebViewBridge`.
  static const protocolVersion = 1;

  /// Path the server connects to.
  static const path = '/remote_webview';

  /// Header carrying the token.
  static const tokenHeader = 'x-mangayomi-webview-token';

  /// Every live session, by id, across connections.
  static final _sessions = <String, RemoteWebViewSession>{};

  static Future<String?>? _engineUserAgent;

  final WebSocket _socket;
  late final RemoteWebViewChannel _channel;
  final _owned = <String>{};

  static RemoteWebViewSession? sessionById(String? id) =>
      id == null ? null : _sessions[id];

  /// Accepts [request] as a host connection when it carries [token] and does
  /// not come from a web page; answers 403 otherwise.
  static Future<void> accept(
    HttpRequest request, {
    required String token,
  }) async {
    if (!isAuthorized(request.headers, token) ||
        !WebSocketTransformer.isUpgradeRequest(request)) {
      request.response
        ..statusCode = HttpStatus.forbidden
        ..write('Forbidden');
      await request.response.close();
      return;
    }
    // The host owns the socket and closes it when the connection ends.
    // Compression stays off: Dart answers permessage-deflate with a
    // client_max_window_bits parameter that OkHttp rejects, closing the
    // connection (1010) right after it opens. Frames never leave loopback.
    // ignore: close_sinks
    final socket = await WebSocketTransformer.upgrade(
      request,
      compression: CompressionOptions.compressionOff,
    );
    RemoteWebViewHost._(socket)._start();
  }

  /// Whether a request may drive WebViews. Browsers always send `Origin` on a
  /// WebSocket handshake, so refusing it keeps any web page out even if it
  /// learned the port; the token keeps out other local processes.
  @visibleForTesting
  static bool isAuthorized(HttpHeaders headers, String token) {
    if (token.isEmpty) return false;
    if (headers.value('origin') != null) return false;
    final presented = headers.value(tokenHeader);
    return presented != null && _constantTimeEquals(presented, token);
  }

  void _start() {
    _socket.listen(
      (data) {
        if (data is String) _channel.receive(data);
      },
      onDone: _close,
      onError: (Object error) {
        _log('WebView host connection failed: $error');
        _close();
      },
      cancelOnError: true,
    );
    unawaited(_sendHello());
  }

  Future<void> _sendHello() async {
    final interceptsRequests =
        Platform.isAndroid ||
        Platform.isWindows ||
        await DarwinRequestInterceptor.available;
    _channel.event('hello', {
      'protocol': protocolVersion,
      'platform': Platform.operatingSystem,
      'defaultUserAgent': await (_engineUserAgent ??= _readEngineUserAgent()),
      'interceptsRequests': interceptsRequests,
    });
  }

  static Future<String?> _readEngineUserAgent() async {
    try {
      final userAgent = await InAppWebViewController.getDefaultUserAgent();
      return userAgent.isEmpty ? null : userAgent;
    } catch (error) {
      _log('Could not read the WebView user-agent: $error');
      return null;
    }
  }

  Future<Object?> _handle(String method, Map<String, dynamic> params) async {
    final id = params['session'];
    if (id is! String || id.isEmpty) {
      throw RemoteWebViewException('Missing session');
    }
    if (method == 'destroy') {
      _owned.remove(id);
      await _sessions.remove(id)?.dispose();
      return null;
    }
    final session = _sessions[id] ??= RemoteWebViewSession(
      id: id,
      channel: _channel,
      onClosed: (closed) {
        _owned.remove(closed.id);
        _sessions.remove(closed.id);
      },
    );
    _owned.add(id);
    return session.handle(method, params);
  }

  void _close() {
    _channel.close('WebView host connection closed');
    for (final id in _owned.toList()) {
      unawaited(_sessions.remove(id)?.dispose());
    }
    _owned.clear();
    unawaited(_socket.close());
  }

  static bool _constantTimeEquals(String a, String b) {
    final left = utf8.encode(a);
    final right = utf8.encode(b);
    if (left.length != right.length) return false;
    var difference = 0;
    for (var i = 0; i < left.length; i++) {
      difference |= left[i] ^ right[i];
    }
    return difference == 0;
  }

  static void _log(String message) {
    Logger.add(LoggerLevel.warning, '[RemoteWebView] $message');
    if (kDebugMode) debugPrint('[RemoteWebView] $message');
  }
}
