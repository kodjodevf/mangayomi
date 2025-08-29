import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/about/providers/check_for_update.dart';
import 'package:mangayomi/modules/more/about/providers/get_package_info.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context);
    final checkForUpdates = ref.watch(checkForAppUpdatesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n!.about)),
      body: ref
          .watch(getPackageInfoProvider)
          .when(
            data: (data) => SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Image.asset(
                      "assets/app_icons/icon.png",
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                      fit: BoxFit.cover,
                      height: 100,
                    ),
                  ),
                  Column(
                    children: [
                      const Divider(color: Colors.grey),
                      ListTile(
                        onTap: () {},
                        title: const Text('Version'),
                        subtitle: Text(
                          'Beta (${data.version})',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      SwitchListTile(
                        title: Text(l10n.check_for_app_updates),
                        value: checkForUpdates,
                        onChanged: (value) {
                          isar.writeTxnSync(() {
                            final settings = isar.settings.getSync(227);
                            isar.settings.putSync(
                              settings!
                                ..checkForAppUpdates = value
                                ..updatedAt =
                                    DateTime.now().millisecondsSinceEpoch,
                            );
                          });
                          ref.invalidate(checkForAppUpdatesProvider);
                        },
                      ),
                      ListTile(
                        onTap: () {
                          ref.read(
                            checkForUpdateProvider(
                              context: context,
                              manualUpdate: true,
                            ),
                          );
                        },
                        title: Text(l10n.check_for_update),
                      ),
                      ListTile(
                        onTap: () async {
                          final storage = StorageProvider();
                          final directory = await storage.getDefaultDirectory();
                          final file = File(
                            path.join(directory!.path, 'logs.txt'),
                          );
                          if (await file.exists()) {
                            if (Platform.isLinux) {
                              await Clipboard.setData(
                                ClipboardData(text: file.path),
                              );
                            }
                            if (context.mounted) {
                              final box =
                                  context.findRenderObject() as RenderBox?;
                              Share.shareXFiles(
                                [XFile(file.path)],
                                text: "log.txt",
                                sharePositionOrigin:
                                    box!.localToGlobal(Offset.zero) & box.size,
                              );
                            }
                          } else {
                            botToast(l10n.no_app_logs);
                          }
                        },
                        title: Text(l10n.share_app_logs),
                      ),
                      // ListTile(
                      //   onTap: () {},
                      //   title: const Text("What's news"),
                      // ),
                      // ListTile(
                      //   onTap: () {},
                      //   title: const Text('Help translation'),
                      // ),
                      // ListTile(
                      //   onTap: () {},
                      //   title: const Text('Privacy policy'),
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              _launchInBrowser(
                                Uri.parse(
                                  'https://github.com/kodjodevf/mangayomi',
                                ),
                              );
                            },
                            icon: const Padding(
                              padding: EdgeInsets.only(left: 2.5, right: 2.5),
                              child: Icon(FontAwesomeIcons.github),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _launchInBrowser(
                                Uri.parse(
                                  'https://discord.com/invite/EjfBuYahsP',
                                ),
                              );
                            },
                            icon: const Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Icon(FontAwesomeIcons.discord),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            error: (error, stackTrace) => ErrorWidget(error),
            loading: () => const ProgressCenter(),
          ),
    );
  }
}

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}
