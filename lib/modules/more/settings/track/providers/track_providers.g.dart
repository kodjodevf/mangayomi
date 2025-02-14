// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tracksHash() => r'de3a19fc6542e0f610d154978fbd0272259142fc';

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

abstract class _$Tracks extends BuildlessAutoDisposeNotifier<TrackPreference?> {
  late final int? syncId;

  TrackPreference? build({
    required int? syncId,
  });
}

/// See also [Tracks].
@ProviderFor(Tracks)
const tracksProvider = TracksFamily();

/// See also [Tracks].
class TracksFamily extends Family<TrackPreference?> {
  /// See also [Tracks].
  const TracksFamily();

  /// See also [Tracks].
  TracksProvider call({
    required int? syncId,
  }) {
    return TracksProvider(
      syncId: syncId,
    );
  }

  @override
  TracksProvider getProviderOverride(
    covariant TracksProvider provider,
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
  String? get name => r'tracksProvider';
}

/// See also [Tracks].
class TracksProvider
    extends AutoDisposeNotifierProviderImpl<Tracks, TrackPreference?> {
  /// See also [Tracks].
  TracksProvider({
    required int? syncId,
  }) : this._internal(
          () => Tracks()..syncId = syncId,
          from: tracksProvider,
          name: r'tracksProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tracksHash,
          dependencies: TracksFamily._dependencies,
          allTransitiveDependencies: TracksFamily._allTransitiveDependencies,
          syncId: syncId,
        );

  TracksProvider._internal(
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
  TrackPreference? runNotifierBuild(
    covariant Tracks notifier,
  ) {
    return notifier.build(
      syncId: syncId,
    );
  }

  @override
  Override overrideWith(Tracks Function() create) {
    return ProviderOverride(
      origin: this,
      override: TracksProvider._internal(
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
  AutoDisposeNotifierProviderElement<Tracks, TrackPreference?> createElement() {
    return _TracksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TracksProvider && other.syncId == syncId;
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
mixin TracksRef on AutoDisposeNotifierProviderRef<TrackPreference?> {
  /// The parameter `syncId` of this provider.
  int? get syncId;
}

class _TracksProviderElement
    extends AutoDisposeNotifierProviderElement<Tracks, TrackPreference?>
    with TracksRef {
  _TracksProviderElement(super.provider);

  @override
  int? get syncId => (origin as TracksProvider).syncId;
}

String _$updateProgressAfterReadingStateHash() =>
    r'ad615c0c03d376adf8bc4728aac4288e61facee5';

/// See also [UpdateProgressAfterReadingState].
@ProviderFor(UpdateProgressAfterReadingState)
final updateProgressAfterReadingStateProvider =
    AutoDisposeNotifierProvider<UpdateProgressAfterReadingState, bool>.internal(
  UpdateProgressAfterReadingState.new,
  name: r'updateProgressAfterReadingStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateProgressAfterReadingStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UpdateProgressAfterReadingState = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
