import 'package:flutter/foundation.dart';
import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:mangayomi/utils/log/log.dart';

/// What every extension runtime gets, Mangayomi and LNReader alike: console
/// output routed to the app log, and the Kotlin-style substring helpers.
void registerJsCommon(JavascriptRuntime runtime) {
  runtime.onMessage('log', (dynamic args) {
    if (kDebugMode || useLogger) {
      // ignore: avoid_print
      print("LoggerLevel.warning:${args[0]}");
      Logger.add(LoggerLevel.warning, "${args[0]}");
    }
    return null;
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
''');
}
