import 'dart:typed_data';

import 'package:dart_eval/dart_eval.dart';
import 'package:mangayomi/eval/m_bridge.dart';
import 'package:mangayomi/eval/bridge_class/manga_model.dart';

Runtime runtimeEval(Uint8List bytecode) {
  final runtime = Runtime(bytecode.buffer.asByteData());
  runtime.registerBridgeFunc(
      'package:bridge_lib/bridge_lib.dart', 'MBridge.', $MBridge.$construct,
      isBridge: true);
  runtime.registerBridgeFunc(
      'package:bridge_lib/bridge_lib.dart', 'MangaModel.', $MangaModel.$new);
  runtime.registerBridgeFunc(
      'package:bridge_lib/bridge_lib.dart', 'MBridge.http', $MBridge.$http);
  runtime.registerBridgeFunc('package:bridge_lib/bridge_lib.dart',
      'MBridge.listParseDateTime', $MBridge.$listParseDateTime);
  runtime.registerBridgeFunc('package:bridge_lib/bridge_lib.dart',
      'MBridge.jsonPathToString', $MBridge.$jsonPathToString);
  runtime.registerBridgeFunc('package:bridge_lib/bridge_lib.dart',
      'MBridge.jsonPathToList', $MBridge.$jsonPathToList);
  runtime.registerBridgeFunc('package:bridge_lib/bridge_lib.dart',
      'MBridge.jsonDecodeToList', $MBridge.$jsonDecodeToList);
  runtime.registerBridgeFunc('package:bridge_lib/bridge_lib.dart',
      'MBridge.jsonPathToMap', $MBridge.$jsonPathToMap);
  runtime.registerBridgeFunc('package:bridge_lib/bridge_lib.dart',
      'MBridge.parseStatus', $MBridge.$parseStatus);
  runtime.registerBridgeFunc('package:bridge_lib/bridge_lib.dart',
      'MBridge.stringParseValue', $MBridge.$stringParseValue);
  runtime.registerBridgeFunc('package:bridge_lib/bridge_lib.dart',
      'MBridge.getMapValue', $MBridge.$getMapValue);
  runtime.registerBridgeFunc(
      'package:bridge_lib/bridge_lib.dart', 'MBridge.regExp', $MBridge.$regExp);
  runtime.registerBridgeFunc('package:bridge_lib/bridge_lib.dart',
      'MBridge.parseChapterDate', $MBridge.$parseChapterDate);
  runtime.registerBridgeFunc('package:bridge_lib/bridge_lib.dart',
      'MBridge.stringParse', $MBridge.$stringParse);
  runtime.registerBridgeFunc(
      'package:bridge_lib/bridge_lib.dart', 'MBridge.evalJs', $MBridge.$evalJs);
  runtime.registerBridgeFunc('package:bridge_lib/bridge_lib.dart',
      'MBridge.intParse', $MBridge.$intParse);
  runtime.registerBridgeFunc('package:bridge_lib/bridge_lib.dart',
      'MBridge.listParse', $MBridge.$listParse);
  runtime.registerBridgeFunc('package:bridge_lib/bridge_lib.dart',
      'MBridge.getHtmlViaWebview', $MBridge.$getHtmlViaWebview);
  runtime.registerBridgeFunc('package:bridge_lib/bridge_lib.dart',
      'MBridge.listContain', $MBridge.$listContain);
  runtime.registerBridgeFunc(
      'package:bridge_lib/bridge_lib.dart', 'MBridge.xpath', $MBridge.$xpath);
  runtime.registerBridgeFunc('package:bridge_lib/bridge_lib.dart',
      'MBridge.querySelector', $MBridge.$querySelector);
  runtime.registerBridgeFunc('package:bridge_lib/bridge_lib.dart',
      'MBridge.querySelectorAll', $MBridge.$querySelectorAll);
  runtime.setup();
  return runtime;
}
