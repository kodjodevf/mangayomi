import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/widgets/downloaded_only_widget.dart';
import 'package:mangayomi/modules/more/widgets/incognito_mode_widget.dart';
import 'package:mangayomi/modules/more/widgets/list_tile_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class MoreScreen extends ConsumerStatefulWidget {
  const MoreScreen({super.key});

  @override
  ConsumerState<MoreScreen> createState() => MoreScreenState();
}

class MoreScreenState extends ConsumerState<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context);
    final hiddenItems = ref.watch(hideItemsStateProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: AppBar().preferredSize.height),
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
            const Divider(),
            // ListTile(
            //   onTap: () {},
            //   leading: const SizedBox(height: 40, child: Icon(Icons.cloud_off)),
            //   subtitle: const Text('Filter all entries in your library'),
            //   title: const Text('Donloaded only'),
            //   trailing: Switch(
            //     value: false,
            //     onChanged: (value) {},
            //   ),
            // ),
            const DownloadedOnlyWidget(),
            const IncognitoModeWidget(),
            const Divider(),
            if (hiddenItems.contains("/history"))
              ListTileWidget(
                onTap: () {
                  context.push('/history');
                },
                icon: Icons.history,
                title: l10n!.history,
              ),
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
            ListTileWidget(
              onTap: () {
                context.push('/statistics');
              },
              icon: Icons.query_stats_outlined,
              title: l10n.statistics,
            ),
            ListTileWidget(
              onTap: () {
                context.push('/calendarScreen');
              },
              icon: Icons.calendar_month_outlined,
              title: l10n.calendar,
            ),
            ListTileWidget(
              onTap: () {
                context.push('/dataAndStorage');
              },
              icon: Icons.storage,
              title: l10n.data_and_storage,
            ),
            const Divider(),
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
              title: l10n.about,
            ),
            // ListTileWidget(
            //   onTap: () {},
            //   icon: Icons.help_outline,
            //   title: l10n.help,
            // ),
          ],
        ),
      ),
    );
  }
}
