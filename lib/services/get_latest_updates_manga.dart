import 'dart:async';
import 'package:mangayomi/eval/compiler/compiler.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/eval/bridge/m_manga.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/runtime/runtime.dart';
import 'package:mangayomi/sources/source_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_latest_updates_manga.g.dart';

@riverpod
Future<List<MManga?>> getLatestUpdatesManga(
  GetLatestUpdatesMangaRef ref, {
  required Source source,
  required int page,
}) async {
  List<MManga?>? latestUpdatesManga = [];
  try {
    final bytecode =
        compilerEval(useTestSourceCode ? testSourceCode : source.sourceCode!);

    final runtime = runtimeEval(bytecode);
    runtime.args = [$MManga.wrap(source.toMManga(page: page))];
    var res = await runtime.executeLib(
      'package:mangayomi/source_code.dart',
      source.isManga! ? 'getLatestUpdatesManga' : 'getLatestUpdatesAnime',
    );
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
            sourceId: value.sourceId,
            dateFormat: value.dateFormat,
            hasNextPage: value.hasNextPage ?? true,
            dateFormatLocale: value.dateFormatLocale);
        newManga.add(newMangaa);
      }
      latestUpdatesManga = newManga;
    } else {
      latestUpdatesManga =
          (res.$reified as List<dynamic>).map((e) => e as MManga).toList();
    }
  } catch (e) {
    throw Exception(e);
  }

  return latestUpdatesManga;
}
