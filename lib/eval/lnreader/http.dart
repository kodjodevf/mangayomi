import 'dart:convert';
import 'dart:io';
import 'package:d4rt/d4rt.dart';
import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:http/http.dart' as http;

class JsHttpClient {
  late JavascriptRuntime runtime;
  JsHttpClient(this.runtime);

  void init() {
    InterceptedClient client() {
      return MClient.init();
    }

    runtime.onMessage('http_head', (dynamic args) async {
      return await _toHttpResponse(client(), "HEAD", args);
    });
    runtime.onMessage('http_get', (dynamic args) async {
      return await _toHttpResponse(client(), "GET", args);
    });
    runtime.onMessage('http_post', (dynamic args) async {
      return await _toHttpResponse(client(), "POST", args);
    });
    runtime.onMessage('http_put', (dynamic args) async {
      return await _toHttpResponse(client(), "PUT", args);
    });
    runtime.onMessage('http_delete', (dynamic args) async {
      return await _toHttpResponse(client(), "DELETE", args);
    });
    runtime.onMessage('http_patch', (dynamic args) async {
      return await _toHttpResponse(client(), "PATCH", args);
    });
    runtime.evaluate('''
class Response {
  constructor(url, result) {
    this.url = url;
    this.response = JSON.parse(result);
  }
  get status() {
    return this.response.statusCode;
  }
  get statusText() {
    return this.response.reasonPhrase;
  }
  get ok() {
    return this.status >= 200 && this.status <= 299;
  }
  get redirected() {
    return this.response.isRedirect;
  }
  get headers() {
    return this.response.headers;
  }
  get body() {
    return this.response.body;
  }
  json() {
    const val = JSON.parse(this.body);
    return new Promise(function(resolve, reject) {
      resolve(val);
    });
  }
  text() {
    const val = this.body;
    return new Promise(function(resolve, reject) {
      resolve(val);
    });
  }
}

async function fetchApi(url, init) {
  const method = init?.method ? init.method.toLowerCase() : "get";
  const result = await sendMessage(
    "http_" + method,
    JSON.stringify([url, init?.headers, init?.body])
  );
  return new Response(url, result);
}
''');
  }
}

Future<String> _toHttpResponse(Client client, String method, List args) async {
  final url = args[0] as String;
  final headers = (args[1] as Map?)?.toMapStringString ?? {};
  final body = args.length >= 3
      ? args[2] is List
            ? args[2] as List
            : args[2] is String
            ? args[2] as String
            : (args[2] as Map?)?.toMapStringDynamic
      : null;
  var request = http.Request(method, Uri.parse(url));
  request.headers.addAll(headers);
  if ((request.headers[HttpHeaders.contentTypeHeader]?.contains(
        "application/json",
      )) ??
      false) {
    request.body = json.encode(body);
    request.headers.addAll(headers);
    http.StreamedResponse response = await client.send(request);
    final res = Response(
      "",
      response.statusCode,
      request: response.request,
      headers: response.headers,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      reasonPhrase: response.reasonPhrase,
    );
    Map<String, dynamic> resMap = res.toJson();
    resMap["body"] = await response.stream.bytesToString();
    return jsonEncode(resMap);
  }
  String? formData;
  if (body is Map && body.containsKey("_data")) {
    formData = (body.get("_data") as List<dynamic>)
        .map(
          (e) =>
              "${Uri.encodeQueryComponent(e[0])}"
              "=${Uri.encodeQueryComponent(e[1])}",
        )
        .join("&");
    headers["content-type"] =
        "application/x-www-form-urlencoded; charset=UTF-8";
  }
  final future = switch (method) {
    "HEAD" => client.head(Uri.parse(url), headers: headers),
    "GET" => client.get(Uri.parse(url), headers: headers),
    "POST" => client.post(
      Uri.parse(url),
      headers: headers,
      body: formData ?? body,
    ),
    "PUT" => client.put(
      Uri.parse(url),
      headers: headers,
      body: formData ?? body,
    ),
    "DELETE" => client.delete(
      Uri.parse(url),
      headers: headers,
      body: formData ?? body,
    ),
    _ => client.patch(Uri.parse(url), headers: headers, body: formData ?? body),
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
