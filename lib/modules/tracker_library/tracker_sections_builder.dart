import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/manga/detail/providers/track_state_providers.dart';
import 'package:mangayomi/modules/tracker_library/tracker_library_section.dart';

/// Builds the list of library sections for the given tracker provider and item type.
List<TrackLibrarySection> buildTrackerSections({
  required WidgetRef ref,
  required TrackerProviders trackerProvider,
  required ItemType itemType,
  String? searchQuery,
}) {
  final syncId = trackerProvider.syncId;
  final sections = switch (syncId) {
    1 => _sectionsMAL(ref, syncId, itemType),
    2 => _sectionsAL(ref, syncId, itemType),
    3 => _sectionsKitsu(ref, syncId, itemType),
    4 => _sectionsSimkl(ref, syncId, itemType),
    5 => _sectionsTrakt(ref, syncId, itemType),
    _ => <TrackLibrarySection>[],
  };

  if (searchQuery != null && searchQuery.isNotEmpty) {
    sections.insert(
      0,
      TrackLibrarySection(
        name: "Search results",
        syncId: syncId,
        func: _fetchSearch(ref, syncId, searchQuery, itemType),
        itemType: itemType,
        isSearch: true,
      ),
    );
  }

  return sections;
}

List<TrackLibrarySection> _sectionsTrakt(
  WidgetRef ref,
  int syncId,
  ItemType itemType,
) {
  return [
    TrackLibrarySection(
      name: "Continue watching series",
      syncId: syncId,
      func: _fetchUserData(ref, syncId, ItemType.anime),
      itemType: ItemType.anime,
    ),
    TrackLibrarySection(
      name: "Watchlist series",
      syncId: syncId,
      func: _fetchWatchlistData(ref, syncId, ItemType.anime),
      itemType: ItemType.anime,
    ),
    TrackLibrarySection(
      name: "Continue watching movies",
      syncId: syncId,
      func: _fetchUserData(ref, syncId, ItemType.manga),
      itemType: ItemType.anime,
    ),
    TrackLibrarySection(
      name: "Watchlist movies",
      syncId: syncId,
      func: _fetchWatchlistData(ref, syncId, ItemType.manga),
      itemType: ItemType.anime,
    ),
    TrackLibrarySection(
      name: "Trending Series",
      syncId: syncId,
      func: _fetchGeneralData(ref, syncId, ItemType.anime),
      itemType: ItemType.anime,
    ),
    TrackLibrarySection(
      name: "Trending Movies",
      syncId: syncId,
      func: _fetchGeneralData(ref, syncId, ItemType.manga),
      itemType: ItemType.anime,
    ),
    TrackLibrarySection(
      name: "Popular Series",
      syncId: syncId,
      func: _fetchGeneralData(
        ref,
        syncId,
        ItemType.anime,
        rankingType: "popular",
      ),
      itemType: ItemType.anime,
    ),
    TrackLibrarySection(
      name: "Popular Movies",
      syncId: syncId,
      func: _fetchGeneralData(
        ref,
        syncId,
        ItemType.manga,
        rankingType: "popular",
      ),
      itemType: ItemType.anime,
    ),
    TrackLibrarySection(
      name: "Top Series (All Time)",
      syncId: syncId,
      func: _fetchGeneralData(
        ref,
        syncId,
        ItemType.anime,
        rankingType: "favorited/all",
      ),
      itemType: ItemType.anime,
    ),
    TrackLibrarySection(
      name: "Top Movies (All Time)",
      syncId: syncId,
      func: _fetchGeneralData(
        ref,
        syncId,
        ItemType.manga,
        rankingType: "favorited/all",
      ),
      itemType: ItemType.anime,
    ),
  ];
}

List<TrackLibrarySection> _sectionsSimkl(
  WidgetRef ref,
  int syncId,
  ItemType itemType,
) {
  return [
    TrackLibrarySection(
      name: "Continue watching movies",
      syncId: syncId,
      func: _fetchUserData(ref, syncId, ItemType.manga),
      itemType: ItemType.anime,
    ),
    TrackLibrarySection(
      name: "Continue watching series",
      syncId: syncId,
      func: _fetchUserData(ref, syncId, ItemType.anime),
      itemType: ItemType.anime,
    ),
    TrackLibrarySection(
      name: "Trending Movies",
      syncId: syncId,
      func: _fetchGeneralData(ref, syncId, ItemType.manga),
      itemType: ItemType.anime,
    ),
    TrackLibrarySection(
      name: "Trending Series",
      syncId: syncId,
      func: _fetchGeneralData(ref, syncId, ItemType.anime),
      itemType: ItemType.anime,
    ),
    TrackLibrarySection(
      name: "Airing Series",
      syncId: syncId,
      func: _fetchGeneralData(
        ref,
        syncId,
        ItemType.anime,
        rankingType: "airing",
      ),
      itemType: ItemType.anime,
    ),
    TrackLibrarySection(
      name: "Top Series (All Time)",
      syncId: syncId,
      func: _fetchGeneralData(ref, syncId, ItemType.anime, rankingType: "best"),
      itemType: ItemType.anime,
    ),
  ];
}

List<TrackLibrarySection> _sectionsMAL(
  WidgetRef ref,
  int syncId,
  ItemType itemType,
) {
  return itemType == ItemType.anime
      ? [
          TrackLibrarySection(
            name: "Continue watching",
            syncId: syncId,
            func: _fetchUserData(ref, syncId, ItemType.anime),
            itemType: ItemType.anime,
          ),
          TrackLibrarySection(
            name: "Airing Anime",
            syncId: syncId,
            func: _fetchGeneralData(ref, syncId, ItemType.anime),
            itemType: ItemType.anime,
          ),
          TrackLibrarySection(
            name: "Popular Anime",
            syncId: syncId,
            func: _fetchGeneralData(
              ref,
              syncId,
              ItemType.anime,
              rankingType: "bypopularity",
            ),
            itemType: ItemType.anime,
          ),
          TrackLibrarySection(
            name: "Upcoming Anime",
            syncId: syncId,
            func: _fetchGeneralData(
              ref,
              syncId,
              ItemType.anime,
              rankingType: "upcoming",
            ),
            itemType: ItemType.anime,
          ),
        ]
      : [
          TrackLibrarySection(
            name: "Continue reading",
            syncId: syncId,
            func: _fetchUserData(ref, syncId, ItemType.manga),
          ),
          TrackLibrarySection(
            name: "Popular Manga",
            syncId: syncId,
            func: _fetchGeneralData(
              ref,
              syncId,
              ItemType.manga,
              rankingType: "bypopularity",
            ),
          ),
          TrackLibrarySection(
            name: "Top Manga",
            syncId: syncId,
            func: _fetchGeneralData(
              ref,
              syncId,
              ItemType.manga,
              rankingType: "manga",
            ),
          ),
          TrackLibrarySection(
            name: "Top Manhwa",
            syncId: syncId,
            func: _fetchGeneralData(
              ref,
              syncId,
              ItemType.manga,
              rankingType: "manhwa",
            ),
          ),
          TrackLibrarySection(
            name: "Top Manhua",
            syncId: syncId,
            func: _fetchGeneralData(
              ref,
              syncId,
              ItemType.manga,
              rankingType: "manhua",
            ),
          ),
        ];
}

List<TrackLibrarySection> _sectionsKitsu(
  WidgetRef ref,
  int syncId,
  ItemType itemType,
) {
  return itemType == ItemType.anime
      ? [
          TrackLibrarySection(
            name: "Continue watching",
            syncId: syncId,
            func: _fetchUserData(ref, syncId, ItemType.anime),
            itemType: ItemType.anime,
          ),
          TrackLibrarySection(
            name: "Popular Anime",
            syncId: syncId,
            func: _fetchGeneralData(ref, syncId, ItemType.anime),
            itemType: ItemType.anime,
          ),
          TrackLibrarySection(
            name: "Latest Anime",
            syncId: syncId,
            func: _fetchGeneralData(
              ref,
              syncId,
              ItemType.anime,
              rankingType: "-updatedAt",
            ),
            itemType: ItemType.anime,
          ),
          TrackLibrarySection(
            name: "Best Rated Anime",
            syncId: syncId,
            func: _fetchGeneralData(
              ref,
              syncId,
              ItemType.anime,
              rankingType: "-averageRating",
            ),
            itemType: ItemType.anime,
          ),
        ]
      : [
          TrackLibrarySection(
            name: "Continue reading",
            syncId: syncId,
            func: _fetchUserData(ref, syncId, ItemType.manga),
          ),
          TrackLibrarySection(
            name: "Popular Manga",
            syncId: syncId,
            func: _fetchGeneralData(ref, syncId, ItemType.manga),
          ),
          TrackLibrarySection(
            name: "Latest Manga",
            syncId: syncId,
            func: _fetchGeneralData(
              ref,
              syncId,
              ItemType.manga,
              rankingType: "-updatedAt",
            ),
          ),
          TrackLibrarySection(
            name: "Best Rated Manga",
            syncId: syncId,
            func: _fetchGeneralData(
              ref,
              syncId,
              ItemType.manga,
              rankingType: "-averageRating",
            ),
          ),
        ];
}

List<TrackLibrarySection> _sectionsAL(
  WidgetRef ref,
  int syncId,
  ItemType itemType,
) {
  return itemType == ItemType.anime
      ? [
          TrackLibrarySection(
            name: "Continue watching",
            syncId: syncId,
            func: _fetchUserData(ref, syncId, ItemType.anime),
            itemType: ItemType.anime,
          ),
          TrackLibrarySection(
            name: "Plan to watch",
            syncId: syncId,
            func: _fetchPlanningData(ref, syncId, ItemType.anime),
            itemType: ItemType.anime,
          ),
          TrackLibrarySection(
            name: "Upcoming Anime",
            syncId: syncId,
            func: _fetchGeneralData(ref, syncId, ItemType.anime),
            itemType: ItemType.anime,
          ),
          TrackLibrarySection(
            name: "Popular Anime",
            syncId: syncId,
            func: _fetchGeneralData(
              ref,
              syncId,
              ItemType.anime,
              rankingType: "sort: POPULARITY_DESC",
            ),
            itemType: ItemType.anime,
          ),
          TrackLibrarySection(
            name: "Trending Anime",
            syncId: syncId,
            func: _fetchGeneralData(
              ref,
              syncId,
              ItemType.anime,
              rankingType: "sort: TRENDING_DESC",
            ),
            itemType: ItemType.anime,
          ),
          TrackLibrarySection(
            name: "Latest Anime",
            syncId: syncId,
            func: _fetchGeneralData(
              ref,
              syncId,
              ItemType.anime,
              rankingType:
                  "sort: [UPDATED_AT_DESC, POPULARITY_DESC], status: RELEASING",
            ),
            itemType: ItemType.anime,
          ),
        ]
      : [
          TrackLibrarySection(
            name: "Continue reading",
            syncId: syncId,
            func: _fetchUserData(ref, syncId, ItemType.manga),
          ),
          TrackLibrarySection(
            name: "Plan to read",
            syncId: syncId,
            func: _fetchPlanningData(ref, syncId, ItemType.manga),
          ),
          TrackLibrarySection(
            name: "Upcoming Manga",
            syncId: syncId,
            func: _fetchGeneralData(ref, syncId, ItemType.manga),
          ),
          TrackLibrarySection(
            name: "Popular Manga",
            syncId: syncId,
            func: _fetchGeneralData(
              ref,
              syncId,
              ItemType.manga,
              rankingType: "sort: POPULARITY_DESC",
            ),
          ),
          TrackLibrarySection(
            name: "Trending Manga",
            syncId: syncId,
            func: _fetchGeneralData(
              ref,
              syncId,
              ItemType.manga,
              rankingType: "sort: TRENDING_DESC",
            ),
          ),
          TrackLibrarySection(
            name: "Latest Manga",
            syncId: syncId,
            func: _fetchGeneralData(
              ref,
              syncId,
              ItemType.manga,
              rankingType:
                  "sort: [UPDATED_AT_DESC, POPULARITY_DESC], status: RELEASING",
            ),
          ),
        ];
}

Future<List<TrackSearch>?> Function() _fetchSearch(
  WidgetRef ref,
  int syncId,
  String query,
  ItemType itemType,
) {
  return () async => await ref
      .read(
        trackStateProvider(
          track: Track(syncId: syncId, status: TrackStatus.completed),
          itemType: itemType,
          widgetRef: ref,
        ).notifier,
      )
      .search(query);
}

Future<List<TrackSearch>?> Function() _fetchGeneralData(
  WidgetRef ref,
  int syncId,
  ItemType itemType, {
  String? rankingType,
}) {
  return () async => await ref
      .read(
        trackStateProvider(
          track: Track(syncId: syncId, status: TrackStatus.completed),
          itemType: itemType,
          widgetRef: ref,
        ).notifier,
      )
      .fetchGeneralData(rankingType: rankingType);
}

Future<List<TrackSearch>?> Function() _fetchUserData(
  WidgetRef ref,
  int syncId,
  ItemType itemType,
) {
  return () async => await ref
      .read(
        trackStateProvider(
          track: Track(syncId: syncId, status: TrackStatus.completed),
          itemType: itemType,
          widgetRef: ref,
        ).notifier,
      )
      .fetchUserData();
}

Future<List<TrackSearch>?> Function() _fetchPlanningData(
  WidgetRef ref,
  int syncId,
  ItemType itemType,
) {
  return () async => await ref
      .read(
        trackStateProvider(
          track: Track(syncId: syncId, status: TrackStatus.completed),
          itemType: itemType,
          widgetRef: ref,
        ).notifier,
      )
      .fetchPlanningData();
}

Future<List<TrackSearch>?> Function() _fetchWatchlistData(
  WidgetRef ref,
  int syncId,
  ItemType itemType,
) {
  return () async => await ref
      .read(
        trackStateProvider(
          track: Track(syncId: syncId, status: TrackStatus.completed),
          itemType: itemType,
          widgetRef: ref,
        ).notifier,
      )
      .fetchWatchlistData();
}
