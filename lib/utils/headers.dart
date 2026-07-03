import 'dart:async';
import 'dart:convert';

import 'package:mangayomi/eval/javascript/http.dart';
import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/modules/more/settings/general/providers/general_state_provider.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'headers.g.dart';

/// Headers are static per source version, but computing them spins up a full
/// JS/Dart extension runtime. Cache them so widget builds never pay that cost.
final _sourceHeadersCache = <String, Map<String, String>>{};

@riverpod
Map<String, String> headers(
  Ref ref, {
  required String source,
  required String lang,
  required int? sourceId,
  String androidProxyServer = "",
}) {
  // Once the last listener drops, wait before actually disposing — this is
  // what covers rapid tab-switch unmount/remount without caching forever.
  // If a new listener shows up before the timer fires, onResume cancels it.
  final link = ref.keepAlive();
  Timer? timer;
  ref.onCancel(() {
    timer = Timer(const Duration(minutes: 5), link.close);
  });
  ref.onResume(() => timer?.cancel());
  ref.onDispose(() => timer?.cancel());
  final mSource = getSource(lang, source, sourceId);

  if (mSource == null) return {};

  final cacheKey =
      '${mSource.id}|${mSource.version}|${mSource.sourceCode?.hashCode}|$androidProxyServer';
  final base = _sourceHeadersCache.putIfAbsent(cacheKey, () {
    final headers = <String, String>{};
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
    return headers;
  });

  if (mSource.sourceCodeLanguage != SourceCodeLanguage.mihon) return base;

  final headers = Map<String, String>.of(base);
  headers['user-agent'] = isar.settings.getSync(227)!.userAgent!;
  return headers;
}
