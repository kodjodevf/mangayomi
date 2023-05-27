// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloudflare_bypass.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cloudflareBypassDomHash() =>
    r'9329b2e079dda8e1ccdbccd41fe7370df1509953';

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

typedef CloudflareBypassDomRef = AutoDisposeFutureProviderRef<Document?>;

/// See also [cloudflareBypassDom].
@ProviderFor(cloudflareBypassDom)
const cloudflareBypassDomProvider = CloudflareBypassDomFamily();

/// See also [cloudflareBypassDom].
class CloudflareBypassDomFamily extends Family<AsyncValue<Document?>> {
  /// See also [cloudflareBypassDom].
  const CloudflareBypassDomFamily();

  /// See also [cloudflareBypassDom].
  CloudflareBypassDomProvider call({
    required String url,
    required String source,
    required bool useUserAgent,
  }) {
    return CloudflareBypassDomProvider(
      url: url,
      source: source,
      useUserAgent: useUserAgent,
    );
  }

  @override
  CloudflareBypassDomProvider getProviderOverride(
    covariant CloudflareBypassDomProvider provider,
  ) {
    return call(
      url: provider.url,
      source: provider.source,
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
  String? get name => r'cloudflareBypassDomProvider';
}

/// See also [cloudflareBypassDom].
class CloudflareBypassDomProvider extends AutoDisposeFutureProvider<Document?> {
  /// See also [cloudflareBypassDom].
  CloudflareBypassDomProvider({
    required this.url,
    required this.source,
    required this.useUserAgent,
  }) : super.internal(
          (ref) => cloudflareBypassDom(
            ref,
            url: url,
            source: source,
            useUserAgent: useUserAgent,
          ),
          from: cloudflareBypassDomProvider,
          name: r'cloudflareBypassDomProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cloudflareBypassDomHash,
          dependencies: CloudflareBypassDomFamily._dependencies,
          allTransitiveDependencies:
              CloudflareBypassDomFamily._allTransitiveDependencies,
        );

  final String url;
  final String source;
  final bool useUserAgent;

  @override
  bool operator ==(Object other) {
    return other is CloudflareBypassDomProvider &&
        other.url == url &&
        other.source == source &&
        other.useUserAgent == useUserAgent;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);
    hash = _SystemHash.combine(hash, source.hashCode);
    hash = _SystemHash.combine(hash, useUserAgent.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$cloudflareBypassHtmlHash() =>
    r'8c1d6820ba10fe5ddfe6ce532e1e4677b563ceee';
typedef CloudflareBypassHtmlRef = AutoDisposeFutureProviderRef<String>;

/// See also [cloudflareBypassHtml].
@ProviderFor(cloudflareBypassHtml)
const cloudflareBypassHtmlProvider = CloudflareBypassHtmlFamily();

/// See also [cloudflareBypassHtml].
class CloudflareBypassHtmlFamily extends Family<AsyncValue<String>> {
  /// See also [cloudflareBypassHtml].
  const CloudflareBypassHtmlFamily();

  /// See also [cloudflareBypassHtml].
  CloudflareBypassHtmlProvider call({
    required String url,
    required String source,
    required bool useUserAgent,
  }) {
    return CloudflareBypassHtmlProvider(
      url: url,
      source: source,
      useUserAgent: useUserAgent,
    );
  }

  @override
  CloudflareBypassHtmlProvider getProviderOverride(
    covariant CloudflareBypassHtmlProvider provider,
  ) {
    return call(
      url: provider.url,
      source: provider.source,
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
  String? get name => r'cloudflareBypassHtmlProvider';
}

/// See also [cloudflareBypassHtml].
class CloudflareBypassHtmlProvider extends AutoDisposeFutureProvider<String> {
  /// See also [cloudflareBypassHtml].
  CloudflareBypassHtmlProvider({
    required this.url,
    required this.source,
    required this.useUserAgent,
  }) : super.internal(
          (ref) => cloudflareBypassHtml(
            ref,
            url: url,
            source: source,
            useUserAgent: useUserAgent,
          ),
          from: cloudflareBypassHtmlProvider,
          name: r'cloudflareBypassHtmlProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cloudflareBypassHtmlHash,
          dependencies: CloudflareBypassHtmlFamily._dependencies,
          allTransitiveDependencies:
              CloudflareBypassHtmlFamily._allTransitiveDependencies,
        );

  final String url;
  final String source;
  final bool useUserAgent;

  @override
  bool operator ==(Object other) {
    return other is CloudflareBypassHtmlProvider &&
        other.url == url &&
        other.source == source &&
        other.useUserAgent == useUserAgent;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);
    hash = _SystemHash.combine(hash, source.hashCode);
    hash = _SystemHash.combine(hash, useUserAgent.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
