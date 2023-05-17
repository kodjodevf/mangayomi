// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cookie.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$setCookieHash() => r'e9519081f85b28e34d09466392e4e253cc51b9af';

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
    String source,
    String url,
  ) {
    return SetCookieProvider(
      source,
      url,
    );
  }

  @override
  SetCookieProvider getProviderOverride(
    covariant SetCookieProvider provider,
  ) {
    return call(
      provider.source,
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
    this.source,
    this.url,
  ) : super.internal(
          (ref) => setCookie(
            ref,
            source,
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

  final String source;
  final String url;

  @override
  bool operator ==(Object other) {
    return other is SetCookieProvider &&
        other.source == source &&
        other.url == url;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, source.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
