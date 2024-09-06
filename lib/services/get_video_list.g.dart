// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_video_list.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getVideoListHash() => r'2002f381edbe8c3c5e8a00826b3d9aaf49410e57';

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

/// See also [getVideoList].
@ProviderFor(getVideoList)
const getVideoListProvider = GetVideoListFamily();

/// See also [getVideoList].
class GetVideoListFamily
    extends Family<AsyncValue<(List<Video>, bool, String?, HttpServer?)>> {
  /// See also [getVideoList].
  const GetVideoListFamily();

  /// See also [getVideoList].
  GetVideoListProvider call({
    required Chapter episode,
    bool ignoreM3u8File = false,
  }) {
    return GetVideoListProvider(
      episode: episode,
      ignoreM3u8File: ignoreM3u8File,
    );
  }

  @override
  GetVideoListProvider getProviderOverride(
    covariant GetVideoListProvider provider,
  ) {
    return call(
      episode: provider.episode,
      ignoreM3u8File: provider.ignoreM3u8File,
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
  String? get name => r'getVideoListProvider';
}

/// See also [getVideoList].
class GetVideoListProvider extends AutoDisposeFutureProvider<
    (List<Video>, bool, String?, HttpServer?)> {
  /// See also [getVideoList].
  GetVideoListProvider({
    required Chapter episode,
    bool ignoreM3u8File = false,
  }) : this._internal(
          (ref) => getVideoList(
            ref as GetVideoListRef,
            episode: episode,
            ignoreM3u8File: ignoreM3u8File,
          ),
          from: getVideoListProvider,
          name: r'getVideoListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getVideoListHash,
          dependencies: GetVideoListFamily._dependencies,
          allTransitiveDependencies:
              GetVideoListFamily._allTransitiveDependencies,
          episode: episode,
          ignoreM3u8File: ignoreM3u8File,
        );

  GetVideoListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.episode,
    required this.ignoreM3u8File,
  }) : super.internal();

  final Chapter episode;
  final bool ignoreM3u8File;

  @override
  Override overrideWith(
    FutureOr<(List<Video>, bool, String?, HttpServer?)> Function(
            GetVideoListRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetVideoListProvider._internal(
        (ref) => create(ref as GetVideoListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        episode: episode,
        ignoreM3u8File: ignoreM3u8File,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<(List<Video>, bool, String?, HttpServer?)>
      createElement() {
    return _GetVideoListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetVideoListProvider &&
        other.episode == episode &&
        other.ignoreM3u8File == ignoreM3u8File;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, episode.hashCode);
    hash = _SystemHash.combine(hash, ignoreM3u8File.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetVideoListRef
    on AutoDisposeFutureProviderRef<(List<Video>, bool, String?, HttpServer?)> {
  /// The parameter `episode` of this provider.
  Chapter get episode;

  /// The parameter `ignoreM3u8File` of this provider.
  bool get ignoreM3u8File;
}

class _GetVideoListProviderElement extends AutoDisposeFutureProviderElement<
    (List<Video>, bool, String?, HttpServer?)> with GetVideoListRef {
  _GetVideoListProviderElement(super.provider);

  @override
  Chapter get episode => (origin as GetVideoListProvider).episode;
  @override
  bool get ignoreM3u8File => (origin as GetVideoListProvider).ignoreM3u8File;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
