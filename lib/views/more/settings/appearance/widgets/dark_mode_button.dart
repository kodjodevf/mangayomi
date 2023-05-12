import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/views/more/settings/appearance/providers/flex_scheme_color_state_provider.dart';
import 'package:mangayomi/views/more/settings/appearance/providers/theme_mode_state_provider.dart';
// import 'package:rive/rive.dart';

class DarkModeButton extends ConsumerStatefulWidget {
  const DarkModeButton({
    super.key,
  });

  @override
  ConsumerState<DarkModeButton> createState() => _DarkModeButtonState();
}

class _DarkModeButtonState extends ConsumerState<DarkModeButton> {
  @override
  Widget build(BuildContext context) {
    bool isLight = ref.watch(themeModeStateProvider);

    return ListTile(
        onTap: () {
          int flexColorIndex = ref
              .watch(hiveBoxSettingsProvider)
              .get('FlexColorIndex', defaultValue: 7);
          if (!isLight == true) {
            ref.read(themeModeStateProvider.notifier).setLightTheme();
          } else {
            ref.read(themeModeStateProvider.notifier).setDarkTheme();
          }

          !isLight
              ? ref.read(flexSchemeColorStateProvider.notifier).setTheme(
                  ThemeAA.schemes[flexColorIndex].light, flexColorIndex)
              : ref.read(flexSchemeColorStateProvider.notifier).setTheme(
                  ThemeAA.schemes[flexColorIndex].dark, flexColorIndex);
        },
        title: const Text("Dark mode"),
        subtitle: Text(
          ref.watch(themeModeStateProvider) ? 'Off' : 'On',
          style: TextStyle(fontSize: 11, color: secondaryColor(context)),
        ),
        trailing: Switch(
            value: !isLight,
            onChanged: (dd) {
              if (!isLight == true) {
                ref.read(themeModeStateProvider.notifier).setLightTheme();
              } else {
                ref.read(themeModeStateProvider.notifier).setDarkTheme();
              }
            }));
  }
}
