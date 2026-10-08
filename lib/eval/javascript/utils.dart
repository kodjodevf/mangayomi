import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:mangayomi/eval/javascript/js_common.dart';
import 'package:flutter_qjs/quickjs/ffi.dart';
import 'package:http/http.dart' as http;
import 'package:mangayomi/src/rust/api/epub.dart';
import 'package:path/path.dart' as p;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:js_packer/js_packer.dart';
import 'package:mangayomi/eval/http_response_extensions.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/services/http/hls_proxy.dart';
import 'package:mangayomi/utils/cryptoaes/js_unpacker.dart';

class JsUtils {
  late JavascriptRuntime runtime;
  JsUtils(this.runtime);

  void init() {
    registerJsCommon(runtime);
    InterceptedClient client() {
      return MClient.init();
    }

    runtime.onMessage('cryptoHandler', (dynamic args) {
      return MBridge.cryptoHandler(args[0], args[1], args[2], args[3]);
    });
    runtime.onMessage('encryptAESCryptoJS', (dynamic args) {
      return MBridge.encryptAESCryptoJS(args[0], args[1]);
    });
    runtime.onMessage('decryptAESCryptoJS', (dynamic args) {
      return MBridge.decryptAESCryptoJS(args[0], args[1]);
    });
    runtime.onMessage('decryptAESGCM', (dynamic args) {
      // tagHex is optional (empty when already appended); coerce null → "".
      return MBridge.decryptAESGCM(args[0], args[1], args[2], args[3] ?? '');
    });
    runtime.onMessage('deobfuscateJsPassword', (dynamic args) {
      return MBridge.deobfuscateJsPassword(args[0]);
    });
    runtime.onMessage('unpackJsAndCombine', (dynamic args) {
      return JsUnpacker.unpackAndCombine(args[0]) ?? "";
    });
    runtime.onMessage('unpackJs', (dynamic args) {
      return JSPacker(args[0]).unpack() ?? "";
    });
    runtime.onMessage('parseDates', (dynamic args) {
      final list = args[0] as List? ?? [];
      final format = args[1]?.toString() ?? '';
      final locale = args[2]?.toString() ?? '';
      return MBridge.parseDates(list, format, locale);
    });
    runtime.onMessage('evaluateJavascriptViaWebview', (dynamic args) async {
      return http
          .post(
            Uri.parse('http://localhost:$cfPort/evaluateJavascriptViaWebview'),
            headers: {HttpHeaders.contentTypeHeader: 'application/json'},
            body: jsonEncode({
              'url': args[0]!,
              'headers': (args[1]! as Map).toMapStringString!,
              'scripts': (args[2]! as List).map((e) => e.toString()).toList(),
              "time": args.length > 3 ? args[3] ?? 30 : 30,
            }),
          )
          .then((res) {
            if (res.statusCode == 200) {
              final data = jsonDecode(res.body) as Map<String, dynamic>;
              return data['result']?.toString() ?? '';
            }
            return '';
          });
    });
    runtime.onMessage('createHlsProxyUrl', (dynamic args) async {
      final url = args[0]?.toString() ?? '';
      final headers =
          (args.length > 1 ? args[1] as Map? : null)?.toMapStringString ??
          const <String, String>{};
      return HlsProxyService.instance.createUrl(url, headers);
    });
    runtime.onMessage('parseEpub', (dynamic args) async {
      final bytes = await _toBytesResponse(client(), "GET", args);
      final book = await parseEpubFromBytes(epubBytes: bytes, fullData: true);
      final List<String> chapters = [];
      for (var chapter in book.chapters) {
        final chapterTitle = chapter.name;
        chapters.add(chapterTitle);
      }
      return jsonEncode({
        "title": book.name,
        "author": book.author,
        "chapters": chapters,
      });
    });
    runtime.onMessage('parseEpubChapter', (dynamic args) async {
      final bytes = await _toBytesResponse(client(), "GET", args);
      final book = await parseEpubFromBytes(epubBytes: bytes, fullData: true);
      final chapter = book.chapters.firstWhereOrNull(
        (element) => element.name == args[3],
      );
      return chapter?.content;
    });

    runtime.evaluate('''
function cryptoHandler(text, iv, secretKeyString, encrypt) {
    return sendMessage(
        "cryptoHandler",
        JSON.stringify([text, iv, secretKeyString, encrypt])
    );
}
function encryptAESCryptoJS(plainText, passphrase) {
    return sendMessage(
        "encryptAESCryptoJS",
        JSON.stringify([plainText, passphrase])
    );
}
function decryptAESCryptoJS(encrypted, passphrase) {
    return sendMessage(
        "decryptAESCryptoJS",
        JSON.stringify([encrypted, passphrase])
    );
}
function decryptAESGCM(encrypted, keyHex, ivHex, tagHex = "") {
    return sendMessage(
        "decryptAESGCM",
        JSON.stringify([encrypted, keyHex, ivHex, tagHex])
    );
}
function deobfuscateJsPassword(inputString) {
    return sendMessage(
        "deobfuscateJsPassword",
        JSON.stringify([inputString])
    );
}
function unpackJsAndCombine(scriptBlock) {
    return sendMessage(
        "unpackJsAndCombine",
        JSON.stringify([scriptBlock])
    );
}
function unpackJs(packedJS) {
    return sendMessage(
        "unpackJs",
        JSON.stringify([packedJS])
    );
}
function parseDates(value, dateFormat, dateFormatLocale) {
    return sendMessage(
        "parseDates",
        JSON.stringify([value, dateFormat, dateFormatLocale])
    );
}
async function evaluateJavascriptViaWebview(url, headers, scripts, time = 30) {
    return await sendMessage(
        "evaluateJavascriptViaWebview",
        JSON.stringify([url, headers, scripts, time])
    );
}
async function createHlsProxyUrl(url, headers = {}) {
    return await sendMessage(
        "createHlsProxyUrl",
        JSON.stringify([url, headers])
    );
}
async function parseEpub(bookName, url, headers) {
    return JSON.parse(await sendMessage(
        "parseEpub",
        JSON.stringify([bookName, url, headers])
    ));
}
async function parseEpubChapter(bookName, url, headers, chapterTitle) {
    return await sendMessage(
        "parseEpubChapter",
        JSON.stringify([bookName, url, headers, chapterTitle])
    );
}
''');
  }

  Future<Uint8List> _toBytesResponse(
    http.Client client,
    String method,
    List args,
  ) async {
    final bookName = args[0] as String;
    final url = args[1] as String;
    final headers = (args[2] as Map?)?.toMapStringString;
    final body = args.length >= 4
        ? args[3] is List
              ? args[3] as List
              : args[3] is String
              ? args[3] as String
              : (args[3] as Map?)?.toMapStringDynamic
        : null;

    final tmpDirectory = (await StorageProvider().getTmpDirectory())!;
    if (Platform.isAndroid) {
      if (!(await File(p.join(tmpDirectory.path, ".nomedia")).exists())) {
        await File(p.join(tmpDirectory.path, ".nomedia")).create();
      }
    }
    final file = File(p.join(tmpDirectory.path, "$bookName.epub"));
    if (await file.exists()) {
      return await file.readAsBytes();
    }

    var request = http.Request(method, Uri.parse(url));
    request.headers.addAll(headers ?? {});
    final future = switch (method) {
      "GET" => client.get(Uri.parse(url), headers: headers),
      "POST" => client.post(Uri.parse(url), headers: headers, body: body),
      "PUT" => client.put(Uri.parse(url), headers: headers, body: body),
      "DELETE" => client.delete(Uri.parse(url), headers: headers, body: body),
      _ => client.patch(Uri.parse(url), headers: headers, body: body),
    };
    final bytes = (await future).bodyBytes;
    await file.writeAsBytes(bytes);
    return bytes;
  }
}
