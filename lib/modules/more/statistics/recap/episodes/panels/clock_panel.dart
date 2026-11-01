import 'package:flutter/material.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/strip_theme.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_format.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_math.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// When you read, as a sunrise and a speech bubble.
class ClockPanel extends StatelessWidget {
  const ClockPanel({
    super.key,
    required this.hours,
    required this.itemType,
    required this.text,
  });

  /// 24 buckets, local hour. The episode omits this panel when all are 0.
  final List<int> hours;
  final ItemType itemType;
  final StripText text;

  /// The second-busiest hour, or -1 when there's no distinct one.
  static int secondPeak(List<int> hours, int peak) {
    var best = -1;
    for (var h = 0; h < hours.length; h++) {
      if (h == peak || hours[h] == 0) continue;
      if (best == -1 || hours[h] > hours[best]) best = h;
    }
    return best;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final peak = peakHour(hours);
    final second = secondPeak(hours, peak);
    final flavour = peak >= 5 && peak <= 9
        ? ' ${l10n.recapStripClockDawn}'
        : peak >= 0 && peak <= 4
        ? ' ${l10n.recapStripClockNight}'
        : '';
    return StripPanel(
      height: 220,
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          StripColors.dawnTop,
          StripColors.dawnMid,
          StripColors.dawnBottom,
        ],
        stops: [0, 0.6, 1],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            bottom: -40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: StripColors.sun,
                  border: Border.all(width: StripShape.panelBorder),
                ),
              ),
            ),
          ),
          Positioned(
            left: ShioriSpace.s16,
            top: ShioriSpace.s16,
            right: ShioriSpace.s48 + ShioriSpace.s48,
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: ShioriSpace.s16,
                  vertical: ShioriSpace.s12,
                ),
                decoration: BoxDecoration(
                  color: StripColors.paper,
                  border: Border.all(width: 2.5),
                  borderRadius: const BorderRadius.all(
                    Radius.elliptical(120, 40),
                  ),
                ),
                child: Text(
                  l10n.recapStripClockBubble(
                        hourLabel(context, peak),
                        itemType.name,
                      ) +
                      flavour,
                  textAlign: TextAlign.center,
                  style: text.body.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ),
          if (second >= 0)
            Positioned(
              right: ShioriSpace.s8,
              bottom: ShioriSpace.s8,
              child: StripCaption(
                l10n.recapStripClockSecond(hourLabel(context, second)),
                style: text,
              ),
            ),
        ],
      ),
    );
  }
}
