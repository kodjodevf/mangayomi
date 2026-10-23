// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SubtitleSettingsState)
final subtitleSettingsStateProvider = SubtitleSettingsStateProvider._();

final class SubtitleSettingsStateProvider
    extends $NotifierProvider<SubtitleSettingsState, PlayerSubtitleSettings> {
  SubtitleSettingsStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subtitleSettingsStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subtitleSettingsStateHash();

  @$internal
  @override
  SubtitleSettingsState create() => SubtitleSettingsState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlayerSubtitleSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlayerSubtitleSettings>(value),
    );
  }
}

String _$subtitleSettingsStateHash() =>
    r'c717aed7de35640792cf678304b8c2edef32ba45';

abstract class _$SubtitleSettingsState
    extends $Notifier<PlayerSubtitleSettings> {
  PlayerSubtitleSettings build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<PlayerSubtitleSettings, PlayerSubtitleSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PlayerSubtitleSettings, PlayerSubtitleSettings>,
              PlayerSubtitleSettings,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The player's picture adjustments, kept from one episode to the next.

@ProviderFor(VideoFiltersState)
final videoFiltersStateProvider = VideoFiltersStateProvider._();

/// The player's picture adjustments, kept from one episode to the next.
final class VideoFiltersStateProvider
    extends $NotifierProvider<VideoFiltersState, Map<VideoFilter, int>> {
  /// The player's picture adjustments, kept from one episode to the next.
  VideoFiltersStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'videoFiltersStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$videoFiltersStateHash();

  @$internal
  @override
  VideoFiltersState create() => VideoFiltersState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<VideoFilter, int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<VideoFilter, int>>(value),
    );
  }
}

String _$videoFiltersStateHash() => r'60884e50d009d208b3a555d9516e90d70363f622';

/// The player's picture adjustments, kept from one episode to the next.

abstract class _$VideoFiltersState extends $Notifier<Map<VideoFilter, int>> {
  Map<VideoFilter, int> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Map<VideoFilter, int>, Map<VideoFilter, int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<VideoFilter, int>, Map<VideoFilter, int>>,
              Map<VideoFilter, int>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
