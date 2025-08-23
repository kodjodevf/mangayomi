import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'get_detail.g.dart';

@riverpod
Future<MManga> getDetail(
  Ref ref, {
  required String url,
  required Source source,
}) async {
  return getExtensionService(
    source,
    ref.read(androidProxyServerStateProvider),
  ).getDetail(url);
}
