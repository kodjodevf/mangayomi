// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_for_update.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$checkForUpdateHash() => r'644316334ac3e95d37f54d7197d744c9de1260b6';

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

/// See also [checkForUpdate].
@ProviderFor(checkForUpdate)
const checkForUpdateProvider = CheckForUpdateFamily();

/// See also [checkForUpdate].
class CheckForUpdateFamily extends Family<AsyncValue<void>> {
  /// See also [checkForUpdate].
  const CheckForUpdateFamily();

  /// See also [checkForUpdate].
  CheckForUpdateProvider call({BuildContext? context, bool? manualUpdate}) {
    return CheckForUpdateProvider(context: context, manualUpdate: manualUpdate);
  }

  @override
  CheckForUpdateProvider getProviderOverride(
    covariant CheckForUpdateProvider provider,
  ) {
    return call(context: provider.context, manualUpdate: provider.manualUpdate);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'checkForUpdateProvider';
}

/// See also [checkForUpdate].
class CheckForUpdateProvider extends AutoDisposeFutureProvider<void> {
  /// See also [checkForUpdate].
  CheckForUpdateProvider({BuildContext? context, bool? manualUpdate})
    : this._internal(
        (ref) => checkForUpdate(
          ref as CheckForUpdateRef,
          context: context,
          manualUpdate: manualUpdate,
        ),
        from: checkForUpdateProvider,
        name: r'checkForUpdateProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$checkForUpdateHash,
        dependencies: CheckForUpdateFamily._dependencies,
        allTransitiveDependencies:
            CheckForUpdateFamily._allTransitiveDependencies,
        context: context,
        manualUpdate: manualUpdate,
      );

  CheckForUpdateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.context,
    required this.manualUpdate,
  }) : super.internal();

  final BuildContext? context;
  final bool? manualUpdate;

  @override
  Override overrideWith(
    FutureOr<void> Function(CheckForUpdateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CheckForUpdateProvider._internal(
        (ref) => create(ref as CheckForUpdateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        context: context,
        manualUpdate: manualUpdate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _CheckForUpdateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CheckForUpdateProvider &&
        other.context == context &&
        other.manualUpdate == manualUpdate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, context.hashCode);
    hash = _SystemHash.combine(hash, manualUpdate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CheckForUpdateRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `context` of this provider.
  BuildContext? get context;

  /// The parameter `manualUpdate` of this provider.
  bool? get manualUpdate;
}

class _CheckForUpdateProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with CheckForUpdateRef {
  _CheckForUpdateProviderElement(super.provider);

  @override
  BuildContext? get context => (origin as CheckForUpdateProvider).context;
  @override
  bool? get manualUpdate => (origin as CheckForUpdateProvider).manualUpdate;
}

String _$checkForAppUpdatesHash() =>
    r'2243b74d748a90847bacff256cb2ef0a344fee80';

/// See also [checkForAppUpdates].
@ProviderFor(checkForAppUpdates)
final checkForAppUpdatesProvider = AutoDisposeProvider<bool>.internal(
  checkForAppUpdates,
  name: r'checkForAppUpdatesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$checkForAppUpdatesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CheckForAppUpdatesRef = AutoDisposeProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
