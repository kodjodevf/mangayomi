// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cookie.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$setCookieHash() => r'320b02afaf98d721518937f1b894240d3800d765';

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

typedef SetCookieRef = AutoDisposeFutureProviderRef<dynamic>;

/// See also [setCookie].
@ProviderFor(setCookie)
const setCookieProvider = SetCookieFamily();

/// See also [setCookie].
class SetCookieFamily extends Family<AsyncValue<dynamic>> {
  /// See also [setCookie].
  const SetCookieFamily();

  /// See also [setCookie].
  SetCookieProvider call(
    String sourceId,
    String url,
  ) {
    return SetCookieProvider(
      sourceId,
      url,
    );
  }

  @override
  SetCookieProvider getProviderOverride(
    covariant SetCookieProvider provider,
  ) {
    return call(
      provider.sourceId,
      provider.url,
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
  String? get name => r'setCookieProvider';
}

/// See also [setCookie].
class SetCookieProvider extends AutoDisposeFutureProvider<dynamic> {
  /// See also [setCookie].
  SetCookieProvider(
    this.sourceId,
    this.url,
  ) : super.internal(
          (ref) => setCookie(
            ref,
            sourceId,
            url,
          ),
          from: setCookieProvider,
          name: r'setCookieProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$setCookieHash,
          dependencies: SetCookieFamily._dependencies,
          allTransitiveDependencies: SetCookieFamily._allTransitiveDependencies,
        );

  final String sourceId;
  final String url;

  @override
  bool operator ==(Object other) {
    return other is SetCookieProvider &&
        other.sourceId == sourceId &&
        other.url == url;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sourceId.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
