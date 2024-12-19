// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_html_content.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getHtmlContentHash() => r'1d7f76fb0f3b3cc9a5012746ec478269c0f0d5e0';

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

/// See also [getHtmlContent].
@ProviderFor(getHtmlContent)
const getHtmlContentProvider = GetHtmlContentFamily();

/// See also [getHtmlContent].
class GetHtmlContentFamily extends Family<AsyncValue<String>> {
  /// See also [getHtmlContent].
  const GetHtmlContentFamily();

  /// See also [getHtmlContent].
  GetHtmlContentProvider call({
    required String url,
    required Source source,
  }) {
    return GetHtmlContentProvider(
      url: url,
      source: source,
    );
  }

  @override
  GetHtmlContentProvider getProviderOverride(
    covariant GetHtmlContentProvider provider,
  ) {
    return call(
      url: provider.url,
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
  String? get name => r'getHtmlContentProvider';
}

/// See also [getHtmlContent].
class GetHtmlContentProvider extends AutoDisposeFutureProvider<String> {
  /// See also [getHtmlContent].
  GetHtmlContentProvider({
    required String url,
    required Source source,
  }) : this._internal(
          (ref) => getHtmlContent(
            ref as GetHtmlContentRef,
            url: url,
            source: source,
          ),
          from: getHtmlContentProvider,
          name: r'getHtmlContentProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getHtmlContentHash,
          dependencies: GetHtmlContentFamily._dependencies,
          allTransitiveDependencies:
              GetHtmlContentFamily._allTransitiveDependencies,
          url: url,
          source: source,
        );

  GetHtmlContentProvider._internal(
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
    FutureOr<String> Function(GetHtmlContentRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetHtmlContentProvider._internal(
        (ref) => create(ref as GetHtmlContentRef),
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
  AutoDisposeFutureProviderElement<String> createElement() {
    return _GetHtmlContentProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetHtmlContentProvider &&
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
mixin GetHtmlContentRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `url` of this provider.
  String get url;

  /// The parameter `source` of this provider.
  Source get source;
}

class _GetHtmlContentProviderElement
    extends AutoDisposeFutureProviderElement<String> with GetHtmlContentRef {
  _GetHtmlContentProviderElement(super.provider);

  @override
  String get url => (origin as GetHtmlContentProvider).url;
  @override
  Source get source => (origin as GetHtmlContentProvider).source;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
