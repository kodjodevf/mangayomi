import 'package:mangayomi/eval/dart/bridge/m_source.dart';
import 'package:mangayomi/eval/dart/compiler/compiler.dart';
import 'package:mangayomi/eval/dart/model/m_provider.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/eval/dart/runtime/runtime.dart';
import 'package:mangayomi/sources/source_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'supports_latest.g.dart';

@riverpod
bool supportsLatest(SupportsLatestRef ref, {required Source source}) {
  bool? supportsLatest;
  if (source.sourceCodeLanguage == SourceCodeLanguage.dart) {
    try {
      final bytecode =
          compilerEval(useTestSourceCode ? testSourceCode : source.sourceCode!);

      final runtime = runtimeEval(bytecode);

      var res = runtime.executeLib('package:mangayomi/main.dart', 'main',
          [$MSource.wrap(source.toMSource())]);
      supportsLatest = (res as MProvider).supportsLatest;
    } catch (e) {
      supportsLatest = true;
    }
  } else {
    supportsLatest = true;
  }
  return supportsLatest;
}
