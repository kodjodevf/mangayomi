import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:mangayomi/eval/compiler/compiler.dart';
import 'package:mangayomi/eval/model/m_provider.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/eval/runtime/runtime.dart';
import 'package:mangayomi/sources/source_test.dart';

List<dynamic> getFilterList({required Source source}) {
  List<dynamic> filterList = [];

  try {
    final bytecode =
        compilerEval(useTestSourceCode ? testSourceCode : source.sourceCode!);

    final runtime = runtimeEval(bytecode);

    var res = runtime.executeLib('package:mangayomi/main.dart', 'main');
    filterList = (res as MProvider)
        .getFilterList(source.toMSource())
        .map((e) => e is $Value ? e.$reified : e)
        .toList();
  } catch (_) {
    return [];
  }

  return filterList;
}
