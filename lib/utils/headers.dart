import 'dart:convert';
import 'package:mangayomi/eval/javascript/http.dart';
import 'package:mangayomi/services/fetch_manga_sources.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/sources/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'headers.g.dart';

@riverpod
Map<String, String> headers(HeadersRef ref,
    {required String source, required String lang}) {
  final mSource = getSource(lang, source);
  if (mSource == null) return {};
  Map<String, String> headers = {};
  if (mSource.headers?.isNotEmpty ?? false) {
    headers = (jsonDecode(mSource.headers!) as Map).toMapStringString!;
  } else {
    headers = getSourceHeaders(mSource);
  }

  final cookies = MClient.getCookiesPref(mSource.baseUrl!);
  headers.addAll(cookies);

  return headers;
}
