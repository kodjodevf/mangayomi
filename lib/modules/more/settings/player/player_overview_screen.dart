import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
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
                  return ShioriSwitchRow(
                    autofocus: true,
                    icon: Symbols.smart_display_rounded,
                    title: context.l10n.tv_player_beta,
                    subtitle: context.l10n.tv_player_beta_subtitle,
                    value: useTvPlayer,
                    onChanged: (v) =>
                        ref.read(tvPlayerStyleProvider.notifier).set(v),
                  );
                },
              ),
            ListTileWidget(
              title: l10n.internal_player,
              subtitle: l10n.internal_player_info,
              icon: Symbols.play_circle_rounded,
              onTap: () => context.push('/playerMode'),
            ),
            ListTileWidget(
              title: l10n.decoder,
              subtitle: l10n.decoder_info,
              icon: Symbols.memory_rounded,
              onTap: () => context.push('/playerDecoderScreen'),
            ),
            ListTileWidget(
              title: l10n.video_audio,
              subtitle: l10n.video_audio_info,
              icon: Symbols.audiotrack_rounded,
              onTap: () => context.push('/playerAudioScreen'),
            ),
            ListTileWidget(
              title: l10n.custom_buttons,
              subtitle: l10n.custom_buttons_info,
              icon: Symbols.terminal_rounded,
              onTap: () => context.push('/customButtonScreen'),
            ),
            ListTileWidget(
              title: l10n.advanced,
              subtitle: l10n.advanced_info,
              icon: Symbols.code_rounded,
              onTap: () => context.push('/playerAdvancedScreen'),
            ),
          ],
        ),
      ),
    );
  }
}
