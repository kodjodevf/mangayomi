import 'package:http/http.dart';
import 'package:mangayomi/services/http/rhttp/src/client/rhttp_client.dart';
import 'package:mangayomi/services/http/rhttp/src/model/exception.dart';
import 'package:mangayomi/services/http/rhttp/src/model/settings.dart';
import 'package:mangayomi/src/rust/api/rhttp/http.dart' as rust;

/// An HTTP client that is compatible with the `http` package.
/// This minimizes the changes needed to switch from `http` to `rhttp`
/// and also avoids vendor lock-in.
///
/// This comes with some downsides, such as:
/// - inferior type safety due to the flaw that `body` is of type `Object?`
///   instead of a sane supertype.
/// - body of type [Map] is implicitly interpreted as `x-www-form-urlencoded`
///   that is only documented in StackOverflow (as of writing this).
/// - no support for cancellation
/// - no out-of-the-box support for multipart requests
class RhttpCompatibleClient with BaseClient {
  /// The actual client that is used to make requests.
  final RhttpClient client;

  RhttpCompatibleClient._(this.client);

  /// Use this method if your app is starting up to simplify the code
  /// that might arise by using async/await.
  ///
  /// Note:
  /// This method crashes when configured to use HTTP/3.
  /// See: https://github.com/Tienisto/rhttp/issues/10
  factory RhttpCompatibleClient.createSync({
    ClientSettings? settings,
  }) {
    final client = RhttpClient.createSync(
      settings: (settings ?? const ClientSettings()).digest(),
    );
    return RhttpCompatibleClient._(client);
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    try {
      final response = await client.requestStream(
        method: switch (request.method) {
          'GET' => rust.HttpMethod.get_,
          'POST' => rust.HttpMethod.post,
          'PUT' => rust.HttpMethod.put,
          'PATCH' => rust.HttpMethod.patch,
          'DELETE' => rust.HttpMethod.delete,
          'HEAD' => rust.HttpMethod.head,
          'OPTIONS' => rust.HttpMethod.options,
          'TRACE' => rust.HttpMethod.trace,
          'CONNECT' => rust.HttpMethod.connect,
          _ => throw ArgumentError('Unsupported method: ${request.method}'),
        },
        url: request.url.toString(),
        headers: rust.HttpHeaders.map(request.headers),
        body: await request.finalize().toBytes(),
      );

      final responseHeaderMap = response.headerMap;

      return StreamedResponse(
        response.body,
        response.statusCode,
        contentLength: switch (responseHeaderMap['content-length']) {
          String s => int.parse(s),
          null => null,
        },
        request: request,
        headers: responseHeaderMap,
        isRedirect: false,
        persistentConnection: true,
        reasonPhrase: null,
      );
    } on RhttpException catch (e, st) {
      Error.throwWithStackTrace(
        RhttpWrappedClientException(e.toString(), request.url, e),
        st,
      );
    } catch (e, st) {
      Error.throwWithStackTrace(
        ClientException(e.toString(), request.url),
        st,
      );
    }
  }

  @override
  void close() {
    client.dispose(cancelRunningRequests: true);
  }
}

/// Every exception must be a subclass of [ClientException]
/// as per contract of [BaseClient].
class RhttpWrappedClientException extends ClientException {
  /// The original exception that was thrown by rhttp.
  final RhttpException rhttpException;

  RhttpWrappedClientException(super.message, super.uri, this.rhttpException);

  @override
  String toString() => rhttpException.toString();
}

extension on ClientSettings {
  /// Makes sure that the settings conform to the requirements of [BaseClient].
  ClientSettings digest() {
    ClientSettings settings = this;
    if (throwOnStatusCode) {
      settings = settings.copyWith(
        throwOnStatusCode: false,
      );
    }

    return settings;
  }
}
