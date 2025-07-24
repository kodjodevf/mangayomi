import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/modules/more/settings/general/providers/general_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class GeneralScreen extends ConsumerWidget {
  const GeneralScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context);
    final enableDiscordRpc = ref.watch(enableDiscordRpcStateProvider);
    final hideDiscordRpcInIncognito = ref.watch(
      hideDiscordRpcInIncognitoStateProvider,
    );
    final rpcShowReadingWatchingProgress = ref.watch(
      rpcShowReadingWatchingProgressStateProvider,
    );
    final rpcShowTitleState = ref.watch(rpcShowTitleStateProvider);
    final rpcShowCoverImage = ref.watch(rpcShowCoverImageStateProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n!.general)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SwitchListTile(
              value: enableDiscordRpc,
              title: Text(l10n.enable_discord_rpc),
              onChanged: (value) {
                ref.read(enableDiscordRpcStateProvider.notifier).set(value);
                if (value) {
                  discordRpc?.connect(ref);
                } else {
                  discordRpc?.disconnect();
                }
              },
            ),
            SwitchListTile(
              value: hideDiscordRpcInIncognito,
              title: Text(l10n.hide_discord_rpc_incognito),
              onChanged: (value) {
                ref
                    .read(hideDiscordRpcInIncognitoStateProvider.notifier)
                    .set(value);
              },
            ),
            SwitchListTile(
              value: rpcShowReadingWatchingProgress,
              title: Text(l10n.rpc_show_reading_watching_progress),
              onChanged: (value) {
                ref
                    .read(rpcShowReadingWatchingProgressStateProvider.notifier)
                    .set(value);
              },
            ),
            SwitchListTile(
              value: rpcShowTitleState,
              title: Text(l10n.rpc_show_title),
              onChanged: (value) {
                ref.read(rpcShowTitleStateProvider.notifier).set(value);
              },
            ),
            SwitchListTile(
              value: rpcShowCoverImage,
              title: Text(l10n.rpc_show_cover_image),
              onChanged: (value) {
                ref.read(rpcShowCoverImageStateProvider.notifier).set(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
