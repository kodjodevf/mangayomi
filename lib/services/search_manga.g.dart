// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_manga.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchMangaHash() => r'f1a2af2f06c967c647ed803f8199de711a84bb49';

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

/// See also [searchManga].
@ProviderFor(searchManga)
const searchMangaProvider = SearchMangaFamily();

/// See also [searchManga].
class SearchMangaFamily extends Family<AsyncValue<MPages?>> {
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
class SearchMangaProvider extends AutoDisposeFutureProvider<MPages?> {
  /// See also [searchManga].
  SearchMangaProvider({
    required Source source,
    required String query,
    required int page,
  }) : this._internal(
          (ref) => searchManga(
            ref as SearchMangaRef,
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
          source: source,
          query: query,
          page: page,
        );

  SearchMangaProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.source,
    required this.query,
    required this.page,
  }) : super.internal();

  final Source source;
  final String query;
  final int page;

  @override
  Override overrideWith(
    FutureOr<MPages?> Function(SearchMangaRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchMangaProvider._internal(
        (ref) => create(ref as SearchMangaRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        source: source,
        query: query,
        page: page,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MPages?> createElement() {
    return _SearchMangaProviderElement(this);
  }

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

mixin SearchMangaRef on AutoDisposeFutureProviderRef<MPages?> {
  /// The parameter `source` of this provider.
  Source get source;

  /// The parameter `query` of this provider.
  String get query;

  /// The parameter `page` of this provider.
  int get page;
}

class _SearchMangaProviderElement
    extends AutoDisposeFutureProviderElement<MPages?> with SearchMangaRef {
  _SearchMangaProviderElement(super.provider);

  @override
  Source get source => (origin as SearchMangaProvider).source;
  @override
  String get query => (origin as SearchMangaProvider).query;
  @override
  int get page => (origin as SearchMangaProvider).page;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
