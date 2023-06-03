// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'headers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$headersHash() => r'b25fd0415020bf0585f8ecad168689935188bfad';

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

typedef HeadersRef = AutoDisposeProviderRef<Map<String, String>>;

/// See also [headers].
@ProviderFor(headers)
const headersProvider = HeadersFamily();

/// See also [headers].
class HeadersFamily extends Family<Map<String, String>> {
  /// See also [headers].
  const HeadersFamily();

  /// See also [headers].
  HeadersProvider call({
    String source = "",
  }) {
    return HeadersProvider(
      source: source,
    );
  }

  @override
  HeadersProvider getProviderOverride(
    covariant HeadersProvider provider,
  ) {
    return call(
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
  String? get name => r'headersProvider';
}

/// See also [headers].
class HeadersProvider extends AutoDisposeProvider<Map<String, String>> {
  /// See also [headers].
  HeadersProvider({
    this.source = "",
  }) : super.internal(
          (ref) => headers(
            ref,
            source: source,
          ),
          from: headersProvider,
          name: r'headersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$headersHash,
          dependencies: HeadersFamily._dependencies,
          allTransitiveDependencies: HeadersFamily._allTransitiveDependencies,
        );

  final String source;

  @override
  bool operator ==(Object other) {
    return other is HeadersProvider && other.source == source;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, source.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
