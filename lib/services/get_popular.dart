import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/eval/compiler/compiler.dart';
import 'package:mangayomi/eval/model/m_provider.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/eval/runtime/runtime.dart';
import 'package:mangayomi/services/isolate.dart';
import 'package:mangayomi/sources/source_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_popular.g.dart';

@riverpod
Future<MPages?> getPopular(
  GetPopularRef ref, {
  required Source source,
  required int page,
}) async {
  return await compute<RootIsolateToken, MPages?>((token) async {
    await initInIsolate(token);
    MPages? popularManga;

    try {
      final bytecode =
          compilerEval(useTestSourceCode ? testSourceCode : source.sourceCode!);

      final runtime = runtimeEval(bytecode);

      var res = runtime.executeLib('package:mangayomi/main.dart', 'main');
      popularManga =
          await (res as MProvider).getPopular(source.toMSource(), page);
    } catch (e) {
      throw Exception(e);
    }

    return popularManga;
  }, RootIsolateToken.instance!);
}
