import 'package:mangayomi/utils/platform_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/collapsing_header.dart';
import 'package:mangayomi/modules/main_view/nav_groups.dart';
import 'package:mangayomi/modules/main_view/widgets/nav_group_switcher.dart';
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
import 'package:mangayomi/modules/library/widgets/library_update_runner.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/library_updater.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:mangayomi/modules/manga/widgets/manga_image_card_widget.dart';
import 'package:mangayomi/modules/widgets/tv_menu.dart';
import 'package:mangayomi/modules/library/widgets/library_entry_utils.dart';
import 'package:shiori/shiori.dart';

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

  /// Whether the library's switcher has scrolled out of sight; grouped, the
  /// title then names the media instead of the group.
  final ValueListenable<bool>? headerCollapsed;

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
    this.headerCollapsed,
  });

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  /// The library menu actions, shared by the popup off-TV and the centred TV
  /// menu.
  void _onLibraryMenu(
    BuildContext context,
    WidgetRef ref,
    int value,
    AsyncValue<List<Manga>> manga,
  ) {
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
          lang: randomManga.lang ?? '',
          mangaM: randomManga,
          source: randomManga.source ?? '',
          sourceId: randomManga.sourceId,
        );
      });
    } else if (value == 2) {
      showImportLocalDialog(context, itemType);
    } else if (value == 3 && itemType == ItemType.anime) {
      addTorrent(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLongPressed = ref.watch(isLongPressedStateProvider);
    final mangaIdsList = ref.watch(mangasListStateProvider);
    final allMangaStream = ref.watch(
      getAllMangaStreamProvider(categoryId: null, itemType: itemType),
    );
    final manga = allMangaStream.whenData((allMangas) {
      if (categoryId == null && !isCategory) {
        return allMangas;
      }
      if (categoryId == null) {
        return allMangas
            .where((m) => m.categories == null || m.categories!.isEmpty)
            .toList();
      }
      return allMangas
          .where((m) => m.categories?.contains(categoryId) ?? false)
          .toList();
    });
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
              spacing: ShioriSpace.s8,
              children: [
                Flexible(
                  child: ValueListenableBuilder<bool>(
                    valueListenable:
                        headerCollapsed ?? const AlwaysStoppedAnimation(false),
                    builder: (context, collapsed, _) => CollapsingTitle(
                      isGroupedNavRoute(ref, libraryRouteFor(itemType)) &&
                              !collapsed
                          ? navGroupTitle(context, libraryRouteFor(itemType))
                          : itemType.localized(l10n),
                      style: context.shiori.text.screenTitle.copyWith(
                        color: context.shiori.color.fg,
                      ),
                    ),
                  ),
                ),
                if (showNumbersOfItems)
                  EntryBadgeChip(label: numberOfItems.toString()),
              ],
            ),
      actions: [
        // Stop a running library update. Only shown while one is in progress.
        if (ref.watch(libraryUpdateProvider).running)
          IconButton(
            splashRadius: 20,
            tooltip: l10n.cancel,
            onPressed: () =>
                ref.read(libraryUpdateProvider.notifier).requestCancel(),
            icon: const Icon(Symbols.stop_circle_rounded),
          ),
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
                tooltip: MaterialLocalizations.of(context).searchFieldLabel,
                icon: const Icon(Symbols.search_rounded),
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
          tooltip: l10n.filter,
          // An active filter is the accent, filled, so a library that looks
          // short is never a mystery.
          icon: Icon(
            Symbols.filter_list_rounded,
            fill: isNotFiltering ? 0 : 1,
            color: isNotFiltering ? null : context.shiori.color.accentInk,
          ),
        ),
        // Torrent stream is anime-only, so the menu's values are not its
        // indices: keep label and value paired.
        if (isTv)
          Builder(
            builder: (context) {
              final entries = <(String, int)>[
                (context.l10n.update_library, 0),
                (l10n.open_random_entry, 1),
                (l10n.import, 2),
                if (itemType == ItemType.anime) (l10n.torrent_stream, 3),
              ];
              return IconButton(
                tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
                icon: const Icon(Symbols.more_vert_rounded),
                onPressed: () async {
                  final picked = await showTvMenu(
                    context,
                    title: l10n.library,
                    options: [for (final e in entries) TvMenuOption(e.$1)],
                  );
                  if (picked != null && context.mounted) {
                    _onLibraryMenu(context, ref, entries[picked].$2, manga);
                  }
                },
              );
            },
          )
        else
          ShioriMenuButton(
            tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
            items: [
              ShioriMenuItem(
                label: l10n.update_library,
                icon: Symbols.refresh_rounded,
                onSelected: () => _onLibraryMenu(context, ref, 0, manga),
              ),
              ShioriMenuItem(
                label: l10n.open_random_entry,
                icon: Symbols.shuffle_rounded,
                onSelected: () => _onLibraryMenu(context, ref, 1, manga),
              ),
              ShioriMenuItem(
                label: l10n.import,
                icon: Symbols.file_open_rounded,
                onSelected: () => _onLibraryMenu(context, ref, 2, manga),
              ),
              if (itemType == ItemType.anime)
                ShioriMenuItem(
                  label: l10n.torrent_stream,
                  icon: Symbols.podcasts_rounded,
                  onSelected: () => _onLibraryMenu(context, ref, 3, manga),
                ),
            ],
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
      color: context.shiori.color.ink0,
      child: AppBar(
        title: Text(context.l10n.n_selected(mangaIdsList.length)),
        backgroundColor: context.shiori.color.accent.withValues(
          alpha: Alphas.accentTint,
        ),
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          onPressed: () {
            ref.read(mangasListStateProvider.notifier).clear();
            ref
                .read(isLongPressedStateProvider.notifier)
                .update(!isLongPressed);
          },
          icon: const Icon(Symbols.close_rounded),
        ),
        actions: [
          IconButton(
            tooltip: MaterialLocalizations.of(context).selectAllButtonLabel,
            onPressed: () {
              for (var manga in data) {
                ref.read(mangasListStateProvider.notifier).selectAll(manga);
              }
            },
            icon: const Icon(Symbols.select_all_rounded),
          ),
          IconButton(
            tooltip: context.l10n.invert_selection,
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
            icon: const Icon(Symbols.flip_to_back_rounded),
          ),
        ],
      ),
    );
  }
}
