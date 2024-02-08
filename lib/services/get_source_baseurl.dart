import 'package:mangayomi/eval/bridge/m_source.dart';
import 'package:mangayomi/eval/compiler/compiler.dart';
import 'package:mangayomi/eval/model/m_provider.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/eval/runtime/runtime.dart';
import 'package:mangayomi/sources/source_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_source_baseurl.g.dart';

@riverpod
String sourceBaseUrl(SourceBaseUrlRef ref, {required Source source}) {
  String? baseUrl;

  try {
    final bytecode =
        compilerEval(useTestSourceCode ? testSourceCode : source.sourceCode!);

    final runtime = runtimeEval(bytecode);

    var res = runtime.executeLib('package:mangayomi/main.dart', 'main',
        [$MSource.wrap(source.toMSource())]);
    baseUrl = (res as MProvider).baseUrl;
  } catch (e) {
    baseUrl = source.baseUrl;
  }
  if (baseUrl == null || baseUrl.isEmpty) {
    baseUrl = source.baseUrl;
  }

  return baseUrl!;
}
