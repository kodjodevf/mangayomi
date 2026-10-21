import 'package:flutter/material.dart';
import 'package:mangayomi/modules/browse/providers/browse_initial_tab_provider.dart';
import 'package:mangayomi/modules/browse/browse_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/providers/isar_providers.dart';
import 'package:mangayomi/modules/library/providers/library_filter_provider.dart';
import 'package:mangayomi/modules/library/providers/library_source_badge_provider.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/library/widgets/library_gridview_widget.dart';
import 'package:mangayomi/modules/library/widgets/library_listview_widget.dart';
import 'package:mangayomi/modules/library/widgets/library_entry_utils.dart';
import 'package:mangayomi/modules/widgets/cover_grid_skeleton.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/library_updater.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';
import 'package:shiori/shiori.dart';

/// Displays the library body content for a given category (or uncategorized).
///
/// Uses [filteredLibraryMangaProvider] for cached, optimized filtering
/// instead of calling _filterAndSortManga inline (which was O(N*M) due to
/// per-chapter Isar queries).
class LibraryBody extends ConsumerWidget {
  final ItemType itemType;
  final int? categoryId;
  final bool withoutCategories;
  final int downloadFilterType;
  final int unreadFilterType;
  final int startedFilterType;
  final int bookmarkedFilterType;
  final int completedFilterType;
  final int trackingFilterType;
  final bool reverse;
  final bool downloadedChapter;
  final bool continueReaderBtn;
  final bool localSource;
  final bool language;
  final DisplayType displayType;
  final Settings settings;
  final bool downloadedOnly;
  final String searchQuery;
  final bool ignoreFiltersOnSearch;
  final List<String> sourceIds;

  const LibraryBody({
    super.key,
    required this.itemType,
    this.categoryId,
    this.withoutCategories = false,
    required this.downloadFilterType,
    required this.unreadFilterType,
    required this.startedFilterType,
    required this.bookmarkedFilterType,
    required this.completedFilterType,
    required this.trackingFilterType,
    required this.reverse,
    required this.downloadedChapter,
    required this.continueReaderBtn,
    required this.localSource,
    required this.language,
    required this.displayType,
    required this.settings,
    required this.downloadedOnly,
    required this.searchQuery,
    required this.ignoreFiltersOnSearch,
    required this.sourceIds,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    final sortType = ref
        .watch(
          sortLibraryMangaStateProvider(itemType: itemType, settings: settings),
        )
        .index;
    final mangaIdsList = ref.watch(mangasListStateProvider);
    final sourceBadge = ref.watch(librarySourceBadgeProvider);

    // Watch the global manga stream and filter by category in-memory,
    // avoiding N+1 active Isar database stream connections.
    final allMangaStream = ref.watch(
      getAllMangaStreamProvider(categoryId: null, itemType: itemType),
    );
    final mangaStream = allMangaStream.whenData((allMangas) {
      if (withoutCategories) {
        return allMangas
            .where((m) => m.categories == null || m.categories!.isEmpty)
            .toList();
      }
      if (categoryId != null) {
        return allMangas
            .where((m) => m.categories?.contains(categoryId) ?? false)
            .toList();
      }
      return allMangas;
    });

    return mangaStream.when(
      data: (data) {
        // Use the cached filtering provider instead of inline filtering
        final entries = ref.watch(
          filteredLibraryMangaProvider(
            data: data,
            downloadFilterType: downloadFilterType,
            unreadFilterType: unreadFilterType,
            startedFilterType: startedFilterType,
            bookmarkedFilterType: bookmarkedFilterType,
            completedFilterType: completedFilterType,
            trackingFilterType: trackingFilterType,
            sortType: sortType ?? 0,
            downloadedOnly: downloadedOnly,
            searchQuery: searchQuery,
            ignoreFiltersOnSearch: ignoreFiltersOnSearch,
            sourceIds: sourceIds,
            settings: settings,
          ),
        );

        if (entries.isEmpty) {
          // A search or a filter that matches nothing is not an empty
          // library; say which it is.
          final narrowed = searchQuery.isNotEmpty || data.isNotEmpty;
          return ShioriEmptyState(
            icon: narrowed
                ? Symbols.search_off_rounded
                : Symbols.collections_bookmark_rounded,
            title: narrowed ? l10n.no_result : l10n.empty_library,
            message: narrowed ? null : l10n.empty_library_hint,
            // An empty library leads somewhere: the sources for this media.
            actionLabel: narrowed ? null : l10n.browse,
            onAction: narrowed
                ? null
                : () {
                    ref
                        .read(browseInitialTabProvider.notifier)
                        .request(BrowseTab(itemType, BrowseTabKind.sources));
                    context.go('/browse');
                  },
          );
        }

        final entriesManga = reverse
            ? sortType == 3
                  ? sortByUnreadCount(
                      entries,
                      unreadCountOf: (manga) =>
                          manga.unreadChaptersCount(settings),
                      descending: true,
                    )
                  : entries.reversed.toList()
            : entries;
        return RefreshIndicator(
          onRefresh: () async {
            await updateLibrary(
              ref: ref,
              context: context,
              mangaList: data,
              itemType: itemType,
            );
          },
          child: displayType == DisplayType.list
              ? LibraryListViewWidget(
                  entriesManga: entriesManga,
                  continueReaderBtn: continueReaderBtn,
                  downloadedChapter: downloadedChapter,
                  language: language,
                  mangaIdsList: mangaIdsList,
                  localSource: localSource,
                  settings: settings,
                )
              : LibraryGridViewWidget(
                  entriesManga: entriesManga,
                  isCoverOnlyGrid: !(displayType == DisplayType.compactGrid),
                  isComfortableGrid: displayType == DisplayType.comfortableGrid,
                  continueReaderBtn: continueReaderBtn,
                  downloadedChapter: downloadedChapter,
                  language: language,
                  sourceBadge: sourceBadge,
                  mangaIdsList: mangaIdsList,
                  localSource: localSource,
                  itemType: itemType,
                  settings: settings,
                ),
        );
      },
      error: (error, _) => ErrorState(detail: error.toString()),
      loading: () => displayType == DisplayType.list
          ? ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (var i = 0; i < 8; i++) const ShioriSkeletonRow(),
              ],
            )
          : CoverGridSkeleton(
              gridSize: ref.watch(
                libraryGridSizeStateProvider(itemType: itemType),
              ),
              childAspectRatio: displayType == DisplayType.comfortableGrid
                  ? 0.642
                  : 0.69,
            ),
    );
  }
}

/// Badge showing the number of items in a category tab.
///
/// Uses the cached filtering provider for consistent results without
/// re-running the filter logic.
class CategoryBadge extends ConsumerWidget {
  final ItemType itemType;
  final int categoryId;
  final int downloadFilterType;
  final int unreadFilterType;
  final int startedFilterType;
  final int bookmarkedFilterType;
  final int completedFilterType;
  final int trackingFilterType;
  final Settings settings;
  final bool downloadedOnly;
  final String searchQuery;
  final bool ignoreFiltersOnSearch;
  final List<String> sourceIds;

  const CategoryBadge({
    super.key,
    required this.itemType,
    required this.categoryId,
    required this.downloadFilterType,
    required this.unreadFilterType,
    required this.startedFilterType,
    required this.bookmarkedFilterType,
    required this.completedFilterType,
    required this.trackingFilterType,
    required this.settings,
    required this.downloadedOnly,
    required this.searchQuery,
    required this.ignoreFiltersOnSearch,
    required this.sourceIds,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mangas = ref.watch(
      getAllMangaStreamProvider(categoryId: null, itemType: itemType),
    );
    final sortType = ref
        .watch(
          sortLibraryMangaStateProvider(itemType: itemType, settings: settings),
        )
        .index;

    return mangas.when(
      data: (allMangas) {
        final data = allMangas
            .where((m) => m.categories?.contains(categoryId) ?? false)
            .toList();
        final filtered = ref.watch(
          filteredLibraryMangaProvider(
            data: data,
            downloadFilterType: downloadFilterType,
            unreadFilterType: unreadFilterType,
            startedFilterType: startedFilterType,
            bookmarkedFilterType: bookmarkedFilterType,
            completedFilterType: completedFilterType,
            trackingFilterType: trackingFilterType,
            sortType: sortType ?? 0,
            downloadedOnly: downloadedOnly,
            searchQuery: searchQuery,
            ignoreFiltersOnSearch: ignoreFiltersOnSearch,
            sourceIds: sourceIds,
            settings: settings,
          ),
        );
        // The gap lives here so a tab with no badge keeps no trailing space.
        return Padding(
          padding: const EdgeInsetsDirectional.only(start: ShioriSpace.s4),
          child: EntryBadgeChip(label: filtered.length.toString()),
        );
      },
      error: (error, _) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}
