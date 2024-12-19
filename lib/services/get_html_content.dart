import 'package:mangayomi/eval/dart/service.dart';
import 'package:mangayomi/eval/javascript/service.dart';
import 'package:mangayomi/models/source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'get_html_content.g.dart';

@riverpod
Future<String> getHtmlContent(
  Ref ref, {
  required String url,
  required Source source,
}) async {
  String? html;
  if (source.sourceCodeLanguage == SourceCodeLanguage.dart) {
    html = await DartExtensionService(source).getHtmlContent(url);
  } else {
    html = await JsExtensionService(source).getHtmlContent(url);
  }
  return html;
}
