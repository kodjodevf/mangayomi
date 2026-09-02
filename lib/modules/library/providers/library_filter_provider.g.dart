// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Pre-fetches all downloaded chapter IDs in a single Isar query.
/// Returns a [Set<int>] for O(1) lookup instead of per-chapter queries.

@ProviderFor(downloadedChapterIds)
final downloadedChapterIdsProvider = DownloadedChapterIdsProvider._();

/// Pre-fetches all downloaded chapter IDs in a single Isar query.
/// Returns a [Set<int>] for O(1) lookup instead of per-chapter queries.

final class DownloadedChapterIdsProvider
    extends
        $FunctionalProvider<AsyncValue<Set<int>>, Set<int>, Stream<Set<int>>>
    with $FutureModifier<Set<int>>, $StreamProvider<Set<int>> {
  /// Pre-fetches all downloaded chapter IDs in a single Isar query.
  /// Returns a [Set<int>] for O(1) lookup instead of per-chapter queries.
  DownloadedChapterIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadedChapterIdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadedChapterIdsHash();

  @$internal
  @override
  $StreamProviderElement<Set<int>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Set<int>> create(Ref ref) {
    return downloadedChapterIds(ref);
  }
}

String _$downloadedChapterIdsHash() =>
    r'65a652cb30e42b989e2e67eb9dae24992afe26f1';

/// Pre-fetches all manga IDs that have at least one tracking entry reactively.

@ProviderFor(trackedMangaIds)
final trackedMangaIdsProvider = TrackedMangaIdsProvider._();

/// Pre-fetches all manga IDs that have at least one tracking entry reactively.

final class TrackedMangaIdsProvider
    extends
        $FunctionalProvider<AsyncValue<Set<int>>, Set<int>, Stream<Set<int>>>
    with $FutureModifier<Set<int>>, $StreamProvider<Set<int>> {
  /// Pre-fetches all manga IDs that have at least one tracking entry reactively.
  TrackedMangaIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trackedMangaIdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trackedMangaIdsHash();

  @$internal
  @override
  $StreamProviderElement<Set<int>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Set<int>> create(Ref ref) {
    return trackedMangaIds(ref);
  }
}

String _$trackedMangaIdsHash() => r'902bbf011185a59ee10f175efaa4e96c6610e46b';

/// Filters and sorts a list of [Manga] based on library filter/sort settings.

@ProviderFor(filteredLibraryManga)
final filteredLibraryMangaProvider = FilteredLibraryMangaFamily._();

/// Filters and sorts a list of [Manga] based on library filter/sort settings.

final class FilteredLibraryMangaProvider
    extends $FunctionalProvider<List<Manga>, List<Manga>, List<Manga>>
    with $Provider<List<Manga>> {
  /// Filters and sorts a list of [Manga] based on library filter/sort settings.
  FilteredLibraryMangaProvider._({
    required FilteredLibraryMangaFamily super.from,
    required ({
      List<Manga> data,
      int downloadFilterType,
      int unreadFilterType,
      int startedFilterType,
      int bookmarkedFilterType,
      int completedFilterType,
      int trackingFilterType,
      int sortType,
      bool downloadedOnly,
      String searchQuery,
      bool ignoreFiltersOnSearch,
      List<String> sourceIds,
      Settings settings,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'filteredLibraryMangaProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$filteredLibraryMangaHash();

  @override
  String toString() {
    return r'filteredLibraryMangaProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<List<Manga>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Manga> create(Ref ref) {
    final argument =
        this.argument
            as ({
              List<Manga> data,
              int downloadFilterType,
              int unreadFilterType,
              int startedFilterType,
              int bookmarkedFilterType,
              int completedFilterType,
              int trackingFilterType,
              int sortType,
              bool downloadedOnly,
              String searchQuery,
              bool ignoreFiltersOnSearch,
              List<String> sourceIds,
              Settings settings,
            });
    return filteredLibraryManga(
      ref,
      data: argument.data,
      downloadFilterType: argument.downloadFilterType,
      unreadFilterType: argument.unreadFilterType,
      startedFilterType: argument.startedFilterType,
      bookmarkedFilterType: argument.bookmarkedFilterType,
      completedFilterType: argument.completedFilterType,
      trackingFilterType: argument.trackingFilterType,
      sortType: argument.sortType,
      downloadedOnly: argument.downloadedOnly,
      searchQuery: argument.searchQuery,
      ignoreFiltersOnSearch: argument.ignoreFiltersOnSearch,
      sourceIds: argument.sourceIds,
      settings: argument.settings,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Manga> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Manga>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredLibraryMangaProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$filteredLibraryMangaHash() =>
    r'0d24c1464203816fb724873a55b67ad5eb3dbe43';

/// Filters and sorts a list of [Manga] based on library filter/sort settings.

final class FilteredLibraryMangaFamily extends $Family
    with
        $FunctionalFamilyOverride<
          List<Manga>,
          ({
            List<Manga> data,
            int downloadFilterType,
            int unreadFilterType,
            int startedFilterType,
            int bookmarkedFilterType,
            int completedFilterType,
            int trackingFilterType,
            int sortType,
            bool downloadedOnly,
            String searchQuery,
            bool ignoreFiltersOnSearch,
            List<String> sourceIds,
            Settings settings,
          })
        > {
  FilteredLibraryMangaFamily._()
    : super(
        retry: null,
        name: r'filteredLibraryMangaProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Filters and sorts a list of [Manga] based on library filter/sort settings.

  FilteredLibraryMangaProvider call({
    required List<Manga> data,
    required int downloadFilterType,
    required int unreadFilterType,
    required int startedFilterType,
    required int bookmarkedFilterType,
    required int completedFilterType,
    required int trackingFilterType,
    required int sortType,
    required bool downloadedOnly,
    required String searchQuery,
    required bool ignoreFiltersOnSearch,
    required List<String> sourceIds,
    required Settings settings,
  }) => FilteredLibraryMangaProvider._(
    argument: (
      data: data,
      downloadFilterType: downloadFilterType,
      unreadFilterType: unreadFilterType,
      startedFilterType: startedFilterType,
      bookmarkedFilterType: bookmarkedFilterType,
      completedFilterType: completedFilterType,
      trackingFilterType: trackingFilterType,
      sortType: sortType,
      downloadedOnly: downloadedOnly,
      searchQuery: searchQuery,
      ignoreFiltersOnSearch: ignoreFiltersOnSearch,
      sourceIds: sourceIds,
      settings: settings,
    ),
    from: this,
  );

  @override
  String toString() => r'filteredLibraryMangaProvider';
}
