import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mangayomi/services/remote_webview/remote_webview_host.dart';
import 'package:mangayomi/utils/log/log.dart';

/// `shouldInterceptRequest` for WKWebView, which has no such API.
///
/// The native side (packages/remote_webview_interceptor) installs a
/// `WKURLSchemeHandler` for http and https on the WebViews that ask for it,
/// so every request of the page — documents, scripts, images, XHR, fetch —
/// reaches the extension first, and is loaded from the network natively
/// when the extension does not answer it.
///
/// A WebView asks for it by listing [markerScheme] in its
/// `resourceCustomSchemes`, which is how its configuration is recognised.
abstract final class DarwinRequestInterceptor {
  static const _channel = MethodChannel('mangayomi/remote_webview_interceptor');

  static Future<bool>? _available;

  /// Whether interception could be installed on this device.
  static Future<bool> get available => _available ??= _install();

  /// The scheme that marks a WebView as belonging to [sessionId].
  static String markerScheme(String sessionId) =>
      'mangayomi-intercept-${sessionId.toLowerCase()}';

  static Future<bool> _install() async {
    if (!Platform.isIOS && !Platform.isMacOS) return false;
    try {
      _channel.setMethodCallHandler(_handle);
      return await _channel.invokeMethod<bool>('install') ?? false;
    } catch (error) {
      Logger.add(
        LoggerLevel.warning,
        '[RemoteWebView] Request interception is unavailable: $error',
      );
      if (kDebugMode) {
        debugPrint('[RemoteWebView] interception unavailable: $error');
      }
      return false;
    }
  }

  static Future<Object?> _handle(MethodCall call) async {
    if (call.method != 'shouldInterceptRequest') {
      throw MissingPluginException('Unknown method ${call.method}');
    }
    final request = Map<String, dynamic>.from(call.arguments as Map);
    final session = RemoteWebViewHost.sessionById(
      request['session'] as String?,
    );
    if (session == null) return null;
    return session.interceptForDarwin(request);
  }
}
