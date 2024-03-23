import 'dart:convert';
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
    headers = (jsonDecode(mSource.headers!) as Map)
        .map((key, value) => MapEntry(key.toString(), value.toString()));
  }

  final cookies = MClient.getCookiesPref(mSource.baseUrl!);
  headers.addAll(cookies);

  return headers;
}
