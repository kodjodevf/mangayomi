import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/strip_theme.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_format.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// Hours as a sound effect over speed lines.
class HoursPanel extends StatelessWidget {
  const HoursPanel({
    super.key,
    required this.seconds,
    required this.intro,
    required this.text,
    this.previousSeconds,
  });

  final int seconds;
  final String intro;
  final StripText text;

  /// The month before, when it has reading time; null hides the change.
  final int? previousSeconds;

  /// A small month reads in tenths; a big one in whole hours.
  static String hoursText(BuildContext context, int seconds) =>
      seconds >= 10 * 3600
      ? formatCount(context, wholeHours(seconds))
      : tenthHours(context, seconds);

  String? _footnote(BuildContext context) {
    final l10n = context.l10n;
    final previous = previousSeconds;
    if (previous != null) {
      final delta = ((seconds - previous) / 3600).round();
      if (delta == 0) return l10n.recapStripDeltaSame;
      final amount = formatCount(context, delta.abs());
      return delta > 0
          ? l10n.recapStripDeltaUp(amount)
          : l10n.recapStripDeltaDown(amount);
    }
    final days = seconds / 86400;
    if (days < 1) return null;
    return l10n.recapStripSleepless(oneDecimal(context, days));
  }

  @override
  Widget build(BuildContext context) {
    final footnote = _footnote(context);
    return StripPanel(
      height: 260,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const CustomPaint(painter: SpeedLinesPainter()),
          Center(
            child: Transform.rotate(
              angle: -6 * pi / 180,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: StripSfx(
                      hoursText(context, seconds),
                      stroke: 3,
                      style: text.numeral(104, color: StripColors.red),
                    ),
                  ),
                  StripSfx(
                    context.l10n.recapStripHoursSfx,
                    style: text.sfx(40, color: StripColors.yellow),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: ShioriSpace.s8,
            left: ShioriSpace.s8,
            right: ShioriSpace.s48,
            child: Align(
              alignment: Alignment.topLeft,
              child: StripCaption(intro, style: text),
            ),
          ),
          if (footnote != null)
            Positioned(
              bottom: ShioriSpace.s8,
              right: ShioriSpace.s8,
              left: ShioriSpace.s48,
              child: Align(
                alignment: Alignment.bottomRight,
                child: StripCaption(footnote, style: text),
              ),
            ),
        ],
      ),
    );
  }
}
