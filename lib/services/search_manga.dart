import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/eval/compiler/compiler.dart';
import 'package:mangayomi/eval/model/source_provider.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/eval/runtime/runtime.dart';
import 'package:mangayomi/sources/source_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'search_manga.g.dart';

@riverpod
Future<MPages?> searchManga(
  SearchMangaRef ref, {
  required Source source,
  required String query,
  required int page,
}) async {
  MPages? manga;
  final bytecode =
      compilerEval(useTestSourceCode ? testSourceCode : source.sourceCode!);
  final runtime = runtimeEval(bytecode);
  var res = runtime.executeLib('package:mangayomi/main.dart', 'main');
  try {
    manga = await (res as MSourceProvider)
        .search(source.toMSource(), query, page);
  } catch (e) {
    throw Exception(e);
  }
  return manga;
}
