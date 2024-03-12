import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:mangayomi/eval/dart/bridge/m_source.dart';
import 'package:mangayomi/eval/dart/compiler/compiler.dart';
import 'package:mangayomi/eval/javascript/service.dart';
import 'package:mangayomi/eval/dart/model/m_provider.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/eval/dart/runtime/runtime.dart';
import 'package:mangayomi/sources/source_test.dart';

Future<List<dynamic>> getFilterList({required Source source}) async {
  List<dynamic> filterList = [];
  if (source.sourceCodeLanguage == SourceCodeLanguage.dart) {
    try {
      final bytecode =
          compilerEval(useTestSourceCode ? testSourceCode : source.sourceCode!);

      final runtime = runtimeEval(bytecode);

      var res = runtime.executeLib('package:mangayomi/main.dart', 'main',
          [$MSource.wrap(source.toMSource())]);
      filterList = (res as MProvider)
          .getFilterList()
          .map((e) => e is $Value ? e.$reified : e)
          .toList();
    } catch (_) {
      return [];
    }
  } else {
    filterList = (await JsExtensionService(source).getFilterList()).filters;
  }

  return filterList;
}
