import 'dart:convert';
import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:js_packer/js_packer.dart';
import 'package:mangayomi/eval/dart/model/m_bridge.dart';
import 'package:mangayomi/utils/cryptoaes/js_unpacker.dart';

class JsUtils {
  late JavascriptRuntime runtime;
  JsUtils(this.runtime);

  init() {
    runtime.onMessage('cryptoHandler', (dynamic args) async {
      return MBridge.cryptoHandler(args[0], args[1], args[2], args[3]);
    });
    runtime.onMessage('encryptAESCryptoJS', (dynamic args) async {
      return MBridge.encryptAESCryptoJS(args[0], args[1]);
    });
    runtime.onMessage('decryptAESCryptoJS', (dynamic args) async {
      return MBridge.decryptAESCryptoJS(args[0], args[1]);
    });
    runtime.onMessage('deobfuscateJsPassword', (dynamic args) async {
      return MBridge.deobfuscateJsPassword(args[0]);
    });
    runtime.onMessage('unpackJsAndCombine', (dynamic args) async {
      return JsUnpacker.unpackAndCombine(args[0]) ?? "";
    });
    runtime.onMessage('unpackJs', (dynamic args) async {
      return JSPacker(args[0]).unpack() ?? "";
    });
    runtime.onMessage('parseDates', (dynamic args) async {
      return jsonEncode(MBridge.parseDates(args[0], args[1], args[2]));
    });

    runtime.evaluate('''
async function cryptoHandler(text, iv, secretKeyString, encrypt) {
    const result = await sendMessage(
        "cryptoHandler",
        JSON.stringify([text, iv, secretKeyString, encrypt])
    );
    return JSON.parse(result);
}
async function encryptAESCryptoJS(plainText, passphrase) {
    const result = await sendMessage(
        "encryptAESCryptoJS",
        JSON.stringify([plainText, passphrase])
    );
    return JSON.parse(result);
}
async function decryptAESCryptoJS(encrypted, passphrase) {
    const result = await sendMessage(
        "decryptAESCryptoJS",
        JSON.stringify([encrypted, passphrase])
    );
    return JSON.parse(result);
}
async function deobfuscateJsPassword(inputString) {
    const result = await sendMessage(
        "deobfuscateJsPassword",
        JSON.stringify([inputString])
    );
    return JSON.parse(result);
}
async function unpackJsAndCombine(scriptBlock) {
    const result = await sendMessage(
        "unpackJsAndCombine",
        JSON.stringify([scriptBlock])
    );
    return JSON.parse(result);
}
async function unpackJs(packedJS) {
    const result = await sendMessage(
        "unpackJs",
        JSON.stringify([packedJS])
    );
    return JSON.parse(result);
}
async function parseDates(value, dateFormat, dateFormatLocale) {
    const result = await sendMessage(
        "parseDates",
        JSON.stringify([value, dateFormat, dateFormatLocale])
    );
    return JSON.parse(result);
}
''');
  }
}
