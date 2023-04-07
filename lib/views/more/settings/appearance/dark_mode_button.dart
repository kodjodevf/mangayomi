import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/views/more/settings/appearance/thememode_provider.dart';
import 'package:rive/rive.dart';

class DarkModeButton extends ConsumerStatefulWidget {
  const DarkModeButton({
    super.key,
  });

  @override
  ConsumerState<DarkModeButton> createState() => _DarkModeButtonState();
}

class _DarkModeButtonState extends ConsumerState<DarkModeButton> {
  SMIBool? _bump;

  void _onRiveInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    artboard.addController(controller!);
    _bump = controller.findInput<bool>('isDark') as SMIBool;
    _bump?.value = !ref.watch(themeModeProvider);
  }

  void _hitBump(bool value) => _bump?.value = value;

  @override
  Widget build(BuildContext context) {
    bool isLight = ref.watch(themeModeProvider);
    _hitBump(!isLight);
    return ListTile(
      onTap: () {
        if (!isLight == true) {
          ref.read(themeModeProvider.notifier).setLightTheme();
        } else {
          ref.read(themeModeProvider.notifier).setDarkTheme();
        }
      },
      title: const Text("Theme mode"),
      subtitle: Text(ref.watch(themeModeProvider) ? 'Light' : 'Dark'),
      trailing: SizedBox(
        height: 80,
        width: 80,
        child: RiveAnimation.asset(
          'assets/switch.riv',
          onInit: _onRiveInit,
        ),
      ),
    );
  }
}
