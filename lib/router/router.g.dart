// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$routerHash() => r'898ce90fa3d611eeb9ada09b0b29672c5accb22a';

/// See also [router].
@ProviderFor(router)
final routerProvider = AutoDisposeProvider<GoRouter>.internal(
  router,
  name: r'routerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$routerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RouterRef = AutoDisposeProviderRef<GoRouter>;
String _$routerCurrentLocationStateHash() =>
    r'6d08e611ff9bb4c7b91e02b7ffc456df010990aa';

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

abstract class _$RouterCurrentLocationState
    extends BuildlessAutoDisposeNotifier<String?> {
  late final BuildContext context;

  String? build(
    BuildContext context,
  );
}

/// See also [RouterCurrentLocationState].
@ProviderFor(RouterCurrentLocationState)
const routerCurrentLocationStateProvider = RouterCurrentLocationStateFamily();

/// See also [RouterCurrentLocationState].
class RouterCurrentLocationStateFamily extends Family<String?> {
  /// See also [RouterCurrentLocationState].
  const RouterCurrentLocationStateFamily();

  /// See also [RouterCurrentLocationState].
  RouterCurrentLocationStateProvider call(
    BuildContext context,
  ) {
    return RouterCurrentLocationStateProvider(
      context,
    );
  }

  @override
  RouterCurrentLocationStateProvider getProviderOverride(
    covariant RouterCurrentLocationStateProvider provider,
  ) {
    return call(
      provider.context,
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
  String? get name => r'routerCurrentLocationStateProvider';
}

/// See also [RouterCurrentLocationState].
class RouterCurrentLocationStateProvider
    extends AutoDisposeNotifierProviderImpl<RouterCurrentLocationState,
        String?> {
  /// See also [RouterCurrentLocationState].
  RouterCurrentLocationStateProvider(
    BuildContext context,
  ) : this._internal(
          () => RouterCurrentLocationState()..context = context,
          from: routerCurrentLocationStateProvider,
          name: r'routerCurrentLocationStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$routerCurrentLocationStateHash,
          dependencies: RouterCurrentLocationStateFamily._dependencies,
          allTransitiveDependencies:
              RouterCurrentLocationStateFamily._allTransitiveDependencies,
          context: context,
        );

  RouterCurrentLocationStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.context,
  }) : super.internal();

  final BuildContext context;

  @override
  String? runNotifierBuild(
    covariant RouterCurrentLocationState notifier,
  ) {
    return notifier.build(
      context,
    );
  }

  @override
  Override overrideWith(RouterCurrentLocationState Function() create) {
    return ProviderOverride(
      origin: this,
      override: RouterCurrentLocationStateProvider._internal(
        () => create()..context = context,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        context: context,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<RouterCurrentLocationState, String?>
      createElement() {
    return _RouterCurrentLocationStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RouterCurrentLocationStateProvider &&
        other.context == context;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, context.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RouterCurrentLocationStateRef on AutoDisposeNotifierProviderRef<String?> {
  /// The parameter `context` of this provider.
  BuildContext get context;
}

class _RouterCurrentLocationStateProviderElement
    extends AutoDisposeNotifierProviderElement<RouterCurrentLocationState,
        String?> with RouterCurrentLocationStateRef {
  _RouterCurrentLocationStateProviderElement(super.provider);

  @override
  BuildContext get context =>
      (origin as RouterCurrentLocationStateProvider).context;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
