import 'dart:typed_data';
import 'package:dart_eval/dart_eval.dart';
import 'package:mangayomi/eval/bridge/m_manga.dart';
import 'package:mangayomi/eval/bridge/m_status.dart';
import 'package:mangayomi/eval/bridge/m_track.dart';
import 'package:mangayomi/eval/bridge/m_video.dart';
import 'package:mangayomi/eval/bridge/m_bridge.dart';
import 'package:mangayomi/eval/utils.dart';

Uint8List compilerEval(String sourceCode) {
  final compiler = Compiler();
  compiler.defineBridgeClasses([
    $MBridge.$declaration,
    $MManga.$declaration,
    $MVideo.$declaration,
    $MTrack.$declaration
  ]);
  compiler.defineBridgeEnum($MStatus.$declaration);
  final program = compiler.compile({
    'mangayomi': {'source_code.dart': sourceCode, 'utils.dart': utils}
  });

  final bytecode = program.write();
  return bytecode;
}
