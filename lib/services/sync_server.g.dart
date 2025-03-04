// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_server.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$syncServerHash() => r'f973d04732090056e127d6d882146adfd192705d';

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

abstract class _$SyncServer extends BuildlessAutoDisposeNotifier<void> {
  late final int syncId;

  void build({
    required int syncId,
  });
}

/// See also [SyncServer].
@ProviderFor(SyncServer)
const syncServerProvider = SyncServerFamily();

/// See also [SyncServer].
class SyncServerFamily extends Family<void> {
  /// See also [SyncServer].
  const SyncServerFamily();

  /// See also [SyncServer].
  SyncServerProvider call({
    required int syncId,
  }) {
    return SyncServerProvider(
      syncId: syncId,
    );
  }

  @override
  SyncServerProvider getProviderOverride(
    covariant SyncServerProvider provider,
  ) {
    return call(
      syncId: provider.syncId,
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
  String? get name => r'syncServerProvider';
}

/// See also [SyncServer].
class SyncServerProvider
    extends AutoDisposeNotifierProviderImpl<SyncServer, void> {
  /// See also [SyncServer].
  SyncServerProvider({
    required int syncId,
  }) : this._internal(
          () => SyncServer()..syncId = syncId,
          from: syncServerProvider,
          name: r'syncServerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$syncServerHash,
          dependencies: SyncServerFamily._dependencies,
          allTransitiveDependencies:
              SyncServerFamily._allTransitiveDependencies,
          syncId: syncId,
        );

  SyncServerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.syncId,
  }) : super.internal();

  final int syncId;

  @override
  void runNotifierBuild(
    covariant SyncServer notifier,
  ) {
    return notifier.build(
      syncId: syncId,
    );
  }

  @override
  Override overrideWith(SyncServer Function() create) {
    return ProviderOverride(
      origin: this,
      override: SyncServerProvider._internal(
        () => create()..syncId = syncId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        syncId: syncId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SyncServer, void> createElement() {
    return _SyncServerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SyncServerProvider && other.syncId == syncId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, syncId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SyncServerRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `syncId` of this provider.
  int get syncId;
}

class _SyncServerProviderElement
    extends AutoDisposeNotifierProviderElement<SyncServer, void>
    with SyncServerRef {
  _SyncServerProviderElement(super.provider);

  @override
  int get syncId => (origin as SyncServerProvider).syncId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
