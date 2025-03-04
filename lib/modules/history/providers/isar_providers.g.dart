// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAllHistoryStreamHash() =>
    r'42048cb03035be55b52fc501fb2309cdb2acfcb8';

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

/// See also [getAllHistoryStream].
@ProviderFor(getAllHistoryStream)
const getAllHistoryStreamProvider = GetAllHistoryStreamFamily();

/// See also [getAllHistoryStream].
class GetAllHistoryStreamFamily extends Family<AsyncValue<List<History>>> {
  /// See also [getAllHistoryStream].
  const GetAllHistoryStreamFamily();

  /// See also [getAllHistoryStream].
  GetAllHistoryStreamProvider call({
    required ItemType itemType,
  }) {
    return GetAllHistoryStreamProvider(
      itemType: itemType,
    );
  }

  @override
  GetAllHistoryStreamProvider getProviderOverride(
    covariant GetAllHistoryStreamProvider provider,
  ) {
    return call(
      itemType: provider.itemType,
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
  String? get name => r'getAllHistoryStreamProvider';
}

/// See also [getAllHistoryStream].
class GetAllHistoryStreamProvider
    extends AutoDisposeStreamProvider<List<History>> {
  /// See also [getAllHistoryStream].
  GetAllHistoryStreamProvider({
    required ItemType itemType,
  }) : this._internal(
          (ref) => getAllHistoryStream(
            ref as GetAllHistoryStreamRef,
            itemType: itemType,
          ),
          from: getAllHistoryStreamProvider,
          name: r'getAllHistoryStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getAllHistoryStreamHash,
          dependencies: GetAllHistoryStreamFamily._dependencies,
          allTransitiveDependencies:
              GetAllHistoryStreamFamily._allTransitiveDependencies,
          itemType: itemType,
        );

  GetAllHistoryStreamProvider._internal(
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
    Stream<List<History>> Function(GetAllHistoryStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetAllHistoryStreamProvider._internal(
        (ref) => create(ref as GetAllHistoryStreamRef),
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
  AutoDisposeStreamProviderElement<List<History>> createElement() {
    return _GetAllHistoryStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetAllHistoryStreamProvider && other.itemType == itemType;
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
mixin GetAllHistoryStreamRef on AutoDisposeStreamProviderRef<List<History>> {
  /// The parameter `itemType` of this provider.
  ItemType get itemType;
}

class _GetAllHistoryStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<History>>
    with GetAllHistoryStreamRef {
  _GetAllHistoryStreamProviderElement(super.provider);

  @override
  ItemType get itemType => (origin as GetAllHistoryStreamProvider).itemType;
}

String _$getAllUpdateStreamHash() =>
    r'6a20f8feba3010c2ab7a80560f7a7f6cf10c7366';

/// See also [getAllUpdateStream].
@ProviderFor(getAllUpdateStream)
const getAllUpdateStreamProvider = GetAllUpdateStreamFamily();

/// See also [getAllUpdateStream].
class GetAllUpdateStreamFamily extends Family<AsyncValue<List<Update>>> {
  /// See also [getAllUpdateStream].
  const GetAllUpdateStreamFamily();

  /// See also [getAllUpdateStream].
  GetAllUpdateStreamProvider call({
    required ItemType itemType,
  }) {
    return GetAllUpdateStreamProvider(
      itemType: itemType,
    );
  }

  @override
  GetAllUpdateStreamProvider getProviderOverride(
    covariant GetAllUpdateStreamProvider provider,
  ) {
    return call(
      itemType: provider.itemType,
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
  String? get name => r'getAllUpdateStreamProvider';
}

/// See also [getAllUpdateStream].
class GetAllUpdateStreamProvider
    extends AutoDisposeStreamProvider<List<Update>> {
  /// See also [getAllUpdateStream].
  GetAllUpdateStreamProvider({
    required ItemType itemType,
  }) : this._internal(
          (ref) => getAllUpdateStream(
            ref as GetAllUpdateStreamRef,
            itemType: itemType,
          ),
          from: getAllUpdateStreamProvider,
          name: r'getAllUpdateStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getAllUpdateStreamHash,
          dependencies: GetAllUpdateStreamFamily._dependencies,
          allTransitiveDependencies:
              GetAllUpdateStreamFamily._allTransitiveDependencies,
          itemType: itemType,
        );

  GetAllUpdateStreamProvider._internal(
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
    Stream<List<Update>> Function(GetAllUpdateStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetAllUpdateStreamProvider._internal(
        (ref) => create(ref as GetAllUpdateStreamRef),
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
  AutoDisposeStreamProviderElement<List<Update>> createElement() {
    return _GetAllUpdateStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetAllUpdateStreamProvider && other.itemType == itemType;
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
mixin GetAllUpdateStreamRef on AutoDisposeStreamProviderRef<List<Update>> {
  /// The parameter `itemType` of this provider.
  ItemType get itemType;
}

class _GetAllUpdateStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Update>>
    with GetAllUpdateStreamRef {
  _GetAllUpdateStreamProviderElement(super.provider);

  @override
  ItemType get itemType => (origin as GetAllUpdateStreamProvider).itemType;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
