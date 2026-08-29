import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'state_provider.g.dart';

@riverpod
class SubtitleSettingsState extends _$SubtitleSettingsState {
  @override
  PlayerSubtitleSettings build() {
    final subSets = settingsRepository.current.playerSubtitleSettings;
    if (subSets == null || subSets.backgroundColorA == null) {
      set(PlayerSubtitleSettings(), true);
      return PlayerSubtitleSettings();
    }
    return subSets;
  }

  void set(PlayerSubtitleSettings value, bool end) {
    state = value;
    if (end) {
      settingsRepository.update((s) => s.playerSubtitleSettings = value);
    }
  }

  void resetColor() {
    state = PlayerSubtitleSettings(
      fontSize: state.fontSize,
      useBold: state.useBold,
      useItalic: state.useItalic,
    );
    settingsRepository.update((s) => s.playerSubtitleSettings = state);
  }
}
