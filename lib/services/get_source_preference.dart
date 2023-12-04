import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:mangayomi/eval/compiler/compiler.dart';
import 'package:mangayomi/eval/model/m_provider.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/eval/runtime/runtime.dart';

List<SourcePreference> getSourcePreference({required Source source}) {
  List<SourcePreference> sourcePreference = [];

  try {
    final bytecode = compilerEval(source.sourceCode!);

    final runtime = runtimeEval(bytecode);

    var res = runtime.executeLib('package:mangayomi/main.dart', 'main');
    sourcePreference = (res as MProvider)
        .getSourcePreferences(source.toMSource())
        .map((e) => (e is $Value ? e.$reified : e) as SourcePreference)
        .toList();
  } catch (_) {
    return [];
  }

  return sourcePreference;
}
