// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$trackStateHash() => r'b70770f8524a0d9059ffd3f52b42634c16672a0f';

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

abstract class _$TrackState extends BuildlessAutoDisposeNotifier<Track> {
  late final Track? track;
  late final ItemType? itemType;

  Track build({
    Track? track,
    required ItemType? itemType,
  });
}

/// See also [TrackState].
@ProviderFor(TrackState)
const trackStateProvider = TrackStateFamily();

/// See also [TrackState].
class TrackStateFamily extends Family<Track> {
  /// See also [TrackState].
  const TrackStateFamily();

  /// See also [TrackState].
  TrackStateProvider call({
    Track? track,
    required ItemType? itemType,
  }) {
    return TrackStateProvider(
      track: track,
      itemType: itemType,
    );
  }

  @override
  TrackStateProvider getProviderOverride(
    covariant TrackStateProvider provider,
  ) {
    return call(
      track: provider.track,
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
  String? get name => r'trackStateProvider';
}

/// See also [TrackState].
class TrackStateProvider
    extends AutoDisposeNotifierProviderImpl<TrackState, Track> {
  /// See also [TrackState].
  TrackStateProvider({
    Track? track,
    required ItemType? itemType,
  }) : this._internal(
          () => TrackState()
            ..track = track
            ..itemType = itemType,
          from: trackStateProvider,
          name: r'trackStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$trackStateHash,
          dependencies: TrackStateFamily._dependencies,
          allTransitiveDependencies:
              TrackStateFamily._allTransitiveDependencies,
          track: track,
          itemType: itemType,
        );

  TrackStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.track,
    required this.itemType,
  }) : super.internal();

  final Track? track;
  final ItemType? itemType;

  @override
  Track runNotifierBuild(
    covariant TrackState notifier,
  ) {
    return notifier.build(
      track: track,
      itemType: itemType,
    );
  }

  @override
  Override overrideWith(TrackState Function() create) {
    return ProviderOverride(
      origin: this,
      override: TrackStateProvider._internal(
        () => create()
          ..track = track
          ..itemType = itemType,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        track: track,
        itemType: itemType,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<TrackState, Track> createElement() {
    return _TrackStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TrackStateProvider &&
        other.track == track &&
        other.itemType == itemType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, track.hashCode);
    hash = _SystemHash.combine(hash, itemType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TrackStateRef on AutoDisposeNotifierProviderRef<Track> {
  /// The parameter `track` of this provider.
  Track? get track;

  /// The parameter `itemType` of this provider.
  ItemType? get itemType;
}

class _TrackStateProviderElement
    extends AutoDisposeNotifierProviderElement<TrackState, Track>
    with TrackStateRef {
  _TrackStateProviderElement(super.provider);

  @override
  Track? get track => (origin as TrackStateProvider).track;
  @override
  ItemType? get itemType => (origin as TrackStateProvider).itemType;
}

String _$lastTrackerLibraryLocationStateHash() =>
    r'c09efe7fe4f8dda723c31bc6543dbaa571718342';

/// See also [LastTrackerLibraryLocationState].
@ProviderFor(LastTrackerLibraryLocationState)
final lastTrackerLibraryLocationStateProvider = AutoDisposeNotifierProvider<
    LastTrackerLibraryLocationState, (int, bool)>.internal(
  LastTrackerLibraryLocationState.new,
  name: r'lastTrackerLibraryLocationStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lastTrackerLibraryLocationStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LastTrackerLibraryLocationState = AutoDisposeNotifier<(int, bool)>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
