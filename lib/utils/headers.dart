import 'dart:convert';
import 'package:mangayomi/eval/javascript/http.dart';
import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'headers.g.dart';

@riverpod
Map<String, String> headers(
  Ref ref, {
  required String source,
  required String lang,
  required int? sourceId,
  String androidProxyServer = "",
}) {
  final mSource = getSource(lang, source, sourceId);

  Map<String, String> headers = {};

  if (mSource != null) {
    final fromSource = mSource.headers;

    if (fromSource != null && fromSource.isNotEmpty) {
      headers.addAll((jsonDecode(fromSource) as Map).toMapStringString!);
    }
    final service = getExtensionService(mSource, androidProxyServer);
    try {
      headers.addAll(service.getHeaders());
    } finally {
      service.dispose();
    }
    if (mSource.sourceCodeLanguage == SourceCodeLanguage.mihon) {
      headers['user-agent'] = isar.settings.getSync(227)!.userAgent!;
    }
  }

  return headers;
}
