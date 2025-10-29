// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime_player_controller_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AnimeStreamController)
const animeStreamControllerProvider = AnimeStreamControllerFamily._();

final class AnimeStreamControllerProvider
    extends $NotifierProvider<AnimeStreamController, KeepAliveLink> {
  const AnimeStreamControllerProvider._({
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
    r'486889b2b9f71759e4d9ff147b039436572cc01e';

final class AnimeStreamControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          AnimeStreamController,
          KeepAliveLink,
          KeepAliveLink,
          KeepAliveLink,
          Chapter
        > {
  const AnimeStreamControllerFamily._()
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
    final created = build(episode: _$args);
    final ref = this.ref as $Ref<KeepAliveLink, KeepAliveLink>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<KeepAliveLink, KeepAliveLink>,
              KeepAliveLink,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
