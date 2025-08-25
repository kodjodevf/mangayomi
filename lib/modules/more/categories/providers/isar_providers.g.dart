// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getMangaCategorieStreamHash() =>
    r'1dcf15018a6467eef7a26c1728b9e531ebd984d0';

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

/// See also [getMangaCategorieStream].
@ProviderFor(getMangaCategorieStream)
const getMangaCategorieStreamProvider = GetMangaCategorieStreamFamily();

/// See also [getMangaCategorieStream].
class GetMangaCategorieStreamFamily extends Family<AsyncValue<List<Category>>> {
  /// See also [getMangaCategorieStream].
  const GetMangaCategorieStreamFamily();

  /// See also [getMangaCategorieStream].
  GetMangaCategorieStreamProvider call({required ItemType itemType}) {
    return GetMangaCategorieStreamProvider(itemType: itemType);
  }

  @override
  GetMangaCategorieStreamProvider getProviderOverride(
    covariant GetMangaCategorieStreamProvider provider,
  ) {
    return call(itemType: provider.itemType);
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
  GetMangaCategorieStreamProvider({required ItemType itemType})
    : this._internal(
        (ref) => getMangaCategorieStream(
          ref as GetMangaCategorieStreamRef,
          itemType: itemType,
        ),
        from: getMangaCategorieStreamProvider,
        name: r'getMangaCategorieStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$getMangaCategorieStreamHash,
        dependencies: GetMangaCategorieStreamFamily._dependencies,
        allTransitiveDependencies:
            GetMangaCategorieStreamFamily._allTransitiveDependencies,
        itemType: itemType,
      );

  GetMangaCategorieStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemType,
  }) : super.internal();

  final ItemType itemType;

  @override
  Override overrideWith(
    Stream<List<Category>> Function(GetMangaCategorieStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetMangaCategorieStreamProvider._internal(
        (ref) => create(ref as GetMangaCategorieStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemType: itemType,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Category>> createElement() {
    return _GetMangaCategorieStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetMangaCategorieStreamProvider &&
        other.itemType == itemType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetMangaCategorieStreamRef
    on AutoDisposeStreamProviderRef<List<Category>> {
  /// The parameter `itemType` of this provider.
  ItemType get itemType;
}

class _GetMangaCategorieStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Category>>
    with GetMangaCategorieStreamRef {
  _GetMangaCategorieStreamProviderElement(super.provider);

  @override
  ItemType get itemType => (origin as GetMangaCategorieStreamProvider).itemType;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
