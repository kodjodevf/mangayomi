// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_detail.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getDetailHash() => r'6b758b79281cb00a7df2fe1903d4a67068052bca';

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

/// See also [getDetail].
@ProviderFor(getDetail)
const getDetailProvider = GetDetailFamily();

/// See also [getDetail].
class GetDetailFamily extends Family<AsyncValue<MManga>> {
  /// See also [getDetail].
  const GetDetailFamily();

  /// See also [getDetail].
  GetDetailProvider call({required String url, required Source source}) {
    return GetDetailProvider(url: url, source: source);
  }

  @override
  GetDetailProvider getProviderOverride(covariant GetDetailProvider provider) {
    return call(url: provider.url, source: provider.source);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getDetailProvider';
}

/// See also [getDetail].
class GetDetailProvider extends AutoDisposeFutureProvider<MManga> {
  /// See also [getDetail].
  GetDetailProvider({required String url, required Source source})
    : this._internal(
        (ref) => getDetail(ref as GetDetailRef, url: url, source: source),
        from: getDetailProvider,
        name: r'getDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$getDetailHash,
        dependencies: GetDetailFamily._dependencies,
        allTransitiveDependencies: GetDetailFamily._allTransitiveDependencies,
        url: url,
        source: source,
      );

  GetDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.url,
    required this.source,
  }) : super.internal();

  final String url;
  final Source source;

  @override
  Override overrideWith(
    FutureOr<MManga> Function(GetDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetDetailProvider._internal(
        (ref) => create(ref as GetDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        url: url,
        source: source,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MManga> createElement() {
    return _GetDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetDetailProvider &&
        other.url == url &&
        other.source == source;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);
    hash = _SystemHash.combine(hash, source.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetDetailRef on AutoDisposeFutureProviderRef<MManga> {
  /// The parameter `url` of this provider.
  String get url;

  /// The parameter `source` of this provider.
  Source get source;
}

class _GetDetailProviderElement extends AutoDisposeFutureProviderElement<MManga>
    with GetDetailRef {
  _GetDetailProviderElement(super.provider);

  @override
  String get url => (origin as GetDetailProvider).url;
  @override
  Source get source => (origin as GetDetailProvider).source;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
