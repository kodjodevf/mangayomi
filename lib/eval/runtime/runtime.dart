import 'dart:typed_data';

import 'package:dart_eval/dart_eval.dart';
import 'package:mangayomi/eval/bridge/m_bridge.dart';
import 'package:mangayomi/eval/bridge/m_chapter.dart';
import 'package:mangayomi/eval/bridge/m_pages.dart';
import 'package:mangayomi/eval/bridge/m_status.dart';
import 'package:mangayomi/eval/bridge/source_provider.dart';
import 'package:mangayomi/eval/bridge/m_manga.dart';
import 'package:mangayomi/eval/bridge/m_source.dart';
import 'package:mangayomi/eval/bridge/m_track.dart';
import 'package:mangayomi/eval/bridge/m_video.dart';

Runtime runtimeEval(Uint8List bytecode) {
  final runtime = Runtime(bytecode.buffer.asByteData());
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MSourceProvider.', $MSourceProvider.$construct,
      isBridge: true);
  runtime.registerBridgeFunc(
      'package:mangayomi/bridge_lib.dart', 'MBridge.', $MBridge.$construct,
      isBridge: true);

  runtime.registerBridgeFunc(
      'package:mangayomi/bridge_lib.dart', 'MChapter.', $MChapter.$new);
  runtime.registerBridgeFunc(
      'package:mangayomi/bridge_lib.dart', 'MManga.', $MManga.$new);
  runtime.registerBridgeFunc(
      'package:mangayomi/bridge_lib.dart', 'MPages.', $MPages.$new);
  runtime.registerBridgeFunc(
      'package:mangayomi/bridge_lib.dart', 'MSource.', $MSource.$new);
  runtime.registerBridgeFunc(
      'package:mangayomi/bridge_lib.dart', 'MVideo.', $MVideo.$new);
  runtime.registerBridgeFunc(
      'package:mangayomi/bridge_lib.dart', 'MTrack.', $MTrack.$new);
  runtime.registerBridgeEnumValues(
      'package:mangayomi/bridge_lib.dart', 'MStatus', $MStatus.$values);
  runtime.registerBridgeFunc(
      'package:mangayomi/bridge_lib.dart', 'MBridge.http', $MBridge.$http);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.parseDates', $MBridge.$parseDates);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.gogoCdnExtractor', $MBridge.$gogoCdnExtractor);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.doodExtractor', $MBridge.$doodExtractor);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.rapidCloudExtractor', $MBridge.$rapidCloudExtractor);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.encryptAESCryptoJS', $MBridge.$encryptAESCryptoJS);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.decryptAESCryptoJS', $MBridge.$decryptAESCryptoJS);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.streamTapeExtractor', $MBridge.$streamTapeExtractor);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.streamWishExtractor', $MBridge.$streamWishExtractor);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.filemoonExtractor', $MBridge.$filemoonExtractor);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.mp4UploadExtractor', $MBridge.$mp4UploadExtractor);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.myTvExtractor', $MBridge.$myTvExtractor);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.sendVidExtractor', $MBridge.$sendVidExtractor);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.sibnetExtractor', $MBridge.$sibnetExtractor);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.okruExtractor', $MBridge.$okruExtractor);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.yourUploadExtractor', $MBridge.$yourUploadExtractor);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.voeExtractor', $MBridge.$voeExtractor);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.vidBomExtractor', $MBridge.$vidBomExtractor);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.streamlareExtractor', $MBridge.$streamlareExtractor);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.jsonPathToString', $MBridge.$jsonPathToString);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.toVideo', $MBridge.$toVideo);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.jsonPathToList', $MBridge.$jsonPathToList);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.jsonDecodeToList', $MBridge.$jsonDecodeToList);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.jsonPathToMap', $MBridge.$jsonPathToMap);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.parseStatus', $MBridge.$parseStatus);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.getMapValue', $MBridge.$getMapValue);
  runtime.registerBridgeFunc(
      'package:mangayomi/bridge_lib.dart', 'MBridge.regExp', $MBridge.$regExp);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.parseChapterDate', $MBridge.$parseChapterDate);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.substringAfter', $MBridge.$substringAfter);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.substringAfterLast', $MBridge.$substringAfterLast);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.substringBeforeLast', $MBridge.$substringBeforeLast);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.substringBefore', $MBridge.$substringBefore);
  runtime.registerBridgeFunc(
      'package:mangayomi/bridge_lib.dart', 'MBridge.evalJs', $MBridge.$evalJs);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.getHtmlViaWebview', $MBridge.$getHtmlViaWebview);
  runtime.registerBridgeFunc(
      'package:mangayomi/bridge_lib.dart', 'MBridge.xpath', $MBridge.$xpath);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.querySelector', $MBridge.$querySelector);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.deobfuscateJsPassword', $MBridge.$deobfuscateJsPassword);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.querySelectorAll', $MBridge.$querySelectorAll);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.cryptoHandler', $MBridge.$cryptoHandler);
  runtime.registerBridgeFunc('package:mangayomi/bridge_lib.dart',
      'MBridge.sortMapList', $MBridge.$sortMapList);
  runtime.setup();
  return runtime;
}
