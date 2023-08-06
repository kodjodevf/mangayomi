// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_anime_sources.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchAnimeSourcesListHash() =>
    r'c6d2c5cd85d0086160d7af66e9f7f07da7dcbc53';

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

typedef FetchAnimeSourcesListRef = AutoDisposeFutureProviderRef<dynamic>;

/// See also [fetchAnimeSourcesList].
@ProviderFor(fetchAnimeSourcesList)
const fetchAnimeSourcesListProvider = FetchAnimeSourcesListFamily();

/// See also [fetchAnimeSourcesList].
class FetchAnimeSourcesListFamily extends Family<AsyncValue<dynamic>> {
  /// See also [fetchAnimeSourcesList].
  const FetchAnimeSourcesListFamily();

  /// See also [fetchAnimeSourcesList].
  FetchAnimeSourcesListProvider call({
    int? id,
  }) {
    return FetchAnimeSourcesListProvider(
      id: id,
    );
  }

  @override
  FetchAnimeSourcesListProvider getProviderOverride(
    covariant FetchAnimeSourcesListProvider provider,
  ) {
    return call(
      id: provider.id,
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
  String? get name => r'fetchAnimeSourcesListProvider';
}

/// See also [fetchAnimeSourcesList].
class FetchAnimeSourcesListProvider extends AutoDisposeFutureProvider<dynamic> {
  /// See also [fetchAnimeSourcesList].
  FetchAnimeSourcesListProvider({
    this.id,
  }) : super.internal(
          (ref) => fetchAnimeSourcesList(
            ref,
            id: id,
          ),
          from: fetchAnimeSourcesListProvider,
          name: r'fetchAnimeSourcesListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchAnimeSourcesListHash,
          dependencies: FetchAnimeSourcesListFamily._dependencies,
          allTransitiveDependencies:
              FetchAnimeSourcesListFamily._allTransitiveDependencies,
        );

  final int? id;

  @override
  bool operator ==(Object other) {
    return other is FetchAnimeSourcesListProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
