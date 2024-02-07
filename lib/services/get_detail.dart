import 'dart:async';
import 'package:mangayomi/eval/bridge/m_source.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/compiler/compiler.dart';
import 'package:mangayomi/eval/model/m_provider.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/eval/runtime/runtime.dart';
import 'package:mangayomi/sources/source_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_detail.g.dart';

@riverpod
Future<MManga> getDetail(
  GetDetailRef ref, {
  required String url,
  required Source source,
}) async {
  MManga? mangadetail;
  final bytecode =
      compilerEval(useTestSourceCode ? testSourceCode : source.sourceCode!);

  final runtime = runtimeEval(bytecode);

  var res = await runtime.executeLib('package:mangayomi/main.dart', 'main',
      [$MSource.wrap(source.toMSource())]);
  try {
    mangadetail = await (res as MProvider).getDetail(url);
  } catch (e) {
    throw Exception(e);
  }
  return mangadetail;
}
