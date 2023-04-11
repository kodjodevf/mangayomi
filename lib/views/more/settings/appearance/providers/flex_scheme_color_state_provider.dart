import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/views/more/settings/appearance/providers/theme_mode_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'flex_scheme_color_state_provider.g.dart';

@riverpod
class FlexSchemeColorState extends _$FlexSchemeColorState {
  @override
  FlexSchemeColor build() {
    if (ref.read(themeModeStateProvider)) {
      if (ref.watch(hiveBoxSettings).get('FlexColorIndex') != null) {
        state = ThemeAA
            .schemes[ref.watch(hiveBoxSettings).get('FlexColorIndex')].light;
      }
    } else {
      if (ref.watch(hiveBoxSettings).get('FlexColorIndex') != null) {
        state = ThemeAA
            .schemes[ref.watch(hiveBoxSettings).get('FlexColorIndex')].dark;
      }
    }
    return FlexColor.deepBlue.light;
  }

  void setTheme(FlexSchemeColor color, int index) {
    state = color;
    ref.watch(hiveBoxSettings).put('FlexColorIndex', index);
  }
}

class ThemeAA {
  static const List<FlexSchemeData> schemes = <FlexSchemeData>[
    ...FlexColor.schemesList,
  ];
}
