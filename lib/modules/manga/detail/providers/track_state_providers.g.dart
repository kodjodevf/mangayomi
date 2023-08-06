// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$trackStateHash() => r'eeca421125ff52ccf671d434c41e0198bb7b6fea';

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
  late final bool? isManga;

  Track build({
    Track? track,
    required bool? isManga,
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
    required bool? isManga,
  }) {
    return TrackStateProvider(
      track: track,
      isManga: isManga,
    );
  }

  @override
  TrackStateProvider getProviderOverride(
    covariant TrackStateProvider provider,
  ) {
    return call(
      track: provider.track,
      isManga: provider.isManga,
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
    required this.isManga,
  }) : super.internal(
          () => TrackState()
            ..track = track
            ..isManga = isManga,
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
  final bool? isManga;

  @override
  bool operator ==(Object other) {
    return other is TrackStateProvider &&
        other.track == track &&
        other.isManga == isManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, track.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  Track runNotifierBuild(
    covariant TrackState notifier,
  ) {
    return notifier.build(
      track: track,
      isManga: isManga,
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
