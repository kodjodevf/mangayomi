import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_source_baseurl.g.dart';

String buildSourceUrl(String baseUrl, String url) {
  final normalizedBase = baseUrl.trim().replaceFirst(RegExp(r'/+$'), '');
  final normalizedPath = url.trim().getUrlWithoutDomain;
  final separator = normalizedPath.startsWith('/') ? '' : '/';
  return '$normalizedBase$separator$normalizedPath';
}

@riverpod
String sourceBaseUrl(Ref ref, {required Source source}) {
  final service = getExtensionService(
    source,
    ref.read(androidProxyServerStateProvider),
  );
  try {
    return service.sourceBaseUrl;
  } finally {
    service.dispose();
  }
}
