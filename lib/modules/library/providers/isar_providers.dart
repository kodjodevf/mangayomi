import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'isar_providers.g.dart';

@riverpod
Stream<List<Manga>> getAllMangaStream(GetAllMangaStreamRef ref,
    {required int? categoryId, required ItemType itemType}) async* {
  yield* categoryId == null
      ? isar.mangas
          .filter()
          .idIsNotNull()
          .favoriteEqualTo(true)
          .and()
          .itemTypeEqualTo(itemType)
          .watch(fireImmediately: true)
      : isar.mangas
          .filter()
          .idIsNotNull()
          .favoriteEqualTo(true)
          .categoriesIsNotEmpty()
          .categoriesElementEqualTo(categoryId)
          .and()
          .itemTypeEqualTo(itemType)
          .watch(fireImmediately: true);
}

@riverpod
Stream<List<Manga>> getAllMangaWithoutCategoriesStream(
    GetAllMangaWithoutCategoriesStreamRef ref,
    {required ItemType itemType}) async* {
  yield* isar.mangas
      .filter()
      .idIsNotNull()
      .favoriteEqualTo(true)
      .categoriesIsEmpty()
      .and()
      .itemTypeEqualTo(itemType)
      .or()
      .idIsNotNull()
      .categoriesIsNull()
      .favoriteEqualTo(true)
      .and()
      .itemTypeEqualTo(itemType)
      .watch(fireImmediately: true);
}

@riverpod
Stream<List<Settings>> getSettingsStream(GetSettingsStreamRef ref) async* {
  yield* isar.settings
      .filter()
      .idIsNotNull()
      .and()
      .idEqualTo(227)
      .watch(fireImmediately: true);
}
