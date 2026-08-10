import 'dart:async';
import 'dart:convert';
import 'package:mangayomi/eval/javascript/http.dart';
import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/modules/more/settings/general/providers/general_state_provider.dart';
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
      headers['user-agent'] = ref.watch(userAgentStateProvider);
    }
  }

  return headers;
}
