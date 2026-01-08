// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime_player_controller_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AnimeStreamController)
final animeStreamControllerProvider = AnimeStreamControllerFamily._();

final class AnimeStreamControllerProvider
    extends $NotifierProvider<AnimeStreamController, KeepAliveLink> {
  AnimeStreamControllerProvider._({
    required AnimeStreamControllerFamily super.from,
    required Chapter super.argument,
  }) : super(
         retry: null,
         name: r'animeStreamControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$animeStreamControllerHash();

  @override
  String toString() {
    return r'animeStreamControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AnimeStreamController create() => AnimeStreamController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KeepAliveLink value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KeepAliveLink>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AnimeStreamControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$animeStreamControllerHash() =>
    r'1bca3ada0f7919439500ce8c42fa39958c1c5a7b';

final class AnimeStreamControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          AnimeStreamController,
          KeepAliveLink,
          KeepAliveLink,
          KeepAliveLink,
          Chapter
        > {
  AnimeStreamControllerFamily._()
    : super(
        retry: null,
        name: r'animeStreamControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AnimeStreamControllerProvider call({required Chapter episode}) =>
      AnimeStreamControllerProvider._(argument: episode, from: this);

  @override
  String toString() => r'animeStreamControllerProvider';
}

abstract class _$AnimeStreamController extends $Notifier<KeepAliveLink> {
  late final _$args = ref.$arg as Chapter;
  Chapter get episode => _$args;

  KeepAliveLink build({required Chapter episode});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<KeepAliveLink, KeepAliveLink>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<KeepAliveLink, KeepAliveLink>,
              KeepAliveLink,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(episode: _$args));
  }
}
