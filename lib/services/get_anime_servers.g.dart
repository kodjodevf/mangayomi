// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_anime_servers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAnimeServersHash() => r'39f02b0c0b51a78a7c1a67747686909beedc5d0e';

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

/// See also [getAnimeServers].
@ProviderFor(getAnimeServers)
const getAnimeServersProvider = GetAnimeServersFamily();

/// See also [getAnimeServers].
class GetAnimeServersFamily extends Family<AsyncValue<(List<Video>, bool)>> {
  /// See also [getAnimeServers].
  const GetAnimeServersFamily();

  /// See also [getAnimeServers].
  GetAnimeServersProvider call({
    required Chapter episode,
  }) {
    return GetAnimeServersProvider(
      episode: episode,
    );
  }

  @override
  GetAnimeServersProvider getProviderOverride(
    covariant GetAnimeServersProvider provider,
  ) {
    return call(
      episode: provider.episode,
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
  String? get name => r'getAnimeServersProvider';
}

/// See also [getAnimeServers].
class GetAnimeServersProvider
    extends AutoDisposeFutureProvider<(List<Video>, bool)> {
  /// See also [getAnimeServers].
  GetAnimeServersProvider({
    required Chapter episode,
  }) : this._internal(
          (ref) => getAnimeServers(
            ref as GetAnimeServersRef,
            episode: episode,
          ),
          from: getAnimeServersProvider,
          name: r'getAnimeServersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getAnimeServersHash,
          dependencies: GetAnimeServersFamily._dependencies,
          allTransitiveDependencies:
              GetAnimeServersFamily._allTransitiveDependencies,
          episode: episode,
        );

  GetAnimeServersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.episode,
  }) : super.internal();

  final Chapter episode;

  @override
  Override overrideWith(
    FutureOr<(List<Video>, bool)> Function(GetAnimeServersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetAnimeServersProvider._internal(
        (ref) => create(ref as GetAnimeServersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        episode: episode,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<(List<Video>, bool)> createElement() {
    return _GetAnimeServersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetAnimeServersProvider && other.episode == episode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, episode.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetAnimeServersRef on AutoDisposeFutureProviderRef<(List<Video>, bool)> {
  /// The parameter `episode` of this provider.
  Chapter get episode;
}

class _GetAnimeServersProviderElement
    extends AutoDisposeFutureProviderElement<(List<Video>, bool)>
    with GetAnimeServersRef {
  _GetAnimeServersProviderElement(super.provider);

  @override
  Chapter get episode => (origin as GetAnimeServersProvider).episode;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
