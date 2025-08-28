import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/javascript/http.dart';
import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/services/http/m_client.dart';
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

    headers.addAll(
      getExtensionService(mSource, androidProxyServer).getHeaders(),
    );
    headers.addAll(MClient.getCookiesPref(mSource.baseUrl!));
  }

  return headers;
}
