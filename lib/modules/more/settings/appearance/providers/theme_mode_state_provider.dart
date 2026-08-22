import 'package:flutter/widgets.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/flex_scheme_color_state_provider.dart';
import 'package:mangayomi/utils/settings_write.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'theme_mode_state_provider.g.dart';

@riverpod
class ThemeModeState extends _$ThemeModeState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.themeIsDark!;
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
    updateSettings((settings) => settings.themeIsDark = isDark);
  }
}

@riverpod
class FollowSystemThemeState extends _$FollowSystemThemeState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.followSystemTheme ?? false;
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
    updateSettings((settings) => settings.followSystemTheme = value);
  }
}
