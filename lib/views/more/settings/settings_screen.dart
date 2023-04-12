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
      ),
      body: Column(
        children: [
          ListTileWidget(
              title: 'General', icon: Icons.tune_rounded, onTap: () {}),
          ListTileWidget(
              title: 'Appearance',
              icon: Icons.color_lens_rounded,
              onTap: () => context.push('/appearance')),
          ListTileWidget(
              title: 'Library',
              icon: Icons.collections_bookmark_rounded,
              onTap: () {}),
          ListTileWidget(
              title: 'Reader',
              icon: Icons.chrome_reader_mode_rounded,
              onTap: () {}),
          ListTileWidget(
              title: 'Explore', icon: Icons.explore_rounded, onTap: () {}),
          ListTileWidget(
            onTap: () {
              context.push('/about');
            },
            icon: Icons.info_outline,
            title: 'About',
          ),
        ],
      ),
    );
  }
}
