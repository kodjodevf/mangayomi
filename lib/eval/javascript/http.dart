import 'dart:convert';
import 'dart:io';
import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:http/http.dart' as http;

class JsHttpClient {
  late JavascriptRuntime runtime;
  JsHttpClient(this.runtime);

  void init() {
    InterceptedClient client(dynamic reqcopyWith) {
      return MClient.init(
          reqcopyWith: (reqcopyWith as Map?)?.toMapStringDynamic);
    }

    runtime.onMessage('http_get', (dynamic args) async {
      return await _toHttpResponse(client(args[1]), "GET", args);
    });
    runtime.onMessage('http_post', (dynamic args) async {
      return await _toHttpResponse(client(args[1]), "POST", args);
    });
    runtime.onMessage('http_put', (dynamic args) async {
      return await _toHttpResponse(client(args[1]), "PUT", args);
    });
    runtime.onMessage('http_delete', (dynamic args) async {
      return await _toHttpResponse(client(args[1]), "DELETE", args);
    });
    runtime.onMessage('http_patch', (dynamic args) async {
      return await _toHttpResponse(client(args[1]), "PATCH", args);
    });
    runtime.evaluate('''
class Client {
    constructor(reqcopyWith) {
        this.reqcopyWith = reqcopyWith;
    }
    async get(url, headers) {
        headers = headers;
        const result = await sendMessage(
            "http_get",
            JSON.stringify([null, this.reqcopyWith, url, headers])
        );
        return JSON.parse(result);
    }
    async post(url, headers, body) {
        headers = headers;
        const result = await sendMessage(
            "http_post",
            JSON.stringify([null, this.reqcopyWith, url, headers, body])
        );
        return JSON.parse(result);
    }
    async put(url, headers, body) {
        headers = headers;
        const result = await sendMessage(
            "http_post",
            JSON.stringify([null, this.reqcopyWith, url, headers, body])
        );
        return JSON.parse(result);
    }
    async delete(url, headers, body) {
        headers = headers;
        const result = await sendMessage(
            "http_post",
            JSON.stringify([null, this.reqcopyWith, url, headers, body])
        );
        return JSON.parse(result);
    }
    async patch(url, headers, body) {
        headers = headers;
        const result = await sendMessage(
            "http_post",
            JSON.stringify([null, this.reqcopyWith, url, headers, body])
        );
        return JSON.parse(result);
    }
}
''');
  }
}

Future<String> _toHttpResponse(Client client, String method, List args) async {
  final url = args[2] as String;
  final headers = (args[3] as Map?)?.toMapStringString;
  final body = args.length >= 5 ? (args[4] as Map?)?.toMapStringDynamic : null;
  var request = http.Request(method, Uri.parse(url));
  request.headers.addAll(headers ?? {});
  if ((request.headers[HttpHeaders.contentTypeHeader]
          ?.contains("application/json")) ??
      false) {
    request.body = json.encode(body);
    request.headers.addAll(headers ?? {});
    http.StreamedResponse response = await client.send(request);
    final res = Response("", response.statusCode,
        request: response.request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase);
    Map<String, dynamic> resMap = res.toJson();
    resMap["body"] = await response.stream.bytesToString();
    return jsonEncode(resMap);
  }
  final future = switch (method) {
    "GET" => client.get(Uri.parse(url), headers: headers),
    "POST" => client.post(Uri.parse(url), headers: headers, body: body),
    "PUT" => client.put(Uri.parse(url), headers: headers, body: body),
    "DELETE" => client.delete(Uri.parse(url), headers: headers, body: body),
    _ => client.patch(Uri.parse(url), headers: headers, body: body),
  };
  return jsonEncode((await future).toJson());
}

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
          'url': request?.url.toString()
        }
      };
}

extension ToMapExtension on Map? {
  Map<String, dynamic>? get toMapStringDynamic {
    return this?.map((key, value) => MapEntry(key.toString(), value));
  }

  Map<String, String>? get toMapStringString {
    return this
        ?.map((key, value) => MapEntry(key.toString(), value.toString()));
  }
}
