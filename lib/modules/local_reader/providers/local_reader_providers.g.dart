// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_reader_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getArchiveDataFromDirectoryHash() =>
    r'fb85bd2b43ae73f083bdfa0760d8185ef989dd09';

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
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
