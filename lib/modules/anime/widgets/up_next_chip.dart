import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// How long before the end the next episode is announced.
const upNextWindow = Duration(seconds: 20);

/// "Next episode in 12 s", over the last seconds of an episode: a tap plays
/// it now, the cross keeps this episode from rolling on. Playing on used to
/// happen with no warning and no way to stay.
class UpNextChip extends StatelessWidget {
  const UpNextChip({
    super.key,
    required this.secondsLeft,
    required this.onPlayNow,
    required this.onCancel,
  });

  final int secondsLeft;
  final VoidCallback onPlayNow;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.shiori;
    final label = l10n.next_episode_in(secondsLeft);
    return Semantics(
      liveRegion: true,
      container: true,
      child: Material(
        // Over the video, so on the scrim, whatever the theme.
        color: ShioriScrim.underText,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: onPlayNow,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: tokens.density.minTarget,
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: ShioriSpace.s16,
                    end: ShioriSpace.s8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: ShioriSpace.s8,
                    children: [
                      const Icon(
                        Symbols.skip_next_rounded,
                        fill: 1,
                        color: Colors.white,
                      ),
                      Text(
                        label,
                        style: tokens.text.row.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              tooltip: l10n.stay_on_this_episode,
              onPressed: onCancel,
              color: Colors.white,
              icon: const Icon(Symbols.close_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
