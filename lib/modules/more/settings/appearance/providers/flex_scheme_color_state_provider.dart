import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'flex_scheme_color_state_provider.g.dart';

/// Provides both the selected theme index and the resolved FlexSchemeColor.
///
/// Returns a tuple `(color, index)`:
/// - `color` -> the resolved FlexSchemeColor (light or dark variant),
///              depending on the current theme mode
/// - `index` -> the selected FlexSchemeColor index stored in Isar
@riverpod
class FlexSchemeColorState extends _$FlexSchemeColorState {
  @override
  (FlexSchemeColor color, int index) build() {
    final index = settingsRepository.current.flexSchemeColorIndex!;
    final color = ref.read(themeModeStateProvider)
        ? ThemeAA.schemes[index].dark
        : ThemeAA.schemes[index].light;
    return (color, index);
  }

  void setTheme(FlexSchemeColor color, int index) {
    state = (color, index);
    settingsRepository.update((s) => s.flexSchemeColorIndex = index);
  }
}

class ThemeAA {
  static const List<FlexSchemeData> schemes = <FlexSchemeData>[
    ...FlexColor.schemesList,
  ];
}
