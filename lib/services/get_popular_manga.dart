import 'dart:async';
import 'package:mangayomi/eval/bridge/m_http_response.dart';
import 'package:mangayomi/eval/compiler/compiler.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/eval/bridge/m_manga.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/runtime/runtime.dart';
import 'package:mangayomi/sources/source_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_popular_manga.g.dart';

@riverpod
Future<List<MManga?>> getPopularManga(
  GetPopularMangaRef ref, {
  required Source source,
  required int page,
}) async {
  List<MManga> popularManga = [];
  final bytecode =
      compilerEval(useTestSourceCode ? testSourceCode : source.sourceCode!);

  final runtime = runtimeEval(bytecode);
  runtime.args = [$MManga.wrap(source.toMManga(page: page))];
  var res = await runtime.executeLib(
    'package:mangayomi/source_code.dart',
    source.isManga! ? 'getPopularManga' : 'getPopularAnime',
  );
  try {
    if (res is $MHttpResponse) {
      final value = res.$reified;
      if (value.hasError!) {
        throw value.body!;
      }
    }

    if (res is $MManga) {
      final value = res.$reified;
      List<MManga> newManga = [];
      for (var i = 0; i < value.names!.length; i++) {
        MManga newMangaa = MManga(
            name: value.names![i],
            link: value.urls![i],
            imageUrl: value.images!.isEmpty ? "" : value.images![i],
            baseUrl: value.baseUrl,
            apiUrl: value.apiUrl,
            lang: value.lang,
            status: value.status,
            dateFormat: value.dateFormat,
            hasNextPage: value.hasNextPage ?? true,
            dateFormatLocale: value.dateFormatLocale);
        newManga.add(newMangaa);
      }
      popularManga = newManga;
    } else {
      popularManga =
          (res.$reified as List<dynamic>).map((e) => e as MManga).toList();
    }
  } catch (e) {
    throw e.toString();
  }

  return popularManga;
}
