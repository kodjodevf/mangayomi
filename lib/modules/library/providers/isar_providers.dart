import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'isar_providers.g.dart';

@riverpod
Stream<List<Manga>> getAllMangaStream(GetAllMangaStreamRef ref,
    {required int? categoryId, required bool? isManga}) async* {
  yield* categoryId == null
      ? isar.mangas
          .filter()
          .idIsNotNull()
          .favoriteEqualTo(true)
          .and()
          .isMangaEqualTo(isManga)
          .watch(fireImmediately: true)
      : isar.mangas
          .filter()
          .idIsNotNull()
          .favoriteEqualTo(true)
          .categoriesIsNotEmpty()
          .categoriesElementEqualTo(categoryId)
          .and()
          .isMangaEqualTo(isManga)
          .watch(fireImmediately: true);
}

@riverpod
Stream<List<Manga>> getAllMangaWithoutCategoriesStream(
    GetAllMangaWithoutCategoriesStreamRef ref,
    {required bool? isManga}) async* {
  yield* isar.mangas
      .filter()
      .idIsNotNull()
      .favoriteEqualTo(true)
      .categoriesIsEmpty()
      .and()
      .isMangaEqualTo(isManga)
      .or()
      .idIsNotNull()
      .categoriesIsNull()
      .favoriteEqualTo(true)
      .and()
      .isMangaEqualTo(isManga)
      .watch(fireImmediately: true);
}
