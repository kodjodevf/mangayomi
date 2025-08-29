import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_audio_state_provider.g.dart';

@riverpod
class AudioPreferredLangState extends _$AudioPreferredLangState {
  @override
  String build() {
    return isar.settings.getSync(227)!.audioPreferredLanguages ?? "";
  }

  void set(String value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..audioPreferredLanguages = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class EnableAudioPitchCorrectionState
    extends _$EnableAudioPitchCorrectionState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.enableAudioPitchCorrection ?? true;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..enableAudioPitchCorrection = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class AudioChannelState extends _$AudioChannelState {
  @override
  AudioChannel build() {
    return isar.settings.getSync(227)!.audioChannels;
  }

  void set(AudioChannel value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..audioChannels = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class VolumeBoostCapState extends _$VolumeBoostCapState {
  @override
  int build() {
    return isar.settings.getSync(227)!.volumeBoostCap ?? 30;
  }

  void set(int value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..volumeBoostCap = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
