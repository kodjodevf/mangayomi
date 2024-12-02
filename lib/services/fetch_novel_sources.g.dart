// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_novel_sources.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchNovelSourcesListHash() =>
    r'cc4b989c0248c3b16155444c0c429d1ed0025ecb';

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

/// See also [fetchNovelSourcesList].
@ProviderFor(fetchNovelSourcesList)
const fetchNovelSourcesListProvider = FetchNovelSourcesListFamily();

/// See also [fetchNovelSourcesList].
class FetchNovelSourcesListFamily extends Family<AsyncValue> {
  /// See also [fetchNovelSourcesList].
  const FetchNovelSourcesListFamily();

  /// See also [fetchNovelSourcesList].
  FetchNovelSourcesListProvider call({
    int? id,
    required dynamic reFresh,
  }) {
    return FetchNovelSourcesListProvider(
      id: id,
      reFresh: reFresh,
    );
  }

  @override
  FetchNovelSourcesListProvider getProviderOverride(
    covariant FetchNovelSourcesListProvider provider,
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
  String? get name => r'fetchNovelSourcesListProvider';
}

/// See also [fetchNovelSourcesList].
class FetchNovelSourcesListProvider extends AutoDisposeFutureProvider<Object?> {
  /// See also [fetchNovelSourcesList].
  FetchNovelSourcesListProvider({
    int? id,
    required dynamic reFresh,
  }) : this._internal(
          (ref) => fetchNovelSourcesList(
            ref as FetchNovelSourcesListRef,
            id: id,
            reFresh: reFresh,
          ),
          from: fetchNovelSourcesListProvider,
          name: r'fetchNovelSourcesListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchNovelSourcesListHash,
          dependencies: FetchNovelSourcesListFamily._dependencies,
          allTransitiveDependencies:
              FetchNovelSourcesListFamily._allTransitiveDependencies,
          id: id,
          reFresh: reFresh,
        );

  FetchNovelSourcesListProvider._internal(
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
    FutureOr<Object?> Function(FetchNovelSourcesListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchNovelSourcesListProvider._internal(
        (ref) => create(ref as FetchNovelSourcesListRef),
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
    return _FetchNovelSourcesListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchNovelSourcesListProvider &&
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
mixin FetchNovelSourcesListRef on AutoDisposeFutureProviderRef<Object?> {
  /// The parameter `id` of this provider.
  int? get id;

  /// The parameter `reFresh` of this provider.
  dynamic get reFresh;
}

class _FetchNovelSourcesListProviderElement
    extends AutoDisposeFutureProviderElement<Object?>
    with FetchNovelSourcesListRef {
  _FetchNovelSourcesListProviderElement(super.provider);

  @override
  int? get id => (origin as FetchNovelSourcesListProvider).id;
  @override
  dynamic get reFresh => (origin as FetchNovelSourcesListProvider).reFresh;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
