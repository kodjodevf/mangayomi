import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:js_packer/js_packer.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/utils/cryptoaes/js_unpacker.dart';
import 'package:mangayomi/utils/log/log.dart';

class JsUtils {
  late JavascriptRuntime runtime;
  JsUtils(this.runtime);

  void init() {
    runtime.onMessage('log', (dynamic args) {
      Logger.add(LoggerLevel.warning, "${args[0]}");
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
''');
  }
}
