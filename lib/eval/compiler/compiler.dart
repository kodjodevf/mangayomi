import 'dart:typed_data';
import 'package:dart_eval/dart_eval.dart';
import 'package:mangayomi/eval/bridge_class/manga_model.dart';
import 'package:mangayomi/eval/bridge_class/track_model.dart';
import 'package:mangayomi/eval/bridge_class/video_model.dart';
import 'package:mangayomi/eval/m_bridge.dart';
import 'package:mangayomi/eval/utils.dart';

Uint8List compilerEval(String sourceCode) {
  final compiler = Compiler();
  compiler.defineBridgeClasses([
    $MBridge.$declaration,
    $MangaModel.$declaration,
    $VideoModel.$declaration,
    $TrackModel.$declaration
  ]);
  final program = compiler.compile({
    'mangayomi': {'source_code.dart': sourceCode, 'utils.dart': utils}
  });

  final bytecode = program.write();
  return bytecode;
}
