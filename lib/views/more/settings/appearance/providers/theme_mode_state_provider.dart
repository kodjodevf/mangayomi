import 'package:mangayomi/providers/hive_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'theme_mode_state_provider.g.dart';


@riverpod
class ThemeModeState extends _$ThemeModeState {
  @override
  bool build() {
    return ref.watch(hiveBoxSettingsProvider).get('isLight', defaultValue: true)!;
  }

  void setLightTheme() {
    state = true;
    ref.watch(hiveBoxSettingsProvider).put('isLight', state);
  }

  void setDarkTheme() {
    state = false;
    ref.watch(hiveBoxSettingsProvider).put('isLight', state);
  }
}
