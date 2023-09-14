// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extension_preferences_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getMirrorPrefHash() => r'b56f6cf8dcb17279b2945c9233711182380dd0c5';

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

/// See also [getMirrorPref].
@ProviderFor(getMirrorPref)
const getMirrorPrefProvider = GetMirrorPrefFamily();

/// See also [getMirrorPref].
class GetMirrorPrefFamily extends Family<AsyncValue<Map<String, String>?>> {
  /// See also [getMirrorPref].
  const GetMirrorPrefFamily();

  /// See also [getMirrorPref].
  GetMirrorPrefProvider call(
    String codeSource,
  ) {
    return GetMirrorPrefProvider(
      codeSource,
    );
  }

  @override
  GetMirrorPrefProvider getProviderOverride(
    covariant GetMirrorPrefProvider provider,
  ) {
    return call(
      provider.codeSource,
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
  String? get name => r'getMirrorPrefProvider';
}

/// See also [getMirrorPref].
class GetMirrorPrefProvider
    extends AutoDisposeFutureProvider<Map<String, String>?> {
  /// See also [getMirrorPref].
  GetMirrorPrefProvider(
    String codeSource,
  ) : this._internal(
          (ref) => getMirrorPref(
            ref as GetMirrorPrefRef,
            codeSource,
          ),
          from: getMirrorPrefProvider,
          name: r'getMirrorPrefProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getMirrorPrefHash,
          dependencies: GetMirrorPrefFamily._dependencies,
          allTransitiveDependencies:
              GetMirrorPrefFamily._allTransitiveDependencies,
          codeSource: codeSource,
        );

  GetMirrorPrefProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.codeSource,
  }) : super.internal();

  final String codeSource;

  @override
  Override overrideWith(
    FutureOr<Map<String, String>?> Function(GetMirrorPrefRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetMirrorPrefProvider._internal(
        (ref) => create(ref as GetMirrorPrefRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        codeSource: codeSource,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, String>?> createElement() {
    return _GetMirrorPrefProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetMirrorPrefProvider && other.codeSource == codeSource;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, codeSource.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetMirrorPrefRef on AutoDisposeFutureProviderRef<Map<String, String>?> {
  /// The parameter `codeSource` of this provider.
  String get codeSource;
}

class _GetMirrorPrefProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, String>?>
    with GetMirrorPrefRef {
  _GetMirrorPrefProviderElement(super.provider);

  @override
  String get codeSource => (origin as GetMirrorPrefProvider).codeSource;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
