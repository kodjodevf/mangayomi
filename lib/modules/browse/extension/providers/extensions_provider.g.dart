// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extensions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getExtensionsStreamHash() =>
    r'62f2884dd64a2f3d8928f7399c6b2547f0311078';

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

/// See also [getExtensionsStream].
@ProviderFor(getExtensionsStream)
const getExtensionsStreamProvider = GetExtensionsStreamFamily();

/// See also [getExtensionsStream].
class GetExtensionsStreamFamily extends Family<AsyncValue<List<Source>>> {
  /// See also [getExtensionsStream].
  const GetExtensionsStreamFamily();

  /// See also [getExtensionsStream].
  GetExtensionsStreamProvider call(
    bool? isManga,
  ) {
    return GetExtensionsStreamProvider(
      isManga,
    );
  }

  @override
  GetExtensionsStreamProvider getProviderOverride(
    covariant GetExtensionsStreamProvider provider,
  ) {
    return call(
      provider.isManga,
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
  String? get name => r'getExtensionsStreamProvider';
}

/// See also [getExtensionsStream].
class GetExtensionsStreamProvider
    extends AutoDisposeStreamProvider<List<Source>> {
  /// See also [getExtensionsStream].
  GetExtensionsStreamProvider(
    bool? isManga,
  ) : this._internal(
          (ref) => getExtensionsStream(
            ref as GetExtensionsStreamRef,
            isManga,
          ),
          from: getExtensionsStreamProvider,
          name: r'getExtensionsStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getExtensionsStreamHash,
          dependencies: GetExtensionsStreamFamily._dependencies,
          allTransitiveDependencies:
              GetExtensionsStreamFamily._allTransitiveDependencies,
          isManga: isManga,
        );

  GetExtensionsStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.isManga,
  }) : super.internal();

  final bool? isManga;

  @override
  Override overrideWith(
    Stream<List<Source>> Function(GetExtensionsStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetExtensionsStreamProvider._internal(
        (ref) => create(ref as GetExtensionsStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        isManga: isManga,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Source>> createElement() {
    return _GetExtensionsStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetExtensionsStreamProvider && other.isManga == isManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetExtensionsStreamRef on AutoDisposeStreamProviderRef<List<Source>> {
  /// The parameter `isManga` of this provider.
  bool? get isManga;
}

class _GetExtensionsStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Source>>
    with GetExtensionsStreamRef {
  _GetExtensionsStreamProviderElement(super.provider);

  @override
  bool? get isManga => (origin as GetExtensionsStreamProvider).isManga;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
