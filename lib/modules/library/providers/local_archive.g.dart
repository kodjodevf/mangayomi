// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_archive.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$importArchivesFromDirectoryHash() =>
    r'c42265b5ccec477da1a39964a4fffeaf37b49164';

/// See also [importArchivesFromDirectory].
@ProviderFor(importArchivesFromDirectory)
final importArchivesFromDirectoryProvider =
    AutoDisposeFutureProvider<dynamic>.internal(
  importArchivesFromDirectory,
  name: r'importArchivesFromDirectoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$importArchivesFromDirectoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ImportArchivesFromDirectoryRef = AutoDisposeFutureProviderRef<dynamic>;
String _$importArchivesFromFileHash() =>
    r'ee38771c056b3f15d856ed0b91cd559ab22dc236';

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

typedef ImportArchivesFromFileRef = AutoDisposeFutureProviderRef<dynamic>;

/// See also [importArchivesFromFile].
@ProviderFor(importArchivesFromFile)
const importArchivesFromFileProvider = ImportArchivesFromFileFamily();

/// See also [importArchivesFromFile].
class ImportArchivesFromFileFamily extends Family<AsyncValue<dynamic>> {
  /// See also [importArchivesFromFile].
  const ImportArchivesFromFileFamily();

  /// See also [importArchivesFromFile].
  ImportArchivesFromFileProvider call(
    Manga? mManga,
  ) {
    return ImportArchivesFromFileProvider(
      mManga,
    );
  }

  @override
  ImportArchivesFromFileProvider getProviderOverride(
    covariant ImportArchivesFromFileProvider provider,
  ) {
    return call(
      provider.mManga,
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
  String? get name => r'importArchivesFromFileProvider';
}

/// See also [importArchivesFromFile].
class ImportArchivesFromFileProvider
    extends AutoDisposeFutureProvider<dynamic> {
  /// See also [importArchivesFromFile].
  ImportArchivesFromFileProvider(
    this.mManga,
  ) : super.internal(
          (ref) => importArchivesFromFile(
            ref,
            mManga,
          ),
          from: importArchivesFromFileProvider,
          name: r'importArchivesFromFileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$importArchivesFromFileHash,
          dependencies: ImportArchivesFromFileFamily._dependencies,
          allTransitiveDependencies:
              ImportArchivesFromFileFamily._allTransitiveDependencies,
        );

  final Manga? mManga;

  @override
  bool operator ==(Object other) {
    return other is ImportArchivesFromFileProvider && other.mManga == mManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mManga.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
