import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'supports_latest.g.dart';

@riverpod
bool supportsLatest(Ref ref, {required Source source}) {
  return getExtensionService(
    source,
    ref.read(androidProxyServerStateProvider),
  ).supportsLatest;
}
