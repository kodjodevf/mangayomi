import 'package:dart_eval/stdlib/core.dart';
import 'package:mangayomi/eval/compiler/compiler.dart';
import 'package:mangayomi/eval/runtime/runtime.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'extension_preferences_providers.g.dart';

@riverpod
Future<Map<String, String>?> getMirrorPref(
    GetMirrorPrefRef ref, String codeSource) async {
  try {
    final bytecode = compilerEval(codeSource);
    final runtime = runtimeEval(bytecode);
    var res = await runtime.executeLib(
      'package:mangayomi/main.dart',
      'getMirrorPref',
    );
    Map<String, String> headers = {};
    if (res is $Map) {
      headers = res.$reified
          .map((key, value) => MapEntry(key.toString(), value.toString()));
    }
    return headers;
  } catch (_) {
    return null;
  }
}
