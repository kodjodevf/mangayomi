import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/more/widgets/incognito_mode_widget.dart';
import 'package:mangayomi/modules/more/widgets/list_tile_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                height: 200,
                // child: Center(
                //     child: Image.asset(
                //   "assets/icon.png",
                //   color: Theme.of(context).brightness == Brightness.light
                //       ? Colors.black
                //       : Colors.white,
                // ))
                ),
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
              title: l10n!.download_queue,
            ),
            ListTileWidget(
              onTap: () {
                context.push('/categories', extra: (false, 0));
              },
              icon: Icons.label_outline_rounded,
              title: l10n.categories,
            ),
            const Divider(),
            // ListTileWidget(
            //   onTap: () {
            //     context.push('/history');
            //   },
            //   icon: Icons.history_outlined,
            //   title: l10n.history,
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
              title: l10n.settings,
            ),
            ListTileWidget(
                onTap: () {
                  context.push('/about');
                },
                icon: Icons.info_outline,
                title: l10n.about),
            ListTileWidget(
              onTap: () {},
              icon: Icons.help_outline,
              title: l10n.help,
            ),
          ],
        ),
      ),
    );
  }
}
