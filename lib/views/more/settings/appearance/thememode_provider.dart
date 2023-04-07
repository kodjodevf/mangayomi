import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/providers/hive_provider.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeState, bool>((ref) {
  return ThemeModeState(ref);
});
final onPressedProvider = StateProvider<String>((ref) {
  return '';
});

class ThemeModeState extends StateNotifier<bool> {
  final Ref _ref;

  ThemeModeState(this._ref)
      : super(_ref.watch(hiveBoxSettings).get('isLight', defaultValue: true)!);

  void setLightTheme() {
    state = true;
    _ref.watch(hiveBoxSettings).put('isLight', state);
  }

  void setDarkTheme() {
    state = false;
    _ref.watch(hiveBoxSettings).put('isLight', state);
  }
}
