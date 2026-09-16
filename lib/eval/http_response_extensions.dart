// Wire-serialization helpers shared by the eval backends' JS-bridge HTTP
// glue (eval/javascript/http.dart, eval/lnreader/http.dart): turning a
// package:http Response into the JSON shape the JS side expects, and
// normalizing whatever key/value types come back from the JS runtime's
// maps. Pure data mapping, so unlike the rest of that glue - which differs
// per backend in argument order and client-caching strategy - this part is
// safe to share.
import 'package:http/http.dart';

extension ResponseExtexsion on Response {
  Map<String, dynamic> toJson() => {
    'body': body,
    'headers': headers,
    'isRedirect': isRedirect,
    'persistentConnection': persistentConnection,
    'reasonPhrase': reasonPhrase,
    'statusCode': statusCode,
    'request': {
      'contentLength': request?.contentLength,
      'finalized': request?.finalized,
      'followRedirects': request?.followRedirects,
      'headers': request?.headers,
      'maxRedirects': request?.maxRedirects,
      'method': request?.method,
      'persistentConnection': request?.persistentConnection,
      'url': request?.url.toString(),
    },
  };
}

extension ToMapExtension on Map? {
  Map<String, dynamic>? get toMapStringDynamic {
    return this?.map((key, value) => MapEntry(key.toString(), value));
  }

  Map<String, String>? get toMapStringString {
    return this?.map(
      (key, value) => MapEntry(key.toString(), value.toString()),
    );
  }
}
