import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/views/more/widgets/list_tile_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        actions: [],
      ),
      body: Column(
        children: [
          ListTileWidget(
              title: 'Appearance',
              icon: Icons.color_lens_rounded,
              onTap: () => context.push('/appearance')),
        ],
      ),
    );
  }
}
