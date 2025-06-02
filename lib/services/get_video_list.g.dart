// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_video_list.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getVideoListHash() => r'bae6a3cbc064163148577d0646b87a3f16d44da7';

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
    extends Family<AsyncValue<(List<Video>, bool, List<String>)>> {
  /// See also [getVideoList].
  const GetVideoListFamily();

  /// See also [getVideoList].
  GetVideoListProvider call({
    required Chapter episode,
  }) {
    return GetVideoListProvider(
      episode: episode,
    );
  }

  @override
  GetVideoListProvider getProviderOverride(
    covariant GetVideoListProvider provider,
  ) {
    return call(
      episode: provider.episode,
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
class GetVideoListProvider
    extends AutoDisposeFutureProvider<(List<Video>, bool, List<String>)> {
  /// See also [getVideoList].
  GetVideoListProvider({
    required Chapter episode,
  }) : this._internal(
          (ref) => getVideoList(
            ref as GetVideoListRef,
            episode: episode,
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
        );

  GetVideoListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.episode,
  }) : super.internal();

  final Chapter episode;

  @override
  Override overrideWith(
    FutureOr<(List<Video>, bool, List<String>)> Function(
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
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<(List<Video>, bool, List<String>)>
      createElement() {
    return _GetVideoListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetVideoListProvider && other.episode == episode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, episode.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetVideoListRef
    on AutoDisposeFutureProviderRef<(List<Video>, bool, List<String>)> {
  /// The parameter `episode` of this provider.
  Chapter get episode;
}

class _GetVideoListProviderElement
    extends AutoDisposeFutureProviderElement<(List<Video>, bool, List<String>)>
    with GetVideoListRef {
  _GetVideoListProviderElement(super.provider);

  @override
  Chapter get episode => (origin as GetVideoListProvider).episode;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
