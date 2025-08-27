// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_source_baseurl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sourceBaseUrlHash() => r'ead3cca719e2530502d97613e3168e0031eecde7';

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

/// See also [sourceBaseUrl].
@ProviderFor(sourceBaseUrl)
const sourceBaseUrlProvider = SourceBaseUrlFamily();

/// See also [sourceBaseUrl].
class SourceBaseUrlFamily extends Family<String> {
  /// See also [sourceBaseUrl].
  const SourceBaseUrlFamily();

  /// See also [sourceBaseUrl].
  SourceBaseUrlProvider call({required Source source}) {
    return SourceBaseUrlProvider(source: source);
  }

  @override
  SourceBaseUrlProvider getProviderOverride(
    covariant SourceBaseUrlProvider provider,
  ) {
    return call(source: provider.source);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sourceBaseUrlProvider';
}

/// See also [sourceBaseUrl].
class SourceBaseUrlProvider extends AutoDisposeProvider<String> {
  /// See also [sourceBaseUrl].
  SourceBaseUrlProvider({required Source source})
    : this._internal(
        (ref) => sourceBaseUrl(ref as SourceBaseUrlRef, source: source),
        from: sourceBaseUrlProvider,
        name: r'sourceBaseUrlProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sourceBaseUrlHash,
        dependencies: SourceBaseUrlFamily._dependencies,
        allTransitiveDependencies:
            SourceBaseUrlFamily._allTransitiveDependencies,
        source: source,
      );

  SourceBaseUrlProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.source,
  }) : super.internal();

  final Source source;

  @override
  Override overrideWith(String Function(SourceBaseUrlRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: SourceBaseUrlProvider._internal(
        (ref) => create(ref as SourceBaseUrlRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        source: source,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _SourceBaseUrlProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SourceBaseUrlProvider && other.source == source;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, source.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SourceBaseUrlRef on AutoDisposeProviderRef<String> {
  /// The parameter `source` of this provider.
  Source get source;
}

class _SourceBaseUrlProviderElement extends AutoDisposeProviderElement<String>
    with SourceBaseUrlRef {
  _SourceBaseUrlProviderElement(super.provider);

  @override
  Source get source => (origin as SourceBaseUrlProvider).source;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
