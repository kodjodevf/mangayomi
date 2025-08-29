import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/library/widgets/list_tile_manga_category.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

void showCategorySelectionDialog({
  required BuildContext context,
  required WidgetRef ref,
  required ItemType itemType,
  Manga? singleManga,
  List<Manga>? bulkMangas,
}) {
  assert(
    (singleManga != null) ^ (bulkMangas != null),
    "Provide either singleManga or bulkMangas, not both.",
  );
  final l10n = l10nLocalizations(context)!;
  final bool isBulk = bulkMangas != null;
  final bool isFavorite = !isBulk && (singleManga!.favorite ?? false);
  List<int> categoryIds = [];
  if (!isBulk && isFavorite) {
    categoryIds = List<int>.from(singleManga.categories ?? []);
  }
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(l10n.set_categories),
        content: SizedBox(
          width: context.width(0.8),
          child: StreamBuilder(
            stream: isar.categorys
                .filter()
                .idIsNotNull()
                .and()
                .forItemTypeEqualTo(itemType)
                .watch(fireImmediately: true),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text(l10n.library_no_category_exist);
              }
              var entries = (snapshot.data!
                ..sort((a, b) => (a.pos ?? 0).compareTo(b.pos ?? 0)));
              if (isFavorite || isBulk) {
                // When item is in library, hide hidden categories in list
                entries = entries.where((e) => !(e.hide ?? false)).toList();
              }
              if (entries.isEmpty) return Text(l10n.library_no_category_exist);
              return SuperListView.builder(
                shrinkWrap: true,
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final category = entries[index];
                  final isSelected = categoryIds.contains(category.id);
                  if (!isBulk) {
                    return ListTileChapterFilter(
                      label: category.name!,
                      onTap: () {
                        setState(() {
                          isSelected
                              ? categoryIds.remove(category.id)
                              : categoryIds.add(category.id!);
                        });
                      },
                      type: isSelected ? 1 : 0,
                    );
                  }
                  return ListTileMangaCategory(
                    category: category,
                    categoryIds: categoryIds,
                    mangasList: bulkMangas,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          categoryIds.remove(category.id);
                        } else {
                          categoryIds.add(category.id!);
                        }
                      });
                    },
                    res: (res) {
                      if (res.isNotEmpty && !isSelected) {
                        categoryIds.add(category.id!);
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: Text(l10n.edit),
                onPressed: () {
                  context.push(
                    "/categories",
                    extra: (
                      true,
                      itemType == ItemType.manga
                          ? 0
                          : itemType == ItemType.anime
                          ? 1
                          : 2,
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
              Row(
                children: [
                  TextButton(
                    child: Text(l10n.cancel),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 15),
                  TextButton(
                    child: Text(l10n.ok),
                    onPressed: () {
                      isar.writeTxnSync(() {
                        if (isBulk) {
                          for (var manga in bulkMangas) {
                            manga.categories = categoryIds;
                            manga.updatedAt =
                                DateTime.now().millisecondsSinceEpoch;
                            isar.mangas.putSync(manga);
                          }
                        } else {
                          if (!isFavorite) {
                            singleManga!.favorite = true;
                            singleManga.dateAdded =
                                DateTime.now().millisecondsSinceEpoch;
                          }
                          singleManga.categories = categoryIds;
                          singleManga.updatedAt =
                              DateTime.now().millisecondsSinceEpoch;
                          isar.mangas.putSync(singleManga);
                        }
                        if (isBulk) {
                          ref.read(mangasListStateProvider.notifier).clear();
                          ref
                              .read(isLongPressedStateProvider.notifier)
                              .update(false);
                        }
                      });
                      if (context.mounted) Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
