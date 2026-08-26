import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_inappwebview/flutter_inappwebview.dart'
    as flutter_inappwebview;
import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:http/http.dart' as http;
import 'package:mangayomi/main.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/src/rust/aidoku_wasm/host_js.dart' as rust_js;

import '../util/logger.dart';

/// Manages QuickJS runtimes and Webviews for in-WASM JavaScript and Webview execution.
class AidokuJsManager {
  final Map<int, JavascriptRuntime> _contexts = {};
  final Map<int, _AidokuWebviewContext> _webviews = {};

  JavascriptRuntime? _getOrCreateContext(int contextId) {
    if (_contexts.containsKey(contextId)) {
      return _contexts[contextId];
    }
    try {
      final runtime = QuickJsRuntime2(stackSize: 1024 * 1024 * 4);
      runtime.enableHandlePromises();
      _contexts[contextId] = runtime;
      return runtime;
    } catch (e, st) {
      AidokuLogger.error(
        'AidokuJsManager',
        'Failed to initialize JS runtime',
        e,
        st,
      );
      return null;
    }
  }

  Future<rust_js.AidokuJsResponse> handleJsRequest(
    rust_js.AidokuJsRequest request,
  ) async {
    try {
      switch (request.action) {
        // --- JS Context Actions ---
        case rust_js.AidokuJsAction.createContext:
          final runtime = _getOrCreateContext(request.contextId);
          if (runtime == null) {
            return const rust_js.AidokuJsResponse(
              success: false,
              result: null,
              error: 'Failed to initialize JavaScript runtime',
            );
          }
          return const rust_js.AidokuJsResponse(
            success: true,
            result: null,
            error: null,
          );

        case rust_js.AidokuJsAction.evaluate:
          final runtime = _getOrCreateContext(request.contextId);
          if (runtime == null) {
            return const rust_js.AidokuJsResponse(
              success: false,
              result: null,
              error: 'JS runtime not available',
            );
          }
          final res = runtime.evaluate(request.script);
          if (res.isError) {
            AidokuLogger.error(
              'AidokuJsManager',
              'JS eval error: ${res.stringResult}',
            );
            return rust_js.AidokuJsResponse(
              success: false,
              result: null,
              error: res.stringResult,
            );
          }
          final val = res.stringResult;
          return rust_js.AidokuJsResponse(
            success: true,
            result: val,
            error: null,
          );

        case rust_js.AidokuJsAction.evaluateAsync:
          final runtime = _getOrCreateContext(request.contextId);
          if (runtime == null) {
            return const rust_js.AidokuJsResponse(
              success: false,
              result: null,
              error: 'JS runtime not available',
            );
          }
          final res = await runtime.evaluateAsync(request.script);
          if (res.isError) {
            AidokuLogger.error(
              'AidokuJsManager',
              'JS async eval error: ${res.stringResult}',
            );
            return rust_js.AidokuJsResponse(
              success: false,
              result: null,
              error: res.stringResult,
            );
          }
          final val = res.stringResult;
          return rust_js.AidokuJsResponse(
            success: true,
            result: val,
            error: null,
          );

        case rust_js.AidokuJsAction.getProperty:
          final runtime = _getOrCreateContext(request.contextId);
          if (runtime == null) {
            return const rust_js.AidokuJsResponse(
              success: false,
              result: null,
              error: 'JS runtime not available',
            );
          }
          final escapedKey = request.script
              .replaceAll(r'\', r'\\')
              .replaceAll('"', r'\"');
          final res = runtime.evaluate('globalThis["$escapedKey"]');
          if (res.isError) {
            return rust_js.AidokuJsResponse(
              success: false,
              result: null,
              error: res.stringResult,
            );
          }
          final val = res.stringResult;
          return rust_js.AidokuJsResponse(
            success: true,
            result: val,
            error: null,
          );

        case rust_js.AidokuJsAction.destroyContext:
          final runtime = _contexts.remove(request.contextId);
          runtime?.dispose();
          return const rust_js.AidokuJsResponse(
            success: true,
            result: null,
            error: null,
          );

        // --- Webview Actions ---
        case rust_js.AidokuJsAction.webviewCreate:
          _webviews.putIfAbsent(
            request.contextId,
            () => _AidokuWebviewContext(),
          );
          return const rust_js.AidokuJsResponse(
            success: true,
            result: null,
            error: null,
          );

        case rust_js.AidokuJsAction.webviewSetRuleList:
          return const rust_js.AidokuJsResponse(
            success: true,
            result: null,
            error: null,
          );

        case rust_js.AidokuJsAction.webviewLoad:
          final webview = _webviews.putIfAbsent(
            request.contextId,
            () => _AidokuWebviewContext(),
          );
          await webview.load(request.script);
          return const rust_js.AidokuJsResponse(
            success: true,
            result: null,
            error: null,
          );

        case rust_js.AidokuJsAction.webviewLoadHtml:
          final webview = _webviews.putIfAbsent(
            request.contextId,
            () => _AidokuWebviewContext(),
          );
          await webview.loadHtml(
            request.script,
            baseUrlData: request.extra,
          );
          return const rust_js.AidokuJsResponse(
            success: true,
            result: null,
            error: null,
          );

        case rust_js.AidokuJsAction.webviewWaitForLoad:
          final webview = _webviews[request.contextId];
          await webview?.waitForLoad();
          return const rust_js.AidokuJsResponse(
            success: true,
            result: null,
            error: null,
          );

        case rust_js.AidokuJsAction.webviewAddUserScript:
          final webview = _webviews.putIfAbsent(
            request.contextId,
            () => _AidokuWebviewContext(),
          );
          webview.userScripts.add(request.script);
          return const rust_js.AidokuJsResponse(
            success: true,
            result: null,
            error: null,
          );

        case rust_js.AidokuJsAction.webviewEval:
        case rust_js.AidokuJsAction.webviewEvalAsync:
          final webview = _webviews[request.contextId];
          if (webview != null) {
            final res = await webview.evaluate(request.script);
            return rust_js.AidokuJsResponse(
              success: true,
              result: res,
              error: null,
            );
          }
          return const rust_js.AidokuJsResponse(
            success: false,
            result: null,
            error: 'Webview not found',
          );

        case rust_js.AidokuJsAction.webviewGetCookies:
          final webview = _webviews[request.contextId];
          final cookies = await webview?.getCookies();
          return rust_js.AidokuJsResponse(
            success: true,
            result: cookies,
            error: null,
          );

        case rust_js.AidokuJsAction.webviewDeleteCookie:
          return const rust_js.AidokuJsResponse(
            success: true,
            result: null,
            error: null,
          );

        case rust_js.AidokuJsAction.webviewDestroy:
          final webview = _webviews.remove(request.contextId);
          await webview?.dispose();
          return const rust_js.AidokuJsResponse(
            success: true,
            result: null,
            error: null,
          );
      }
    } catch (e, st) {
      AidokuLogger.error(
        'AidokuJsManager',
        'Error evaluating JS/Webview: ${request.script}',
        e,
        st,
      );
      return rust_js.AidokuJsResponse(
        success: false,
        result: null,
        error: e.toString(),
      );
    }
  }

  void dispose() {
    for (final runtime in _contexts.values) {
      try {
        runtime.dispose();
      } catch (_) {}
    }
    _contexts.clear();

    for (final webview in _webviews.values) {
      try {
        webview.dispose();
      } catch (_) {}
    }
    _webviews.clear();
  }
}

class _AidokuWebviewContext {
  String? url;
  String? html;
  String? baseUrl;
  final List<String> userScripts = [];
  flutter_inappwebview.HeadlessInAppWebView? headlessWebView;
  flutter_inappwebview.InAppWebViewController? controller;
  Completer<void>? loadCompleter;
  bool isLoaded = false;

  Future<void> load(String targetUrl, {Map<String, String>? headers}) async {
    url = targetUrl;
    isLoaded = false;
    loadCompleter = Completer<void>();

    try {
      headlessWebView = flutter_inappwebview.HeadlessInAppWebView(
        webViewEnvironment: webViewEnvironment,
        initialUrlRequest: flutter_inappwebview.URLRequest(
          url: flutter_inappwebview.WebUri(targetUrl),
          headers: headers,
        ),
        onWebViewCreated: (c) {
          controller = c;
        },
        onLoadStop: (c, uri) async {
          for (final script in userScripts) {
            try {
              await c.evaluateJavascript(source: script);
            } catch (_) {}
          }
          isLoaded = true;
          if (loadCompleter != null && !loadCompleter!.isCompleted) {
            loadCompleter!.complete();
          }
        },
        onReceivedError: (c, request, error) {
          isLoaded = true;
          if (loadCompleter != null && !loadCompleter!.isCompleted) {
            loadCompleter!.complete();
          }
        },
      );
      await headlessWebView!.run();
    } catch (e, st) {
      AidokuLogger.error(
        'AidokuJsManager',
        'Failed to run HeadlessInAppWebView: $targetUrl',
        e,
        st,
      );
    }
  }

  Future<void> loadHtml(String htmlData, {String? baseUrlData}) async {
    html = htmlData;
    baseUrl = baseUrlData;
    isLoaded = false;
    loadCompleter = Completer<void>();

    try {
      headlessWebView = flutter_inappwebview.HeadlessInAppWebView(
        webViewEnvironment: webViewEnvironment,
        initialData: flutter_inappwebview.InAppWebViewInitialData(
          data: htmlData,
          baseUrl: baseUrlData != null
              ? flutter_inappwebview.WebUri(baseUrlData)
              : null,
        ),
        onWebViewCreated: (c) {
          controller = c;
        },
        onLoadStop: (c, uri) async {
          for (final script in userScripts) {
            try {
              await c.evaluateJavascript(source: script);
            } catch (_) {}
          }
          isLoaded = true;
          if (loadCompleter != null && !loadCompleter!.isCompleted) {
            loadCompleter!.complete();
          }
        },
        onReceivedError: (c, request, error) {
          isLoaded = true;
          if (loadCompleter != null && !loadCompleter!.isCompleted) {
            loadCompleter!.complete();
          }
        },
      );
      await headlessWebView!.run();
    } catch (e, st) {
      AidokuLogger.error(
        'AidokuJsManager',
        'Failed to run HeadlessInAppWebView with HTML',
        e,
        st,
      );
    }
  }

  Future<void> waitForLoad({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    if (isLoaded) return;
    if (loadCompleter != null) {
      try {
        await loadCompleter!.future.timeout(timeout);
      } catch (_) {}
    }
  }

  Future<String?> evaluate(String script) async {
    if (controller != null) {
      final res = await controller!.evaluateJavascript(source: script);
      return res?.toString();
    }
    // Fallback: If cfPort is active, evaluate via evaluateJavascriptViaWebview endpoint
    if (url != null && url!.isNotEmpty) {
      try {
        final res = await http.post(
          Uri.parse('http://localhost:$cfPort/evaluateJavascriptViaWebview'),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          body: jsonEncode({
            'url': url,
            'headers': <String, String>{},
            'scripts': [...userScripts, script],
            'time': 30,
          }),
        );
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body) as Map<String, dynamic>;
          return data['result']?.toString();
        }
      } catch (_) {}
    }
    return null;
  }

  Future<String?> getCookies() async {
    if (url != null && url!.isNotEmpty) {
      try {
        final cookieManager = flutter_inappwebview.CookieManager.instance();
        final cookies = await cookieManager.getCookies(
          url: flutter_inappwebview.WebUri(url!),
        );
        final cookieStr =
            cookies.map((c) => '${c.name}=${c.value}').join('; ');
        return cookieStr;
      } catch (_) {}
    }
    return null;
  }

  Future<void> dispose() async {
    try {
      await headlessWebView?.dispose();
    } catch (_) {}
    headlessWebView = null;
    controller = null;
  }
}
