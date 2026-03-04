import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/providers/isar_providers.dart';
import 'package:mangayomi/modules/library/providers/library_filter_provider.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/library/widgets/library_gridview_widget.dart';
import 'package:mangayomi/modules/library/widgets/library_listview_widget.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/library_updater.dart';

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

    // Choose the right data stream based on whether this is a category tab
    final mangaStream = withoutCategories
        ? ref.watch(
            getAllMangaWithoutCategoriesStreamProvider(itemType: itemType),
          )
        : ref.watch(
            getAllMangaStreamProvider(
              categoryId: categoryId,
              itemType: itemType,
            ),
          );

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
          ),
        );

        if (entries.isEmpty) {
          return Center(child: Text(l10n.empty_library));
        }

        final entriesManga = reverse ? entries.reversed.toList() : entries;
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
                )
              : LibraryGridViewWidget(
                  entriesManga: entriesManga,
                  isCoverOnlyGrid: !(displayType == DisplayType.compactGrid),
                  isComfortableGrid: displayType == DisplayType.comfortableGrid,
                  continueReaderBtn: continueReaderBtn,
                  downloadedChapter: downloadedChapter,
                  language: language,
                  mangaIdsList: mangaIdsList,
                  localSource: localSource,
                  itemType: itemType,
                ),
        );
      },
      error: (error, _) => ErrorText(error),
      loading: () => const ProgressCenter(),
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
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mangas = ref.watch(
      getAllMangaStreamProvider(categoryId: categoryId, itemType: itemType),
    );
    final sortType = ref
        .watch(
          sortLibraryMangaStateProvider(itemType: itemType, settings: settings),
        )
        .index;

    return mangas.when(
      data: (data) {
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
          ),
        );
        return CircleAvatar(
          backgroundColor: Theme.of(context).focusColor,
          radius: 8,
          child: Text(
            filtered.length.toString(),
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).textTheme.bodySmall!.color,
            ),
          ),
        );
      },
      error: (error, _) => ErrorText(error),
      loading: () => const ProgressCenter(),
    );
  }
}
