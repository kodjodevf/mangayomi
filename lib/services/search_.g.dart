// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchHash() => r'b08d5a4b6e7d285830af7e5388b06fa61f175ede';

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

/// See also [search].
@ProviderFor(search)
const searchProvider = SearchFamily();

/// See also [search].
class SearchFamily extends Family<AsyncValue<MPages?>> {
  /// See also [search].
  const SearchFamily();

  /// See also [search].
  SearchProvider call({
    required Source source,
    required String query,
    required int page,
    required List<dynamic> filterList,
  }) {
    return SearchProvider(
      source: source,
      query: query,
      page: page,
      filterList: filterList,
    );
  }

  @override
  SearchProvider getProviderOverride(covariant SearchProvider provider) {
    return call(
      source: provider.source,
      query: provider.query,
      page: provider.page,
      filterList: provider.filterList,
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
  String? get name => r'searchProvider';
}

/// See also [search].
class SearchProvider extends AutoDisposeFutureProvider<MPages?> {
  /// See also [search].
  SearchProvider({
    required Source source,
    required String query,
    required int page,
    required List<dynamic> filterList,
  }) : this._internal(
         (ref) => search(
           ref as SearchRef,
           source: source,
           query: query,
           page: page,
           filterList: filterList,
         ),
         from: searchProvider,
         name: r'searchProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$searchHash,
         dependencies: SearchFamily._dependencies,
         allTransitiveDependencies: SearchFamily._allTransitiveDependencies,
         source: source,
         query: query,
         page: page,
         filterList: filterList,
       );

  SearchProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.source,
    required this.query,
    required this.page,
    required this.filterList,
  }) : super.internal();

  final Source source;
  final String query;
  final int page;
  final List<dynamic> filterList;

  @override
  Override overrideWith(FutureOr<MPages?> Function(SearchRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: SearchProvider._internal(
        (ref) => create(ref as SearchRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        source: source,
        query: query,
        page: page,
        filterList: filterList,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MPages?> createElement() {
    return _SearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchProvider &&
        other.source == source &&
        other.query == query &&
        other.page == page &&
        other.filterList == filterList;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, source.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, filterList.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchRef on AutoDisposeFutureProviderRef<MPages?> {
  /// The parameter `source` of this provider.
  Source get source;

  /// The parameter `query` of this provider.
  String get query;

  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `filterList` of this provider.
  List<dynamic> get filterList;
}

class _SearchProviderElement extends AutoDisposeFutureProviderElement<MPages?>
    with SearchRef {
  _SearchProviderElement(super.provider);

  @override
  Source get source => (origin as SearchProvider).source;
  @override
  String get query => (origin as SearchProvider).query;
  @override
  int get page => (origin as SearchProvider).page;
  @override
  List<dynamic> get filterList => (origin as SearchProvider).filterList;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
