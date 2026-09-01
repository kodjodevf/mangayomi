import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:mangayomi/services/http/m_client.dart';
import 'package:wasd/wasd.dart';

import '../interpreter/memory_helper.dart';
import '../store/global_store.dart';
import 'html.dart';

enum NetMethod {
  get(0),
  post(1),
  put(2),
  head(3),
  delete(4);

  const NetMethod(this.value);
  final int value;

  static NetMethod fromValue(int val) {
    for (final m in values) {
      if (m.value == val) return m;
    }
    return NetMethod.get;
  }
}

class NetRequest {
  NetRequest({this.method = NetMethod.get});

  NetMethod method;
  String? url;
  final Map<String, String> headers = {};
  Uint8List? body;
  Duration timeout = const Duration(seconds: 30);

  http.Response? response;
  Uint8List? responseData;
  Object? responseError;

  Future<void> execute({http.Client? client}) async {
    if (url == null) {
      responseError = 'Missing URL';
      return;
    }
    final uri = Uri.parse(url!);
    final effectiveClient = client ?? http.Client();
    try {
      final req = http.Request(method.name.toUpperCase(), uri);
      req.headers.addAll(headers);
      if (body != null) {
        req.bodyBytes = body!;
      }
      final streamedResponse = await effectiveClient.send(req).timeout(timeout);
      final res = await http.Response.fromStream(streamedResponse);
      response = res;
      responseData = res.bodyBytes;
    } catch (e) {
      responseError = e;
    } finally {
      if (client == null) {
        effectiveClient.close();
      }
    }
  }
}

class NetImports {
  NetImports({
    required this.store,
    required this.memoryHelper,
    this.customRequestHandler,
  });

  final GlobalStore store;
  final MemoryHelper memoryHelper;
  final Future<http.Response> Function(http.Request request)?
  customRequestHandler;

  static const namespace = 'net';

  ModuleImports build() {
    return {
      'init': ImportExportKind.function((args) {
        final method = (args[0] as num).toInt();
        return initialize(method);
      }),
      'set_url': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        final value = (args[1] as num).toInt();
        final length = (args[2] as num).toInt();
        return setUrl(descriptor, value, length);
      }),
      'set_header': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        final key = (args[1] as num).toInt();
        final keyLength = (args[2] as num).toInt();
        final value = (args[3] as num).toInt();
        final valueLength = (args[4] as num).toInt();
        return setHeader(descriptor, key, keyLength, value, valueLength);
      }),
      'set_body': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        final value = (args[1] as num).toInt();
        final length = (args[2] as num).toInt();
        return setBody(descriptor, value, length);
      }),
      'set_timeout': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        final value = (args[1] as num).toDouble();
        return setTimeout(descriptor, value);
      }),
      'set_rate_limit': ImportExportKind.function((args) {
        return null;
      }),
      'send': ImportExportKind.function((args) async {
        final descriptor = (args[0] as num).toInt();
        return await send(descriptor);
      }),
      'send_all': ImportExportKind.function((args) async {
        final descriptors = (args[0] as num).toInt();
        final length = (args[1] as num).toInt();
        return await sendAll(descriptors, length);
      }),
      'data_len': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return dataLength(descriptor);
      }),
      'read_data': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        final buffer = (args[1] as num).toInt();
        final size = (args[2] as num).toInt();
        return readData(descriptor, buffer, size);
      }),
      'get_image': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return getImage(descriptor);
      }),
      'get_status_code': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return getStatusCode(descriptor);
      }),
      'get_url': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return getUrl(descriptor);
      }),
      'get_header': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        final key = (args[1] as num).toInt();
        final keyLength = (args[2] as num).toInt();
        return getHeader(descriptor, key, keyLength);
      }),
      'html': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return dataToHtml(descriptor);
      }),
    };
  }

  int initialize(int method) {
    final netMethod = NetMethod.fromValue(method);
    final request = NetRequest(method: netMethod);
    return store.store(request);
  }

  int setUrl(int descriptor, int value, int length) {
    final req = store.fetch(descriptor);
    if (req is! NetRequest) return -1; // invalidDescriptor
    if (value < 0 || length <= 0) return -2; // invalidString

    try {
      final urlStr = memoryHelper.readString(value, length);
      req.url = urlStr;
      return 0; // success
    } catch (_) {
      return -4; // invalidUrl
    }
  }

  int setHeader(
    int descriptor,
    int key,
    int keyLength,
    int value,
    int valueLength,
  ) {
    final req = store.fetch(descriptor);
    if (req is! NetRequest) return -1;
    if (key < 0 || keyLength <= 0 || value < 0 || valueLength <= 0) return -2;

    try {
      final keyStr = memoryHelper.readString(key, keyLength);
      final valueStr = memoryHelper.readString(value, valueLength);
      req.headers[keyStr] = valueStr;
      return 0;
    } catch (_) {
      return -2;
    }
  }

  int setBody(int descriptor, int value, int length) {
    final req = store.fetch(descriptor);
    if (req is! NetRequest) return -1;
    if (value < 0 || length <= 0) return -2;

    try {
      final bodyData = memoryHelper.readBytes(value, length);
      req.body = bodyData;
      return 0;
    } catch (_) {
      return -2;
    }
  }

  int setTimeout(int descriptor, double value) {
    final req = store.fetch(descriptor);
    if (req is! NetRequest) return -1;
    req.timeout = Duration(milliseconds: (value * 1000).toInt());
    return 0;
  }

  Future<int> send(int descriptor) async {
    final req = store.fetch(descriptor);
    if (req is! NetRequest) return -1;
    if (req.url == null) return -9; // missingUrl

    if (customRequestHandler != null) {
      try {
        final uri = Uri.parse(req.url!);
        final httpRequest = http.Request(req.method.name.toUpperCase(), uri);
        httpRequest.headers['User-Agent'] = 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148';
        httpRequest.headers['Accept'] = 'application/json, text/plain, */*';
        httpRequest.headers['Referer'] = '${uri.scheme}://${uri.host}/';
        httpRequest.headers['Origin'] = '${uri.scheme}://${uri.host}';
        httpRequest.headers.addAll(req.headers);
        if (req.body != null) httpRequest.bodyBytes = req.body!;
        final res = await customRequestHandler!(httpRequest);
        req.response = res;
        req.responseData = res.bodyBytes;
        return 0;
      } catch (e) {
        req.responseError = e;
        return -10;
      }
    }

    await req.execute(client: MClient.init());
    if (req.responseError != null) {
      return -10; // requestError
    }
    return 0; // success
  }

  Future<int> sendAll(int descriptors, int length) async {
    if (descriptors < 0 || length <= 0) return -1;

    final descriptorList = <int>[];
    for (var i = 0; i < length; i++) {
      descriptorList.add(memoryHelper.readInt32(descriptors + i * 4));
    }

    final futures = descriptorList.map((d) => send(d)).toList();
    final results = await Future.wait(futures);
    for (var i = 0; i < length; i++) {
      memoryHelper.writeInt32(descriptors + i * 4, results[i]);
    }

    return results.any((r) => r != 0) ? -10 : 0;
  }

  int dataLength(int descriptor) {
    final req = store.fetch(descriptor);
    if (req is! NetRequest) return -1;
    if (req.responseData == null) return -7; // missingData
    return req.responseData!.length;
  }

  int readData(int descriptor, int buffer, int size) {
    final req = store.fetch(descriptor);
    if (req is! NetRequest) return -1;
    final data = req.responseData;
    if (data == null) return -7;
    if (size > data.length) return -6; // invalidBufferSize

    try {
      memoryHelper.writeBytes(buffer, data.sublist(0, size));
      return 0;
    } catch (_) {
      return -11; // failedMemoryWrite
    }
  }

  int getImage(int descriptor) {
    final req = store.fetch(descriptor);
    if (req is! NetRequest) return -1;
    final data = req.responseData;
    if (data == null) return -7;
    return store.store(data);
  }

  int getStatusCode(int descriptor) {
    final req = store.fetch(descriptor);
    if (req is! NetRequest) return -1;
    if (req.response == null) return -8; // missingResponse
    return req.response!.statusCode;
  }

  int getUrl(int descriptor) {
    final req = store.fetch(descriptor);
    if (req is! NetRequest) return -1;
    final url = req.url ?? req.response?.request?.url.toString();
    if (url == null) return -9;
    return store.store(url);
  }

  int getHeader(int descriptor, int key, int keyLength) {
    final req = store.fetch(descriptor);
    if (req is! NetRequest) return -1;
    if (req.response == null) return -8;

    try {
      final keyStr = memoryHelper.readString(key, keyLength);
      final value = req.response!.headers[keyStr.toLowerCase()];
      if (value == null) return -7;
      return store.store(value);
    } catch (_) {
      return -2;
    }
  }

  int dataToHtml(int descriptor) {
    final req = store.fetch(descriptor);
    if (req is! NetRequest) return -1;
    final data = req.responseData;
    if (data == null) return -7;

    try {
      String htmlStr;
      try {
        htmlStr = utf8.decode(data);
      } catch (_) {
        htmlStr = latin1.decode(data);
      }
      final baseUrl = req.response?.request?.url.toString() ?? req.url;
      final doc = html_parser.parse(htmlStr, sourceUrl: baseUrl);
      if (baseUrl != null) {
        HtmlImports.docBaseUrls[doc] = baseUrl;
      }
      return store.store(doc);
    } catch (_) {
      return -5; // invalidHtml
    }
  }
}
