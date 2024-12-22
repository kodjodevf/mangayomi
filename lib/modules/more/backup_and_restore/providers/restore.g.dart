// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restore.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$doRestoreHash() => r'508725e75a03ac5f561c2cf8bf4943052d605d5b';

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

String _$restoreV1Hash() => r'4dca1ac4cec79fdc78bec4d71367e77caf696f17';

/// See also [restoreV1].
@ProviderFor(restoreV1)
const restoreV1Provider = RestoreV1Family();

/// See also [restoreV1].
class RestoreV1Family extends Family<void> {
  /// See also [restoreV1].
  const RestoreV1Family();

  /// See also [restoreV1].
  RestoreV1Provider call(
    Map<String, dynamic> backup,
  ) {
    return RestoreV1Provider(
      backup,
    );
  }

  @override
  RestoreV1Provider getProviderOverride(
    covariant RestoreV1Provider provider,
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
  String? get name => r'restoreV1Provider';
}

/// See also [restoreV1].
class RestoreV1Provider extends AutoDisposeProvider<void> {
  /// See also [restoreV1].
  RestoreV1Provider(
    Map<String, dynamic> backup,
  ) : this._internal(
          (ref) => restoreV1(
            ref as RestoreV1Ref,
            backup,
          ),
          from: restoreV1Provider,
          name: r'restoreV1Provider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$restoreV1Hash,
          dependencies: RestoreV1Family._dependencies,
          allTransitiveDependencies: RestoreV1Family._allTransitiveDependencies,
          backup: backup,
        );

  RestoreV1Provider._internal(
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
    void Function(RestoreV1Ref provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RestoreV1Provider._internal(
        (ref) => create(ref as RestoreV1Ref),
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
    return _RestoreV1ProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RestoreV1Provider && other.backup == backup;
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
mixin RestoreV1Ref on AutoDisposeProviderRef<void> {
  /// The parameter `backup` of this provider.
  Map<String, dynamic> get backup;
}

class _RestoreV1ProviderElement extends AutoDisposeProviderElement<void>
    with RestoreV1Ref {
  _RestoreV1ProviderElement(super.provider);

  @override
  Map<String, dynamic> get backup => (origin as RestoreV1Provider).backup;
}

String _$restoreV2Hash() => r'fbdd1978f8be7512277620e351b9a0eee1827bfc';

/// See also [restoreV2].
@ProviderFor(restoreV2)
const restoreV2Provider = RestoreV2Family();

/// See also [restoreV2].
class RestoreV2Family extends Family<void> {
  /// See also [restoreV2].
  const RestoreV2Family();

  /// See also [restoreV2].
  RestoreV2Provider call(
    Map<String, dynamic> backup,
  ) {
    return RestoreV2Provider(
      backup,
    );
  }

  @override
  RestoreV2Provider getProviderOverride(
    covariant RestoreV2Provider provider,
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
  String? get name => r'restoreV2Provider';
}

/// See also [restoreV2].
class RestoreV2Provider extends AutoDisposeProvider<void> {
  /// See also [restoreV2].
  RestoreV2Provider(
    Map<String, dynamic> backup,
  ) : this._internal(
          (ref) => restoreV2(
            ref as RestoreV2Ref,
            backup,
          ),
          from: restoreV2Provider,
          name: r'restoreV2Provider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$restoreV2Hash,
          dependencies: RestoreV2Family._dependencies,
          allTransitiveDependencies: RestoreV2Family._allTransitiveDependencies,
          backup: backup,
        );

  RestoreV2Provider._internal(
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
    void Function(RestoreV2Ref provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RestoreV2Provider._internal(
        (ref) => create(ref as RestoreV2Ref),
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
    return _RestoreV2ProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RestoreV2Provider && other.backup == backup;
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
mixin RestoreV2Ref on AutoDisposeProviderRef<void> {
  /// The parameter `backup` of this provider.
  Map<String, dynamic> get backup;
}

class _RestoreV2ProviderElement extends AutoDisposeProviderElement<void>
    with RestoreV2Ref {
  _RestoreV2ProviderElement(super.provider);

  @override
  Map<String, dynamic> get backup => (origin as RestoreV2Provider).backup;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
