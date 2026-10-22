import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/services/source_code_errors.dart';
import 'package:mangayomi/providers/browse_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'supports_latest.g.dart';

@riverpod
bool supportsLatest(Ref ref, {required Source source}) {
  final androidProxy = ref.read(androidProxyServerStateProvider);
  // Code that will not run has no Latest to offer; the source's home still
  // opens, rather than showing an error where its tabs go.
  try {
    return getCachedExtensionService(source, androidProxy).supportsLatest;
  } catch (e, stack) {
    SourceCodeErrors.report(source, 'Latest', e, stack);
    return false;
  }
}
