import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/downloads/providers/downloads_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class DownloadsScreen extends ConsumerStatefulWidget {
  const DownloadsScreen({super.key});

  @override
  ConsumerState<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends ConsumerState<DownloadsScreen> {
  @override
  Widget build(
    BuildContext context,
  ) {
    final saveAsCBZArchiveState = ref.watch(saveAsCBZArchiveStateProvider);
    final onlyOnWifiState = ref.watch(onlyOnWifiStateProvider);
    final l10n = l10nLocalizations(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n!.downloads),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SwitchListTile(
                value: onlyOnWifiState,
                title: Text(l10n.only_on_wifi),
                onChanged: (value) {
                  ref.read(onlyOnWifiStateProvider.notifier).set(value);
                }),
            SwitchListTile(
                value: saveAsCBZArchiveState,
                title: Text(l10n.save_as_cbz_archive),
                onChanged: (value) {
                  ref.read(saveAsCBZArchiveStateProvider.notifier).set(value);
                }),
          ],
        ),
      ),
    );
  }
}
