// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getMangaDetailStreamHash() =>
    r'e5323174237e1a07497b683c59a88f4f3d74b492';

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

typedef GetMangaDetailStreamRef = AutoDisposeStreamProviderRef<ModelManga?>;

/// See also [getMangaDetailStream].
@ProviderFor(getMangaDetailStream)
const getMangaDetailStreamProvider = GetMangaDetailStreamFamily();

/// See also [getMangaDetailStream].
class GetMangaDetailStreamFamily extends Family<AsyncValue<ModelManga?>> {
  /// See also [getMangaDetailStream].
  const GetMangaDetailStreamFamily();

  /// See also [getMangaDetailStream].
  GetMangaDetailStreamProvider call({
    required int mangaId,
  }) {
    return GetMangaDetailStreamProvider(
      mangaId: mangaId,
    );
  }

  @override
  GetMangaDetailStreamProvider getProviderOverride(
    covariant GetMangaDetailStreamProvider provider,
  ) {
    return call(
      mangaId: provider.mangaId,
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
  String? get name => r'getMangaDetailStreamProvider';
}

/// See also [getMangaDetailStream].
class GetMangaDetailStreamProvider
    extends AutoDisposeStreamProvider<ModelManga?> {
  /// See also [getMangaDetailStream].
  GetMangaDetailStreamProvider({
    required this.mangaId,
  }) : super.internal(
          (ref) => getMangaDetailStream(
            ref,
            mangaId: mangaId,
          ),
          from: getMangaDetailStreamProvider,
          name: r'getMangaDetailStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getMangaDetailStreamHash,
          dependencies: GetMangaDetailStreamFamily._dependencies,
          allTransitiveDependencies:
              GetMangaDetailStreamFamily._allTransitiveDependencies,
        );

  final int mangaId;

  @override
  bool operator ==(Object other) {
    return other is GetMangaDetailStreamProvider && other.mangaId == mangaId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaId.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$getChaptersStreamHash() => r'975919d4d4c67e8677bf47d81e2f2def812c1325';
typedef GetChaptersStreamRef
    = AutoDisposeStreamProviderRef<List<ModelChapters>>;

/// See also [getChaptersStream].
@ProviderFor(getChaptersStream)
const getChaptersStreamProvider = GetChaptersStreamFamily();

/// See also [getChaptersStream].
class GetChaptersStreamFamily extends Family<AsyncValue<List<ModelChapters>>> {
  /// See also [getChaptersStream].
  const GetChaptersStreamFamily();

  /// See also [getChaptersStream].
  GetChaptersStreamProvider call({
    required int mangaId,
  }) {
    return GetChaptersStreamProvider(
      mangaId: mangaId,
    );
  }

  @override
  GetChaptersStreamProvider getProviderOverride(
    covariant GetChaptersStreamProvider provider,
  ) {
    return call(
      mangaId: provider.mangaId,
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
  String? get name => r'getChaptersStreamProvider';
}

/// See also [getChaptersStream].
class GetChaptersStreamProvider
    extends AutoDisposeStreamProvider<List<ModelChapters>> {
  /// See also [getChaptersStream].
  GetChaptersStreamProvider({
    required this.mangaId,
  }) : super.internal(
          (ref) => getChaptersStream(
            ref,
            mangaId: mangaId,
          ),
          from: getChaptersStreamProvider,
          name: r'getChaptersStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getChaptersStreamHash,
          dependencies: GetChaptersStreamFamily._dependencies,
          allTransitiveDependencies:
              GetChaptersStreamFamily._allTransitiveDependencies,
        );

  final int mangaId;

  @override
  bool operator ==(Object other) {
    return other is GetChaptersStreamProvider && other.mangaId == mangaId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaId.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$getChaptersFilterStreamHash() =>
    r'a8ebf64e90477dd851f65a7f1e5134b5fd6ada1c';
typedef GetChaptersFilterStreamRef
    = AutoDisposeStreamProviderRef<ChaptersFilter?>;

/// See also [getChaptersFilterStream].
@ProviderFor(getChaptersFilterStream)
const getChaptersFilterStreamProvider = GetChaptersFilterStreamFamily();

/// See also [getChaptersFilterStream].
class GetChaptersFilterStreamFamily
    extends Family<AsyncValue<ChaptersFilter?>> {
  /// See also [getChaptersFilterStream].
  const GetChaptersFilterStreamFamily();

  /// See also [getChaptersFilterStream].
  GetChaptersFilterStreamProvider call({
    required int mangaId,
  }) {
    return GetChaptersFilterStreamProvider(
      mangaId: mangaId,
    );
  }

  @override
  GetChaptersFilterStreamProvider getProviderOverride(
    covariant GetChaptersFilterStreamProvider provider,
  ) {
    return call(
      mangaId: provider.mangaId,
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
  String? get name => r'getChaptersFilterStreamProvider';
}

/// See also [getChaptersFilterStream].
class GetChaptersFilterStreamProvider
    extends AutoDisposeStreamProvider<ChaptersFilter?> {
  /// See also [getChaptersFilterStream].
  GetChaptersFilterStreamProvider({
    required this.mangaId,
  }) : super.internal(
          (ref) => getChaptersFilterStream(
            ref,
            mangaId: mangaId,
          ),
          from: getChaptersFilterStreamProvider,
          name: r'getChaptersFilterStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getChaptersFilterStreamHash,
          dependencies: GetChaptersFilterStreamFamily._dependencies,
          allTransitiveDependencies:
              GetChaptersFilterStreamFamily._allTransitiveDependencies,
        );

  final int mangaId;

  @override
  bool operator ==(Object other) {
    return other is GetChaptersFilterStreamProvider && other.mangaId == mangaId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaId.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
