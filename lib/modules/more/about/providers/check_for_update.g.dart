// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_for_update.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$checkForUpdateHash() => r'2b857a33efbdf16c0d3ccdd8217b9ce472de605f';

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

typedef CheckForUpdateRef = AutoDisposeProviderRef<dynamic>;

/// See also [checkForUpdate].
@ProviderFor(checkForUpdate)
const checkForUpdateProvider = CheckForUpdateFamily();

/// See also [checkForUpdate].
class CheckForUpdateFamily extends Family<dynamic> {
  /// See also [checkForUpdate].
  const CheckForUpdateFamily();

  /// See also [checkForUpdate].
  CheckForUpdateProvider call({
    BuildContext? context,
    bool? manualUpdate,
  }) {
    return CheckForUpdateProvider(
      context: context,
      manualUpdate: manualUpdate,
    );
  }

  @override
  CheckForUpdateProvider getProviderOverride(
    covariant CheckForUpdateProvider provider,
  ) {
    return call(
      context: provider.context,
      manualUpdate: provider.manualUpdate,
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
  String? get name => r'checkForUpdateProvider';
}

/// See also [checkForUpdate].
class CheckForUpdateProvider extends AutoDisposeProvider<dynamic> {
  /// See also [checkForUpdate].
  CheckForUpdateProvider({
    this.context,
    this.manualUpdate,
  }) : super.internal(
          (ref) => checkForUpdate(
            ref,
            context: context,
            manualUpdate: manualUpdate,
          ),
          from: checkForUpdateProvider,
          name: r'checkForUpdateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$checkForUpdateHash,
          dependencies: CheckForUpdateFamily._dependencies,
          allTransitiveDependencies:
              CheckForUpdateFamily._allTransitiveDependencies,
        );

  final BuildContext? context;
  final bool? manualUpdate;

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
