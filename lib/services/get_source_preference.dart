import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:mangayomi/eval/dart/bridge/m_source.dart';
import 'package:mangayomi/eval/dart/compiler/compiler.dart';
import 'package:mangayomi/eval/javascript/service.dart';
import 'package:mangayomi/eval/dart/model/m_provider.dart';
import 'package:mangayomi/eval/dart/model/source_preference.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/eval/dart/runtime/runtime.dart';

List<SourcePreference> getSourcePreference({required Source source}) {
  List<SourcePreference> sourcePreference = [];

  try {
    final bytecode = compilerEval(source.sourceCode!);

    final runtime = runtimeEval(bytecode);

    var res = runtime.executeLib('package:mangayomi/main.dart', 'main',
        [$MSource.wrap(source.toMSource())]);
    sourcePreference = (res as MProvider)
        .getSourcePreferences()
        .map((e) => (e is $Value ? e.$reified : e) as SourcePreference)
        .toList();
  } catch (_) {
    return [];
  }

  return sourcePreference;
}

Future<List<SourcePreference>> getSourcePreferenceAsync(
    {required Source source}) async {
  List<SourcePreference> sourcePreference = [];
  if (source.sourceCodeLanguage == SourceCodeLanguage.dart) {
    try {
      final bytecode = compilerEval(source.sourceCode!);

      final runtime = runtimeEval(bytecode);

      var res = runtime.executeLib('package:mangayomi/main.dart', 'main',
          [$MSource.wrap(source.toMSource())]);
      sourcePreference = (res as MProvider)
          .getSourcePreferences()
          .map((e) => (e is $Value ? e.$reified : e) as SourcePreference)
          .toList();
    } catch (_) {
      return [];
    }
  } else {
    sourcePreference = await JsExtensionService(source).getSourcePreferences();
  }

  return sourcePreference;
}
