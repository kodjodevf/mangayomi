import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/strip_theme.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_cover.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_models.dart';
import 'package:mangayomi/modules/more/statistics/recap/status_window/sw_bonded.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// The #1 series, introduced like a main character. Tapping opens it.
class TopSeriesPanel extends StatelessWidget {
  const TopSeriesPanel({
    super.key,
    required this.series,
    required this.caption,
    required this.text,
  });

  final RecapSeries series;
  final String caption;
  final StripText text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openSeries(context, series.id),
      child: StripPanel(
        height: 330,
        color: StripColors.ink,
        child: Stack(
          fit: StackFit.expand,
          children: [
            RecapCover(
              mangaId: series.id,
              placeholder: StripColors.coverPlaceholder,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [StripColors.shade, StripColors.veil],
                  stops: [0, 0.7],
                ),
              ),
            ),
            Positioned(
              left: ShioriSpace.s16,
              top: ShioriSpace.s16,
              right: ShioriSpace.s48 + ShioriSpace.s48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.recapStripTopLabel,
                    style: text.label.copyWith(color: StripColors.red),
                  ),
                  const SizedBox(height: ShioriSpace.s4),
                  StripSfx(
                    series.name.toUpperCase(),
                    stroke: 0,
                    maxLines: 4,
                    style: text.sfx(34),
                  ),
                ],
              ),
            ),
            Positioned(
              left: ShioriSpace.s16,
              right: ShioriSpace.s16,
              bottom: ShioriSpace.s16,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: StripCaption(caption, style: text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
