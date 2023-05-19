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
    bool isLight = ref.watch(themeModeStateProvider);
    return SwitchListTile(
      onChanged: (value) {
        if (value) {
          ref.read(themeModeStateProvider.notifier).setLightTheme();
        } else {
          ref.read(themeModeStateProvider.notifier).setDarkTheme();
        }
      },
      title: const Text(
        "Dark mode",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        isLight ? 'Off' : 'On',
        style: TextStyle(fontSize: 11, color: secondaryColor(context)),
      ),
      value: isLight,
    );
  }
}
