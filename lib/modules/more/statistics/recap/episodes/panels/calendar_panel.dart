import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/strip_theme.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// The month as a grid of days, the ones read inked in, with the streak.
class CalendarPanel extends StatelessWidget {
  const CalendarPanel({
    super.key,
    required this.month,
    required this.daysRead,
    required this.longestStreak,
    required this.text,
  });

  static const _gap = 4.0;

  final DateTime month;
  final Set<int> daysRead;
  final int longestStreak;
  final StripText text;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final days = DateUtils.getDaysInMonth(month.year, month.month);
    final leading = DateTime(month.year, month.month).weekday - 1;
    final narrow = DateFormat.EEEEE(locale);
    return StripPanel(
      height: null,
      child: Padding(
        padding: const EdgeInsets.all(ShioriSpace.s16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cell = ((constraints.maxWidth - 6 * _gap) / 7)
                .floorToDouble();
            Widget box(Widget child, {Color? fill, bool inked = false}) =>
                SizedBox.square(
                  dimension: cell,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: fill,
                      border: inked ? Border.all(width: 2) : null,
                    ),
                    child: Center(child: child),
                  ),
                );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.recapStripCalendarLabel, style: text.label),
                const SizedBox(height: ShioriSpace.s12),
                Wrap(
                  spacing: _gap,
                  runSpacing: _gap,
                  children: [
                    for (var i = 0; i < 7; i++)
                      box(
                        Text(
                          // 2024-01-01 is a Monday.
                          narrow.format(DateTime(2024, 1, 1 + i)),
                          style: text.label.copyWith(letterSpacing: 0),
                        ),
                      ),
                    for (var i = 0; i < leading; i++) box(const SizedBox()),
                    for (var day = 1; day <= days; day++)
                      box(
                        Text(
                          '$day',
                          style: text.caption.copyWith(
                            color: daysRead.contains(day)
                                ? StripColors.paper
                                : StripColors.ink,
                          ),
                        ),
                        fill: daysRead.contains(day)
                            ? StripColors.red
                            : StripColors.caption,
                        inked: true,
                      ),
                  ],
                ),
                const SizedBox(height: ShioriSpace.s12),
                StripCaption(
                  '${l10n.recapStripDaysRead(daysRead.length, days)} · '
                  '${l10n.recapStripStreak(longestStreak)}',
                  style: text,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
