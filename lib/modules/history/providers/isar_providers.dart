import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/update_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'isar_providers.g.dart';

@riverpod
Stream<List<History>> getAllHistoryStream(
  Ref ref, {
  required ItemType itemType,
  String search = "",
}) async* {
  yield* historyRepository.watchByItemTypeAndSearch(itemType, search);
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
  final mangaIdsStream = mangaRepository.watchIdsByItemTypeAndSearch(
    itemType,
    search,
  );

  await for (final mangaIds in mangaIdsStream) {
    yield* updateRepository.watchByMangaIds(mangaIds);
  }
}
