// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_manga_detail.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getMangaDetailHash() => r'025ccc11f94f9b69bd85d86833bc261f66b74f7f';

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

typedef GetMangaDetailRef = AutoDisposeFutureProviderRef<MangaModel>;

/// See also [getMangaDetail].
@ProviderFor(getMangaDetail)
const getMangaDetailProvider = GetMangaDetailFamily();

/// See also [getMangaDetail].
class GetMangaDetailFamily extends Family<AsyncValue<MangaModel>> {
  /// See also [getMangaDetail].
  const GetMangaDetailFamily();

  /// See also [getMangaDetail].
  GetMangaDetailProvider call({
    required MangaModel manga,
    required Source source,
  }) {
    return GetMangaDetailProvider(
      manga: manga,
      source: source,
    );
  }

  @override
  GetMangaDetailProvider getProviderOverride(
    covariant GetMangaDetailProvider provider,
  ) {
    return call(
      manga: provider.manga,
      source: provider.source,
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
  String? get name => r'getMangaDetailProvider';
}

/// See also [getMangaDetail].
class GetMangaDetailProvider extends AutoDisposeFutureProvider<MangaModel> {
  /// See also [getMangaDetail].
  GetMangaDetailProvider({
    required this.manga,
    required this.source,
  }) : super.internal(
          (ref) => getMangaDetail(
            ref,
            manga: manga,
            source: source,
          ),
          from: getMangaDetailProvider,
          name: r'getMangaDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getMangaDetailHash,
          dependencies: GetMangaDetailFamily._dependencies,
          allTransitiveDependencies:
              GetMangaDetailFamily._allTransitiveDependencies,
        );

  final MangaModel manga;
  final Source source;

  @override
  bool operator ==(Object other) {
    return other is GetMangaDetailProvider &&
        other.manga == manga &&
        other.source == source;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, manga.hashCode);
    hash = _SystemHash.combine(hash, source.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
