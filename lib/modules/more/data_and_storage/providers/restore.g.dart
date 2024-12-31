// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restore.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$doRestoreHash() => r'ff5b1cbb192ec7f0da82d79c5ac90e15dd28c1de';

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

/// See also [doRestore].
@ProviderFor(doRestore)
const doRestoreProvider = DoRestoreFamily();

/// See also [doRestore].
class DoRestoreFamily extends Family<void> {
  /// See also [doRestore].
  const DoRestoreFamily();

  /// See also [doRestore].
  DoRestoreProvider call({
    required String path,
    required BuildContext context,
  }) {
    return DoRestoreProvider(
      path: path,
      context: context,
    );
  }

  @override
  DoRestoreProvider getProviderOverride(
    covariant DoRestoreProvider provider,
  ) {
    return call(
      path: provider.path,
      context: provider.context,
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
  String? get name => r'doRestoreProvider';
}

/// See also [doRestore].
class DoRestoreProvider extends AutoDisposeProvider<void> {
  /// See also [doRestore].
  DoRestoreProvider({
    required String path,
    required BuildContext context,
  }) : this._internal(
          (ref) => doRestore(
            ref as DoRestoreRef,
            path: path,
            context: context,
          ),
          from: doRestoreProvider,
          name: r'doRestoreProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$doRestoreHash,
          dependencies: DoRestoreFamily._dependencies,
          allTransitiveDependencies: DoRestoreFamily._allTransitiveDependencies,
          path: path,
          context: context,
        );

  DoRestoreProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.path,
    required this.context,
  }) : super.internal();

  final String path;
  final BuildContext context;

  @override
  Override overrideWith(
    void Function(DoRestoreRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DoRestoreProvider._internal(
        (ref) => create(ref as DoRestoreRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        path: path,
        context: context,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<void> createElement() {
    return _DoRestoreProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DoRestoreProvider &&
        other.path == path &&
        other.context == context;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, path.hashCode);
    hash = _SystemHash.combine(hash, context.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DoRestoreRef on AutoDisposeProviderRef<void> {
  /// The parameter `path` of this provider.
  String get path;

  /// The parameter `context` of this provider.
  BuildContext get context;
}

class _DoRestoreProviderElement extends AutoDisposeProviderElement<void>
    with DoRestoreRef {
  _DoRestoreProviderElement(super.provider);

  @override
  String get path => (origin as DoRestoreProvider).path;
  @override
  BuildContext get context => (origin as DoRestoreProvider).context;
}

String _$restoreBackupHash() => r'8f55a7fa09ef293d558bf336e282ca1f4f44b8d4';

/// See also [restoreBackup].
@ProviderFor(restoreBackup)
const restoreBackupProvider = RestoreBackupFamily();

/// See also [restoreBackup].
class RestoreBackupFamily extends Family<void> {
  /// See also [restoreBackup].
  const RestoreBackupFamily();

  /// See also [restoreBackup].
  RestoreBackupProvider call(
    Map<String, dynamic> backup,
  ) {
    return RestoreBackupProvider(
      backup,
    );
  }

  @override
  RestoreBackupProvider getProviderOverride(
    covariant RestoreBackupProvider provider,
  ) {
    return call(
      provider.backup,
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
  String? get name => r'restoreBackupProvider';
}

/// See also [restoreBackup].
class RestoreBackupProvider extends AutoDisposeProvider<void> {
  /// See also [restoreBackup].
  RestoreBackupProvider(
    Map<String, dynamic> backup,
  ) : this._internal(
          (ref) => restoreBackup(
            ref as RestoreBackupRef,
            backup,
          ),
          from: restoreBackupProvider,
          name: r'restoreBackupProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$restoreBackupHash,
          dependencies: RestoreBackupFamily._dependencies,
          allTransitiveDependencies:
              RestoreBackupFamily._allTransitiveDependencies,
          backup: backup,
        );

  RestoreBackupProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.backup,
  }) : super.internal();

  final Map<String, dynamic> backup;

  @override
  Override overrideWith(
    void Function(RestoreBackupRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RestoreBackupProvider._internal(
        (ref) => create(ref as RestoreBackupRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        backup: backup,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<void> createElement() {
    return _RestoreBackupProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RestoreBackupProvider && other.backup == backup;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, backup.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RestoreBackupRef on AutoDisposeProviderRef<void> {
  /// The parameter `backup` of this provider.
  Map<String, dynamic> get backup;
}

class _RestoreBackupProviderElement extends AutoDisposeProviderElement<void>
    with RestoreBackupRef {
  _RestoreBackupProviderElement(super.provider);

  @override
  Map<String, dynamic> get backup => (origin as RestoreBackupProvider).backup;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
