import 'package:flutter/foundation.dart';
import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:mangayomi/utils/log/log.dart';

class JsLibs {
  late JavascriptRuntime runtime;
  JsLibs(this.runtime);

  void init() {
    runtime.onMessage('log', (dynamic args) {
      if (kDebugMode || useLogger) {
        // ignore: avoid_print
        print("LoggerLevel.warning:${args[0]}");
        Logger.add(LoggerLevel.warning, "${args[0]}");
      }
      return null;
    });
    runtime.onMessage('urlencode', (dynamic args) {
      return Uri.encodeComponent(args[0]);
    });
    runtime.onMessage('urldecode', (dynamic args) {
      return Uri.decodeComponent(args[0]);
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

async function jsonStringify(fn) {
    return JSON.stringify(await fn());
}

const isUrlAbsolute = url => {
  if (url) {
    if (url.indexOf("//") === 0) {
      return true
    } // URL is protocol-relative (= absolute)
    if (url.indexOf("://") === -1) {
      return false
    } // URL has no protocol (= relative)
    if (url.indexOf(".") === -1) {
      return false
    } // URL does not contain a dot, i.e. no TLD (= relative, possibly REST)
    if (url.indexOf("/") === -1) {
      return false
    } // URL does not contain a single slash (= relative)
    if (url.indexOf(":") > url.indexOf("/")) {
      return false
    } // The first colon comes after the first slash (= relative)
    if (url.indexOf("://") < url.indexOf(".")) {
      return true
    } // Protocol is defined before first dot (= absolute)
  }
  return false // Anything else must be relative
}

const NovelStatus = {
  "Unknown": "Unknown",
  "Ongoing": "Ongoing",
  "Completed": "Completed",
  "Licensed": "Licensed",
  "PublishingFinished": "Publishing Finished",
  "Cancelled": "Cancelled",
  "OnHiatus": "On Hiatus"
};

const FilterTypes = {
  "TextInput": "Text",
  "Picker": "Picker",
  "CheckboxGroup": "Checkbox",
  "Switch": "Switch",
  "ExcludableCheckboxGroup": "XCheckbox"
};

const isPickerValue = q => {
  return q.type === FilterTypes.Picker && typeof q.value === "string"
}

const isCheckboxValue = q => {
  return q.type === FilterTypes.CheckboxGroup && Array.isArray(q.value)
}

const isSwitchValue = q => {
  return q.type === FilterTypes.Switch && typeof q.value === "boolean"
}

const isTextValue = q => {
  return q.type === FilterTypes.TextInput && typeof q.value === "string"
}

const isXCheckboxValue = q => {
  return (
    q.type === FilterTypes.ExcludableCheckboxGroup &&
    typeof q.value === "object" &&
    !Array.isArray(q.value)
  )
}

function urlencode(input) {
    return sendMessage(
        "urlencode",
        JSON.stringify([input])
    );
}
function urldecode(input) {
    return sendMessage(
        "urldecode",
        JSON.stringify([input])
    );
}
''');
  }
}
