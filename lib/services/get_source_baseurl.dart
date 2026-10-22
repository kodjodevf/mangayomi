import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/services/source_code_errors.dart';
import 'package:mangayomi/providers/browse_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_source_baseurl.g.dart';

@riverpod
String sourceBaseUrl(Ref ref, {required Source source}) {
  // The one the source declares, when its code will not run to say.
  try {
    return getCachedExtensionService(
      source,
      ref.read(androidProxyServerStateProvider),
    ).sourceBaseUrl;
  } catch (e, stack) {
    SourceCodeErrors.report(source, 'Base URL', e, stack);
    return source.baseUrl ?? '';
  }
}
