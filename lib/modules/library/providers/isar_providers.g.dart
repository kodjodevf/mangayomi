// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAllMangaStreamHash() => r'd06c3a94ba847055746f2d52566cc94db4c28b7e';

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

typedef GetAllMangaStreamRef = AutoDisposeStreamProviderRef<List<Manga>>;

/// See also [getAllMangaStream].
@ProviderFor(getAllMangaStream)
const getAllMangaStreamProvider = GetAllMangaStreamFamily();

/// See also [getAllMangaStream].
class GetAllMangaStreamFamily extends Family<AsyncValue<List<Manga>>> {
  /// See also [getAllMangaStream].
  const GetAllMangaStreamFamily();

  /// See also [getAllMangaStream].
  GetAllMangaStreamProvider call({
    required int? categoryId,
    required bool? isManga,
  }) {
    return GetAllMangaStreamProvider(
      categoryId: categoryId,
      isManga: isManga,
    );
  }

  @override
  GetAllMangaStreamProvider getProviderOverride(
    covariant GetAllMangaStreamProvider provider,
  ) {
    return call(
      categoryId: provider.categoryId,
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
  String? get name => r'getAllMangaStreamProvider';
}

/// See also [getAllMangaStream].
class GetAllMangaStreamProvider extends AutoDisposeStreamProvider<List<Manga>> {
  /// See also [getAllMangaStream].
  GetAllMangaStreamProvider({
    required this.categoryId,
    required this.isManga,
  }) : super.internal(
          (ref) => getAllMangaStream(
            ref,
            categoryId: categoryId,
            isManga: isManga,
          ),
          from: getAllMangaStreamProvider,
          name: r'getAllMangaStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getAllMangaStreamHash,
          dependencies: GetAllMangaStreamFamily._dependencies,
          allTransitiveDependencies:
              GetAllMangaStreamFamily._allTransitiveDependencies,
        );

  final int? categoryId;
  final bool? isManga;

  @override
  bool operator ==(Object other) {
    return other is GetAllMangaStreamProvider &&
        other.categoryId == categoryId &&
        other.isManga == isManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$getAllMangaWithoutCategoriesStreamHash() =>
    r'03581754f330a87894f953f8eaae528642b0afc2';
typedef GetAllMangaWithoutCategoriesStreamRef
    = AutoDisposeStreamProviderRef<List<Manga>>;

/// See also [getAllMangaWithoutCategoriesStream].
@ProviderFor(getAllMangaWithoutCategoriesStream)
const getAllMangaWithoutCategoriesStreamProvider =
    GetAllMangaWithoutCategoriesStreamFamily();

/// See also [getAllMangaWithoutCategoriesStream].
class GetAllMangaWithoutCategoriesStreamFamily
    extends Family<AsyncValue<List<Manga>>> {
  /// See also [getAllMangaWithoutCategoriesStream].
  const GetAllMangaWithoutCategoriesStreamFamily();

  /// See also [getAllMangaWithoutCategoriesStream].
  GetAllMangaWithoutCategoriesStreamProvider call({
    required bool? isManga,
  }) {
    return GetAllMangaWithoutCategoriesStreamProvider(
      isManga: isManga,
    );
  }

  @override
  GetAllMangaWithoutCategoriesStreamProvider getProviderOverride(
    covariant GetAllMangaWithoutCategoriesStreamProvider provider,
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
  String? get name => r'getAllMangaWithoutCategoriesStreamProvider';
}

/// See also [getAllMangaWithoutCategoriesStream].
class GetAllMangaWithoutCategoriesStreamProvider
    extends AutoDisposeStreamProvider<List<Manga>> {
  /// See also [getAllMangaWithoutCategoriesStream].
  GetAllMangaWithoutCategoriesStreamProvider({
    required this.isManga,
  }) : super.internal(
          (ref) => getAllMangaWithoutCategoriesStream(
            ref,
            isManga: isManga,
          ),
          from: getAllMangaWithoutCategoriesStreamProvider,
          name: r'getAllMangaWithoutCategoriesStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getAllMangaWithoutCategoriesStreamHash,
          dependencies: GetAllMangaWithoutCategoriesStreamFamily._dependencies,
          allTransitiveDependencies: GetAllMangaWithoutCategoriesStreamFamily
              ._allTransitiveDependencies,
        );

  final bool? isManga;

  @override
  bool operator ==(Object other) {
    return other is GetAllMangaWithoutCategoriesStreamProvider &&
        other.isManga == isManga;
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
