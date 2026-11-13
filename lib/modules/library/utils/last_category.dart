import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';

/// The category tab [itemType]'s library was last left on, as a category id;
/// null for the first tab (Default when there is one).
int? lastLibraryCategoryId(Settings settings, ItemType itemType) =>
    switch (itemType) {
      ItemType.manga => settings.libraryLastCategoryIdMangas,
      ItemType.anime => settings.libraryLastCategoryIdAnime,
      ItemType.novel => settings.libraryLastCategoryIdNovel,
    };

void setLastLibraryCategoryId(
  Settings settings,
  ItemType itemType,
  int? categoryId,
) {
  switch (itemType) {
    case ItemType.manga:
      settings.libraryLastCategoryIdMangas = categoryId;
    case ItemType.anime:
      settings.libraryLastCategoryIdAnime = categoryId;
    case ItemType.novel:
      settings.libraryLastCategoryIdNovel = categoryId;
  }
}

/// The tab to show for [categoryId] among [tabCategoryIds], the library's
/// tabs in order (null for Default). Tabs are found by category rather than
/// by position, so adding, hiding or reordering categories, or the Default
/// tab coming and going, doesn't move the library onto another category.
/// [fallback] is used, clamped to the tabs, when that category has no tab.
int libraryTabIndexFor(
  List<int?> tabCategoryIds,
  int? categoryId, {
  int fallback = 0,
}) {
  if (tabCategoryIds.isEmpty) return 0;
  final index = tabCategoryIds.indexOf(categoryId);
  if (index != -1) return index;
  return fallback.clamp(0, tabCategoryIds.length - 1);
}
