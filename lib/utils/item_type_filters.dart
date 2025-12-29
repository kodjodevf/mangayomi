import 'package:mangayomi/models/manga.dart';

List<ItemType> hiddenItemTypes(List<String> hideItems) {
  return [
    if (!hideItems.contains("/MangaLibrary")) ItemType.manga,
    if (!hideItems.contains("/AnimeLibrary")) ItemType.anime,
    if (!hideItems.contains("/NovelLibrary")) ItemType.novel,
  ];
}
