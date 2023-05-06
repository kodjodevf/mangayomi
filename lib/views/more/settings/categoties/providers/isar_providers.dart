import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/categories.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'isar_providers.g.dart';

@riverpod
Stream<List<CategoriesModel>> getMangaCategorieStream(
  GetMangaCategorieStreamRef ref,
) async* {
  yield* isar.categoriesModels
      .filter()
      .idIsNotNull()
      .watch(fireImmediately: true);
}
