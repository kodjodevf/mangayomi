import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/more/widgets/list_tile_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class PlayerOverviewScreen extends StatelessWidget {
  const PlayerOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n!.player)),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
