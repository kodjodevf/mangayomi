import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mangayomi/services/http/rhttp/src/model/exception.dart';
import 'package:mangayomi/services/http/rhttp/src/model/request.dart';
import 'package:mangayomi/services/http/rhttp/src/model/response.dart';
import 'package:mangayomi/services/http/rhttp/src/model/settings.dart';
import 'package:mangayomi/src/rust/api/rhttp/error.dart' as rust_error;
import 'package:mangayomi/src/rust/api/rhttp/http.dart' as rust;
import 'package:mangayomi/src/rust/lib.dart' as rust_lib;

/// Non-Generated helper function that is used by
/// the client and also by the static class.

Future<HttpResponse> requestInternalGeneric(HttpRequest request) async {
  if (request.client?.ref.isDisposed ?? false) {
    throw RhttpClientDisposedException(request);
  }

  final url = switch (request.settings?.baseUrl) {
    String baseUrl => baseUrl + request.url,
    null => request.url,
  };

  try {
    final cancelRefCompleter = Completer<rust_lib.CancellationToken>();
    final responseCompleter = Completer<rust.HttpResponse>();
    Stream<Uint8List> stream = rust.makeHttpRequestReceiveStream(
      client: request.client?.ref,
      settings: request.settings?.toRustType(),
      method: request.method,
      url: url,
      query: request.query?.entries.map((e) => (e.key, e.value)).toList(),
      headers: request.headers,
      body: request.body,
      onResponse: (r) => responseCompleter.complete(r),
      onError: (e) => responseCompleter.completeError(e),
      onCancelToken: (cancelRef) => cancelRefCompleter.complete(cancelRef),
      cancelable: request.cancelToken != null,
    );

    final cancelToken = request.cancelToken;
    if (cancelToken != null) {
      final cancelRef = await cancelRefCompleter.future;
      cancelToken.setRef(cancelRef);
    }

    final rustResponse = await responseCompleter.future;

    HttpResponse response = parseHttpResponse(
      request,
      rustResponse,
      bodyStream: stream,
    );

    return response;
  } catch (e, st) {
    if (e is rust_error.RhttpError) {
      RhttpException exception = parseError(request, e);
      Error.throwWithStackTrace(exception, st);
    } else {
      rethrow;
    }
  }
}
