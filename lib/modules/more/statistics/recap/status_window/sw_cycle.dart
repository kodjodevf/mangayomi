import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_format.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_math.dart';
import 'package:mangayomi/modules/more/statistics/recap/status_window/sw_theme.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// Short weekday name, Monday = 0.
String weekdayName(BuildContext context, int index) =>
    DateFormat.E(Localizations.localeOf(context).toString())
        .format(DateTime(2024, 1, 1 + index));

/// The reading clock: a 24-hour radial chart and the week's busiest day.
class SwCycle extends StatelessWidget {
  const SwCycle({
    super.key,
    required this.hours,
    required this.weekdays,
    required this.text,
  });

  final List<int> hours;
  final List<int> weekdays;
  final SwText text;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final peak = peakHour(hours);
    final bestDay = peakHour(weekdays);
    return SwWindow(
      title: l10n.recapCycleTitle,
      text: text,
      child: peak < 0
          ? Text(l10n.recapCycleEmpty, style: text.body)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: ShioriSpace.s12,
              children: [
                Row(
                  spacing: ShioriSpace.s12,
                  children: [
                    SizedBox.square(
                      dimension: 150,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned.fill(
                            child: CustomPaint(painter: RadialClock(hours)),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                hourLabel(context, peak),
                                style: text.bodyStrong,
                              ),
                              Text(l10n.recapPeak, style: text.label),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        l10n.recapCycleLine(hourLabel(context, peak)),
                        style: text.body,
                      ),
                    ),
                  ],
                ),
                _WeekBars(weekdays: weekdays, best: bestDay, text: text),
              ],
            ),
    );
  }
}

class _WeekBars extends StatelessWidget {
  const _WeekBars({
    required this.weekdays,
    required this.best,
    required this.text,
  });

  final List<int> weekdays;
  final int best;
  final SwText text;

  @override
  Widget build(BuildContext context) {
    final top = weekdays.fold(0, max);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: ShioriSpace.s4,
      children: [
        Text(
          '${context.l10n.recapBestDay}: ${weekdayName(context, best)}',
          style: text.label,
        ),
        SizedBox(
          height: 48,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: ShioriSpace.s8,
            children: [
              for (var i = 0; i < 7; i++)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: FractionallySizedBox(
                          heightFactor: top == 0 ? 0 : weekdays[i] / top,
                          child: ColoredBox(
                            color: i == best ? SwColors.cyan : SwColors.blue,
                            child: const SizedBox.expand(),
                          ),
                        ),
                      ),
                      Text(
                        weekdayName(context, i),
                        maxLines: 1,
                        style: text.small,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 24 spokes around a ring, longer for busier hours; the three busiest glow
/// cyan. Midnight is at the top.
class RadialClock extends CustomPainter {
  RadialClock(this.hours);

  final List<int> hours;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final outer = size.shortestSide / 2 - 4;
    final inner = outer * 0.42;
    final top = hours.fold(0, max);
    final ranked = [for (var i = 0; i < 24; i++) i]
      ..sort((a, b) => hours[b].compareTo(hours[a]));
    final hot = ranked.take(3).where((h) => hours[h] > 0).toSet();

    canvas.drawCircle(
      center,
      inner - 4,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = SwColors.hairline,
    );
    for (var h = 0; h < 24; h++) {
      final angle = -pi / 2 + h * 2 * pi / 24;
      final direction = Offset(cos(angle), sin(angle));
      final length = top == 0 ? 0.0 : (outer - inner) * hours[h] / top;
      final paint = Paint()
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..color = hot.contains(h) ? SwColors.cyan : SwColors.blue;
      canvas.drawLine(
        center + direction * inner,
        center + direction * (inner + max(length, 2)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(RadialClock oldDelegate) => oldDelegate.hours != hours;
}
