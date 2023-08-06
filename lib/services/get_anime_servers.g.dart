// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_anime_servers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAnimeServersHash() => r'cd7f0fc4ee58ec02b015348aed60b1b0f2d1b300';

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

typedef GetAnimeServersRef = AutoDisposeFutureProviderRef<List<Video>>;

/// See also [getAnimeServers].
@ProviderFor(getAnimeServers)
const getAnimeServersProvider = GetAnimeServersFamily();

/// See also [getAnimeServers].
class GetAnimeServersFamily extends Family<AsyncValue<List<Video>>> {
  /// See also [getAnimeServers].
  const GetAnimeServersFamily();

  /// See also [getAnimeServers].
  GetAnimeServersProvider call({
    required Chapter chapter,
  }) {
    return GetAnimeServersProvider(
      chapter: chapter,
    );
  }

  @override
  GetAnimeServersProvider getProviderOverride(
    covariant GetAnimeServersProvider provider,
  ) {
    return call(
      chapter: provider.chapter,
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
class GetAnimeServersProvider extends AutoDisposeFutureProvider<List<Video>> {
  /// See also [getAnimeServers].
  GetAnimeServersProvider({
    required this.chapter,
  }) : super.internal(
          (ref) => getAnimeServers(
            ref,
            chapter: chapter,
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
        );

  final Chapter chapter;

  @override
  bool operator ==(Object other) {
    return other is GetAnimeServersProvider && other.chapter == chapter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapter.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
