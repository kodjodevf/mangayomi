import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'webview.dart';

class WebviewImpl extends Webview {
  final int viewId;

  final MethodChannel channel;

  final Map<String, JavaScriptMessageHandler> _javaScriptMessageHandlers = {};

  bool _closed = false;

  PromptHandler? _promptHandler;

  final _closeCompleter = Completer<void>();

  OnHistoryChangedCallback? _onHistoryChanged;

  final ValueNotifier<bool> _isNaivgating = ValueNotifier<bool>(false);

  final Set<OnUrlRequestCallback> _onUrlRequestCallbacks = {};

  final Set<OnWebMessageReceivedCallback> _onWebMessageReceivedCallbacks = {};

  WebviewImpl(this.viewId, this.channel);

  @override
  Future<void> get onClose => _closeCompleter.future;

  void onClosed() {
    _closed = true;
    _closeCompleter.complete();
  }

  void onJavaScriptMessage(String name, dynamic body) {
    assert(!_closed);
    final handler = _javaScriptMessageHandlers[name];
    assert(handler != null, "handler $name is not registed.");
    handler?.call(name, body);
  }

  String onRunJavaScriptTextInputPanelWithPrompt(
      String prompt, String defaultText) {
    assert(!_closed);
    return _promptHandler?.call(prompt, defaultText) ?? defaultText;
  }

  void onHistoryChanged(bool canGoBack, bool canGoForward) {
    assert(!_closed);
    _onHistoryChanged?.call(canGoBack, canGoForward);
  }

  void onNavigationStarted() {
    _isNaivgating.value = true;
  }

  void notifyUrlChanged(String url) {
    for (final callback in _onUrlRequestCallbacks) {
      callback(url);
    }
  }

  void notifyWebMessageReceived(String message) {
    for (final callback in _onWebMessageReceivedCallbacks) {
      callback(message);
    }
  }

  void onNavigationCompleted() {
    _isNaivgating.value = false;
  }

  @override
  ValueListenable<bool> get isNavigating => _isNaivgating;

  @override
  void registerJavaScriptMessageHandler(
      String name, JavaScriptMessageHandler handler) {
    if (!Platform.isMacOS) {
      return;
    }
    assert(!_closed);
    if (_closed) {
      return;
    }
    assert(name.isNotEmpty);
    assert(!_javaScriptMessageHandlers.containsKey(name));
    _javaScriptMessageHandlers[name] = handler;
    channel.invokeMethod("registerJavaScripInterface", {
      "viewId": viewId,
      "name": name,
    });
  }

  @override
  void unregisterJavaScriptMessageHandler(String name) {
    if (!Platform.isMacOS) {
      return;
    }
    if (_closed) {
      return;
    }
    channel.invokeMethod("unregisterJavaScripInterface", {
      "viewId": viewId,
      "name": name,
    });
  }

  @override
  void setPromptHandler(PromptHandler? handler) {
    if (!Platform.isMacOS) {
      return;
    }
    _promptHandler = handler;
  }

  @override
  void launch(String url) async {
    await channel.invokeMethod("launch", {
      "url": url,
      "viewId": viewId,
    });
  }

  @override
  void setBrightness(Brightness? brightness) {
    /// -1 : system default
    /// 0 : dark
    /// 1 : light
    if (!Platform.isMacOS) {
      return;
    }
    channel.invokeMethod("setBrightness", {
      "viewId": viewId,
      "brightness": brightness?.index ?? -1,
    });
  }

  @override
  void addScriptToExecuteOnDocumentCreated(String javaScript) {
    if (!(Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      return;
    }
    assert(javaScript.trim().isNotEmpty);
    channel.invokeMethod("addScriptToExecuteOnDocumentCreated", {
      "viewId": viewId,
      "javaScript": javaScript,
    });
  }

  @override
  Future<void> setApplicationNameForUserAgent(String applicationName) async {
    if (!(Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      return;
    }
    await channel.invokeMethod("setApplicationNameForUserAgent", {
      "viewId": viewId,
      "applicationName": applicationName,
    });
  }

  @override
  Future<void> forward() {
    return channel.invokeMethod("forward", {"viewId": viewId});
  }

  @override
  Future<void> setWebviewWindowVisibility(bool visible) {
    return channel.invokeMethod("setWebviewWindowVisibility", {
      "viewId": viewId,
      "visible": visible,
    });
  }

  @override
  Future<void> back() {
    return channel.invokeMethod("back", {"viewId": viewId});
  }

  @override
  Future<void> reload() {
    return channel.invokeMethod("reload", {"viewId": viewId});
  }

  @override
  Future<void> stop() {
    return channel.invokeMethod("stop", {"viewId": viewId});
  }

  @override
  Future<void> openDevToolsWindow() {
    return channel.invokeMethod('openDevToolsWindow', {"viewId": viewId});
  }

  @override
  void setOnHistoryChangedCallback(OnHistoryChangedCallback? callback) {
    _onHistoryChanged = callback;
  }

  @override
  void addOnUrlRequestCallback(OnUrlRequestCallback callback) {
    _onUrlRequestCallbacks.add(callback);
  }

  @override
  void removeOnUrlRequestCallback(OnUrlRequestCallback callback) {
    _onUrlRequestCallbacks.remove(callback);
  }

  @override
  void addOnWebMessageReceivedCallback(OnWebMessageReceivedCallback callback) {
    _onWebMessageReceivedCallbacks.add(callback);
  }

  @override
  void removeOnWebMessageReceivedCallback(OnWebMessageReceivedCallback callback) {
    _onWebMessageReceivedCallbacks.remove(callback);
  }

  @override
  void close() {
    if (_closed) {
      return;
    }
    channel.invokeMethod("close", {"viewId": viewId});
  }

  @override
  Future<String?> evaluateJavaScript(String javaScript) async {
    final dynamic result = await channel.invokeMethod("evaluateJavaScript", {
      "viewId": viewId,
      "javaScriptString": javaScript,
    });
    if (result is String || result == null) {
      return result;
    }
    return json.encode(result);
  }

  @override
  Future<void> postWebMessageAsString(String webMessage) async {
    return channel.invokeMethod("postWebMessageAsString", {
      "viewId": viewId,
      "webMessage": webMessage,
    });
  }

  @override
  Future<void> postWebMessageAsJson(String webMessage) async {
    return channel.invokeMethod("postWebMessageAsJson", {
      "viewId": viewId,
      "webMessage": webMessage,
    });
  }
}
