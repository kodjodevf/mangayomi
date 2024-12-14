import 'dart:async';
import 'package:mangayomi/src/rust/api/rhttp/http.dart' as rust;
import 'package:mangayomi/src/rust/lib.dart' as rust_lib;

/// A token that can be used to cancel an HTTP request.
/// This token must be passed to the request method.
class CancelToken {
  final _ref = Completer<rust_lib.CancellationToken>();

  bool _isCancelled = false;

  /// Whether the request has been cancelled.
  bool get isCancelled => _isCancelled;

  CancelToken? _delegated;

  CancelToken();

  void setRef(rust_lib.CancellationToken ref) {
    _ref.complete(ref);
  }

  /// Cancels the HTTP request.
  /// If the [CancelToken] is not passed to the request method,
  /// this method never finishes.
  Future<void> cancel() async {
    if (_delegated != null) {
      await _delegated!.cancel();
    } else {
      // We need to wait for the ref to be set.
      final ref = await _ref.future;

      await rust.cancelRequest(token: ref);
      _isCancelled = true;
    }
  }

  /// When a request is retried, a new [CancelToken] is created.
  /// To ensure that [cancel] is still working on the old token,
  /// a new token is created that gets cancelled
  /// when the old token is cancelled.
  CancelToken createDelegatedToken() {
    final delegated = CancelToken();
    _delegated = delegated;
    return delegated;
  }
}
