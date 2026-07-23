import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/more/widgets/list_tile_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class PlayerOverviewScreen extends StatelessWidget {
  const PlayerOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n!.player)),
      body: SingleChildScrollView(
        padding: tvPageInsets,
        child: Column(
          children: [
            // On TV, choose between the dedicated TV player and the original
            // desktop player. Not shown on phones/desktops.
            if (isTv)
              Consumer(
                builder: (context, ref, _) {
                  final useTvPlayer = ref.watch(tvPlayerStyleProvider);
                  return SwitchListTile(
                    secondary: const Icon(Icons.smart_display_outlined),
                    title: const Text('TV player (beta)'),
                    subtitle: const Text(
                      'On: dedicated TV player.  Off: original (desktop) player.',
                    ),
                    value: useTvPlayer,
                    onChanged: (v) =>
                        ref.read(tvPlayerStyleProvider.notifier).set(v),
                  );
                },
              ),
            ListTileWidget(
              title: l10n.internal_player,
              subtitle: l10n.internal_player_info,
              icon: Icons.play_circle_outline_outlined,
              onTap: () => context.push('/playerMode'),
            ),
            ListTileWidget(
              title: l10n.decoder,
              subtitle: l10n.decoder_info,
              icon: Icons.memory_outlined,
              onTap: () => context.push('/playerDecoderScreen'),
            ),
            ListTileWidget(
              title: l10n.video_audio,
              subtitle: l10n.video_audio_info,
              icon: Icons.audiotrack_outlined,
              onTap: () => context.push('/playerAudioScreen'),
            ),
            ListTileWidget(
              title: l10n.custom_buttons,
              subtitle: l10n.custom_buttons_info,
              icon: Icons.terminal_outlined,
              onTap: () => context.push('/customButtonScreen'),
            ),
            ListTileWidget(
              title: l10n.advanced,
              subtitle: l10n.advanced_info,
              icon: Icons.code_outlined,
              onTap: () => context.push('/playerAdvancedScreen'),
            ),
          ],
        ),
      ),
    );
  }
}
