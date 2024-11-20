// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAllMangaStreamHash() => r'1c0b5442ae86b2fa899d509a555f5d375f0ff79a';

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
    required int? categoryId,
    required bool? isManga,
  }) : this._internal(
          (ref) => getAllMangaStream(
            ref as GetAllMangaStreamRef,
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
          categoryId: categoryId,
          isManga: isManga,
        );

  GetAllMangaStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
    required this.isManga,
  }) : super.internal();

  final int? categoryId;
  final bool? isManga;

  @override
  Override overrideWith(
    Stream<List<Manga>> Function(GetAllMangaStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetAllMangaStreamProvider._internal(
        (ref) => create(ref as GetAllMangaStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
        isManga: isManga,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Manga>> createElement() {
    return _GetAllMangaStreamProviderElement(this);
  }

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetAllMangaStreamRef on AutoDisposeStreamProviderRef<List<Manga>> {
  /// The parameter `categoryId` of this provider.
  int? get categoryId;

  /// The parameter `isManga` of this provider.
  bool? get isManga;
}

class _GetAllMangaStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Manga>>
    with GetAllMangaStreamRef {
  _GetAllMangaStreamProviderElement(super.provider);

  @override
  int? get categoryId => (origin as GetAllMangaStreamProvider).categoryId;
  @override
  bool? get isManga => (origin as GetAllMangaStreamProvider).isManga;
}

String _$getAllMangaWithoutCategoriesStreamHash() =>
    r'78076f291274b7defd9567e55314002d9aeecab1';

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
    required bool? isManga,
  }) : this._internal(
          (ref) => getAllMangaWithoutCategoriesStream(
            ref as GetAllMangaWithoutCategoriesStreamRef,
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
          isManga: isManga,
        );

  GetAllMangaWithoutCategoriesStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.isManga,
  }) : super.internal();

  final bool? isManga;

  @override
  Override overrideWith(
    Stream<List<Manga>> Function(GetAllMangaWithoutCategoriesStreamRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetAllMangaWithoutCategoriesStreamProvider._internal(
        (ref) => create(ref as GetAllMangaWithoutCategoriesStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        isManga: isManga,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Manga>> createElement() {
    return _GetAllMangaWithoutCategoriesStreamProviderElement(this);
  }

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetAllMangaWithoutCategoriesStreamRef
    on AutoDisposeStreamProviderRef<List<Manga>> {
  /// The parameter `isManga` of this provider.
  bool? get isManga;
}

class _GetAllMangaWithoutCategoriesStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Manga>>
    with GetAllMangaWithoutCategoriesStreamRef {
  _GetAllMangaWithoutCategoriesStreamProviderElement(super.provider);

  @override
  bool? get isManga =>
      (origin as GetAllMangaWithoutCategoriesStreamProvider).isManga;
}

String _$getSettingsStreamHash() => r'c5a51e0e3473b25d2365025832a27ed2cc029b27';

/// See also [getSettingsStream].
@ProviderFor(getSettingsStream)
final getSettingsStreamProvider =
    AutoDisposeStreamProvider<List<Settings>>.internal(
  getSettingsStream,
  name: r'getSettingsStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getSettingsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetSettingsStreamRef = AutoDisposeStreamProviderRef<List<Settings>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
