// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extension_preferences_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getMirrorPrefHash() => r'87d8329eabbe702d2e612a04cfe6fc719519194c';

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

typedef GetMirrorPrefRef = AutoDisposeFutureProviderRef<Map<String, String>?>;

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
    this.codeSource,
  ) : super.internal(
          (ref) => getMirrorPref(
            ref,
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
        );

  final String codeSource;

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
