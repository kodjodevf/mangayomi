import 'dart:typed_data';
import 'package:dart_eval/dart_eval.dart';
import 'package:mangayomi/eval/dart/plugin.dart';

Uint8List compilerEval(String code) {
  late Compiler compiler = Compiler();
  final plugin = MEvalPlugin();
  compiler.addPlugin(plugin);
  final program = compiler.compile({
    'mangayomi': {'main.dart': code}
  });

  final bytecode = program.write();
  return bytecode;
}
