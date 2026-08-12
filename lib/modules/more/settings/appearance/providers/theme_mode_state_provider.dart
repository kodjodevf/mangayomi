import 'package:flutter/widgets.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/flex_scheme_color_state_provider.dart';
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
    final settings = isar.settings.getSync(227);

    state = isDark;

    final schemeIndex = settings!.flexSchemeColorIndex!;
    final scheme = ThemeAA.schemes[schemeIndex];

    ref
        .read(flexSchemeColorStateProvider.notifier)
        .setTheme(isDark ? scheme.dark : scheme.light, schemeIndex);

    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings
          ..themeIsDark = isDark
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class FollowSystemThemeState extends _$FollowSystemThemeState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.followSystemTheme ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    if (value) {
      if (WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.light) {
        ref.read(themeModeStateProvider.notifier).setLightTheme();
      } else {
        ref.read(themeModeStateProvider.notifier).setDarkTheme();
      }
    }
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..followSystemTheme = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
