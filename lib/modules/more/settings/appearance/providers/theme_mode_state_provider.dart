import 'package:flutter/widgets.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/flex_scheme_color_state_provider.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'theme_mode_state_provider.g.dart';

@riverpod
class ThemeModeState extends _$ThemeModeState {
  @override
  bool build() {
    return settingsRepository.current.themeIsDark!;
  }

  void setTheme(Brightness brightness) {
    if (brightness == Brightness.light) {
      setLightTheme();
    } else {
      setDarkTheme();
    }
  }

  void setLightTheme() => _applyTheme(false);
  void setDarkTheme() => _applyTheme(true);

  void _applyTheme(bool isDark) {
    state = isDark;

    final schemeIndex = ref.read(flexSchemeColorStateProvider).$2;
    final scheme = ThemeAA.schemes[schemeIndex];

    ref
        .read(flexSchemeColorStateProvider.notifier)
        .setTheme(isDark ? scheme.dark : scheme.light, schemeIndex);

    // After setTheme, which writes the same row.
    settingsRepository.update((s) => s.themeIsDark = isDark);
  }
}

@riverpod
class FollowSystemThemeState extends _$FollowSystemThemeState {
  @override
  bool build() {
    return settingsRepository.current.followSystemTheme ?? false;
  }

  void set(bool value) {
    state = value;
    if (value) {
      if (WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.light) {
        ref.read(themeModeStateProvider.notifier).setLightTheme();
      } else {
        ref.read(themeModeStateProvider.notifier).setDarkTheme();
      }
    }
    // After the theme setters above, which write the same row. Reading it
    // before them and writing it here put their themeIsDark back to what it
    // was, so turning this on under a light system came back dark on the next
    // launch.
    settingsRepository.update((s) => s.followSystemTheme = value);
  }
}
