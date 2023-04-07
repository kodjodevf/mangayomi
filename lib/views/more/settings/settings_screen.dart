import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        actions: [],
      ),
      body: Column(
        children: [
          ListTile(
              title: Text("Appearance"),
              leading: const Icon(Icons.color_lens_rounded),
              onTap: () => context.push('/appearance')),
        ],
      ),
    );
  }
}
