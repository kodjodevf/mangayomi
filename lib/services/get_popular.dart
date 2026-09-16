import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/services/isolate_service.dart';
import 'package:mangayomi/services/local_source_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_popular.g.dart';

@riverpod
Future<MPages?> getPopular(
  Ref ref, {
  required Source source,
  required int page,
}) async {
  if (source.name == "local" && source.lang == "") {
    return localSourcePage(
      (offset, limit) => mangaRepository.getLocalByItemTypeSortedByName(
        source.itemType,
        offset,
        limit,
      ),
      page,
    );
  }

  return getIsolateService.get<MPages?>(
    page: page,
    source: source,
    serviceType: 'getPopular',
    proxyServer: ref.read(androidProxyServerStateProvider),
  );
}
