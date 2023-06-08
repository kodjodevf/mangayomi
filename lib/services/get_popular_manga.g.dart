// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_popular_manga.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getPopularMangaHash() => r'4fe87d57b93957bbc848b9b814dd3c9aa94b89c5';

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

typedef GetPopularMangaRef = AutoDisposeFutureProviderRef<List<GetManga?>>;

/// See also [getPopularManga].
@ProviderFor(getPopularManga)
const getPopularMangaProvider = GetPopularMangaFamily();

/// See also [getPopularManga].
class GetPopularMangaFamily extends Family<AsyncValue<List<GetManga?>>> {
  /// See also [getPopularManga].
  const GetPopularMangaFamily();

  /// See also [getPopularManga].
  GetPopularMangaProvider call({
    required String source,
    required int page,
    required String lang,
  }) {
    return GetPopularMangaProvider(
      source: source,
      page: page,
      lang: lang,
    );
  }

  @override
  GetPopularMangaProvider getProviderOverride(
    covariant GetPopularMangaProvider provider,
  ) {
    return call(
      source: provider.source,
      page: provider.page,
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
  String? get name => r'getPopularMangaProvider';
}

/// See also [getPopularManga].
class GetPopularMangaProvider
    extends AutoDisposeFutureProvider<List<GetManga?>> {
  /// See also [getPopularManga].
  GetPopularMangaProvider({
    required this.source,
    required this.page,
    required this.lang,
  }) : super.internal(
          (ref) => getPopularManga(
            ref,
            source: source,
            page: page,
            lang: lang,
          ),
          from: getPopularMangaProvider,
          name: r'getPopularMangaProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getPopularMangaHash,
          dependencies: GetPopularMangaFamily._dependencies,
          allTransitiveDependencies:
              GetPopularMangaFamily._allTransitiveDependencies,
        );

  final String source;
  final int page;
  final String lang;

  @override
  bool operator ==(Object other) {
    return other is GetPopularMangaProvider &&
        other.source == source &&
        other.page == page &&
        other.lang == lang;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, source.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, lang.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
