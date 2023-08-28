// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_manga_sources.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchMangaSourcesListHash() =>
    r'0cd22cf1bb061a13e86e34ec08061e1c52c2f7cf';

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

typedef FetchMangaSourcesListRef = AutoDisposeFutureProviderRef<dynamic>;

/// See also [fetchMangaSourcesList].
@ProviderFor(fetchMangaSourcesList)
const fetchMangaSourcesListProvider = FetchMangaSourcesListFamily();

/// See also [fetchMangaSourcesList].
class FetchMangaSourcesListFamily extends Family<AsyncValue<dynamic>> {
  /// See also [fetchMangaSourcesList].
  const FetchMangaSourcesListFamily();

  /// See also [fetchMangaSourcesList].
  FetchMangaSourcesListProvider call({
    int? id,
    required dynamic refresh,
  }) {
    return FetchMangaSourcesListProvider(
      id: id,
      refresh: refresh,
    );
  }

  @override
  FetchMangaSourcesListProvider getProviderOverride(
    covariant FetchMangaSourcesListProvider provider,
  ) {
    return call(
      id: provider.id,
      refresh: provider.refresh,
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
  String? get name => r'fetchMangaSourcesListProvider';
}

/// See also [fetchMangaSourcesList].
class FetchMangaSourcesListProvider extends AutoDisposeFutureProvider<dynamic> {
  /// See also [fetchMangaSourcesList].
  FetchMangaSourcesListProvider({
    this.id,
    required this.refresh,
  }) : super.internal(
          (ref) => fetchMangaSourcesList(
            ref,
            id: id,
            refresh: refresh,
          ),
          from: fetchMangaSourcesListProvider,
          name: r'fetchMangaSourcesListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchMangaSourcesListHash,
          dependencies: FetchMangaSourcesListFamily._dependencies,
          allTransitiveDependencies:
              FetchMangaSourcesListFamily._allTransitiveDependencies,
        );

  final int? id;
  final dynamic refresh;

  @override
  bool operator ==(Object other) {
    return other is FetchMangaSourcesListProvider &&
        other.id == id &&
        other.refresh == refresh;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);
    hash = _SystemHash.combine(hash, refresh.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
