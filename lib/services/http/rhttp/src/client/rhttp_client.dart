import 'dart:async';
import 'dart:typed_data';

import 'package:mangayomi/services/http/rhttp/src/model/cancel_token.dart';
import 'package:mangayomi/services/http/rhttp/src/model/request.dart';
import 'package:mangayomi/services/http/rhttp/src/model/response.dart';
import 'package:mangayomi/services/http/rhttp/src/model/settings.dart';
import 'package:mangayomi/services/http/rhttp/src/request.dart';
import 'package:mangayomi/src/rust/api/rhttp/client.dart' as rust_client;
import 'package:mangayomi/src/rust/api/rhttp/http.dart' as rust;

/// An HTTP client that is used to make requests.
/// Creating this is an expensive operation, so it is recommended to reuse it.
/// Internally, it holds a connection pool and other resources on the Rust side.
class RhttpClient {
  /// Settings for the client.
  final ClientSettings settings;

  /// Internal reference to the Rust client.

  final rust_client.RequestClient ref;

  const RhttpClient._({
    required this.settings,
    required this.ref,
  });

  /// Creates a new HTTP client synchronously.
  /// Use this method if your app is starting up to simplify the code
  /// that might arise by using async/await.
  ///
  /// Note:
  /// This method crashes when configured to use HTTP/3.
  /// See: https://github.com/Tienisto/rhttp/issues/10
  factory RhttpClient.createSync({
    ClientSettings? settings,
  }) {
    settings ??= const ClientSettings();
    final ref = rust.registerClientSync(
      settings: settings.toRustType(),
    );
    return RhttpClient._(
      settings: settings,
      ref: ref,
    );
  }

  /// Disposes the client.
  /// This frees the resources associated with the client.
  /// After calling this method, the client should not be used anymore.
  ///
  /// Note:
  /// This might improve performance but it is not necessary because the client
  /// is automatically disposed when the Dart object is garbage collected.
  void dispose({bool cancelRunningRequests = false}) async {
    if (ref.isDisposed) {
      return;
    }

    if (cancelRunningRequests) {
      await rust.cancelRunningRequests(client: ref);
    }
    ref.dispose();
  }

  /// Makes an HTTP request.
  /// Use [send] if you already have a [BaseHttpRequest] object.
  Future<HttpResponse> request(
          {required rust.HttpMethod method,
          required String url,
          Map<String, String>? query,
          required rust.HttpHeaders headers,
          Uint8List? body,
          CancelToken? cancelToken}) =>
      requestInternalGeneric(HttpRequest(
          client: this,
          settings: settings,
          method: method,
          url: url,
          query: query,
          headers: headers,
          body: body,
          cancelToken: cancelToken));

  /// Makes an HTTP request and returns the response as a stream.
  Future<HttpStreamResponse> requestStream(
      {required rust.HttpMethod method,
      required String url,
      Map<String, String>? query,
      required rust.HttpHeaders headers,
      Uint8List? body,
      CancelToken? cancelToken}) async {
    final response =
        await request(method: method, url: url, query: query, headers: headers, body: body, cancelToken: cancelToken);
    return response as HttpStreamResponse;
  }
}
