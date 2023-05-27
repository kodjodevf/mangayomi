import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/more/widgets/incognito_mode_widget.dart';
import 'package:mangayomi/modules/more/widgets/list_tile_widget.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                height: 200,
                child: Center(
                    child: Image.asset(
                  "assets/icon.png",
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ))),
            const Divider(),
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
            const Divider(),
            ListTileWidget(
              onTap: () {
                context.push('/downloadQueue');
              },
              icon: Icons.download_outlined,
              title: 'Donwload queue',
            ),
            ListTileWidget(
              onTap: () {
                context.push('/categories');
              },
              icon: Icons.label_outline_rounded,
              title: 'Categories',
            ),
            const Divider(),
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
    );
  }
}
