// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trakt_tv.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$traktTvHash() => r'd852a7d96511637bf565cbcf6e958397740158fd';

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

abstract class _$TraktTv extends BuildlessAutoDisposeNotifier<void> {
  late final int syncId;
  late final ItemType? itemType;

  void build({required int syncId, required ItemType? itemType});
}

/// See also [TraktTv].
@ProviderFor(TraktTv)
const traktTvProvider = TraktTvFamily();

/// See also [TraktTv].
class TraktTvFamily extends Family<void> {
  /// See also [TraktTv].
  const TraktTvFamily();

  /// See also [TraktTv].
  TraktTvProvider call({required int syncId, required ItemType? itemType}) {
    return TraktTvProvider(syncId: syncId, itemType: itemType);
  }

  @override
  TraktTvProvider getProviderOverride(covariant TraktTvProvider provider) {
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
  String? get name => r'traktTvProvider';
}

/// See also [TraktTv].
class TraktTvProvider extends AutoDisposeNotifierProviderImpl<TraktTv, void> {
  /// See also [TraktTv].
  TraktTvProvider({required int syncId, required ItemType? itemType})
    : this._internal(
        () => TraktTv()
          ..syncId = syncId
          ..itemType = itemType,
        from: traktTvProvider,
        name: r'traktTvProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$traktTvHash,
        dependencies: TraktTvFamily._dependencies,
        allTransitiveDependencies: TraktTvFamily._allTransitiveDependencies,
        syncId: syncId,
        itemType: itemType,
      );

  TraktTvProvider._internal(
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
  void runNotifierBuild(covariant TraktTv notifier) {
    return notifier.build(syncId: syncId, itemType: itemType);
  }

  @override
  Override overrideWith(TraktTv Function() create) {
    return ProviderOverride(
      origin: this,
      override: TraktTvProvider._internal(
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
  AutoDisposeNotifierProviderElement<TraktTv, void> createElement() {
    return _TraktTvProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TraktTvProvider &&
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
mixin TraktTvRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `syncId` of this provider.
  int get syncId;

  /// The parameter `itemType` of this provider.
  ItemType? get itemType;
}

class _TraktTvProviderElement
    extends AutoDisposeNotifierProviderElement<TraktTv, void>
    with TraktTvRef {
  _TraktTvProviderElement(super.provider);

  @override
  int get syncId => (origin as TraktTvProvider).syncId;
  @override
  ItemType? get itemType => (origin as TraktTvProvider).itemType;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
