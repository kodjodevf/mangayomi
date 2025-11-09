import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar_community/isar.dart';
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
      builder: (context, setState) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        child: Container(
          width: context.width(0.85),
          constraints: BoxConstraints(maxHeight: context.height(0.75)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.primaryColor.withValues(alpha: 0.05),
                Colors.transparent,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: context.primaryColor.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: context.primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.category_rounded,
                        color: context.primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.set_categories,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: context.primaryColor,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close_rounded,
                        color: context.primaryColor.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: StreamBuilder(
                    stream: isar.categorys
                        .filter()
                        .idIsNotNull()
                        .and()
                        .forItemTypeEqualTo(itemType)
                        .watch(fireImmediately: true),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.category_outlined,
                                size: 64,
                                color: Colors.grey.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                l10n.library_no_category_exist,
                                style: TextStyle(
                                  color: Colors.grey.withValues(alpha: 0.7),
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      var entries = (snapshot.data!
                        ..sort((a, b) => (a.pos ?? 0).compareTo(b.pos ?? 0)));
                      if (isFavorite || isBulk) {
                        // When item is in library, hide hidden categories in list
                        entries = entries
                            .where((e) => !(e.hide ?? false))
                            .toList();
                      }
                      if (entries.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.category_outlined,
                                size: 64,
                                color: Colors.grey.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                l10n.library_no_category_exist,
                                style: TextStyle(
                                  color: Colors.grey.withValues(alpha: 0.7),
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return SuperListView.builder(
                        shrinkWrap: true,
                        itemCount: entries.length,
                        itemBuilder: (context, index) {
                          final category = entries[index];
                          final isSelected = categoryIds.contains(category.id);
                          if (!isBulk) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: ListTileChapterFilter(
                                label: category.name!,
                                onTap: () {
                                  setState(() {
                                    isSelected
                                        ? categoryIds.remove(category.id)
                                        : categoryIds.add(category.id!);
                                  });
                                },
                                type: isSelected ? 1 : 0,
                              ),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: ListTileMangaCategory(
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
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              // Actions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: context.primaryColor.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.edit_rounded, size: 18),
                      label: Text(l10n.edit),
                      style: TextButton.styleFrom(
                        foregroundColor: context.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
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
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(l10n.cancel),
                        ),
                        const SizedBox(width: 12),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: context.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
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
                                ref
                                    .read(mangasListStateProvider.notifier)
                                    .clear();
                                ref
                                    .read(isLongPressedStateProvider.notifier)
                                    .update(false);
                              }
                            });
                            if (context.mounted) Navigator.pop(context);
                          },
                          child: Text(l10n.ok),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
