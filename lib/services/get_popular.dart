import 'package:mangayomi/eval/dart/service.dart';
import 'package:mangayomi/eval/javascript/service.dart';
import 'package:mangayomi/eval/dart/model/m_pages.dart';
import 'package:mangayomi/models/source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'get_popular.g.dart';

@riverpod
Future<MPages?> getPopular(
  Ref ref, {
  required Source source,
  required int page,
}) async {
  MPages? popularManga;
  if (source.sourceCodeLanguage == SourceCodeLanguage.dart) {
    popularManga = await DartExtensionService(source).getPopular(page);
  } else {
    popularManga = await JsExtensionService(source).getPopular(page);
  }

  return popularManga;
}
