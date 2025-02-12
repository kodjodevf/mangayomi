// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime_player_controller_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$animeStreamControllerHash() =>
    r'e0217071ae7b908a12bbba2dcdc4a6da8828e1c5';

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

abstract class _$AnimeStreamController
    extends BuildlessAutoDisposeNotifier<void> {
  late final Chapter episode;

  void build({
    required Chapter episode,
  });
}

/// See also [AnimeStreamController].
@ProviderFor(AnimeStreamController)
const animeStreamControllerProvider = AnimeStreamControllerFamily();

/// See also [AnimeStreamController].
class AnimeStreamControllerFamily extends Family<void> {
  /// See also [AnimeStreamController].
  const AnimeStreamControllerFamily();

  /// See also [AnimeStreamController].
  AnimeStreamControllerProvider call({
    required Chapter episode,
  }) {
    return AnimeStreamControllerProvider(
      episode: episode,
    );
  }

  @override
  AnimeStreamControllerProvider getProviderOverride(
    covariant AnimeStreamControllerProvider provider,
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
  String? get name => r'animeStreamControllerProvider';
}

/// See also [AnimeStreamController].
class AnimeStreamControllerProvider
    extends AutoDisposeNotifierProviderImpl<AnimeStreamController, void> {
  /// See also [AnimeStreamController].
  AnimeStreamControllerProvider({
    required Chapter episode,
  }) : this._internal(
          () => AnimeStreamController()..episode = episode,
          from: animeStreamControllerProvider,
          name: r'animeStreamControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$animeStreamControllerHash,
          dependencies: AnimeStreamControllerFamily._dependencies,
          allTransitiveDependencies:
              AnimeStreamControllerFamily._allTransitiveDependencies,
          episode: episode,
        );

  AnimeStreamControllerProvider._internal(
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
  void runNotifierBuild(
    covariant AnimeStreamController notifier,
  ) {
    return notifier.build(
      episode: episode,
    );
  }

  @override
  Override overrideWith(AnimeStreamController Function() create) {
    return ProviderOverride(
      origin: this,
      override: AnimeStreamControllerProvider._internal(
        () => create()..episode = episode,
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
  AutoDisposeNotifierProviderElement<AnimeStreamController, void>
      createElement() {
    return _AnimeStreamControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AnimeStreamControllerProvider && other.episode == episode;
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
mixin AnimeStreamControllerRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `episode` of this provider.
  Chapter get episode;
}

class _AnimeStreamControllerProviderElement
    extends AutoDisposeNotifierProviderElement<AnimeStreamController, void>
    with AnimeStreamControllerRef {
  _AnimeStreamControllerProviderElement(super.provider);

  @override
  Chapter get episode => (origin as AnimeStreamControllerProvider).episode;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
