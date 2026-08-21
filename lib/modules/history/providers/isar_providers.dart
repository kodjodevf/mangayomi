import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'isar_providers.g.dart';

@riverpod
Stream<List<History>> getAllHistoryStream(
  Ref ref, {
  required ItemType itemType,
  String search = "",
}) async* {
  // idIsNotNull() removed — every Isar document has a non-null id.
  // The itemType hash-index on History + the link traversal does the filtering.
  yield* isar.historys
      .filter()
      .chapter(
        (q) => q.manga(
          (q) => q
              .itemTypeEqualTo(itemType)
              .and()
              .nameContains(search, caseSensitive: false),
        ),
      )
      .watch(fireImmediately: true);
}

@riverpod
Stream<List<Update>> getAllUpdateStream(
  Ref ref, {
  required ItemType itemType,
  String search = "",
}) async* {
  // Filtering via .chapter((q) => q.manga(...)) makes Isar walk and fully
  // deserialize the linked Chapter+Manga for every Update row on every watch
  // re-evaluation. Resolving matching manga ids up front (indexed) and
  // filtering Updates by mangaId (also indexed) avoids that link traversal.
  final mangaIdsStream = isar.mangas
      .filter()
      .itemTypeEqualTo(itemType)
      .nameContains(search, caseSensitive: false)
      .idProperty()
      .watch(fireImmediately: true);

  await for (final mangaIds in mangaIdsStream) {
    yield* isar.updates
        .filter()
        .anyOf(mangaIds, (q, int id) => q.mangaIdEqualTo(id))
        .watch(fireImmediately: true);
  }
}
