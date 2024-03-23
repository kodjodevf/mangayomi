import 'dart:convert';

import 'package:mangayomi/eval/dart/bridge/m_source.dart';
import 'package:mangayomi/eval/javascript/service.dart';
import 'package:mangayomi/eval/dart/model/filter.dart';
import 'package:mangayomi/eval/dart/model/m_pages.dart';
import 'package:mangayomi/eval/dart/compiler/compiler.dart';
import 'package:mangayomi/eval/dart/model/m_provider.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/eval/dart/runtime/runtime.dart';
import 'package:mangayomi/sources/source_test.dart';

Future<MPages?> search(
    {required Source source,
    required String query,
    required int page,
    required List<dynamic> filterList}) async {
  MPages? manga;
  if (source.sourceCodeLanguage == SourceCodeLanguage.dart) {
    final bytecode =
        compilerEval(useTestSourceCode ? testSourceCode : source.sourceCode!);
    final runtime = runtimeEval(bytecode);
    var res = runtime.executeLib('package:mangayomi/main.dart', 'main',
        [$MSource.wrap(source.toMSource())]);
    try {
      manga =
          await (res as MProvider).search(query, page, FilterList(filterList));
    } catch (e) {
      throw Exception(e);
    }
  } else {
    manga = await JsExtensionService(source)
        .search(query, page, jsonEncode(filterValuesListToJson(filterList)));
  }
  return manga;
}
