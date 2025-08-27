// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_popular.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getPopularHash() => r'5fd933ce7e2b9c2dd113b7642ed54c1a1196f638';

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

/// See also [getPopular].
@ProviderFor(getPopular)
const getPopularProvider = GetPopularFamily();

/// See also [getPopular].
class GetPopularFamily extends Family<AsyncValue<MPages?>> {
  /// See also [getPopular].
  const GetPopularFamily();

  /// See also [getPopular].
  GetPopularProvider call({required Source source, required int page}) {
    return GetPopularProvider(source: source, page: page);
  }

  @override
  GetPopularProvider getProviderOverride(
    covariant GetPopularProvider provider,
  ) {
    return call(source: provider.source, page: provider.page);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getPopularProvider';
}

/// See also [getPopular].
class GetPopularProvider extends AutoDisposeFutureProvider<MPages?> {
  /// See also [getPopular].
  GetPopularProvider({required Source source, required int page})
    : this._internal(
        (ref) => getPopular(ref as GetPopularRef, source: source, page: page),
        from: getPopularProvider,
        name: r'getPopularProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$getPopularHash,
        dependencies: GetPopularFamily._dependencies,
        allTransitiveDependencies: GetPopularFamily._allTransitiveDependencies,
        source: source,
        page: page,
      );

  GetPopularProvider._internal(
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
    FutureOr<MPages?> Function(GetPopularRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetPopularProvider._internal(
        (ref) => create(ref as GetPopularRef),
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
  AutoDisposeFutureProviderElement<MPages?> createElement() {
    return _GetPopularProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetPopularProvider &&
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetPopularRef on AutoDisposeFutureProviderRef<MPages?> {
  /// The parameter `source` of this provider.
  Source get source;

  /// The parameter `page` of this provider.
  int get page;
}

class _GetPopularProviderElement
    extends AutoDisposeFutureProviderElement<MPages?>
    with GetPopularRef {
  _GetPopularProviderElement(super.provider);

  @override
  Source get source => (origin as GetPopularProvider).source;
  @override
  int get page => (origin as GetPopularProvider).page;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
