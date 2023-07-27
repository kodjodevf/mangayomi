import 'dart:typed_data';
import 'package:dart_eval/dart_eval.dart';
import 'package:mangayomi/eval/bridge_class/manga_model.dart';
import 'package:mangayomi/eval/bridge_class/video_model.dart';
import 'package:mangayomi/eval/m_bridge.dart';

Uint8List compilerEval(String sourceCode) {
  final compiler = Compiler();
  compiler.defineBridgeClasses([
    $MBridge.$declaration,
    $MangaModel.$declaration,
    $VideoModel.$declaration
  ]);
  final program = compiler.compile({
    'package:mangayomi': {'main.dart': sourceCode}
  });

  final bytecode = program.write();
  return bytecode;
}
