import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/more/widgets/list_tile_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n!.settings)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTileWidget(
              title: l10n.general,
              icon: Icons.settings,
              onTap: () => context.push('/general'),
            ),
            ListTileWidget(
              title: l10n.appearance,
              subtitle: l10n.appearance_subtitle,
              icon: Icons.color_lens_rounded,
              onTap: () => context.push('/appearance'),
            ),
            ListTileWidget(
              title: l10n.reader,
              subtitle: l10n.reader_subtitle,
              icon: Icons.chrome_reader_mode_rounded,
              onTap: () => context.push('/readerMode'),
            ),
            ListTileWidget(
              title: l10n.player,
              subtitle: l10n.reader_subtitle,
              icon: Icons.play_circle_outline_outlined,
              onTap: () => context.push('/playerMode'),
            ),
            ListTileWidget(
              title: l10n.downloads,
              subtitle: l10n.downloads_subtitle,
              icon: Icons.download_outlined,
              onTap: () => context.push('/downloads'),
            ),
            ListTileWidget(
              title: l10n.tracking,
              subtitle: "",
              icon: Icons.sync_outlined,
              onTap: () => context.push('/track'),
            ),
            ListTileWidget(
              title: l10n.syncing,
              subtitle: l10n.syncing_subtitle,
              icon: Icons.cloud_sync_outlined,
              onTap: () => context.push('/sync'),
            ),
            ListTileWidget(
              title: l10n.browse,
              subtitle: l10n.browse_subtitle,
              icon: Icons.explore_rounded,
              onTap: () => context.push('/browseS'),
            ),
            ListTileWidget(
              onTap: () {
                context.push('/about');
              },
              icon: Icons.info_outline,
              title: l10n.about,
            ),
          ],
        ),
      ),
    );
  }
}
