import 'package:mangayomi/eval/compiler/compiler.dart';
import 'package:mangayomi/eval/model/m_provider.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/eval/runtime/runtime.dart';
import 'package:mangayomi/sources/source_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'supports_latest.g.dart';

@riverpod
bool supportsLatest(SupportsLatestRef ref, {required Source source}) {
  bool? supportsLatest;

  try {
    final bytecode =
        compilerEval(useTestSourceCode ? testSourceCode : source.sourceCode!);

    final runtime = runtimeEval(bytecode);

    var res = runtime.executeLib('package:mangayomi/main.dart', 'main');
    supportsLatest = (res as MProvider).supportsLatest;
  } catch (e) {
    supportsLatest = true;
  }

  return supportsLatest;
}
