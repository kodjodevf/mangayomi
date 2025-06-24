// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'myanimelist.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myAnimeListHash() => r'885e6c50439c699f12c4f17c9e26b4a53b1d2036';

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

abstract class _$MyAnimeList extends BuildlessAutoDisposeNotifier<void> {
  late final int syncId;
  late final ItemType? itemType;

  void build({
    required int syncId,
    required ItemType? itemType,
  });
}

/// See also [MyAnimeList].
@ProviderFor(MyAnimeList)
const myAnimeListProvider = MyAnimeListFamily();

/// See also [MyAnimeList].
class MyAnimeListFamily extends Family<void> {
  /// See also [MyAnimeList].
  const MyAnimeListFamily();

  /// See also [MyAnimeList].
  MyAnimeListProvider call({
    required int syncId,
    required ItemType? itemType,
  }) {
    return MyAnimeListProvider(
      syncId: syncId,
      itemType: itemType,
    );
  }

  @override
  MyAnimeListProvider getProviderOverride(
    covariant MyAnimeListProvider provider,
  ) {
    return call(
      syncId: provider.syncId,
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
  String? get name => r'myAnimeListProvider';
}

/// See also [MyAnimeList].
class MyAnimeListProvider
    extends AutoDisposeNotifierProviderImpl<MyAnimeList, void> {
  /// See also [MyAnimeList].
  MyAnimeListProvider({
    required int syncId,
    required ItemType? itemType,
  }) : this._internal(
          () => MyAnimeList()
            ..syncId = syncId
            ..itemType = itemType,
          from: myAnimeListProvider,
          name: r'myAnimeListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$myAnimeListHash,
          dependencies: MyAnimeListFamily._dependencies,
          allTransitiveDependencies:
              MyAnimeListFamily._allTransitiveDependencies,
          syncId: syncId,
          itemType: itemType,
        );

  MyAnimeListProvider._internal(
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
  void runNotifierBuild(
    covariant MyAnimeList notifier,
  ) {
    return notifier.build(
      syncId: syncId,
      itemType: itemType,
    );
  }

  @override
  Override overrideWith(MyAnimeList Function() create) {
    return ProviderOverride(
      origin: this,
      override: MyAnimeListProvider._internal(
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
  AutoDisposeNotifierProviderElement<MyAnimeList, void> createElement() {
    return _MyAnimeListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MyAnimeListProvider &&
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
mixin MyAnimeListRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `syncId` of this provider.
  int get syncId;

  /// The parameter `itemType` of this provider.
  ItemType? get itemType;
}

class _MyAnimeListProviderElement
    extends AutoDisposeNotifierProviderElement<MyAnimeList, void>
    with MyAnimeListRef {
  _MyAnimeListProviderElement(super.provider);

  @override
  int get syncId => (origin as MyAnimeListProvider).syncId;
  @override
  ItemType? get itemType => (origin as MyAnimeListProvider).itemType;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
