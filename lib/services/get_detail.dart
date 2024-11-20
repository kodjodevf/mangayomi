import 'package:mangayomi/eval/dart/service.dart';
import 'package:mangayomi/eval/javascript/service.dart';
import 'package:mangayomi/eval/dart/model/m_manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'get_detail.g.dart';

@riverpod
Future<MManga> getDetail(
  Ref ref, {
  required String url,
  required Source source,
}) async {
  MManga? mangadetail;
  if (source.sourceCodeLanguage == SourceCodeLanguage.dart) {
    mangadetail = await DartExtensionService(source).getDetail(url);
  } else {
    mangadetail = await JsExtensionService(source).getDetail(url);
  }
  return mangadetail;
}
