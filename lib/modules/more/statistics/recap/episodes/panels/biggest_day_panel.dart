import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/strip_theme.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_format.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// The single day with the most completions.
class BiggestDayPanel extends StatelessWidget {
  const BiggestDayPanel({
    super.key,
    required this.day,
    required this.completions,
    required this.units,
    required this.text,
  });

  final DateTime day;
  final int completions;

  /// "61 chapters", already pluralised.
  final String units;
  final StripText text;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return StripPanel(
      height: null,
      color: StripColors.pink,
      halftone: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          ShioriSpace.s16,
          ShioriSpace.s16,
          ShioriSpace.s16,
          ShioriSpace.s24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.recapStripBiggestDayLabel, style: text.label),
            // Clears the share button for the numeral on the right.
            const SizedBox(height: ShioriSpace.s24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: StripSfx(
                    dayLabel(context, day).toUpperCase(),
                    style: text.sfx(44),
                  ),
                ),
                const SizedBox(width: ShioriSpace.s8),
                StripSfx(
                  formatCount(context, completions),
                  stroke: 3,
                  style: text.numeral(72, color: StripColors.red),
                ),
              ],
            ),
            const SizedBox(height: ShioriSpace.s12),
            StripCaption(l10n.recapStripBiggestDayCaption(units), style: text),
          ],
        ),
      ),
    );
  }
}
