// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_audio_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AudioPreferredLangState)
final audioPreferredLangStateProvider = AudioPreferredLangStateProvider._();

final class AudioPreferredLangStateProvider
    extends $NotifierProvider<AudioPreferredLangState, String> {
  AudioPreferredLangStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioPreferredLangStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioPreferredLangStateHash();

  @$internal
  @override
  AudioPreferredLangState create() => AudioPreferredLangState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$audioPreferredLangStateHash() =>
    r'9d70ec2677efb51b8e0c174b55114865853f12ea';

abstract class _$AudioPreferredLangState extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(EnableAudioPitchCorrectionState)
final enableAudioPitchCorrectionStateProvider =
    EnableAudioPitchCorrectionStateProvider._();

final class EnableAudioPitchCorrectionStateProvider
    extends $NotifierProvider<EnableAudioPitchCorrectionState, bool> {
  EnableAudioPitchCorrectionStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'enableAudioPitchCorrectionStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$enableAudioPitchCorrectionStateHash();

  @$internal
  @override
  EnableAudioPitchCorrectionState create() => EnableAudioPitchCorrectionState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$enableAudioPitchCorrectionStateHash() =>
    r'6614f4b04ff8fe8ef57c9a6f160646d3d25e2f4d';

abstract class _$EnableAudioPitchCorrectionState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(AudioChannelState)
final audioChannelStateProvider = AudioChannelStateProvider._();

final class AudioChannelStateProvider
    extends $NotifierProvider<AudioChannelState, AudioChannel> {
  AudioChannelStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioChannelStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioChannelStateHash();

  @$internal
  @override
  AudioChannelState create() => AudioChannelState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AudioChannel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AudioChannel>(value),
    );
  }
}

String _$audioChannelStateHash() => r'e71ffa85c37d545fb7b22e9539241b4926a2d384';

abstract class _$AudioChannelState extends $Notifier<AudioChannel> {
  AudioChannel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AudioChannel, AudioChannel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AudioChannel, AudioChannel>,
              AudioChannel,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(VolumeBoostCapState)
final volumeBoostCapStateProvider = VolumeBoostCapStateProvider._();

final class VolumeBoostCapStateProvider
    extends $NotifierProvider<VolumeBoostCapState, int> {
  VolumeBoostCapStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'volumeBoostCapStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$volumeBoostCapStateHash();

  @$internal
  @override
  VolumeBoostCapState create() => VolumeBoostCapState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$volumeBoostCapStateHash() =>
    r'b0f5ad3bbb0e1a798ce229572b363465ad606a06';

abstract class _$VolumeBoostCapState extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
