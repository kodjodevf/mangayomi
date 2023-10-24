import 'dart:async';
import 'package:mangayomi/eval/compiler/compiler.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/eval/bridge/m_manga.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/runtime/runtime.dart';
import 'package:mangayomi/sources/source_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_manga_detail.g.dart';

@riverpod
Future<MManga> getMangaDetail(
  GetMangaDetailRef ref, {
  required MManga manga,
  required Source source,
}) async {
  MManga? mangadetail;
  final bytecode =
      compilerEval(useTestSourceCode ? testSourceCode : source.sourceCode!);

  final runtime = runtimeEval(bytecode);
  runtime.args = [$MManga.wrap(manga)];

  var result = await runtime.executeLib('package:mangayomi/source_code.dart',
      source.isManga! ? 'getMangaDetail' : 'getAnimeDetail');
  try {
    if (result is $MManga) {
      final value = result.$reified;
      mangadetail = value;
    }
  } catch (_) {
    return manga;
  }
  return mangadetail!;
}
