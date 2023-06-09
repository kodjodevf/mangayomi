import 'dart:convert';
import 'package:dart_eval/stdlib/core.dart';
import 'package:mangayomi/eval/compiler/compiler.dart';
import 'package:mangayomi/eval/runtime/runtime.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
part 'fetch_sources.g.dart';

@riverpod
Future fetchSourcesList(FetchSourcesListRef ref, {int? id}) async {
  final req = await http
      .get(Uri.parse("https://kodjodevf.github.io/mangayomi-extensions/index.json"));
  final res = jsonDecode(req.body) as List;

  final sourceList = res.map((e) => Source.fromJson(e)).toList();

  isar.writeTxnSync(() async {
    for (var source in sourceList) {
      if (id != null) {
        if (id == source.id) {
          final sourc = isar.sources.getSync(id)!;
          final req = await http.get(Uri.parse(source.sourceCodeUrl!));
          final headers = await getHeaders(req.body, source.baseUrl!);
          isar.writeTxnSync(() {
            isar.sources.putSync(sourc
              ..headers = headers ?? ""
              ..isAdded = true
              ..sourceCode = req.body
              ..sourceCodeUrl = source.sourceCodeUrl
              ..id = id
              ..apiUrl = source.apiUrl
              ..baseUrl = source.baseUrl
              ..dateFormat = source.dateFormat
              ..dateFormatLocale = source.dateFormatLocale
              ..hasCloudflare = source.hasCloudflare
              ..iconUrl = source.iconUrl
              ..typeSource = source.typeSource
              ..lang = source.lang
              ..isNsfw = source.isNsfw
              ..name = source.name
              ..version = source.version
              ..versionLast = source.version);
          });
          // log("successfully installed");
        }
      } else if (isar.sources.getSync(source.id!) != null) {
        // log("exist");
        final sourc = isar.sources.getSync(source.id!)!;
        if (compareVersions(sourc.version!, source.version!) < 0) {
          // log("update aivalable auto update");
          if (isar.settings.getSync(227)!.autoUpdateExtensions ?? false) {
            final req = await http.get(Uri.parse(source.sourceCodeUrl!));
            final headers = await getHeaders(req.body, source.baseUrl!);
            isar.writeTxnSync(() {
              isar.sources.putSync(sourc
                ..headers = headers
                ..sourceCode = req.body
                ..sourceCodeUrl = source.sourceCodeUrl
                ..id = source.id
                ..apiUrl = source.apiUrl
                ..baseUrl = source.baseUrl
                ..dateFormat = source.dateFormat
                ..dateFormatLocale = source.dateFormatLocale
                ..hasCloudflare = source.hasCloudflare
                ..iconUrl = source.iconUrl
                ..typeSource = source.typeSource
                ..isFullData = source.isFullData
                ..lang = source.lang
                ..isNsfw = source.isNsfw
                ..name = source.name
                ..version = source.version
                ..versionLast = source.version);
            });
          } else {
            // log("update aivalable");
            isar.sources.putSync(sourc..versionLast = source.version);
          }
        }
      } else {
        isar.sources.putSync(Source()
          ..sourceCodeUrl = source.sourceCodeUrl
          ..id = source.id
          ..sourceCode = source.sourceCode
          ..apiUrl = source.apiUrl
          ..baseUrl = source.baseUrl
          ..dateFormat = source.dateFormat
          ..dateFormatLocale = source.dateFormatLocale
          ..hasCloudflare = source.hasCloudflare
          ..iconUrl = source.iconUrl
          ..typeSource = source.typeSource
          ..lang = source.lang
          ..isNsfw = source.isNsfw
          ..name = source.name
          ..version = source.version
          ..versionLast = source.version);
        // log("new source");
      }
    }
  });
}

int compareVersions(String version1, String version2) {
  List<String> v1Components = version1.split('.');
  List<String> v2Components = version2.split('.');

  for (int i = 0; i < v1Components.length && i < v2Components.length; i++) {
    int v1Value = int.parse(v1Components[i]);
    int v2Value = int.parse(v2Components[i]);

    if (v1Value < v2Value) {
      return -1;
    } else if (v1Value > v2Value) {
      return 1;
    }
  }

  if (v1Components.length < v2Components.length) {
    return -1;
  } else if (v1Components.length > v2Components.length) {
    return 1;
  }

  return 0;
}

Future<String?> getHeaders(String codeSource, String baseUrl) async {
  try {
    final bytecode = compilerEval(codeSource);
    final runtime = runtimeEval(bytecode);
    runtime.args = [$String(baseUrl)];
    var result2 = await runtime.executeLib(
      'package:package:mangayomi/main.dart',
      'getHeader',
    );
    Map<String, String> headers = {};
    if (result2 is $Map) {
      headers = result2.$reified
          .map((key, value) => MapEntry(key.toString(), value.toString()));
    }
    return jsonEncode(headers);
  } catch (_) {
    return null;
  }
}
