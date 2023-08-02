import 'dart:async';
import 'package:mangayomi/eval/compiler/compiler.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/eval/bridge_class/manga_model.dart';
import 'package:mangayomi/eval/bridge_class/model.dart';
import 'package:mangayomi/eval/runtime/runtime.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_manga_detail.g.dart';

@riverpod
Future<MangaModel> getMangaDetail(
  GetMangaDetailRef ref, {
  required MangaModel manga,
  required Source source,
}) async {
  MangaModel? mangadetail;
  final bytecode = compilerEval(source.sourceCode!);

  final runtime = runtimeEval(bytecode);
  runtime.args = [
    $MangaModel.wrap(manga
      ..source = source.name
      ..lang = source.lang)
  ];

  var result = await runtime.executeLib('package:mangayomi/source_code.dart',
      source.isManga! ? 'getMangaDetail' : 'getAnimeDetail');
  try {
    if (result is $MangaModel) {
      final value = result.$reified;
      mangadetail = value;
    }
  } catch (_) {
    return manga;
  }
  return mangadetail!;
}
