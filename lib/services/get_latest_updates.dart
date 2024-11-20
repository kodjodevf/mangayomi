import 'package:mangayomi/eval/dart/service.dart';
import 'package:mangayomi/eval/javascript/service.dart';
import 'package:mangayomi/eval/dart/model/m_pages.dart';
import 'package:mangayomi/models/source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'get_latest_updates.g.dart';

@riverpod
Future<MPages?> getLatestUpdates(
  Ref ref, {
  required Source source,
  required int page,
}) async {
  MPages? latestUpdatesManga;
  if (source.sourceCodeLanguage == SourceCodeLanguage.dart) {
    latestUpdatesManga =
        await DartExtensionService(source).getLatestUpdates(page);
  } else {
    latestUpdatesManga =
        await JsExtensionService(source).getLatestUpdates(page);
  }
  return latestUpdatesManga;
}
