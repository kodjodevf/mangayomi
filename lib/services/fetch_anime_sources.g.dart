// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_anime_sources.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchAnimeSourcesListHash() =>
    r'75185e008e90491987fabb55851c536de89653a4';

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

/// See also [fetchAnimeSourcesList].
@ProviderFor(fetchAnimeSourcesList)
const fetchAnimeSourcesListProvider = FetchAnimeSourcesListFamily();

/// See also [fetchAnimeSourcesList].
class FetchAnimeSourcesListFamily extends Family<AsyncValue> {
  /// See also [fetchAnimeSourcesList].
  const FetchAnimeSourcesListFamily();

  /// See also [fetchAnimeSourcesList].
  FetchAnimeSourcesListProvider call({
    int? id,
    required bool reFresh,
  }) {
    return FetchAnimeSourcesListProvider(
      id: id,
      reFresh: reFresh,
    );
  }

  @override
  FetchAnimeSourcesListProvider getProviderOverride(
    covariant FetchAnimeSourcesListProvider provider,
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
  String? get name => r'fetchAnimeSourcesListProvider';
}

/// See also [fetchAnimeSourcesList].
class FetchAnimeSourcesListProvider extends AutoDisposeFutureProvider<Object?> {
  /// See also [fetchAnimeSourcesList].
  FetchAnimeSourcesListProvider({
    int? id,
    required bool reFresh,
  }) : this._internal(
          (ref) => fetchAnimeSourcesList(
            ref as FetchAnimeSourcesListRef,
            id: id,
            reFresh: reFresh,
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
          id: id,
          reFresh: reFresh,
        );

  FetchAnimeSourcesListProvider._internal(
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
  final bool reFresh;

  @override
  Override overrideWith(
    FutureOr<Object?> Function(FetchAnimeSourcesListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchAnimeSourcesListProvider._internal(
        (ref) => create(ref as FetchAnimeSourcesListRef),
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
    return _FetchAnimeSourcesListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchAnimeSourcesListProvider &&
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
mixin FetchAnimeSourcesListRef on AutoDisposeFutureProviderRef<Object?> {
  /// The parameter `id` of this provider.
  int? get id;

  /// The parameter `reFresh` of this provider.
  bool get reFresh;
}

class _FetchAnimeSourcesListProviderElement
    extends AutoDisposeFutureProviderElement<Object?>
    with FetchAnimeSourcesListRef {
  _FetchAnimeSourcesListProviderElement(super.provider);

  @override
  int? get id => (origin as FetchAnimeSourcesListProvider).id;
  @override
  bool get reFresh => (origin as FetchAnimeSourcesListProvider).reFresh;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
