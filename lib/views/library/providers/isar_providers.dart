import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'isar_providers.g.dart';

@riverpod
Stream<List<ModelManga>> getAllMangaStream(GetAllMangaStreamRef ref,
    {required int? categoryId}) async* {
  yield* categoryId == null
      ? isar.modelMangas
          .filter()
          .idIsNotNull()
          .favoriteEqualTo(true)
          .watch(fireImmediately: true)
      : isar.modelMangas
          .filter()
          .idIsNotNull()
          .favoriteEqualTo(true)
          .categoriesIsNotEmpty()
          .categoriesElementEqualTo(categoryId)
          .watch(fireImmediately: true);
}
