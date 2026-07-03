import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'isar_providers.g.dart';

@riverpod
Stream<List<Manga>> getAllMangaStream(
  Ref ref, {
  required int? categoryId,
  required ItemType itemType,
}) async* {
  // Use the composite index (favorite, itemType) via where() for an index scan
  // instead of a full-collection filter — orders of magnitude faster on large
  // libraries.
  yield* categoryId == null
      ? isar.mangas
            .where()
            .favoriteItemTypeEqualTo(true, itemType)
            .watch(fireImmediately: true)
      : isar.mangas
            .where()
            .favoriteItemTypeEqualTo(true, itemType)
            .filter()
            .categoriesIsNotEmpty()
            .categoriesElementEqualTo(categoryId)
            .watch(fireImmediately: true);
}

@riverpod
Stream<List<Manga>> getAllMangaWithoutCategoriesStream(
  Ref ref, {
  required ItemType itemType,
}) async* {
  // Use composite index for the primary filter; keep filter() only for the
  // secondary predicate (null/empty categories) which cannot use an index.
  yield* isar.mangas
      .where()
      .favoriteItemTypeEqualTo(true, itemType)
      .filter()
      .group((q) => q.categoriesIsEmpty().or().categoriesIsNull())
      .watch(fireImmediately: true);
}

@riverpod
Stream<List<Settings>> getSettingsStream(Ref ref) async* {
  yield* isar.settings.where().idEqualTo(227).watch(fireImmediately: true);
}
