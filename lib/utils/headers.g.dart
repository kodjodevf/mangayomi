// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'headers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$headersHash() => r'47499544c2d972da6a0c20f41fe3fc46d1d7c1a0';

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

/// See also [headers].
@ProviderFor(headers)
const headersProvider = HeadersFamily();

/// See also [headers].
class HeadersFamily extends Family<Map<String, String>> {
  /// See also [headers].
  const HeadersFamily();

  /// See also [headers].
  HeadersProvider call({
    required String source,
    required String lang,
  }) {
    return HeadersProvider(
      source: source,
      lang: lang,
    );
  }

  @override
  HeadersProvider getProviderOverride(
    covariant HeadersProvider provider,
  ) {
    return call(
      source: provider.source,
      lang: provider.lang,
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
    required String source,
    required String lang,
  }) : this._internal(
          (ref) => headers(
            ref as HeadersRef,
            source: source,
            lang: lang,
          ),
          from: headersProvider,
          name: r'headersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$headersHash,
          dependencies: HeadersFamily._dependencies,
          allTransitiveDependencies: HeadersFamily._allTransitiveDependencies,
          source: source,
          lang: lang,
        );

  HeadersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.source,
    required this.lang,
  }) : super.internal();

  final String source;
  final String lang;

  @override
  Override overrideWith(
    Map<String, String> Function(HeadersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HeadersProvider._internal(
        (ref) => create(ref as HeadersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        source: source,
        lang: lang,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Map<String, String>> createElement() {
    return _HeadersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HeadersProvider &&
        other.source == source &&
        other.lang == lang;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, source.hashCode);
    hash = _SystemHash.combine(hash, lang.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HeadersRef on AutoDisposeProviderRef<Map<String, String>> {
  /// The parameter `source` of this provider.
  String get source;

  /// The parameter `lang` of this provider.
  String get lang;
}

class _HeadersProviderElement
    extends AutoDisposeProviderElement<Map<String, String>> with HeadersRef {
  _HeadersProviderElement(super.provider);

  @override
  String get source => (origin as HeadersProvider).source;
  @override
  String get lang => (origin as HeadersProvider).lang;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
