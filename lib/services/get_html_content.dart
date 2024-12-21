import 'package:mangayomi/eval/dart/service.dart';
import 'package:mangayomi/eval/javascript/service.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'get_html_content.g.dart';

@riverpod
Future<String> getHtmlContent(Ref ref, {required Chapter chapter}) async {
  if (!chapter.manga.isLoaded) {
    chapter.manga.loadSync();
  }
  final source =
      getSource(chapter.manga.value!.lang!, chapter.manga.value!.source!);
  String? html;
  if (source!.sourceCodeLanguage == SourceCodeLanguage.dart) {
    html = await DartExtensionService(source).getHtmlContent(chapter.url!);
  } else {
    html = await JsExtensionService(source).getHtmlContent(chapter.url!);
  }
  return '''<div id="readerViewContent"><div style="padding: 2em;">${html.substring(1, html.length - 1)}</div></div>'''
      .replaceAll("\\n", "")
      .replaceAll("\\t", "")
      .replaceAll("\\\"", "\"");
}
