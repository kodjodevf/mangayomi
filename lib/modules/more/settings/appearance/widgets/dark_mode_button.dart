import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';

// import 'package:rive/rive.dart';

class DarkModeButton extends ConsumerStatefulWidget {
  const DarkModeButton({super.key});

  @override
  ConsumerState<DarkModeButton> createState() => _DarkModeButtonState();
}

class _DarkModeButtonState extends ConsumerState<DarkModeButton> {
  @override
  Widget build(BuildContext context) {
    bool isDark = ref.watch(themeModeStateProvider);
    final l10n = l10nLocalizations(context);
    return ShioriSwitchRow(
      title: l10n!.dark_mode,
      value: isDark,
      onChanged: (value) => value
          ? ref.read(themeModeStateProvider.notifier).setDarkTheme()
          : ref.read(themeModeStateProvider.notifier).setLightTheme(),
    );
  }
}
