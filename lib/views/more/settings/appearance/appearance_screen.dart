import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/views/more/settings/appearance/dark_mode_button.dart';
import 'package:mangayomi/views/more/settings/appearance/theme_selector.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appearance"),
      ),
      body: Column(
        children: const [DarkModeButton(), ThemeSelector()],
      ),
    );
  }
}
