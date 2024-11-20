// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_manga_sources.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchMangaSourcesListHash() =>
    r'8bc08c334cfdba887227c154e249355f33e69da4';

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

/// See also [fetchMangaSourcesList].
@ProviderFor(fetchMangaSourcesList)
const fetchMangaSourcesListProvider = FetchMangaSourcesListFamily();

/// See also [fetchMangaSourcesList].
class FetchMangaSourcesListFamily extends Family<AsyncValue> {
  /// See also [fetchMangaSourcesList].
  const FetchMangaSourcesListFamily();

  /// See also [fetchMangaSourcesList].
  FetchMangaSourcesListProvider call({
    int? id,
    required dynamic reFresh,
  }) {
    return FetchMangaSourcesListProvider(
      id: id,
      reFresh: reFresh,
    );
  }

  @override
  FetchMangaSourcesListProvider getProviderOverride(
    covariant FetchMangaSourcesListProvider provider,
  ) {
    return call(
      id: provider.id,
      reFresh: provider.reFresh,
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
class FetchMangaSourcesListProvider extends AutoDisposeFutureProvider<Object?> {
  /// See also [fetchMangaSourcesList].
  FetchMangaSourcesListProvider({
    int? id,
    required dynamic reFresh,
  }) : this._internal(
          (ref) => fetchMangaSourcesList(
            ref as FetchMangaSourcesListRef,
            id: id,
            reFresh: reFresh,
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
          id: id,
          reFresh: reFresh,
        );

  FetchMangaSourcesListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
    required this.reFresh,
  }) : super.internal();

  final int? id;
  final dynamic reFresh;

  @override
  Override overrideWith(
    FutureOr<Object?> Function(FetchMangaSourcesListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchMangaSourcesListProvider._internal(
        (ref) => create(ref as FetchMangaSourcesListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
        reFresh: reFresh,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Object?> createElement() {
    return _FetchMangaSourcesListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchMangaSourcesListProvider &&
        other.id == id &&
        other.reFresh == reFresh;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);
    hash = _SystemHash.combine(hash, reFresh.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchMangaSourcesListRef on AutoDisposeFutureProviderRef<Object?> {
  /// The parameter `id` of this provider.
  int? get id;

  /// The parameter `reFresh` of this provider.
  dynamic get reFresh;
}

class _FetchMangaSourcesListProviderElement
    extends AutoDisposeFutureProviderElement<Object?>
    with FetchMangaSourcesListRef {
  _FetchMangaSourcesListProviderElement(super.provider);

  @override
  int? get id => (origin as FetchMangaSourcesListProvider).id;
  @override
  dynamic get reFresh => (origin as FetchMangaSourcesListProvider).reFresh;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
