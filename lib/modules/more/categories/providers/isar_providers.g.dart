// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getMangaCategorieStreamHash() =>
    r'16b3a35e4962b39a2948a257eba66124bbff139a';

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

typedef GetMangaCategorieStreamRef
    = AutoDisposeStreamProviderRef<List<Category>>;

/// See also [getMangaCategorieStream].
@ProviderFor(getMangaCategorieStream)
const getMangaCategorieStreamProvider = GetMangaCategorieStreamFamily();

/// See also [getMangaCategorieStream].
class GetMangaCategorieStreamFamily extends Family<AsyncValue<List<Category>>> {
  /// See also [getMangaCategorieStream].
  const GetMangaCategorieStreamFamily();

  /// See also [getMangaCategorieStream].
  GetMangaCategorieStreamProvider call({
    required bool isManga,
  }) {
    return GetMangaCategorieStreamProvider(
      isManga: isManga,
    );
  }

  @override
  GetMangaCategorieStreamProvider getProviderOverride(
    covariant GetMangaCategorieStreamProvider provider,
  ) {
    return call(
      isManga: provider.isManga,
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
  String? get name => r'getMangaCategorieStreamProvider';
}

/// See also [getMangaCategorieStream].
class GetMangaCategorieStreamProvider
    extends AutoDisposeStreamProvider<List<Category>> {
  /// See also [getMangaCategorieStream].
  GetMangaCategorieStreamProvider({
    required this.isManga,
  }) : super.internal(
          (ref) => getMangaCategorieStream(
            ref,
            isManga: isManga,
          ),
          from: getMangaCategorieStreamProvider,
          name: r'getMangaCategorieStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getMangaCategorieStreamHash,
          dependencies: GetMangaCategorieStreamFamily._dependencies,
          allTransitiveDependencies:
              GetMangaCategorieStreamFamily._allTransitiveDependencies,
        );

  final bool isManga;

  @override
  bool operator ==(Object other) {
    return other is GetMangaCategorieStreamProvider && other.isManga == isManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
