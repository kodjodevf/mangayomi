import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/javascript/service.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/models/source.dart';

final sourceCatalogProvider = FutureProvider.autoDispose
    .family<MPages, ({Source source, String key, int page, bool latest})>((
      ref,
      request,
    ) async {
      final service = JsExtensionService(request.source);
      try {
        return await service.getSourcePage(
          request.key,
          request.page,
          latest: request.latest,
        );
      } finally {
        service.dispose();
      }
    });

Future<List<dynamic>> getCatalogFilters(Source source, String key) async {
  final service = JsExtensionService(source);
  try {
    return await service.getSourceFilters(key);
  } finally {
    service.dispose();
  }
}
