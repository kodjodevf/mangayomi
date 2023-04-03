// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_popular_manga.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getPopularMangaHash() => r'4ab45f760fe457710bb9d09c72faef2fc09261e2';

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

typedef GetPopularMangaRef = AutoDisposeFutureProviderRef<GetMangaModel>;

/// See also [getPopularManga].
@ProviderFor(getPopularManga)
const getPopularMangaProvider = GetPopularMangaFamily();

/// See also [getPopularManga].
class GetPopularMangaFamily extends Family<AsyncValue<GetMangaModel>> {
  /// See also [getPopularManga].
  const GetPopularMangaFamily();

  /// See also [getPopularManga].
  GetPopularMangaProvider call({
    required String source,
    required int page,
  }) {
    return GetPopularMangaProvider(
      source: source,
      page: page,
    );
  }

  @override
  GetPopularMangaProvider getProviderOverride(
    covariant GetPopularMangaProvider provider,
  ) {
    return call(
      source: provider.source,
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
  String? get name => r'getPopularMangaProvider';
}

/// See also [getPopularManga].
class GetPopularMangaProvider extends AutoDisposeFutureProvider<GetMangaModel> {
  /// See also [getPopularManga].
  GetPopularMangaProvider({
    required this.source,
    required this.page,
  }) : super.internal(
          (ref) => getPopularManga(
            ref,
            source: source,
            page: page,
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

  @override
  bool operator ==(Object other) {
    return other is GetPopularMangaProvider &&
        other.source == source &&
        other.page == page;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, source.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
