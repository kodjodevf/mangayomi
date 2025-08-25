// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supports_latest.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$supportsLatestHash() => r'e2d9b73adde86f78f1ab1c97d91ea2d3a59dc78d';

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

/// See also [supportsLatest].
@ProviderFor(supportsLatest)
const supportsLatestProvider = SupportsLatestFamily();

/// See also [supportsLatest].
class SupportsLatestFamily extends Family<bool> {
  /// See also [supportsLatest].
  const SupportsLatestFamily();

  /// See also [supportsLatest].
  SupportsLatestProvider call({required Source source}) {
    return SupportsLatestProvider(source: source);
  }

  @override
  SupportsLatestProvider getProviderOverride(
    covariant SupportsLatestProvider provider,
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
  String? get name => r'supportsLatestProvider';
}

/// See also [supportsLatest].
class SupportsLatestProvider extends AutoDisposeProvider<bool> {
  /// See also [supportsLatest].
  SupportsLatestProvider({required Source source})
    : this._internal(
        (ref) => supportsLatest(ref as SupportsLatestRef, source: source),
        from: supportsLatestProvider,
        name: r'supportsLatestProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$supportsLatestHash,
        dependencies: SupportsLatestFamily._dependencies,
        allTransitiveDependencies:
            SupportsLatestFamily._allTransitiveDependencies,
        source: source,
      );

  SupportsLatestProvider._internal(
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
  Override overrideWith(bool Function(SupportsLatestRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: SupportsLatestProvider._internal(
        (ref) => create(ref as SupportsLatestRef),
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
  AutoDisposeProviderElement<bool> createElement() {
    return _SupportsLatestProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SupportsLatestProvider && other.source == source;
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
mixin SupportsLatestRef on AutoDisposeProviderRef<bool> {
  /// The parameter `source` of this provider.
  Source get source;
}

class _SupportsLatestProviderElement extends AutoDisposeProviderElement<bool>
    with SupportsLatestRef {
  _SupportsLatestProviderElement(super.provider);

  @override
  Source get source => (origin as SupportsLatestProvider).source;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
