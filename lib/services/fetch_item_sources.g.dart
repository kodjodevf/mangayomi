// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_item_sources.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchItemSourcesListHash() =>
    r'16238be20517fddacf52a2694fbd50cafbfa7496';

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

/// See also [fetchItemSourcesList].
@ProviderFor(fetchItemSourcesList)
const fetchItemSourcesListProvider = FetchItemSourcesListFamily();

/// See also [fetchItemSourcesList].
class FetchItemSourcesListFamily extends Family<AsyncValue<void>> {
  /// See also [fetchItemSourcesList].
  const FetchItemSourcesListFamily();

  /// See also [fetchItemSourcesList].
  FetchItemSourcesListProvider call({
    int? id,
    required bool reFresh,
    required ItemType itemType,
  }) {
    return FetchItemSourcesListProvider(
      id: id,
      reFresh: reFresh,
      itemType: itemType,
    );
  }

  @override
  FetchItemSourcesListProvider getProviderOverride(
    covariant FetchItemSourcesListProvider provider,
  ) {
    return call(
      id: provider.id,
      reFresh: provider.reFresh,
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
  String? get name => r'fetchItemSourcesListProvider';
}

/// See also [fetchItemSourcesList].
class FetchItemSourcesListProvider extends FutureProvider<void> {
  /// See also [fetchItemSourcesList].
  FetchItemSourcesListProvider({
    int? id,
    required bool reFresh,
    required ItemType itemType,
  }) : this._internal(
         (ref) => fetchItemSourcesList(
           ref as FetchItemSourcesListRef,
           id: id,
           reFresh: reFresh,
           itemType: itemType,
         ),
         from: fetchItemSourcesListProvider,
         name: r'fetchItemSourcesListProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$fetchItemSourcesListHash,
         dependencies: FetchItemSourcesListFamily._dependencies,
         allTransitiveDependencies:
             FetchItemSourcesListFamily._allTransitiveDependencies,
         id: id,
         reFresh: reFresh,
         itemType: itemType,
       );

  FetchItemSourcesListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
    required this.reFresh,
    required this.itemType,
  }) : super.internal();

  final int? id;
  final bool reFresh;
  final ItemType itemType;

  @override
  Override overrideWith(
    FutureOr<void> Function(FetchItemSourcesListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchItemSourcesListProvider._internal(
        (ref) => create(ref as FetchItemSourcesListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
        reFresh: reFresh,
        itemType: itemType,
      ),
    );
  }

  @override
  FutureProviderElement<void> createElement() {
    return _FetchItemSourcesListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchItemSourcesListProvider &&
        other.id == id &&
        other.reFresh == reFresh &&
        other.itemType == itemType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);
    hash = _SystemHash.combine(hash, reFresh.hashCode);
    hash = _SystemHash.combine(hash, itemType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchItemSourcesListRef on FutureProviderRef<void> {
  /// The parameter `id` of this provider.
  int? get id;

  /// The parameter `reFresh` of this provider.
  bool get reFresh;

  /// The parameter `itemType` of this provider.
  ItemType get itemType;
}

class _FetchItemSourcesListProviderElement extends FutureProviderElement<void>
    with FetchItemSourcesListRef {
  _FetchItemSourcesListProviderElement(super.provider);

  @override
  int? get id => (origin as FetchItemSourcesListProvider).id;
  @override
  bool get reFresh => (origin as FetchItemSourcesListProvider).reFresh;
  @override
  ItemType get itemType => (origin as FetchItemSourcesListProvider).itemType;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
