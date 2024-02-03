import 'package:mangayomi/eval/bridge/m_source.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/eval/compiler/compiler.dart';
import 'package:mangayomi/eval/model/m_provider.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/eval/runtime/runtime.dart';
import 'package:mangayomi/sources/source_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'search.g.dart';

@riverpod
Future<MPages?> search(SearchRef ref,
    {required Source source,
    required String query,
    required int page,
    required List<dynamic> filterList}) async {
  MPages? manga;
  final bytecode =
      compilerEval(useTestSourceCode ? testSourceCode : source.sourceCode!);
  final runtime = runtimeEval(bytecode);
  var res = runtime.executeLib('package:mangayomi/main.dart', 'main',
      [$MSource.wrap(source.toMSource())]);
  try {
    manga =
        await (res as MProvider).search(query, page, FilterList(filterList));
  } catch (e) {
    throw Exception(e);
  }
  return manga;
}
