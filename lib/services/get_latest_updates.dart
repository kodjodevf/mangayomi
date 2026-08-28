import 'dart:math';

import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/services/isolate_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_latest_updates.g.dart';

@riverpod
Future<MPages?> getLatestUpdates(
  Ref ref, {
  required Source source,
  required int page,
}) async {
  if (source.name == "local" && source.lang == "") {
    final result =
        (await mangaRepository.getLocalByItemTypeSortedByDateAdded(
          source.itemType,
          max(0, page - 1) * 50,
          50,
        )).map((e) => MManga(name: e.name)).toList();
    return MPages(list: result, hasNextPage: true);
  }
  return getIsolateService.get<MPages?>(
    page: page,
    source: source,
    serviceType: 'getLatestUpdates',
    proxyServer: ref.read(androidProxyServerStateProvider),
  );
}
