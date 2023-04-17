import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/views/more/widgets/incognito_mode_widget.dart';
import 'package:mangayomi/views/more/widgets/list_tile_widget.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 150, child: Center(child: Text("LOGO"))),
          Flexible(
            flex: 3,
            child: Column(
              children: [
                const Divider(
                  color: Colors.grey,
                ),
                // ListTile(
                //   onTap: () {},
                //   leading:
                //       const SizedBox(height: 40, child: Icon(Icons.cloud_off)),
                //   subtitle: const Text('Filter all entries in your library'),
                //   title: const Text('Donloaded only'),
                //   trailing: Switch(
                //     value: false,
                //     onChanged: (value) {},
                //   ),
                // ),
                const IncognitoModeWidget(),
                const Divider(
                  color: Colors.grey,
                ),
                ListTileWidget(
                  onTap: () {
                    context.push('/settings');
                  },
                  icon: Icons.download_outlined,
                  title: 'Donwload queue',
                ),

                // ListTile(
                //   onTap: () {},
                //   leading: Container(
                //     height: 20,
                //     width: 20,
                //     color: Colors.grey,
                //   ),
                //   title: const Text('Categories'),
                // ),
                // ListTile(
                //   onTap: () {},
                //   leading: Container(
                //     height: 20,
                //     width: 20,
                //     color: Colors.grey,
                //   ),
                //   title: const Text('Statistics'),
                // ),
                // ListTile(
                //   onTap: () {},
                //   leading: const SizedBox(
                //       height: 40,
                //       child: Icon(Icons.settings_backup_restore_sharp)),
                //   title: const Text('Backup and restore'),
                // ),
                // const Divider(
                //   color: Colors.grey,
                // ),
                ListTileWidget(
                  onTap: () {
                    context.push('/settings');
                  },
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                ),
                ListTileWidget(
                  onTap: () {
                    context.push('/about');
                  },
                  icon: Icons.info_outline,
                  title: 'About',
                ),
                ListTileWidget(
                  onTap: () {},
                  icon: Icons.help_outline,
                  title: 'Help',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
