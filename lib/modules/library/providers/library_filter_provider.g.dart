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
    extends $FunctionalProvider<Set<int>, Set<int>, Set<int>>
    with $Provider<Set<int>> {
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
  $ProviderElement<Set<int>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Set<int> create(Ref ref) {
    return downloadedChapterIds(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<int>>(value),
    );
  }
}

String _$downloadedChapterIdsHash() =>
    r'a51ff78fb0ad2548c719d1ca400ae474fc01e683';

/// Pre-fetches all manga IDs that have at least one tracking entry.

@ProviderFor(trackedMangaIds)
final trackedMangaIdsProvider = TrackedMangaIdsProvider._();

/// Pre-fetches all manga IDs that have at least one tracking entry.

final class TrackedMangaIdsProvider
    extends $FunctionalProvider<Set<int>, Set<int>, Set<int>>
    with $Provider<Set<int>> {
  /// Pre-fetches all manga IDs that have at least one tracking entry.
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
  $ProviderElement<Set<int>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Set<int> create(Ref ref) {
    return trackedMangaIds(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<int>>(value),
    );
  }
}

String _$trackedMangaIdsHash() => r'8fd052ae3ff4e9fe47e66d5e24cd57233aa03d0a';

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
    r'afecb3de71f1f8c1682a0bfd9949f8a372c7d1b6';

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
    ),
    from: this,
  );

  @override
  String toString() => r'filteredLibraryMangaProvider';
}
