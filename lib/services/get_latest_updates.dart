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
part 'get_latest_updates.g.dart';

@riverpod
Future<MPages?> getLatestUpdates(
  GetLatestUpdatesRef ref, {
  required Source source,
  required int page,
}) async {
  return await compute<RootIsolateToken, MPages?>((token) async {
    await initInIsolate(token);
    MPages? latestUpdatesManga;

    try {
      final bytecode =
          compilerEval(useTestSourceCode ? testSourceCode : source.sourceCode!);

      final runtime = runtimeEval(bytecode);

      var res = await runtime.executeLib('package:mangayomi/main.dart', 'main');
      latestUpdatesManga =
          await (res as MProvider).getLatestUpdates(source.toMSource(), page);
    } catch (e) {
      throw Exception(e);
    }

    return latestUpdatesManga;
  }, RootIsolateToken.instance!);
}
