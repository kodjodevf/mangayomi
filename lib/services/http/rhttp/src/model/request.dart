import 'dart:typed_data';
import 'package:mangayomi/services/http/rhttp/src/client/rhttp_client.dart';
import 'package:mangayomi/services/http/rhttp/src/model/cancel_token.dart';
import 'package:mangayomi/services/http/rhttp/src/model/settings.dart';
import 'package:mangayomi/src/rust/api/rhttp/http.dart' as rust;

/// An HTTP request that can be used
/// on a client or statically.
class BaseHttpRequest {
  /// The HTTP method to use.
  final rust.HttpMethod method;

  /// The URL to request.
  final String url;

  /// Query parameters.
  /// This can be null, if there are no query parameters
  /// or if they are already part of the URL.
  final Map<String, String>? query;

  /// Headers to send with the request.
  final rust.HttpHeaders? headers;

  /// The body of the request.
  final Uint8List? body;

  /// The cancel token to use for the request.
  final CancelToken? cancelToken;

  /// Map that can be used to store additional information.
  /// Primarily used by interceptors.
  /// This is not const to allow for modifications.
  final Map<String, dynamic> additionalData = {};

  BaseHttpRequest(
      {required this.method,
      required this.url,
      required this.query,
      required this.headers,
      required this.body,
      required this.cancelToken});
}

/// An HTTP request with the information which client to use.
class HttpRequest extends BaseHttpRequest {
  /// The client to use for the request.
  final RhttpClient? client;

  /// The settings to use for the request.
  /// This is **only** used if [client] is `null`.
  final ClientSettings? settings;

  HttpRequest(
      {required this.client,
      required this.settings,
      required super.method,
      required super.url,
      required super.query,
      required super.headers,
      required super.body,
      required super.cancelToken});
}
