import 'package:flutter/material.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_filter_list_tile_widget.dart';

class ListTileMangaCategory extends StatefulWidget {
  final Category category;
  final List<int> categoryIds;
  final List<Manga> mangasList;
  final Function(List<Manga>) res;
  final VoidCallback onTap;
  const ListTileMangaCategory(
      {super.key,
      required this.category,
      required this.mangasList,
      required this.res,
      required this.onTap,
      required this.categoryIds});

  @override
  State<ListTileMangaCategory> createState() => _ListTileMangaCategoryState();
}

class _ListTileMangaCategoryState extends State<ListTileMangaCategory> {
  @override
  void initState() {
    final res = widget.mangasList.where(
      (element) {
        return element.categories == null
            ? false
            : element.categories!.contains(widget.category.id);
      },
    ).toList();
    widget.res(res);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTileChapterFilter(
      label: widget.category.name!,
      onTap: widget.onTap,
      type: widget.categoryIds.contains(widget.category.id) ? 1 : 0,
    );
  }
}
