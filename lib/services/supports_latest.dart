import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'supports_latest.g.dart';

@riverpod
bool supportsLatest(Ref ref, {required Source source}) {
  final androidProxy = ref.read(androidProxyServerStateProvider);
  final service = getExtensionService(source, androidProxy);
  try {
    return service.supportsLatest;
  } finally {
    service.dispose();
  }
}
