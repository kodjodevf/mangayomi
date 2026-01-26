import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:flutter_qjs/quickjs/ffi.dart';
import 'package:http/http.dart' as http;
import 'package:mangayomi/src/rust/api/epub.dart';
import 'package:path/path.dart' as p;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:js_packer/js_packer.dart';
import 'package:mangayomi/eval/javascript/http.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/cryptoaes/js_unpacker.dart';
import 'package:mangayomi/utils/log/log.dart';

class JsUtils {
  late JavascriptRuntime runtime;
  JsUtils(this.runtime);

  void init() {
    InterceptedClient client() {
      return MClient.init();
    }

    runtime.onMessage('log', (dynamic args) {
      if (kDebugMode || useLogger) {
        // ignore: avoid_print
        print("LoggerLevel.warning:${args[0]}");
        Logger.add(LoggerLevel.warning, "${args[0]}");
      }

      return null;
    });
    runtime.onMessage('cryptoHandler', (dynamic args) {
      return MBridge.cryptoHandler(args[0], args[1], args[2], args[3]);
    });
    runtime.onMessage('encryptAESCryptoJS', (dynamic args) {
      return MBridge.encryptAESCryptoJS(args[0], args[1]);
    });
    runtime.onMessage('decryptAESCryptoJS', (dynamic args) {
      return MBridge.decryptAESCryptoJS(args[0], args[1]);
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
    runtime.onMessage('evaluateJavascriptViaWebview', (dynamic args) async {
      return await MBridge.evaluateJavascriptViaWebview(
        args[0]!,
        (args[1]! as Map).toMapStringString!,
        (args[2]! as List).map((e) => e.toString()).toList(),
      );
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
console.log = function (message) {
    if (typeof message === "object") {
         message = JSON.stringify(message);
      }
    sendMessage("log", JSON.stringify([message.toString()]));
};
console.warn = function (message) {
    if (typeof message === "object") {
         message = JSON.stringify(message);
      }
    sendMessage("log", JSON.stringify([message.toString()]));
};
console.error = function (message) {
    if (typeof message === "object") {
         message = JSON.stringify(message);
      }
    sendMessage("log", JSON.stringify([message.toString()]));
};
String.prototype.substringAfter = function(pattern) {
    const startIndex = this.indexOf(pattern);
    if (startIndex === -1) return this.substring(0);

    const start = startIndex + pattern.length;
    return this.substring(start);
}

String.prototype.substringAfterLast = function(pattern) {
    return this.split(pattern).pop();
}

String.prototype.substringBefore = function(pattern) {
    const endIndex = this.indexOf(pattern);
    if (endIndex === -1) return this.substring(0);

    return this.substring(0, endIndex);
}

String.prototype.substringBeforeLast = function(pattern) {
    const endIndex = this.lastIndexOf(pattern);
    if (endIndex === -1) return this.substring(0);
    return this.substring(0, endIndex);
}

String.prototype.substringBetween = function(left, right) {
    let startIndex = 0;
    let index = this.indexOf(left, startIndex);
    if (index === -1) return "";
    let leftIndex = index + left.length;
    let rightIndex = this.indexOf(right, leftIndex);
    if (rightIndex === -1) return "";
    startIndex = rightIndex + right.length;
    return this.substring(leftIndex, rightIndex);
}

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
async function evaluateJavascriptViaWebview(url, headers, scripts) {
    return await sendMessage(
        "evaluateJavascriptViaWebview",
        JSON.stringify([url, headers, scripts])
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
