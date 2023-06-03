// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cookie_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cookieStateHash() => r'73fbf2fed21118db48d07ae0bdd213e1d4789fbd';

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

abstract class _$CookieState extends BuildlessAutoDisposeNotifier<String> {
  late final String source;

  String build(
    String source,
  );
}

/// See also [CookieState].
@ProviderFor(CookieState)
const cookieStateProvider = CookieStateFamily();

/// See also [CookieState].
class CookieStateFamily extends Family<String> {
  /// See also [CookieState].
  const CookieStateFamily();

  /// See also [CookieState].
  CookieStateProvider call(
    String source,
  ) {
    return CookieStateProvider(
      source,
    );
  }

  @override
  CookieStateProvider getProviderOverride(
    covariant CookieStateProvider provider,
  ) {
    return call(
      provider.source,
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
  String? get name => r'cookieStateProvider';
}

/// See also [CookieState].
class CookieStateProvider
    extends AutoDisposeNotifierProviderImpl<CookieState, String> {
  /// See also [CookieState].
  CookieStateProvider(
    this.source,
  ) : super.internal(
          () => CookieState()..source = source,
          from: cookieStateProvider,
          name: r'cookieStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cookieStateHash,
          dependencies: CookieStateFamily._dependencies,
          allTransitiveDependencies:
              CookieStateFamily._allTransitiveDependencies,
        );

  final String source;

  @override
  bool operator ==(Object other) {
    return other is CookieStateProvider && other.source == source;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, source.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  String runNotifierBuild(
    covariant CookieState notifier,
  ) {
    return notifier.build(
      source,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
