// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_manga.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchMangaHash() => r'0448881ce3785ac0c670a87914590008ae19fdd5';

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

typedef SearchMangaRef = AutoDisposeFutureProviderRef<List<GetManga?>>;

/// See also [searchManga].
@ProviderFor(searchManga)
const searchMangaProvider = SearchMangaFamily();

/// See also [searchManga].
class SearchMangaFamily extends Family<AsyncValue<List<GetManga?>>> {
  /// See also [searchManga].
  const SearchMangaFamily();

  /// See also [searchManga].
  SearchMangaProvider call({
    required String source,
    required String query,
    required String lang,
  }) {
    return SearchMangaProvider(
      source: source,
      query: query,
      lang: lang,
    );
  }

  @override
  SearchMangaProvider getProviderOverride(
    covariant SearchMangaProvider provider,
  ) {
    return call(
      source: provider.source,
      query: provider.query,
      lang: provider.lang,
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
class SearchMangaProvider extends AutoDisposeFutureProvider<List<GetManga?>> {
  /// See also [searchManga].
  SearchMangaProvider({
    required this.source,
    required this.query,
    required this.lang,
  }) : super.internal(
          (ref) => searchManga(
            ref,
            source: source,
            query: query,
            lang: lang,
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

  final String source;
  final String query;
  final String lang;

  @override
  bool operator ==(Object other) {
    return other is SearchMangaProvider &&
        other.source == source &&
        other.query == query &&
        other.lang == lang;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, source.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);
    hash = _SystemHash.combine(hash, lang.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
