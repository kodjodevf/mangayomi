import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'isar_providers.g.dart';

@riverpod
Stream<List<Manga>> getAllMangaStream(
  Ref ref, {
  required int? categoryId,
  required ItemType itemType,
}) {
  return mangaRepository.watchFavorites(itemType, categoryId: categoryId);
}

@riverpod
Stream<List<Manga>> getAllMangaWithoutCategoriesStream(
  Ref ref, {
  required ItemType itemType,
}) {
  return mangaRepository.watchFavoritesWithoutCategories(itemType);
}

@riverpod
Stream<Settings> getSettingsStream(Ref ref) {
  return settingsRepository.watch();
}
