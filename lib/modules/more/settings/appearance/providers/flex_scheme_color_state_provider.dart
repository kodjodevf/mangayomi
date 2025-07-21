import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'flex_scheme_color_state_provider.g.dart';

@riverpod
class FlexSchemeColorState extends _$FlexSchemeColorState {
  @override
  FlexSchemeColor build() {
    final flexSchemeColorIndex = isar.settings
        .getSync(227)!
        .flexSchemeColorIndex!;
    return ref.read(themeModeStateProvider)
        ? ThemeAA.schemes[flexSchemeColorIndex].dark
        : ThemeAA.schemes[flexSchemeColorIndex].light;
  }

  void setTheme(FlexSchemeColor color, int index) {
    final settings = isar.settings.getSync(227);
    state = color;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..flexSchemeColorIndex = index
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

class ThemeAA {
  static const List<FlexSchemeData> schemes = <FlexSchemeData>[
    ...FlexColor.schemesList,
  ];
}
