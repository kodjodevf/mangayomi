import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/widgets/downloaded_only_widget.dart';
import 'package:mangayomi/modules/more/widgets/incognito_mode_widget.dart';
import 'package:mangayomi/modules/more/widgets/list_tile_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/models/manga.dart';

class MoreScreen extends ConsumerStatefulWidget {
  const MoreScreen({super.key});

  @override
  ConsumerState<MoreScreen> createState() => MoreScreenState();
}

class MoreScreenState extends ConsumerState<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final hiddenItems = ref.watch(hideItemsStateProvider);
    return Scaffold(
      body: SingleChildScrollView(
        padding: tvPageInsets,
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
                title: l10n.history,
              ),
            // Downloads are hidden on TV: no offline use case, and the download
            // buttons are hidden there too, so a queue entry would just dangle.
            if (!isTv)
              ListTileWidget(
                onTap: () {
                  context.push('/downloadQueue');
                },
                icon: Icons.download_outlined,
                title: l10n.download_queue,
              ),
            // Mass migration is otherwise only reachable from a manga's
            // overflow menu, which the TV detail view does not have. It is a
            // library-wide tool anyway: it lists every source in the library,
            // and only uses a manga to float that source to the top. Seeded
            // with anime because the TV build is anime-first; the per-source
            // shortcut on the TV detail view covers the other libraries.
            // Mass migration is otherwise only reachable from a manga's overflow
            // menu, which the TV anime detail lacks. It is a library-wide tool
            // (lists every source in the library), seeded with anime here since
            // the TV build is anime-first; the TV detail's per-source shortcut
            // covers the other libraries.
            if (isTv)
              ListTileWidget(
                onTap: () => context.push(
                  '/massMigration',
                  extra: (ItemType.anime, null),
                ),
                icon: Icons.swap_horiz,
                title: l10n.mass_migration_title,
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
