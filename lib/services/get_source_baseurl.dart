import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_source_baseurl.g.dart';

@riverpod
String sourceBaseUrl(Ref ref, {required Source source}) {
  return getExtensionService(
    source,
    ref.read(androidProxyServerStateProvider),
  ).sourceBaseUrl;
}
