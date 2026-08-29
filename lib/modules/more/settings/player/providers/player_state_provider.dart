import 'dart:ui';

import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'player_state_provider.g.dart';

@riverpod
class DefaultSubtitleLangState extends _$DefaultSubtitleLangState {
  @override
  Locale build() {
    return Locale(
      _getLocale()!.languageCode ?? "en",
      _getLocale()!.countryCode ?? "",
    );
  }

  L10nLocale? _getLocale() {
    return settingsRepository.current.defaultSubtitleLang ??
        L10nLocale(languageCode: "en", countryCode: "");
  }

  void setLocale(Locale locale) async {
    settingsRepository.update(
      (s) => s.defaultSubtitleLang = L10nLocale(
        languageCode: locale.languageCode,
        countryCode: locale.countryCode,
      ),
    );
    state = locale;
  }
}

@riverpod
class MarkEpisodeAsSeenTypeState extends _$MarkEpisodeAsSeenTypeState {
  @override
  int build() {
    return settingsRepository.current.markEpisodeAsSeenType ?? 75;
  }

  void set(int value) {
    state = value;
    settingsRepository.update((s) => s.markEpisodeAsSeenType = value);
  }
}

@riverpod
class DefaultSkipIntroLengthState extends _$DefaultSkipIntroLengthState {
  @override
  int build() {
    return settingsRepository.current.defaultSkipIntroLength ?? 85;
  }

  void set(int value) {
    state = value;
    settingsRepository.update((s) => s.defaultSkipIntroLength = value);
  }
}

@riverpod
class DefaultDoubleTapToSkipLengthState
    extends _$DefaultDoubleTapToSkipLengthState {
  @override
  int build() {
    return settingsRepository.current.defaultDoubleTapToSkipLength ?? 10;
  }

  void set(int value) {
    state = value;
    settingsRepository.update((s) => s.defaultDoubleTapToSkipLength = value);
  }
}

@riverpod
class DefaultPlayBackSpeedState extends _$DefaultPlayBackSpeedState {
  @override
  double build() {
    return settingsRepository.current.defaultPlayBackSpeed ?? 1.0;
  }

  void set(double value) {
    state = value;
    settingsRepository.update((s) => s.defaultPlayBackSpeed = value);
  }
}

@riverpod
class FullScreenPlayerState extends _$FullScreenPlayerState {
  @override
  bool build() {
    return settingsRepository.current.fullScreenPlayer ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.fullScreenPlayer = value);
  }
}

@riverpod
class EnableAniSkipState extends _$EnableAniSkipState {
  @override
  bool build() {
    return settingsRepository.current.enableAniSkip ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.enableAniSkip = value);
  }
}

@riverpod
class EnableAutoSkipState extends _$EnableAutoSkipState {
  @override
  bool build() {
    return settingsRepository.current.enableAutoSkip ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.enableAutoSkip = value);
  }
}

@riverpod
class AniSkipTimeoutLengthState extends _$AniSkipTimeoutLengthState {
  @override
  int build() {
    return settingsRepository.current.aniSkipTimeoutLength ?? 5;
  }

  void set(int value) {
    state = value;
    settingsRepository.update((s) => s.aniSkipTimeoutLength = value);
  }
}

@riverpod
class UseLibassState extends _$UseLibassState {
  @override
  bool build() {
    return settingsRepository.current.useLibass ?? true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.useLibass = value);
  }
}

@riverpod
class UseMpvConfigState extends _$UseMpvConfigState {
  @override
  bool build() {
    return settingsRepository.current.useMpvConfig ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.useMpvConfig = value);
  }
}

@riverpod
class ForceLandscapePlayerState extends _$ForceLandscapePlayerState {
  @override
  bool build() {
    return settingsRepository.current.forceLandscapePlayer ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.forceLandscapePlayer = value);
  }
}
