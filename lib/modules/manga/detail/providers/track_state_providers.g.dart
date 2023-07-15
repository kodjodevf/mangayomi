// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$trackStateHash() => r'3e7b916624f8035766d9a6408812bf1cc1247915';

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

  Track build({
    Track? track,
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
  }) {
    return TrackStateProvider(
      track: track,
    );
  }

  @override
  TrackStateProvider getProviderOverride(
    covariant TrackStateProvider provider,
  ) {
    return call(
      track: provider.track,
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
    this.track,
  }) : super.internal(
          () => TrackState()..track = track,
          from: trackStateProvider,
          name: r'trackStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$trackStateHash,
          dependencies: TrackStateFamily._dependencies,
          allTransitiveDependencies:
              TrackStateFamily._allTransitiveDependencies,
        );

  final Track? track;

  @override
  bool operator ==(Object other) {
    return other is TrackStateProvider && other.track == track;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, track.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  Track runNotifierBuild(
    covariant TrackState notifier,
  ) {
    return notifier.build(
      track: track,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
