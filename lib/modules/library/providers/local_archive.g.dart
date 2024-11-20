// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_archive.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$importArchivesFromFileHash() =>
    r'8be95f0947ab5247e3305a355a6f17f0aaecad00';

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

/// See also [importArchivesFromFile].
@ProviderFor(importArchivesFromFile)
const importArchivesFromFileProvider = ImportArchivesFromFileFamily();

/// See also [importArchivesFromFile].
class ImportArchivesFromFileFamily extends Family<AsyncValue> {
  /// See also [importArchivesFromFile].
  const ImportArchivesFromFileFamily();

  /// See also [importArchivesFromFile].
  ImportArchivesFromFileProvider call(
    Manga? mManga, {
    required bool isManga,
    required bool init,
  }) {
    return ImportArchivesFromFileProvider(
      mManga,
      isManga: isManga,
      init: init,
    );
  }

  @override
  ImportArchivesFromFileProvider getProviderOverride(
    covariant ImportArchivesFromFileProvider provider,
  ) {
    return call(
      provider.mManga,
      isManga: provider.isManga,
      init: provider.init,
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
    extends AutoDisposeFutureProvider<Object?> {
  /// See also [importArchivesFromFile].
  ImportArchivesFromFileProvider(
    Manga? mManga, {
    required bool isManga,
    required bool init,
  }) : this._internal(
          (ref) => importArchivesFromFile(
            ref as ImportArchivesFromFileRef,
            mManga,
            isManga: isManga,
            init: init,
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
          mManga: mManga,
          isManga: isManga,
          init: init,
        );

  ImportArchivesFromFileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mManga,
    required this.isManga,
    required this.init,
  }) : super.internal();

  final Manga? mManga;
  final bool isManga;
  final bool init;

  @override
  Override overrideWith(
    FutureOr<Object?> Function(ImportArchivesFromFileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ImportArchivesFromFileProvider._internal(
        (ref) => create(ref as ImportArchivesFromFileRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mManga: mManga,
        isManga: isManga,
        init: init,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Object?> createElement() {
    return _ImportArchivesFromFileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ImportArchivesFromFileProvider &&
        other.mManga == mManga &&
        other.isManga == isManga &&
        other.init == init;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mManga.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);
    hash = _SystemHash.combine(hash, init.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ImportArchivesFromFileRef on AutoDisposeFutureProviderRef<Object?> {
  /// The parameter `mManga` of this provider.
  Manga? get mManga;

  /// The parameter `isManga` of this provider.
  bool get isManga;

  /// The parameter `init` of this provider.
  bool get init;
}

class _ImportArchivesFromFileProviderElement
    extends AutoDisposeFutureProviderElement<Object?>
    with ImportArchivesFromFileRef {
  _ImportArchivesFromFileProviderElement(super.provider);

  @override
  Manga? get mManga => (origin as ImportArchivesFromFileProvider).mManga;
  @override
  bool get isManga => (origin as ImportArchivesFromFileProvider).isManga;
  @override
  bool get init => (origin as ImportArchivesFromFileProvider).init;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
