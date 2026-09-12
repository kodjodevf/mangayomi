import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'state_provider.g.dart';

@riverpod
class SubtitleSettingsState extends _$SubtitleSettingsState {
  @override
  PlayerSubtitleSettings build() {
    final s = settingsRepository.current.playerSubtitleSettings;
    bool isValidColor(int? v) => v != null && v >= 0 && v <= 255;
    if (s == null ||
        s.fontSize == null ||
        (s.fontSize ?? 0) <= 0 ||
        s.useBold == null ||
        s.useItalic == null ||
        !isValidColor(s.textColorA) ||
        !isValidColor(s.textColorR) ||
        !isValidColor(s.textColorG) ||
        !isValidColor(s.textColorB) ||
        !isValidColor(s.borderColorA) ||
        !isValidColor(s.borderColorR) ||
        !isValidColor(s.borderColorG) ||
        !isValidColor(s.borderColorB) ||
        !isValidColor(s.backgroundColorA) ||
        !isValidColor(s.backgroundColorR) ||
        !isValidColor(s.backgroundColorG) ||
        !isValidColor(s.backgroundColorB) ||
        s.overrideAssSubtitles == null) {
      final sanitized = PlayerSubtitleSettings(
        fontSize: (s?.fontSize != null && (s!.fontSize! > 0 && s.fontSize! < 200)) ? s.fontSize! : 45,
        useBold: s?.useBold ?? true,
        useItalic: s?.useItalic ?? false,
        textColorA: isValidColor(s?.textColorA) ? s!.textColorA! : 255,
        textColorR: isValidColor(s?.textColorR) ? s!.textColorR! : 255,
        textColorG: isValidColor(s?.textColorG) ? s!.textColorG! : 255,
        textColorB: isValidColor(s?.textColorB) ? s!.textColorB! : 255,
        borderColorA: isValidColor(s?.borderColorA) ? s!.borderColorA! : 255,
        borderColorR: isValidColor(s?.borderColorR) ? s!.borderColorR! : 0,
        borderColorG: isValidColor(s?.borderColorG) ? s!.borderColorG! : 0,
        borderColorB: isValidColor(s?.borderColorB) ? s!.borderColorB! : 0,
        backgroundColorA: isValidColor(s?.backgroundColorA) ? s!.backgroundColorA! : 0,
        backgroundColorR: isValidColor(s?.backgroundColorR) ? s!.backgroundColorR! : 0,
        backgroundColorG: isValidColor(s?.backgroundColorG) ? s!.backgroundColorG! : 0,
        backgroundColorB: isValidColor(s?.backgroundColorB) ? s!.backgroundColorB! : 0,
        overrideAssSubtitles: s?.overrideAssSubtitles ?? false,
      );
      set(sanitized, true);
      return sanitized;
    }
    return s;
  }

  void set(PlayerSubtitleSettings value, bool end) {
    int clampColor(int? v, int def) => (v ?? def).clamp(0, 255);
    state = PlayerSubtitleSettings(
      fontSize: (value.fontSize ?? 45).clamp(5, 150),
      useBold: value.useBold ?? true,
      useItalic: value.useItalic ?? false,
      textColorA: clampColor(value.textColorA, 255),
      textColorR: clampColor(value.textColorR, 255),
      textColorG: clampColor(value.textColorG, 255),
      textColorB: clampColor(value.textColorB, 255),
      borderColorA: clampColor(value.borderColorA, 255),
      borderColorR: clampColor(value.borderColorR, 0),
      borderColorG: clampColor(value.borderColorG, 0),
      borderColorB: clampColor(value.borderColorB, 0),
      backgroundColorA: clampColor(value.backgroundColorA, 0),
      backgroundColorR: clampColor(value.backgroundColorR, 0),
      backgroundColorG: clampColor(value.backgroundColorG, 0),
      backgroundColorB: clampColor(value.backgroundColorB, 0),
      overrideAssSubtitles: value.overrideAssSubtitles ?? false,
    );
    if (end) {
      settingsRepository.update((s) => s.playerSubtitleSettings = state);
    }
  }

  void resetColor() {
    state = PlayerSubtitleSettings(
      fontSize: (state.fontSize ?? 45).clamp(5, 150),
      useBold: state.useBold ?? true,
      useItalic: state.useItalic ?? false,
      textColorA: 255,
      textColorR: 255,
      textColorG: 255,
      textColorB: 255,
      borderColorA: 255,
      borderColorR: 0,
      borderColorG: 0,
      borderColorB: 0,
      backgroundColorA: 0,
      backgroundColorR: 0,
      backgroundColorG: 0,
      backgroundColorB: 0,
      overrideAssSubtitles: state.overrideAssSubtitles ?? false,
    );
    settingsRepository.update((s) => s.playerSubtitleSettings = state);
  }

  void reset() {
    state = PlayerSubtitleSettings(
      fontSize: 45,
      useBold: true,
      useItalic: false,
      textColorA: 255,
      textColorR: 255,
      textColorG: 255,
      textColorB: 255,
      borderColorA: 255,
      borderColorR: 0,
      borderColorG: 0,
      borderColorB: 0,
      backgroundColorA: 0,
      backgroundColorR: 0,
      backgroundColorG: 0,
      backgroundColorB: 0,
      overrideAssSubtitles: state.overrideAssSubtitles ?? false,
    );
    settingsRepository.update((s) => s.playerSubtitleSettings = state);
  }

  void setOverrideAss(bool value) {
    set(state..overrideAssSubtitles = value, true);
  }
}

final overrideAssSubtitlesStateProvider = Provider<bool>((ref) {
  return ref.watch(subtitleSettingsStateProvider).overrideAssSubtitles ?? false;
});

