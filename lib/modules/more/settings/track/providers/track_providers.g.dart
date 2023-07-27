// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tracksHash() => r'65e6092128a8d24edcecb215287d4a774df1b180';

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
    required this.syncId,
  }) : super.internal(
          () => Tracks()..syncId = syncId,
          from: tracksProvider,
          name: r'tracksProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tracksHash,
          dependencies: TracksFamily._dependencies,
          allTransitiveDependencies: TracksFamily._allTransitiveDependencies,
        );

  final int? syncId;

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

  @override
  TrackPreference? runNotifierBuild(
    covariant Tracks notifier,
  ) {
    return notifier.build(
      syncId: syncId,
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
