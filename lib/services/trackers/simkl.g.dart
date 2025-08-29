// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simkl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$simklHash() => r'3a6e18e9a2ef6dc702c569bd747c66ff605643ce';

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

abstract class _$Simkl extends BuildlessAutoDisposeNotifier<void> {
  late final int syncId;
  late final ItemType? itemType;

  void build({required int syncId, required ItemType? itemType});
}

/// See also [Simkl].
@ProviderFor(Simkl)
const simklProvider = SimklFamily();

/// See also [Simkl].
class SimklFamily extends Family<void> {
  /// See also [Simkl].
  const SimklFamily();

  /// See also [Simkl].
  SimklProvider call({required int syncId, required ItemType? itemType}) {
    return SimklProvider(syncId: syncId, itemType: itemType);
  }

  @override
  SimklProvider getProviderOverride(covariant SimklProvider provider) {
    return call(syncId: provider.syncId, itemType: provider.itemType);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'simklProvider';
}

/// See also [Simkl].
class SimklProvider extends AutoDisposeNotifierProviderImpl<Simkl, void> {
  /// See also [Simkl].
  SimklProvider({required int syncId, required ItemType? itemType})
    : this._internal(
        () => Simkl()
          ..syncId = syncId
          ..itemType = itemType,
        from: simklProvider,
        name: r'simklProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$simklHash,
        dependencies: SimklFamily._dependencies,
        allTransitiveDependencies: SimklFamily._allTransitiveDependencies,
        syncId: syncId,
        itemType: itemType,
      );

  SimklProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.syncId,
    required this.itemType,
  }) : super.internal();

  final int syncId;
  final ItemType? itemType;

  @override
  void runNotifierBuild(covariant Simkl notifier) {
    return notifier.build(syncId: syncId, itemType: itemType);
  }

  @override
  Override overrideWith(Simkl Function() create) {
    return ProviderOverride(
      origin: this,
      override: SimklProvider._internal(
        () => create()
          ..syncId = syncId
          ..itemType = itemType,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        syncId: syncId,
        itemType: itemType,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<Simkl, void> createElement() {
    return _SimklProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SimklProvider &&
        other.syncId == syncId &&
        other.itemType == itemType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, syncId.hashCode);
    hash = _SystemHash.combine(hash, itemType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SimklRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `syncId` of this provider.
  int get syncId;

  /// The parameter `itemType` of this provider.
  ItemType? get itemType;
}

class _SimklProviderElement
    extends AutoDisposeNotifierProviderElement<Simkl, void>
    with SimklRef {
  _SimklProviderElement(super.provider);

  @override
  int get syncId => (origin as SimklProvider).syncId;
  @override
  ItemType? get itemType => (origin as SimklProvider).itemType;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
