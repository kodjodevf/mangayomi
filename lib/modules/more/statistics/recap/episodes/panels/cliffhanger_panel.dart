import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/strip_theme.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// "To be continued", pointing at the next episode.
class CliffhangerPanel extends StatelessWidget {
  const CliffhangerPanel({
    super.key,
    required this.next,
    required this.text,
    this.onOpen,
  });

  /// The next episode's name, e.g. "November 2026".
  final String next;

  /// Opens the next episode when it already exists.
  final VoidCallback? onOpen;
  final StripText text;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return StripPanel(
      height: 170,
      color: StripColors.ink,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: ShioriSpace.s12,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: StripSfx(
                  l10n.recapStripToBeContinued,
                  stroke: 0,
                  style: text.sfx(34, color: StripColors.yellow),
                ),
              ),
              Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: onOpen,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ShioriSpace.s16,
                      vertical: ShioriSpace.s8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: StripColors.paper,
                        width: StripShape.captionBorder,
                      ),
                    ),
                    child: Text(
                      onOpen == null
                          ? l10n.recapStripNext(next.toUpperCase())
                          : l10n.recapStripReadNext(next.toUpperCase()),
                      textAlign: TextAlign.center,
                      style: text.button,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
