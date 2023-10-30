import 'dart:typed_data';
import 'package:dart_eval/dart_eval.dart';
import 'package:mangayomi/eval/bridge/m_bridge.dart';
import 'package:mangayomi/eval/bridge/m_chapter.dart';
import 'package:mangayomi/eval/bridge/m_manga.dart';
import 'package:mangayomi/eval/bridge/m_pages.dart';
import 'package:mangayomi/eval/bridge/m_source.dart';
import 'package:mangayomi/eval/bridge/m_status.dart';
import 'package:mangayomi/eval/bridge/m_track.dart';
import 'package:mangayomi/eval/bridge/m_video.dart';
import 'package:mangayomi/eval/bridge/source_provider.dart';
import 'package:mangayomi/eval/utils.dart';

Uint8List compilerEval(String code) {
  late Compiler compiler = Compiler();
  compiler.defineBridgeClasses([
    $MBridge.$declaration,
    $MSourceProvider.$declaration,
    $MPages.$declaration,
    $MSource.$declaration,
    $MVideo.$declaration,
    $MTrack.$declaration,
    $MChapter.$declaration,
    $MManga.$declaration,
  ]);
  compiler.defineBridgeEnum($MStatus.$declaration);
  final program = compiler.compile({
    'mangayomi': {'main.dart': code, 'utils.dart': utils}
  });

  final bytecode = program.write();
  return bytecode;
}
