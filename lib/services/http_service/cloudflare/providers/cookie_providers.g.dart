// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cookie_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cookieStateHash() => r'42286f51989b6f65eed9787ca2390a96854395a8';

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
  late final String idSource;

  String build(
    String idSource,
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
    String idSource,
  ) {
    return CookieStateProvider(
      idSource,
    );
  }

  @override
  CookieStateProvider getProviderOverride(
    covariant CookieStateProvider provider,
  ) {
    return call(
      provider.idSource,
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
    this.idSource,
  ) : super.internal(
          () => CookieState()..idSource = idSource,
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

  final String idSource;

  @override
  bool operator ==(Object other) {
    return other is CookieStateProvider && other.idSource == idSource;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, idSource.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  String runNotifierBuild(
    covariant CookieState notifier,
  ) {
    return notifier.build(
      idSource,
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
