// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_manga.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchMangaHash() => r'381a7a67b818f1633df476a4392412b7757030da';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

typedef SearchMangaRef = AutoDisposeFutureProviderRef<List<MangaModel?>>;

/// See also [searchManga].
@ProviderFor(searchManga)
const searchMangaProvider = SearchMangaFamily();

/// See also [searchManga].
class SearchMangaFamily extends Family<AsyncValue<List<MangaModel?>>> {
  /// See also [searchManga].
  const SearchMangaFamily();

  /// See also [searchManga].
  SearchMangaProvider call({
    required Source source,
    required String query,
    required int page,
  }) {
    return SearchMangaProvider(
      source: source,
      query: query,
      page: page,
    );
  }

  @override
  SearchMangaProvider getProviderOverride(
    covariant SearchMangaProvider provider,
  ) {
    return call(
      source: provider.source,
      query: provider.query,
      page: provider.page,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchMangaProvider';
}

/// See also [searchManga].
class SearchMangaProvider extends AutoDisposeFutureProvider<List<MangaModel?>> {
  /// See also [searchManga].
  SearchMangaProvider({
    required this.source,
    required this.query,
    required this.page,
  }) : super.internal(
          (ref) => searchManga(
            ref,
            source: source,
            query: query,
            page: page,
          ),
          from: searchMangaProvider,
          name: r'searchMangaProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchMangaHash,
          dependencies: SearchMangaFamily._dependencies,
          allTransitiveDependencies:
              SearchMangaFamily._allTransitiveDependencies,
        );

  final Source source;
  final String query;
  final int page;

  @override
  bool operator ==(Object other) {
    return other is SearchMangaProvider &&
        other.source == source &&
        other.query == query &&
        other.page == page;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, source.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
