// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_reader_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getArchivesDataFromDirectoryHash() =>
    r'7ca5e7d4a2a79745c92dd0370703c614406be2ad';

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

typedef GetArchivesDataFromDirectoryRef = AutoDisposeFutureProviderRef<
    List<(String, LocalExtensionType, Uint8List, String)>>;

/// See also [getArchivesDataFromDirectory].
@ProviderFor(getArchivesDataFromDirectory)
const getArchivesDataFromDirectoryProvider =
    GetArchivesDataFromDirectoryFamily();

/// See also [getArchivesDataFromDirectory].
class GetArchivesDataFromDirectoryFamily extends Family<
    AsyncValue<List<(String, LocalExtensionType, Uint8List, String)>>> {
  /// See also [getArchivesDataFromDirectory].
  const GetArchivesDataFromDirectoryFamily();

  /// See also [getArchivesDataFromDirectory].
  GetArchivesDataFromDirectoryProvider call(
    String path,
  ) {
    return GetArchivesDataFromDirectoryProvider(
      path,
    );
  }

  @override
  GetArchivesDataFromDirectoryProvider getProviderOverride(
    covariant GetArchivesDataFromDirectoryProvider provider,
  ) {
    return call(
      provider.path,
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
  String? get name => r'getArchivesDataFromDirectoryProvider';
}

/// See also [getArchivesDataFromDirectory].
class GetArchivesDataFromDirectoryProvider extends AutoDisposeFutureProvider<
    List<(String, LocalExtensionType, Uint8List, String)>> {
  /// See also [getArchivesDataFromDirectory].
  GetArchivesDataFromDirectoryProvider(
    this.path,
  ) : super.internal(
          (ref) => getArchivesDataFromDirectory(
            ref,
            path,
          ),
          from: getArchivesDataFromDirectoryProvider,
          name: r'getArchivesDataFromDirectoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getArchivesDataFromDirectoryHash,
          dependencies: GetArchivesDataFromDirectoryFamily._dependencies,
          allTransitiveDependencies:
              GetArchivesDataFromDirectoryFamily._allTransitiveDependencies,
        );

  final String path;

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

String _$getArchiveDataFromDirectoryHash() =>
    r'fb85bd2b43ae73f083bdfa0760d8185ef989dd09';
typedef GetArchiveDataFromDirectoryRef
    = AutoDisposeFutureProviderRef<List<LocalArchive>>;

/// See also [getArchiveDataFromDirectory].
@ProviderFor(getArchiveDataFromDirectory)
const getArchiveDataFromDirectoryProvider = GetArchiveDataFromDirectoryFamily();

/// See also [getArchiveDataFromDirectory].
class GetArchiveDataFromDirectoryFamily
    extends Family<AsyncValue<List<LocalArchive>>> {
  /// See also [getArchiveDataFromDirectory].
  const GetArchiveDataFromDirectoryFamily();

  /// See also [getArchiveDataFromDirectory].
  GetArchiveDataFromDirectoryProvider call(
    String path,
  ) {
    return GetArchiveDataFromDirectoryProvider(
      path,
    );
  }

  @override
  GetArchiveDataFromDirectoryProvider getProviderOverride(
    covariant GetArchiveDataFromDirectoryProvider provider,
  ) {
    return call(
      provider.path,
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
  String? get name => r'getArchiveDataFromDirectoryProvider';
}

/// See also [getArchiveDataFromDirectory].
class GetArchiveDataFromDirectoryProvider
    extends AutoDisposeFutureProvider<List<LocalArchive>> {
  /// See also [getArchiveDataFromDirectory].
  GetArchiveDataFromDirectoryProvider(
    this.path,
  ) : super.internal(
          (ref) => getArchiveDataFromDirectory(
            ref,
            path,
          ),
          from: getArchiveDataFromDirectoryProvider,
          name: r'getArchiveDataFromDirectoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getArchiveDataFromDirectoryHash,
          dependencies: GetArchiveDataFromDirectoryFamily._dependencies,
          allTransitiveDependencies:
              GetArchiveDataFromDirectoryFamily._allTransitiveDependencies,
        );

  final String path;

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

String _$getArchivesDataFromFileHash() =>
    r'f118f903a693c2f2ad5ec2452430a1eb10b661b2';
typedef GetArchivesDataFromFileRef = AutoDisposeFutureProviderRef<
    (String, LocalExtensionType, Uint8List, String)>;

/// See also [getArchivesDataFromFile].
@ProviderFor(getArchivesDataFromFile)
const getArchivesDataFromFileProvider = GetArchivesDataFromFileFamily();

/// See also [getArchivesDataFromFile].
class GetArchivesDataFromFileFamily extends Family<
    AsyncValue<(String, LocalExtensionType, Uint8List, String)>> {
  /// See also [getArchivesDataFromFile].
  const GetArchivesDataFromFileFamily();

  /// See also [getArchivesDataFromFile].
  GetArchivesDataFromFileProvider call(
    String path,
  ) {
    return GetArchivesDataFromFileProvider(
      path,
    );
  }

  @override
  GetArchivesDataFromFileProvider getProviderOverride(
    covariant GetArchivesDataFromFileProvider provider,
  ) {
    return call(
      provider.path,
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
  String? get name => r'getArchivesDataFromFileProvider';
}

/// See also [getArchivesDataFromFile].
class GetArchivesDataFromFileProvider extends AutoDisposeFutureProvider<
    (String, LocalExtensionType, Uint8List, String)> {
  /// See also [getArchivesDataFromFile].
  GetArchivesDataFromFileProvider(
    this.path,
  ) : super.internal(
          (ref) => getArchivesDataFromFile(
            ref,
            path,
          ),
          from: getArchivesDataFromFileProvider,
          name: r'getArchivesDataFromFileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getArchivesDataFromFileHash,
          dependencies: GetArchivesDataFromFileFamily._dependencies,
          allTransitiveDependencies:
              GetArchivesDataFromFileFamily._allTransitiveDependencies,
        );

  final String path;

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

String _$getArchiveDataFromFileHash() =>
    r'e5dc60fea6c36346c47542c141703bb027173215';
typedef GetArchiveDataFromFileRef = AutoDisposeFutureProviderRef<LocalArchive>;

/// See also [getArchiveDataFromFile].
@ProviderFor(getArchiveDataFromFile)
const getArchiveDataFromFileProvider = GetArchiveDataFromFileFamily();

/// See also [getArchiveDataFromFile].
class GetArchiveDataFromFileFamily extends Family<AsyncValue<LocalArchive>> {
  /// See also [getArchiveDataFromFile].
  const GetArchiveDataFromFileFamily();

  /// See also [getArchiveDataFromFile].
  GetArchiveDataFromFileProvider call(
    String path,
  ) {
    return GetArchiveDataFromFileProvider(
      path,
    );
  }

  @override
  GetArchiveDataFromFileProvider getProviderOverride(
    covariant GetArchiveDataFromFileProvider provider,
  ) {
    return call(
      provider.path,
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
  String? get name => r'getArchiveDataFromFileProvider';
}

/// See also [getArchiveDataFromFile].
class GetArchiveDataFromFileProvider
    extends AutoDisposeFutureProvider<LocalArchive> {
  /// See also [getArchiveDataFromFile].
  GetArchiveDataFromFileProvider(
    this.path,
  ) : super.internal(
          (ref) => getArchiveDataFromFile(
            ref,
            path,
          ),
          from: getArchiveDataFromFileProvider,
          name: r'getArchiveDataFromFileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getArchiveDataFromFileHash,
          dependencies: GetArchiveDataFromFileFamily._dependencies,
          allTransitiveDependencies:
              GetArchiveDataFromFileFamily._allTransitiveDependencies,
        );

  final String path;

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
