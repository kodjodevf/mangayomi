// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restore.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$doRestoreHash() => r'4e556ae822d1f48ef3519fd65393c178de14b73d';

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
    return DoRestoreProvider(path: path, context: context);
  }

  @override
  DoRestoreProvider getProviderOverride(covariant DoRestoreProvider provider) {
    return call(path: provider.path, context: provider.context);
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
  DoRestoreProvider({required String path, required BuildContext context})
    : this._internal(
        (ref) => doRestore(ref as DoRestoreRef, path: path, context: context),
        from: doRestoreProvider,
        name: r'doRestoreProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
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
  Override overrideWith(void Function(DoRestoreRef provider) create) {
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

String _$restoreBackupHash() => r'adc705e1e65dedcc919a525d7bd14f6451620c43';

/// See also [restoreBackup].
@ProviderFor(restoreBackup)
const restoreBackupProvider = RestoreBackupFamily();

/// See also [restoreBackup].
class RestoreBackupFamily extends Family<void> {
  /// See also [restoreBackup].
  const RestoreBackupFamily();

  /// See also [restoreBackup].
  RestoreBackupProvider call(Map<String, dynamic> backup, {bool full = true}) {
    return RestoreBackupProvider(backup, full: full);
  }

  @override
  RestoreBackupProvider getProviderOverride(
    covariant RestoreBackupProvider provider,
  ) {
    return call(provider.backup, full: provider.full);
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
  RestoreBackupProvider(Map<String, dynamic> backup, {bool full = true})
    : this._internal(
        (ref) => restoreBackup(ref as RestoreBackupRef, backup, full: full),
        from: restoreBackupProvider,
        name: r'restoreBackupProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$restoreBackupHash,
        dependencies: RestoreBackupFamily._dependencies,
        allTransitiveDependencies:
            RestoreBackupFamily._allTransitiveDependencies,
        backup: backup,
        full: full,
      );

  RestoreBackupProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.backup,
    required this.full,
  }) : super.internal();

  final Map<String, dynamic> backup;
  final bool full;

  @override
  Override overrideWith(void Function(RestoreBackupRef provider) create) {
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
        full: full,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<void> createElement() {
    return _RestoreBackupProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RestoreBackupProvider &&
        other.backup == backup &&
        other.full == full;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, backup.hashCode);
    hash = _SystemHash.combine(hash, full.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RestoreBackupRef on AutoDisposeProviderRef<void> {
  /// The parameter `backup` of this provider.
  Map<String, dynamic> get backup;

  /// The parameter `full` of this provider.
  bool get full;
}

class _RestoreBackupProviderElement extends AutoDisposeProviderElement<void>
    with RestoreBackupRef {
  _RestoreBackupProviderElement(super.provider);

  @override
  Map<String, dynamic> get backup => (origin as RestoreBackupProvider).backup;
  @override
  bool get full => (origin as RestoreBackupProvider).full;
}

String _$restoreKotatsuBackupHash() =>
    r'4b43cb1719527b3030b9966e5ef662c29435425d';

/// See also [restoreKotatsuBackup].
@ProviderFor(restoreKotatsuBackup)
const restoreKotatsuBackupProvider = RestoreKotatsuBackupFamily();

/// See also [restoreKotatsuBackup].
class RestoreKotatsuBackupFamily extends Family<void> {
  /// See also [restoreKotatsuBackup].
  const RestoreKotatsuBackupFamily();

  /// See also [restoreKotatsuBackup].
  RestoreKotatsuBackupProvider call(Archive archive) {
    return RestoreKotatsuBackupProvider(archive);
  }

  @override
  RestoreKotatsuBackupProvider getProviderOverride(
    covariant RestoreKotatsuBackupProvider provider,
  ) {
    return call(provider.archive);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'restoreKotatsuBackupProvider';
}

/// See also [restoreKotatsuBackup].
class RestoreKotatsuBackupProvider extends AutoDisposeProvider<void> {
  /// See also [restoreKotatsuBackup].
  RestoreKotatsuBackupProvider(Archive archive)
    : this._internal(
        (ref) => restoreKotatsuBackup(ref as RestoreKotatsuBackupRef, archive),
        from: restoreKotatsuBackupProvider,
        name: r'restoreKotatsuBackupProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$restoreKotatsuBackupHash,
        dependencies: RestoreKotatsuBackupFamily._dependencies,
        allTransitiveDependencies:
            RestoreKotatsuBackupFamily._allTransitiveDependencies,
        archive: archive,
      );

  RestoreKotatsuBackupProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.archive,
  }) : super.internal();

  final Archive archive;

  @override
  Override overrideWith(
    void Function(RestoreKotatsuBackupRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RestoreKotatsuBackupProvider._internal(
        (ref) => create(ref as RestoreKotatsuBackupRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        archive: archive,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<void> createElement() {
    return _RestoreKotatsuBackupProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RestoreKotatsuBackupProvider && other.archive == archive;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, archive.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RestoreKotatsuBackupRef on AutoDisposeProviderRef<void> {
  /// The parameter `archive` of this provider.
  Archive get archive;
}

class _RestoreKotatsuBackupProviderElement
    extends AutoDisposeProviderElement<void>
    with RestoreKotatsuBackupRef {
  _RestoreKotatsuBackupProviderElement(super.provider);

  @override
  Archive get archive => (origin as RestoreKotatsuBackupProvider).archive;
}

String _$restoreTachiBkBackupHash() =>
    r'54434eaa9dc875d03ffb1dcf62ad2d7971649d61';

/// See also [restoreTachiBkBackup].
@ProviderFor(restoreTachiBkBackup)
const restoreTachiBkBackupProvider = RestoreTachiBkBackupFamily();

/// See also [restoreTachiBkBackup].
class RestoreTachiBkBackupFamily extends Family<void> {
  /// See also [restoreTachiBkBackup].
  const RestoreTachiBkBackupFamily();

  /// See also [restoreTachiBkBackup].
  RestoreTachiBkBackupProvider call(String path, BackupType bkType) {
    return RestoreTachiBkBackupProvider(path, bkType);
  }

  @override
  RestoreTachiBkBackupProvider getProviderOverride(
    covariant RestoreTachiBkBackupProvider provider,
  ) {
    return call(provider.path, provider.bkType);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'restoreTachiBkBackupProvider';
}

/// See also [restoreTachiBkBackup].
class RestoreTachiBkBackupProvider extends AutoDisposeProvider<void> {
  /// See also [restoreTachiBkBackup].
  RestoreTachiBkBackupProvider(String path, BackupType bkType)
    : this._internal(
        (ref) =>
            restoreTachiBkBackup(ref as RestoreTachiBkBackupRef, path, bkType),
        from: restoreTachiBkBackupProvider,
        name: r'restoreTachiBkBackupProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$restoreTachiBkBackupHash,
        dependencies: RestoreTachiBkBackupFamily._dependencies,
        allTransitiveDependencies:
            RestoreTachiBkBackupFamily._allTransitiveDependencies,
        path: path,
        bkType: bkType,
      );

  RestoreTachiBkBackupProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.path,
    required this.bkType,
  }) : super.internal();

  final String path;
  final BackupType bkType;

  @override
  Override overrideWith(
    void Function(RestoreTachiBkBackupRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RestoreTachiBkBackupProvider._internal(
        (ref) => create(ref as RestoreTachiBkBackupRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        path: path,
        bkType: bkType,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<void> createElement() {
    return _RestoreTachiBkBackupProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RestoreTachiBkBackupProvider &&
        other.path == path &&
        other.bkType == bkType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, path.hashCode);
    hash = _SystemHash.combine(hash, bkType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RestoreTachiBkBackupRef on AutoDisposeProviderRef<void> {
  /// The parameter `path` of this provider.
  String get path;

  /// The parameter `bkType` of this provider.
  BackupType get bkType;
}

class _RestoreTachiBkBackupProviderElement
    extends AutoDisposeProviderElement<void>
    with RestoreTachiBkBackupRef {
  _RestoreTachiBkBackupProviderElement(super.provider);

  @override
  String get path => (origin as RestoreTachiBkBackupProvider).path;
  @override
  BackupType get bkType => (origin as RestoreTachiBkBackupProvider).bkType;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
