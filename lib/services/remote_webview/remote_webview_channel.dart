import 'dart:async';
import 'dart:convert';

/// Handles a request the extension server sent; the returned value becomes
/// the response `result`, a thrown error its `error`.
typedef RemoteWebViewRequestHandler = Future<Object?> Function(
  String method,
  Map<String, dynamic> params,
);

/// Thrown by [RemoteWebViewChannel.request] when the other side answers with
/// an error, or when the channel closes before it answers.
class RemoteWebViewException implements Exception {
  RemoteWebViewException(this.message);

  final String message;

  @override
  String toString() => 'RemoteWebViewException: $message';
}

/// The message layer of the remote WebView protocol, shared with the
/// extension server's `RemoteWebViewConnection`.
///
/// Frames are JSON text, symmetric in both directions:
/// - `{"type":"req","id":1,"method":"loadUrl","params":{...}}` expects one
/// - `{"type":"res","id":1,"result":...}` or `{"type":"res","id":1,"error":"..."}`
/// - `{"type":"evt","method":"pageFinished","params":{...}}` expects nothing.
class RemoteWebViewChannel {
  RemoteWebViewChannel({required this._send});

  final void Function(String) _send;
  final _pending = <int, Completer<Object?>>{};
  int _nextId = 1;
  bool _closed = false;

  /// Requests from the server.
  RemoteWebViewRequestHandler? onRequest;

  bool get isClosed => _closed;

  /// Sends a request and completes with its result.
  Future<Object?> request(String method, Map<String, Object?> params) {
    if (_closed) {
      return Future.error(RemoteWebViewException('Channel is closed'));
    }
    final id = _nextId++;
    final completer = Completer<Object?>();
    _pending[id] = completer;
    _write({'type': 'req', 'id': id, 'method': method, 'params': params});
    return completer.future;
  }

  /// Sends an event; nothing comes back.
  void event(String method, Map<String, Object?> params) {
    if (_closed) return;
    _write({'type': 'evt', 'method': method, 'params': params});
  }

  /// Entry point for every text frame received from the server.
  void receive(String text) {
    final Map<String, dynamic> message;
    try {
      message = jsonDecode(text) as Map<String, dynamic>;
    } catch (_) {
      return;
    }
    switch (message['type']) {
      case 'res':
        final completer = _pending.remove((message['id'] as num?)?.toInt());
        if (completer == null) return;
        final error = message['error'];
        if (error != null) {
          completer.completeError(RemoteWebViewException(error.toString()));
        } else {
          completer.complete(message['result']);
        }
      case 'req':
        final id = message['id'];
        final method = message['method'] as String?;
        if (id == null || method == null) return;
        final params =
            (message['params'] as Map?)?.cast<String, dynamic>() ?? const {};
        unawaited(_answer(id, method, params));
    }
  }

  Future<void> _answer(
    Object id,
    String method,
    Map<String, dynamic> params,
  ) async {
    final handler = onRequest;
    try {
      if (handler == null) {
        throw RemoteWebViewException('No handler for $method');
      }
      final result = await handler(method, params);
      _write({'type': 'res', 'id': id, 'result': result});
    } catch (error) {
      _write({
        'type': 'res',
        'id': id,
        'error': error is RemoteWebViewException
            ? error.message
            : error.toString(),
      });
    }
  }

  /// Fails every pending request; later sends are dropped.
  void close([Object? reason]) {
    if (_closed) return;
    _closed = true;
    final pending = _pending.values.toList();
    _pending.clear();
    for (final completer in pending) {
      completer.completeError(
        RemoteWebViewException(reason?.toString() ?? 'Channel closed'),
      );
    }
  }

  void _write(Map<String, Object?> message) {
    if (_closed) return;
    _send(jsonEncode(message));
  }
}
