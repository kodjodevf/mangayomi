import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/views/more/settings/appearance/thememode_provider.dart';

final flexSchemeColorProvider =
    StateNotifierProvider<ThemeColorState, FlexSchemeColor>((ref) {
  return ThemeColorState(ref);
});

class ThemeColorState extends StateNotifier<FlexSchemeColor> {
  final Ref _ref;
  ThemeColorState(this._ref) : super(FlexColor.deepBlue.light) {
    if (_ref.watch(themeModeProvider)) {
      if (_ref.watch(hiveBoxSettings).get('FlexColorIndex') != null) {
        state = ThemeAA
            .schemes[_ref.watch(hiveBoxSettings).get('FlexColorIndex')].light;
      }
    } else {
      if (_ref.watch(hiveBoxSettings).get('FlexColorIndex') != null) {
        state = ThemeAA
            .schemes[_ref.watch(hiveBoxSettings).get('FlexColorIndex')].dark;
      }
    }
  }
  void setTheme(FlexSchemeColor color, int index) {
    state = color;
    _ref.watch(hiveBoxSettings).put('FlexColorIndex', index);
  }
}

class ThemeAA {
  static const List<FlexSchemeData> schemes = <FlexSchemeData>[
    ...FlexColor.schemesList,
  ];
}
