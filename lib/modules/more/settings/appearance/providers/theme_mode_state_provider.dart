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
      ref.read(themeModeStateProvider.notifier).setLightTheme();
    } else {
      ref.read(themeModeStateProvider.notifier).setDarkTheme();
    }
  }

  void setLightTheme() {
    final settings = isar.settings.getSync(227);
    state = false;
    ref
        .read(flexSchemeColorStateProvider.notifier)
        .setTheme(
          ThemeAA.schemes[settings!.flexSchemeColorIndex!].light,
          settings.flexSchemeColorIndex!,
        );
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings
          ..themeIsDark = state
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  void setDarkTheme() {
    final settings = isar.settings.getSync(227);
    state = true;
    ref
        .read(flexSchemeColorStateProvider.notifier)
        .setTheme(
          ThemeAA.schemes[settings!.flexSchemeColorIndex!].dark,
          settings.flexSchemeColorIndex!,
        );
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings
          ..themeIsDark = state
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
