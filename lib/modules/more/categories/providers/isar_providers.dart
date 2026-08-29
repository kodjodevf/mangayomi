import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/repositories/category_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'isar_providers.g.dart';

@riverpod
Stream<List<Category>> getMangaCategorieStream(
  Ref ref, {
  required ItemType itemType,
}) async* {
  yield* categoryRepository.watchByItemTypeSimple(itemType);
}
