// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$synchingHash() => r'8a4f7f408bf0ac26f4a21368620051ecba3adf53';

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

abstract class _$Synching extends BuildlessAutoDisposeNotifier<SyncPreference> {
  late final int? syncId;

  SyncPreference build({
    required int? syncId,
  });
}

/// See also [Synching].
@ProviderFor(Synching)
const synchingProvider = SynchingFamily();

/// See also [Synching].
class SynchingFamily extends Family<SyncPreference> {
  /// See also [Synching].
  const SynchingFamily();

  /// See also [Synching].
  SynchingProvider call({
    required int? syncId,
  }) {
    return SynchingProvider(
      syncId: syncId,
    );
  }

  @override
  SynchingProvider getProviderOverride(
    covariant SynchingProvider provider,
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
  String? get name => r'synchingProvider';
}

/// See also [Synching].
class SynchingProvider
    extends AutoDisposeNotifierProviderImpl<Synching, SyncPreference> {
  /// See also [Synching].
  SynchingProvider({
    required int? syncId,
  }) : this._internal(
          () => Synching()..syncId = syncId,
          from: synchingProvider,
          name: r'synchingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$synchingHash,
          dependencies: SynchingFamily._dependencies,
          allTransitiveDependencies: SynchingFamily._allTransitiveDependencies,
          syncId: syncId,
        );

  SynchingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.syncId,
  }) : super.internal();

  final int? syncId;

  @override
  SyncPreference runNotifierBuild(
    covariant Synching notifier,
  ) {
    return notifier.build(
      syncId: syncId,
    );
  }

  @override
  Override overrideWith(Synching Function() create) {
    return ProviderOverride(
      origin: this,
      override: SynchingProvider._internal(
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
  AutoDisposeNotifierProviderElement<Synching, SyncPreference> createElement() {
    return _SynchingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SynchingProvider && other.syncId == syncId;
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
mixin SynchingRef on AutoDisposeNotifierProviderRef<SyncPreference> {
  /// The parameter `syncId` of this provider.
  int? get syncId;
}

class _SynchingProviderElement
    extends AutoDisposeNotifierProviderElement<Synching, SyncPreference>
    with SynchingRef {
  _SynchingProviderElement(super.provider);

  @override
  int? get syncId => (origin as SynchingProvider).syncId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
