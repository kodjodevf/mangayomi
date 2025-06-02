// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_torrent.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$addTorrentFromUrlOrFromFileHash() =>
    r'd12f901b675ecbf4a29c496cf99da17f219745f7';

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

/// See also [addTorrentFromUrlOrFromFile].
@ProviderFor(addTorrentFromUrlOrFromFile)
const addTorrentFromUrlOrFromFileProvider = AddTorrentFromUrlOrFromFileFamily();

/// See also [addTorrentFromUrlOrFromFile].
class AddTorrentFromUrlOrFromFileFamily extends Family<AsyncValue> {
  /// See also [addTorrentFromUrlOrFromFile].
  const AddTorrentFromUrlOrFromFileFamily();

  /// See also [addTorrentFromUrlOrFromFile].
  AddTorrentFromUrlOrFromFileProvider call(
    Manga? mManga, {
    required bool init,
    String? url,
  }) {
    return AddTorrentFromUrlOrFromFileProvider(
      mManga,
      init: init,
      url: url,
    );
  }

  @override
  AddTorrentFromUrlOrFromFileProvider getProviderOverride(
    covariant AddTorrentFromUrlOrFromFileProvider provider,
  ) {
    return call(
      provider.mManga,
      init: provider.init,
      url: provider.url,
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
  String? get name => r'addTorrentFromUrlOrFromFileProvider';
}

/// See also [addTorrentFromUrlOrFromFile].
class AddTorrentFromUrlOrFromFileProvider
    extends AutoDisposeFutureProvider<Object?> {
  /// See also [addTorrentFromUrlOrFromFile].
  AddTorrentFromUrlOrFromFileProvider(
    Manga? mManga, {
    required bool init,
    String? url,
  }) : this._internal(
          (ref) => addTorrentFromUrlOrFromFile(
            ref as AddTorrentFromUrlOrFromFileRef,
            mManga,
            init: init,
            url: url,
          ),
          from: addTorrentFromUrlOrFromFileProvider,
          name: r'addTorrentFromUrlOrFromFileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$addTorrentFromUrlOrFromFileHash,
          dependencies: AddTorrentFromUrlOrFromFileFamily._dependencies,
          allTransitiveDependencies:
              AddTorrentFromUrlOrFromFileFamily._allTransitiveDependencies,
          mManga: mManga,
          init: init,
          url: url,
        );

  AddTorrentFromUrlOrFromFileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mManga,
    required this.init,
    required this.url,
  }) : super.internal();

  final Manga? mManga;
  final bool init;
  final String? url;

  @override
  Override overrideWith(
    FutureOr<Object?> Function(AddTorrentFromUrlOrFromFileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AddTorrentFromUrlOrFromFileProvider._internal(
        (ref) => create(ref as AddTorrentFromUrlOrFromFileRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mManga: mManga,
        init: init,
        url: url,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Object?> createElement() {
    return _AddTorrentFromUrlOrFromFileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AddTorrentFromUrlOrFromFileProvider &&
        other.mManga == mManga &&
        other.init == init &&
        other.url == url;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mManga.hashCode);
    hash = _SystemHash.combine(hash, init.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AddTorrentFromUrlOrFromFileRef on AutoDisposeFutureProviderRef<Object?> {
  /// The parameter `mManga` of this provider.
  Manga? get mManga;

  /// The parameter `init` of this provider.
  bool get init;

  /// The parameter `url` of this provider.
  String? get url;
}

class _AddTorrentFromUrlOrFromFileProviderElement
    extends AutoDisposeFutureProviderElement<Object?>
    with AddTorrentFromUrlOrFromFileRef {
  _AddTorrentFromUrlOrFromFileProviderElement(super.provider);

  @override
  Manga? get mManga => (origin as AddTorrentFromUrlOrFromFileProvider).mManga;
  @override
  bool get init => (origin as AddTorrentFromUrlOrFromFileProvider).init;
  @override
  String? get url => (origin as AddTorrentFromUrlOrFromFileProvider).url;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
