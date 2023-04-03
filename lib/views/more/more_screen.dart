import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                const Divider(),
                ListTile(
                  dense: true,
                  onTap: () {},
                  leading:
                      const SizedBox(height: 40, child: Icon(Icons.cloud_off)),
                  subtitle: const Text('Filter all entries in your library'),
                  title: const Text('Donloaded only'),
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
                ListTile(
                  dense: true,
                  onTap: () {},
                  leading: const SizedBox(
                      height: 40, child: Icon(CupertinoIcons.eyeglasses)),
                  subtitle: const Text('pauses reading history'),
                  title: const Text('Incognito mode'),
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
                const Divider(),
                ListTile(
                  dense: true,
                  onTap: () {},
                  leading: const SizedBox(
                      height: 40, child: Icon(Icons.download_outlined)),
                  title: const Text('Donwload queue'),
                ),
                ListTile(
                  dense: true,
                  onTap: () {},
                  leading: Container(
                    height: 20,
                    width: 20,
                    color: Colors.grey,
                  ),
                  title: const Text('Categories'),
                ),
                ListTile(
                  dense: true,
                  onTap: () {},
                  leading: Container(
                    height: 20,
                    width: 20,
                    color: Colors.grey,
                  ),
                  title: const Text('Statistics'),
                ),
                ListTile(
                  dense: true,
                  onTap: () {},
                  leading: const SizedBox(
                      height: 40,
                      child: Icon(Icons.settings_backup_restore_sharp)),
                  title: const Text('Backup and restore'),
                ),
                const Divider(),
                ListTile(
                  dense: true,
                  onTap: () {},
                  leading: const SizedBox(
                      height: 40, child: Icon(Icons.settings_outlined)),
                  title: const Text('Backup and restore'),
                ),
                ListTile(
                  dense: true,
                  onTap: () {},
                  leading: const SizedBox(
                      height: 40, child: Icon(Icons.info_outline)),
                  title: const Text('About'),
                ),
                ListTile(
                  dense: true,
                  onTap: () {},
                  leading: const SizedBox(
                      height: 40, child: Icon(Icons.help_outline)),
                  title: const Text('Help'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
