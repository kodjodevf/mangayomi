// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$statisticsStateHash() => r'81e1957e0e39a9863a8e7d0e1dc565c4eb0e6f9a';

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

abstract class _$StatisticsState extends BuildlessAutoDisposeNotifier<void> {
  late final ItemType itemType;

  void build(ItemType itemType);
}

/// See also [StatisticsState].
@ProviderFor(StatisticsState)
const statisticsStateProvider = StatisticsStateFamily();

/// See also [StatisticsState].
class StatisticsStateFamily extends Family<void> {
  /// See also [StatisticsState].
  const StatisticsStateFamily();

  /// See also [StatisticsState].
  StatisticsStateProvider call(ItemType itemType) {
    return StatisticsStateProvider(itemType);
  }

  @override
  StatisticsStateProvider getProviderOverride(
    covariant StatisticsStateProvider provider,
  ) {
    return call(provider.itemType);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'statisticsStateProvider';
}

/// See also [StatisticsState].
class StatisticsStateProvider
    extends AutoDisposeNotifierProviderImpl<StatisticsState, void> {
  /// See also [StatisticsState].
  StatisticsStateProvider(ItemType itemType)
    : this._internal(
        () => StatisticsState()..itemType = itemType,
        from: statisticsStateProvider,
        name: r'statisticsStateProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$statisticsStateHash,
        dependencies: StatisticsStateFamily._dependencies,
        allTransitiveDependencies:
            StatisticsStateFamily._allTransitiveDependencies,
        itemType: itemType,
      );

  StatisticsStateProvider._internal(
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
  void runNotifierBuild(covariant StatisticsState notifier) {
    return notifier.build(itemType);
  }

  @override
  Override overrideWith(StatisticsState Function() create) {
    return ProviderOverride(
      origin: this,
      override: StatisticsStateProvider._internal(
        () => create()..itemType = itemType,
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
  AutoDisposeNotifierProviderElement<StatisticsState, void> createElement() {
    return _StatisticsStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StatisticsStateProvider && other.itemType == itemType;
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
mixin StatisticsStateRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `itemType` of this provider.
  ItemType get itemType;
}

class _StatisticsStateProviderElement
    extends AutoDisposeNotifierProviderElement<StatisticsState, void>
    with StatisticsStateRef {
  _StatisticsStateProviderElement(super.provider);

  @override
  ItemType get itemType => (origin as StatisticsStateProvider).itemType;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
