// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_manga_detail.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getMangaDetailHash() => r'0977fe9466dcf9262e37beb644b7f66be2214d1a';

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

/// See also [getMangaDetail].
@ProviderFor(getMangaDetail)
const getMangaDetailProvider = GetMangaDetailFamily();

/// See also [getMangaDetail].
class GetMangaDetailFamily extends Family<AsyncValue<MManga>> {
  /// See also [getMangaDetail].
  const GetMangaDetailFamily();

  /// See also [getMangaDetail].
  GetMangaDetailProvider call({
    required MManga manga,
    required Source source,
  }) {
    return GetMangaDetailProvider(
      manga: manga,
      source: source,
    );
  }

  @override
  GetMangaDetailProvider getProviderOverride(
    covariant GetMangaDetailProvider provider,
  ) {
    return call(
      manga: provider.manga,
      source: provider.source,
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
  String? get name => r'getMangaDetailProvider';
}

/// See also [getMangaDetail].
class GetMangaDetailProvider extends AutoDisposeFutureProvider<MManga> {
  /// See also [getMangaDetail].
  GetMangaDetailProvider({
    required MManga manga,
    required Source source,
  }) : this._internal(
          (ref) => getMangaDetail(
            ref as GetMangaDetailRef,
            manga: manga,
            source: source,
          ),
          from: getMangaDetailProvider,
          name: r'getMangaDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getMangaDetailHash,
          dependencies: GetMangaDetailFamily._dependencies,
          allTransitiveDependencies:
              GetMangaDetailFamily._allTransitiveDependencies,
          manga: manga,
          source: source,
        );

  GetMangaDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.manga,
    required this.source,
  }) : super.internal();

  final MManga manga;
  final Source source;

  @override
  Override overrideWith(
    FutureOr<MManga> Function(GetMangaDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetMangaDetailProvider._internal(
        (ref) => create(ref as GetMangaDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        manga: manga,
        source: source,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MManga> createElement() {
    return _GetMangaDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetMangaDetailProvider &&
        other.manga == manga &&
        other.source == source;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, manga.hashCode);
    hash = _SystemHash.combine(hash, source.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetMangaDetailRef on AutoDisposeFutureProviderRef<MManga> {
  /// The parameter `manga` of this provider.
  MManga get manga;

  /// The parameter `source` of this provider.
  Source get source;
}

class _GetMangaDetailProviderElement
    extends AutoDisposeFutureProviderElement<MManga>
    with GetMangaDetailRef {
  _GetMangaDetailProviderElement(super.provider);

  @override
  MManga get manga => (origin as GetMangaDetailProvider).manga;
  @override
  Source get source => (origin as GetMangaDetailProvider).source;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
