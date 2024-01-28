import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/eval/compiler/compiler.dart';
import 'package:mangayomi/eval/model/m_provider.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/eval/runtime/runtime.dart';
import 'package:mangayomi/services/isolate.dart';
import 'package:mangayomi/sources/source_test.dart';

Future<MPages?> search(
    {required Source source,
    required String query,
    required int page,
    required List<dynamic> filterList}) async {
  return await compute<RootIsolateToken, MPages?>((token) async {
    await initInIsolate(token);
    MPages? manga;
    final bytecode =
        compilerEval(useTestSourceCode ? testSourceCode : source.sourceCode!);
    final runtime = runtimeEval(bytecode);
    var res = runtime.executeLib('package:mangayomi/main.dart', 'main');
    try {
      manga = await (res as MProvider)
          .search(source.toMSource(), query, page, FilterList(filterList));
    } catch (e) {
      throw Exception(e);
    }
    return manga;
  }, RootIsolateToken.instance!);
}
