import 'dart:convert';

import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/services/http_service/cloudflare/providers/cookie_providers.dart';
import 'package:mangayomi/sources/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'headers.g.dart';

@riverpod
Map<String, String> headers(HeadersRef ref,
    {required String source, required String lang}) {
  final sourceM = getSource(lang, source);
  if (sourceM.headers!.isEmpty) {
    return {};
  }
  Map<String, String> newHeaders = {};
  final headers = jsonDecode(sourceM.headers!) as Map;
  newHeaders =
      headers.map((key, value) => MapEntry(key.toString(), value.toString()));
  if (sourceM.hasCloudflare!) {
    final userAgent = isar.settings.getSync(227)!.userAgent!;
    final cookie = ref.watch(cookieStateProvider(source));
    newHeaders.addAll({'User-Agent': userAgent, "Cookie": cookie});
  }

  return newHeaders;
}
