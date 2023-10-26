// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_latest_updates_manga.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getLatestUpdatesMangaHash() =>
    r'1d73d374c00305d86e3a62ea762367391a01b093';

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

/// See also [getLatestUpdatesManga].
@ProviderFor(getLatestUpdatesManga)
const getLatestUpdatesMangaProvider = GetLatestUpdatesMangaFamily();

/// See also [getLatestUpdatesManga].
class GetLatestUpdatesMangaFamily extends Family<AsyncValue<List<MManga?>>> {
  /// See also [getLatestUpdatesManga].
  const GetLatestUpdatesMangaFamily();

  /// See also [getLatestUpdatesManga].
  GetLatestUpdatesMangaProvider call({
    required Source source,
    required int page,
  }) {
    return GetLatestUpdatesMangaProvider(
      source: source,
      page: page,
    );
  }

  @override
  GetLatestUpdatesMangaProvider getProviderOverride(
    covariant GetLatestUpdatesMangaProvider provider,
  ) {
    return call(
      source: provider.source,
      page: provider.page,
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
  String? get name => r'getLatestUpdatesMangaProvider';
}

/// See also [getLatestUpdatesManga].
class GetLatestUpdatesMangaProvider
    extends AutoDisposeFutureProvider<List<MManga?>> {
  /// See also [getLatestUpdatesManga].
  GetLatestUpdatesMangaProvider({
    required Source source,
    required int page,
  }) : this._internal(
          (ref) => getLatestUpdatesManga(
            ref as GetLatestUpdatesMangaRef,
            source: source,
            page: page,
          ),
          from: getLatestUpdatesMangaProvider,
          name: r'getLatestUpdatesMangaProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getLatestUpdatesMangaHash,
          dependencies: GetLatestUpdatesMangaFamily._dependencies,
          allTransitiveDependencies:
              GetLatestUpdatesMangaFamily._allTransitiveDependencies,
          source: source,
          page: page,
        );

  GetLatestUpdatesMangaProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.source,
    required this.page,
  }) : super.internal();

  final Source source;
  final int page;

  @override
  Override overrideWith(
    FutureOr<List<MManga?>> Function(GetLatestUpdatesMangaRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetLatestUpdatesMangaProvider._internal(
        (ref) => create(ref as GetLatestUpdatesMangaRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        source: source,
        page: page,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MManga?>> createElement() {
    return _GetLatestUpdatesMangaProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetLatestUpdatesMangaProvider &&
        other.source == source &&
        other.page == page;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, source.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetLatestUpdatesMangaRef on AutoDisposeFutureProviderRef<List<MManga?>> {
  /// The parameter `source` of this provider.
  Source get source;

  /// The parameter `page` of this provider.
  int get page;
}

class _GetLatestUpdatesMangaProviderElement
    extends AutoDisposeFutureProviderElement<List<MManga?>>
    with GetLatestUpdatesMangaRef {
  _GetLatestUpdatesMangaProviderElement(super.provider);

  @override
  Source get source => (origin as GetLatestUpdatesMangaProvider).source;
  @override
  int get page => (origin as GetLatestUpdatesMangaProvider).page;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
