import 'dart:convert';
import 'package:mangayomi/eval/dart/service.dart';
import 'package:mangayomi/eval/javascript/service.dart';
import 'package:mangayomi/eval/dart/model/filter.dart';
import 'package:mangayomi/eval/dart/model/m_pages.dart';
import 'package:mangayomi/models/source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'search.g.dart';

@riverpod
Future<MPages?> search(Ref ref,
    {required Source source,
    required String query,
    required int page,
    required List<dynamic> filterList}) async {
  MPages? manga;
  if (source.sourceCodeLanguage == SourceCodeLanguage.dart) {
    manga = await DartExtensionService(source).search(query, page, filterList);
  } else {
    manga = await JsExtensionService(source)
        .search(query, page, jsonEncode(filterValuesListToJson(filterList)));
  }
  return manga;
}
