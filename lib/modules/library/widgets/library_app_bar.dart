import 'package:mangayomi/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/library_screen.dart';
import 'package:mangayomi/modules/library/providers/isar_providers.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/library/widgets/library_dialogs.dart';
import 'package:mangayomi/modules/library/widgets/library_settings_sheet.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/library_updater.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/global_style.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:mangayomi/modules/widgets/manga_image_card_widget.dart';

/// AppBar for the library screen.
///
/// Handles search mode, long-press selection mode, and the popup menu.
class LibraryAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final ItemType itemType;
  final bool isNotFiltering;
  final bool showNumbersOfItems;
  final int numberOfItems;
  final List<Manga> entries;
  final bool isCategory;
  final int? categoryId;
  final Settings settings;
  final bool isSearch;
  final bool ignoreFiltersOnSearch;
  final TextEditingController textEditingController;
  final VoidCallback onSearchToggle;
  final VoidCallback onSearchClear;
  final ValueChanged<bool> onIgnoreFiltersChanged;
  final TickerProvider vsync;

  const LibraryAppBar({
    super.key,
    required this.itemType,
    required this.isNotFiltering,
    required this.showNumbersOfItems,
    required this.numberOfItems,
    required this.entries,
    required this.isCategory,
    required this.categoryId,
    required this.settings,
    required this.isSearch,
    required this.ignoreFiltersOnSearch,
    required this.textEditingController,
    required this.onSearchToggle,
    required this.onSearchClear,
    required this.onIgnoreFiltersChanged,
    required this.vsync,
  });

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLongPressed = ref.watch(isLongPressedStateProvider);
    final mangaIdsList = ref.watch(mangasListStateProvider);
    final manga = categoryId == null
        ? ref.watch(
            getAllMangaWithoutCategoriesStreamProvider(itemType: itemType),
          )
        : ref.watch(
            getAllMangaStreamProvider(
              categoryId: categoryId,
              itemType: itemType,
            ),
          );
    final l10n = l10nLocalizations(context)!;

    if (isLongPressed) {
      return manga.when(
        data: (data) => _SelectionAppBar(
          itemType: itemType,
          mangaIdsList: mangaIdsList,
          data: data,
        ),
        error: (error, _) => ErrorText(error),
        loading: () => const ProgressCenter(),
      );
    }

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: isSearch
          ? null
          : Row(
              children: [
                Text(
                  itemType.localized(l10n),
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
                const SizedBox(width: 10),
                if (showNumbersOfItems)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Badge(
                      backgroundColor: Theme.of(context).focusColor,
                      label: Text(
                        numberOfItems.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodySmall!.color,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
      actions: [
        isSearch
            ? SeachFormTextField(
                onChanged: (_) => onSearchClear(),
                onPressed: onSearchToggle,
                controller: textEditingController,
                onSuffixPressed: () {
                  textEditingController.clear();
                  onSearchClear();
                },
              )
            : IconButton(
                splashRadius: 20,
                onPressed: () {
                  textEditingController.clear();
                  onSearchToggle();
                },
                icon: const Icon(Icons.search),
              ),
        // Checkbox when searching library to ignore filters
        if (isSearch)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isMobile
                    ? l10n.ignore_filters.replaceFirst(' ', '\n')
                    : l10n.ignore_filters.replaceAll('\n', ''),
                textAlign: TextAlign.center,
              ),
              Checkbox(
                value: ignoreFiltersOnSearch,
                onChanged: (val) {
                  onIgnoreFiltersChanged(val ?? false);
                },
              ),
            ],
          ),
        IconButton(
          splashRadius: 20,
          onPressed: () {
            showLibrarySettingsSheet(
              context: context,
              vsync: vsync,
              settings: settings,
              itemType: itemType,
              entries: entries,
            );
          },
          icon: Icon(
            Icons.filter_list_sharp,
            color: isNotFiltering ? null : Colors.yellow,
          ),
        ),
        PopupMenuButton(
          popUpAnimationStyle: popupAnimationStyle,
          itemBuilder: (context) {
            return [
              PopupMenuItem<int>(
                value: 0,
                child: Text(context.l10n.update_library),
              ),
              PopupMenuItem<int>(value: 1, child: Text(l10n.open_random_entry)),
              PopupMenuItem<int>(value: 2, child: Text(l10n.import)),
              if (itemType == ItemType.anime)
                PopupMenuItem<int>(value: 3, child: Text(l10n.torrent_stream)),
            ];
          },
          onSelected: (value) {
            if (value == 0) {
              manga.whenData((value) {
                updateLibrary(
                  ref: ref,
                  context: context,
                  mangaList: value,
                  itemType: itemType,
                );
              });
            } else if (value == 1) {
              manga.whenData((value) {
                var randomManga = (value..shuffle()).first;
                pushToMangaReaderDetail(
                  ref: ref,
                  archiveId: randomManga.isLocalArchive ?? false
                      ? randomManga.id
                      : null,
                  context: context,
                  lang: randomManga.lang!,
                  mangaM: randomManga,
                  source: randomManga.source!,
                  sourceId: randomManga.sourceId,
                );
              });
            } else if (value == 2) {
              showImportLocalDialog(context, itemType);
            } else if (value == 3 && itemType == ItemType.anime) {
              addTorrent(context);
            }
          },
        ),
      ],
    );
  }
}

/// AppBar shown when items are long-pressed for bulk selection.
class _SelectionAppBar extends ConsumerWidget {
  final ItemType itemType;
  final Set<int> mangaIdsList;
  final List<Manga> data;

  const _SelectionAppBar({
    required this.itemType,
    required this.mangaIdsList,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLongPressed = ref.watch(isLongPressedStateProvider);
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: AppBar(
        title: Text(mangaIdsList.length.toString()),
        backgroundColor: context.primaryColor.withValues(alpha: 0.2),
        leading: IconButton(
          onPressed: () {
            ref.read(mangasListStateProvider.notifier).clear();
            ref
                .read(isLongPressedStateProvider.notifier)
                .update(!isLongPressed);
          },
          icon: const Icon(Icons.clear),
        ),
        actions: [
          IconButton(
            onPressed: () {
              for (var manga in data) {
                ref.read(mangasListStateProvider.notifier).selectAll(manga);
              }
            },
            icon: const Icon(Icons.select_all),
          ),
          IconButton(
            onPressed: () {
              if (data.length == mangaIdsList.length) {
                for (var manga in data) {
                  ref.read(mangasListStateProvider.notifier).selectSome(manga);
                }
                ref.read(isLongPressedStateProvider.notifier).update(false);
              } else {
                for (var manga in data) {
                  ref.read(mangasListStateProvider.notifier).selectSome(manga);
                }
              }
            },
            icon: const Icon(Icons.flip_to_back_rounded),
          ),
        ],
      ),
    );
  }
}
