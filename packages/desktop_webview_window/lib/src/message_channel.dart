import 'package:flutter/services.dart';

typedef MessageHandler = Future<dynamic> Function(MethodCall call);

class ClientMessageChannel {
  const ClientMessageChannel();

  static const _channel = MethodChannel('webview_message/client_channel');

  Future<dynamic> invokeMethod(String method, [dynamic arguments]) {
    return _channel.invokeMethod(method, arguments);
  }

  void setMessageHandler(MessageHandler? handler) {
    _channel.setMethodCallHandler(handler);
  }
}
