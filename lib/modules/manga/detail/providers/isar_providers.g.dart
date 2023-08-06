// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getMangaDetailStreamHash() =>
    r'1c8bd2eb2db6f3384626fae22bcc93422aa0e118';

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

typedef GetMangaDetailStreamRef = AutoDisposeStreamProviderRef<Manga?>;

/// See also [getMangaDetailStream].
@ProviderFor(getMangaDetailStream)
const getMangaDetailStreamProvider = GetMangaDetailStreamFamily();

/// See also [getMangaDetailStream].
class GetMangaDetailStreamFamily extends Family<AsyncValue<Manga?>> {
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
class GetMangaDetailStreamProvider extends AutoDisposeStreamProvider<Manga?> {
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

String _$getChaptersStreamHash() => r'31879a8ff45e1cd61255de50d030a0141450180d';
typedef GetChaptersStreamRef = AutoDisposeStreamProviderRef<List<Chapter>>;

/// See also [getChaptersStream].
@ProviderFor(getChaptersStream)
const getChaptersStreamProvider = GetChaptersStreamFamily();

/// See also [getChaptersStream].
class GetChaptersStreamFamily extends Family<AsyncValue<List<Chapter>>> {
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
    extends AutoDisposeStreamProvider<List<Chapter>> {
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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
