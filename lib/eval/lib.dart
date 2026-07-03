import 'package:mangayomi/eval/interface.dart';
import 'package:mangayomi/models/source.dart';

import 'dart/service.dart';
import 'javascript/service.dart';
import 'mihon/service.dart';
import 'lnreader/service.dart';

ExtensionService getExtensionService(Source source, String androidProxyServer) {
  return switch (source.sourceCodeLanguage) {
    SourceCodeLanguage.dart => DartExtensionService(source),
    SourceCodeLanguage.javascript => JsExtensionService(source),
    SourceCodeLanguage.mihon => MihonExtensionService(
      source,
      androidProxyServer,
    ),
    SourceCodeLanguage.lnreader => LNReaderExtensionService(source),
  };
}

/// Creating an extension service evaluates the entire extension source, which
/// is far too slow for UI-thread paths (headers, filters, preferences, ...).
/// This keeps a small pool of live services keyed by source version so those
/// paths pay the spin-up cost once. Returned instances are shared — callers
/// must NOT dispose them; evicted instances are disposed here.
const _cachedServiceLimit = 6;
final _serviceCache = <String, ExtensionService>{};

ExtensionService getCachedExtensionService(
  Source source,
  String androidProxyServer,
) {
  final key =
      '${source.id}|${source.version}|${source.sourceCode?.hashCode}|$androidProxyServer';
  final cached = _serviceCache.remove(key);
  if (cached != null) {
    _serviceCache[key] = cached; // re-insert as most recently used
    return cached;
  }
  final service = getExtensionService(source, androidProxyServer);
  _serviceCache[key] = service;
  if (_serviceCache.length > _cachedServiceLimit) {
    _serviceCache.remove(_serviceCache.keys.first)?.dispose();
  }
  return service;
}

Future<T> withExtensionService<T>(
  Source source,
  String proxyServer,
  Future<T> Function(ExtensionService service) action,
) async {
  final service = getExtensionService(source, proxyServer);
  try {
    return await action(service);
  } finally {
    service.dispose();
  }
}
