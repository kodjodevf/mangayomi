import 'package:mangayomi/eval/dart/service.dart';
import 'package:mangayomi/models/source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'get_source_baseurl.g.dart';

@riverpod
String sourceBaseUrl(Ref ref, {required Source source}) {
  String? baseUrl;
  if (source.sourceCodeLanguage == SourceCodeLanguage.dart) {
    baseUrl = DartExtensionService(source).sourceBaseUrl;
  } else {}
  if (baseUrl == null || baseUrl.isEmpty) {
    baseUrl = source.baseUrl;
  }

  return baseUrl!;
}
