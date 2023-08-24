// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_archive.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$importArchivesFromFileHash() =>
    r'afa44597ec3e225e22be1207958b6f4553420fb8';

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
    Manga? mManga, {
    required bool isManga,
  }) {
    return ImportArchivesFromFileProvider(
      mManga,
      isManga: isManga,
    );
  }

  @override
  ImportArchivesFromFileProvider getProviderOverride(
    covariant ImportArchivesFromFileProvider provider,
  ) {
    return call(
      provider.mManga,
      isManga: provider.isManga,
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
    this.mManga, {
    required this.isManga,
  }) : super.internal(
          (ref) => importArchivesFromFile(
            ref,
            mManga,
            isManga: isManga,
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
  final bool isManga;

  @override
  bool operator ==(Object other) {
    return other is ImportArchivesFromFileProvider &&
        other.mManga == mManga &&
        other.isManga == isManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mManga.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
