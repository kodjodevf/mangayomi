import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_audio_state_provider.g.dart';

@riverpod
class AudioPreferredLangState extends _$AudioPreferredLangState {
  @override
  String build() {
    return settingsRepository.current.audioPreferredLanguages ?? "";
  }

  void set(String value) {
    state = value;
    settingsRepository.update((s) => s.audioPreferredLanguages = value);
  }
}

@riverpod
class EnableAudioPitchCorrectionState
    extends _$EnableAudioPitchCorrectionState {
  @override
  bool build() {
    return settingsRepository.current.enableAudioPitchCorrection ?? true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.enableAudioPitchCorrection = value);
  }
}

@riverpod
class AudioChannelState extends _$AudioChannelState {
  @override
  AudioChannel build() {
    return settingsRepository.current.audioChannels;
  }

  void set(AudioChannel value) {
    state = value;
    settingsRepository.update((s) => s.audioChannels = value);
  }
}

@riverpod
class VolumeBoostCapState extends _$VolumeBoostCapState {
  @override
  int build() {
    return settingsRepository.current.volumeBoostCap ?? 30;
  }

  void set(int value) {
    state = value;
    settingsRepository.update((s) => s.volumeBoostCap = value);
  }
}
