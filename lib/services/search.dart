import 'package:isar/isar.dart';
import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'search.g.dart';

@riverpod
Future<MPages?> search(
  Ref ref, {
  required Source source,
  required String query,
  required int page,
  required List<dynamic> filterList,
}) async {
  if (source.name == "local" && source.lang == "") {
    final result =
        (await isar.mangas
                .filter()
                .group(
                  (q) => q
                      .sourceEqualTo("local")
                      .or()
                      .linkContains("Mangayomi/local")
                      .or()
                      .linkContains("Mangayomi\\local"),
                )
                .nameContains(query, caseSensitive: false)
                .offset(page * 50)
                .limit(50)
                .findAll())
            .map((e) => MManga(name: e.name))
            .toList();
    return MPages(list: result, hasNextPage: true);
  }
  return getExtensionService(
    source,
    ref.read(androidProxyServerStateProvider),
  ).search(query, page, filterList);
}
