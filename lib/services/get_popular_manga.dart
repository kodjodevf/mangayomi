import 'dart:async';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/eval/compiler/compiler.dart';
import 'package:mangayomi/eval/model/source_provider.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/eval/runtime/runtime.dart';
import 'package:mangayomi/sources/source_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_popular_manga.g.dart';

@riverpod
Future<MPages?> getPopularManga(
  GetPopularMangaRef ref, {
  required Source source,
  required int page,
}) async {
  MPages? popularManga;

  try {
    final bytecode =
        compilerEval(useTestSourceCode ? testSourceCode : source.sourceCode!);

    final runtime = runtimeEval(bytecode);

    var res = runtime.executeLib('package:mangayomi/main.dart', 'main');
    popularManga = await (res as MSourceProvider)
        .getPopular(source.toMSource(), page);
  } catch (e) {
    throw Exception(e);
  }

  return popularManga;
}
