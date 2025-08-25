// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_reader_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getArchivesDataFromDirectoryHash() =>
    r'2a4d1a11e2b028e569ffd8a2700e4a1779bb9264';

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

/// See also [getArchivesDataFromDirectory].
@ProviderFor(getArchivesDataFromDirectory)
const getArchivesDataFromDirectoryProvider =
    GetArchivesDataFromDirectoryFamily();

/// See also [getArchivesDataFromDirectory].
class GetArchivesDataFromDirectoryFamily
    extends
        Family<
          AsyncValue<List<(String, LocalExtensionType, Uint8List, String)>>
        > {
  /// See also [getArchivesDataFromDirectory].
  const GetArchivesDataFromDirectoryFamily();

  /// See also [getArchivesDataFromDirectory].
  GetArchivesDataFromDirectoryProvider call(String path) {
    return GetArchivesDataFromDirectoryProvider(path);
  }

  @override
  GetArchivesDataFromDirectoryProvider getProviderOverride(
    covariant GetArchivesDataFromDirectoryProvider provider,
  ) {
    return call(provider.path);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getArchivesDataFromDirectoryProvider';
}

/// See also [getArchivesDataFromDirectory].
class GetArchivesDataFromDirectoryProvider
    extends
        AutoDisposeFutureProvider<
          List<(String, LocalExtensionType, Uint8List, String)>
        > {
  /// See also [getArchivesDataFromDirectory].
  GetArchivesDataFromDirectoryProvider(String path)
    : this._internal(
        (ref) => getArchivesDataFromDirectory(
          ref as GetArchivesDataFromDirectoryRef,
          path,
        ),
        from: getArchivesDataFromDirectoryProvider,
        name: r'getArchivesDataFromDirectoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$getArchivesDataFromDirectoryHash,
        dependencies: GetArchivesDataFromDirectoryFamily._dependencies,
        allTransitiveDependencies:
            GetArchivesDataFromDirectoryFamily._allTransitiveDependencies,
        path: path,
      );

  GetArchivesDataFromDirectoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.path,
  }) : super.internal();

  final String path;

  @override
  Override overrideWith(
    FutureOr<List<(String, LocalExtensionType, Uint8List, String)>> Function(
      GetArchivesDataFromDirectoryRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetArchivesDataFromDirectoryProvider._internal(
        (ref) => create(ref as GetArchivesDataFromDirectoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        path: path,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<
    List<(String, LocalExtensionType, Uint8List, String)>
  >
  createElement() {
    return _GetArchivesDataFromDirectoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetArchivesDataFromDirectoryProvider && other.path == path;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, path.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetArchivesDataFromDirectoryRef
    on
        AutoDisposeFutureProviderRef<
          List<(String, LocalExtensionType, Uint8List, String)>
        > {
  /// The parameter `path` of this provider.
  String get path;
}

class _GetArchivesDataFromDirectoryProviderElement
    extends
        AutoDisposeFutureProviderElement<
          List<(String, LocalExtensionType, Uint8List, String)>
        >
    with GetArchivesDataFromDirectoryRef {
  _GetArchivesDataFromDirectoryProviderElement(super.provider);

  @override
  String get path => (origin as GetArchivesDataFromDirectoryProvider).path;
}

String _$getArchiveDataFromDirectoryHash() =>
    r'49aa47895feafd9fa0c4f20e25d7674a3d54b212';

/// See also [getArchiveDataFromDirectory].
@ProviderFor(getArchiveDataFromDirectory)
const getArchiveDataFromDirectoryProvider = GetArchiveDataFromDirectoryFamily();

/// See also [getArchiveDataFromDirectory].
class GetArchiveDataFromDirectoryFamily
    extends Family<AsyncValue<List<LocalArchive>>> {
  /// See also [getArchiveDataFromDirectory].
  const GetArchiveDataFromDirectoryFamily();

  /// See also [getArchiveDataFromDirectory].
  GetArchiveDataFromDirectoryProvider call(String path) {
    return GetArchiveDataFromDirectoryProvider(path);
  }

  @override
  GetArchiveDataFromDirectoryProvider getProviderOverride(
    covariant GetArchiveDataFromDirectoryProvider provider,
  ) {
    return call(provider.path);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getArchiveDataFromDirectoryProvider';
}

/// See also [getArchiveDataFromDirectory].
class GetArchiveDataFromDirectoryProvider
    extends AutoDisposeFutureProvider<List<LocalArchive>> {
  /// See also [getArchiveDataFromDirectory].
  GetArchiveDataFromDirectoryProvider(String path)
    : this._internal(
        (ref) => getArchiveDataFromDirectory(
          ref as GetArchiveDataFromDirectoryRef,
          path,
        ),
        from: getArchiveDataFromDirectoryProvider,
        name: r'getArchiveDataFromDirectoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$getArchiveDataFromDirectoryHash,
        dependencies: GetArchiveDataFromDirectoryFamily._dependencies,
        allTransitiveDependencies:
            GetArchiveDataFromDirectoryFamily._allTransitiveDependencies,
        path: path,
      );

  GetArchiveDataFromDirectoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.path,
  }) : super.internal();

  final String path;

  @override
  Override overrideWith(
    FutureOr<List<LocalArchive>> Function(
      GetArchiveDataFromDirectoryRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetArchiveDataFromDirectoryProvider._internal(
        (ref) => create(ref as GetArchiveDataFromDirectoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        path: path,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<LocalArchive>> createElement() {
    return _GetArchiveDataFromDirectoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetArchiveDataFromDirectoryProvider && other.path == path;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, path.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetArchiveDataFromDirectoryRef
    on AutoDisposeFutureProviderRef<List<LocalArchive>> {
  /// The parameter `path` of this provider.
  String get path;
}

class _GetArchiveDataFromDirectoryProviderElement
    extends AutoDisposeFutureProviderElement<List<LocalArchive>>
    with GetArchiveDataFromDirectoryRef {
  _GetArchiveDataFromDirectoryProviderElement(super.provider);

  @override
  String get path => (origin as GetArchiveDataFromDirectoryProvider).path;
}

String _$getArchivesDataFromFileHash() =>
    r'79874b548614b4410c19bca5f74978ec761742c5';

/// See also [getArchivesDataFromFile].
@ProviderFor(getArchivesDataFromFile)
const getArchivesDataFromFileProvider = GetArchivesDataFromFileFamily();

/// See also [getArchivesDataFromFile].
class GetArchivesDataFromFileFamily
    extends
        Family<AsyncValue<(String, LocalExtensionType, Uint8List, String)>> {
  /// See also [getArchivesDataFromFile].
  const GetArchivesDataFromFileFamily();

  /// See also [getArchivesDataFromFile].
  GetArchivesDataFromFileProvider call(String path) {
    return GetArchivesDataFromFileProvider(path);
  }

  @override
  GetArchivesDataFromFileProvider getProviderOverride(
    covariant GetArchivesDataFromFileProvider provider,
  ) {
    return call(provider.path);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getArchivesDataFromFileProvider';
}

/// See also [getArchivesDataFromFile].
class GetArchivesDataFromFileProvider
    extends
        AutoDisposeFutureProvider<
          (String, LocalExtensionType, Uint8List, String)
        > {
  /// See also [getArchivesDataFromFile].
  GetArchivesDataFromFileProvider(String path)
    : this._internal(
        (ref) =>
            getArchivesDataFromFile(ref as GetArchivesDataFromFileRef, path),
        from: getArchivesDataFromFileProvider,
        name: r'getArchivesDataFromFileProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$getArchivesDataFromFileHash,
        dependencies: GetArchivesDataFromFileFamily._dependencies,
        allTransitiveDependencies:
            GetArchivesDataFromFileFamily._allTransitiveDependencies,
        path: path,
      );

  GetArchivesDataFromFileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.path,
  }) : super.internal();

  final String path;

  @override
  Override overrideWith(
    FutureOr<(String, LocalExtensionType, Uint8List, String)> Function(
      GetArchivesDataFromFileRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetArchivesDataFromFileProvider._internal(
        (ref) => create(ref as GetArchivesDataFromFileRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        path: path,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<
    (String, LocalExtensionType, Uint8List, String)
  >
  createElement() {
    return _GetArchivesDataFromFileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetArchivesDataFromFileProvider && other.path == path;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, path.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetArchivesDataFromFileRef
    on
        AutoDisposeFutureProviderRef<
          (String, LocalExtensionType, Uint8List, String)
        > {
  /// The parameter `path` of this provider.
  String get path;
}

class _GetArchivesDataFromFileProviderElement
    extends
        AutoDisposeFutureProviderElement<
          (String, LocalExtensionType, Uint8List, String)
        >
    with GetArchivesDataFromFileRef {
  _GetArchivesDataFromFileProviderElement(super.provider);

  @override
  String get path => (origin as GetArchivesDataFromFileProvider).path;
}

String _$getArchiveDataFromFileHash() =>
    r'a5d8bf8246bfa250af6a7fd3c09bba6a012e0b2d';

/// See also [getArchiveDataFromFile].
@ProviderFor(getArchiveDataFromFile)
const getArchiveDataFromFileProvider = GetArchiveDataFromFileFamily();

/// See also [getArchiveDataFromFile].
class GetArchiveDataFromFileFamily extends Family<AsyncValue<LocalArchive>> {
  /// See also [getArchiveDataFromFile].
  const GetArchiveDataFromFileFamily();

  /// See also [getArchiveDataFromFile].
  GetArchiveDataFromFileProvider call(String path) {
    return GetArchiveDataFromFileProvider(path);
  }

  @override
  GetArchiveDataFromFileProvider getProviderOverride(
    covariant GetArchiveDataFromFileProvider provider,
  ) {
    return call(provider.path);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getArchiveDataFromFileProvider';
}

/// See also [getArchiveDataFromFile].
class GetArchiveDataFromFileProvider
    extends AutoDisposeFutureProvider<LocalArchive> {
  /// See also [getArchiveDataFromFile].
  GetArchiveDataFromFileProvider(String path)
    : this._internal(
        (ref) => getArchiveDataFromFile(ref as GetArchiveDataFromFileRef, path),
        from: getArchiveDataFromFileProvider,
        name: r'getArchiveDataFromFileProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$getArchiveDataFromFileHash,
        dependencies: GetArchiveDataFromFileFamily._dependencies,
        allTransitiveDependencies:
            GetArchiveDataFromFileFamily._allTransitiveDependencies,
        path: path,
      );

  GetArchiveDataFromFileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.path,
  }) : super.internal();

  final String path;

  @override
  Override overrideWith(
    FutureOr<LocalArchive> Function(GetArchiveDataFromFileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetArchiveDataFromFileProvider._internal(
        (ref) => create(ref as GetArchiveDataFromFileRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        path: path,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<LocalArchive> createElement() {
    return _GetArchiveDataFromFileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetArchiveDataFromFileProvider && other.path == path;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, path.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetArchiveDataFromFileRef on AutoDisposeFutureProviderRef<LocalArchive> {
  /// The parameter `path` of this provider.
  String get path;
}

class _GetArchiveDataFromFileProviderElement
    extends AutoDisposeFutureProviderElement<LocalArchive>
    with GetArchiveDataFromFileRef {
  _GetArchiveDataFromFileProviderElement(super.provider);

  @override
  String get path => (origin as GetArchiveDataFromFileProvider).path;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
