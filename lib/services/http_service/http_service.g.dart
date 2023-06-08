// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$httpGetHash() => r'115d7fdde9392d32055ddefe661731c37b2b584e';

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

typedef HttpGetRef = AutoDisposeFutureProviderRef<dynamic>;

/// See also [httpGet].
@ProviderFor(httpGet)
const httpGetProvider = HttpGetFamily();

/// See also [httpGet].
class HttpGetFamily extends Family<AsyncValue<dynamic>> {
  /// See also [httpGet].
  const HttpGetFamily();

  /// See also [httpGet].
  HttpGetProvider call({
    required String url,
    required String source,
    required bool resDom,
    Map<String, String>? headers,
    bool useUserAgent = false,
  }) {
    return HttpGetProvider(
      url: url,
      source: source,
      resDom: resDom,
      headers: headers,
      useUserAgent: useUserAgent,
    );
  }

  @override
  HttpGetProvider getProviderOverride(
    covariant HttpGetProvider provider,
  ) {
    return call(
      url: provider.url,
      source: provider.source,
      resDom: provider.resDom,
      headers: provider.headers,
      useUserAgent: provider.useUserAgent,
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
  String? get name => r'httpGetProvider';
}

/// See also [httpGet].
class HttpGetProvider extends AutoDisposeFutureProvider<dynamic> {
  /// See also [httpGet].
  HttpGetProvider({
    required this.url,
    required this.source,
    required this.resDom,
    this.headers,
    this.useUserAgent = false,
  }) : super.internal(
          (ref) => httpGet(
            ref,
            url: url,
            source: source,
            resDom: resDom,
            headers: headers,
            useUserAgent: useUserAgent,
          ),
          from: httpGetProvider,
          name: r'httpGetProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$httpGetHash,
          dependencies: HttpGetFamily._dependencies,
          allTransitiveDependencies: HttpGetFamily._allTransitiveDependencies,
        );

  final String url;
  final String source;
  final bool resDom;
  final Map<String, String>? headers;
  final bool useUserAgent;

  @override
  bool operator ==(Object other) {
    return other is HttpGetProvider &&
        other.url == url &&
        other.source == source &&
        other.resDom == resDom &&
        other.headers == headers &&
        other.useUserAgent == useUserAgent;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);
    hash = _SystemHash.combine(hash, source.hashCode);
    hash = _SystemHash.combine(hash, resDom.hashCode);
    hash = _SystemHash.combine(hash, headers.hashCode);
    hash = _SystemHash.combine(hash, useUserAgent.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
