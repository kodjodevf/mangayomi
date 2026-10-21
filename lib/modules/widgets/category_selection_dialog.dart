import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/repositories/category_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
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
      builder: (context, setState) => ShioriDialog(
        title: l10n.set_categories,
        content: SizedBox(
          width: double.maxFinite,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: context.height(0.55)),
            child: StreamBuilder(
              stream: categoryRepository.watchByItemType(itemType),
              builder: (context, snapshot) {
                final empty = ShioriEmptyState(
                  icon: Symbols.category_rounded,
                  title: l10n.library_no_category_exist,
                  compact: true,
                );
                if (!snapshot.hasData || snapshot.data!.isEmpty) return empty;
                var entries = (snapshot.data!
                  ..sort((a, b) => (a.pos ?? 0).compareTo(b.pos ?? 0)));
                if (isFavorite || isBulk) {
                  // When item is in library, hide hidden categories in list
                  entries = entries.where((e) => !(e.hide ?? false)).toList();
                }
                if (entries.isEmpty) return empty;
                return SuperListView.builder(
                  shrinkWrap: true,
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final category = entries[index];
                    final isSelected = categoryIds.contains(category.id);
                    if (!isBulk) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: ShioriSpace.s8),
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
                      padding: const EdgeInsets.only(bottom: ShioriSpace.s8),
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
        actions: [
          ShioriButton.quiet(
            icon: Symbols.edit_rounded,
            label: l10n.edit,
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
          ShioriButton.quiet(
            label: l10n.cancel,
            onPressed: () => Navigator.pop(context),
          ),
          ShioriButton(
            label: l10n.ok,
            onPressed: () {
              if (isBulk) {
                final now = DateTime.now().millisecondsSinceEpoch;
                for (var manga in bulkMangas) {
                  manga
                    ..categories = categoryIds
                    ..updatedAt = now;
                }
                mangaRepository.putAll(bulkMangas);
                ref.read(mangasListStateProvider.notifier).clear();
                ref.read(isLongPressedStateProvider.notifier).update(false);
              } else {
                if (!isFavorite) {
                  singleManga!.favorite = true;
                  singleManga.dateAdded = DateTime.now().millisecondsSinceEpoch;
                }
                singleManga.categories = categoryIds;
                mangaRepository.save(singleManga);
              }
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    ),
  );
}
