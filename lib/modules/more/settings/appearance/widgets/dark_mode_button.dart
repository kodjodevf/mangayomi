import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';
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
    bool isDark = ref.watch(themeModeStateProvider);
    return SwitchListTile(
      onChanged: (value) {
        if (value) {
          ref.read(themeModeStateProvider.notifier).setDarkTheme();
        } else {
          ref.read(themeModeStateProvider.notifier).setLightTheme();
        }
      },
      title: const Text("Dark mode"),
      subtitle: Text(
        !isDark ? 'Off' : 'On',
        style: TextStyle(fontSize: 11, color: secondaryColor(context)),
      ),
      value: isDark,
    );
  }
}
