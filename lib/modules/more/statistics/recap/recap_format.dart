import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_math.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_models.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

String formatCount(BuildContext context, num value) =>
    NumberFormat.decimalPattern(Localizations.localeOf(context).toString())
        .format(value);

/// Whole hours, for headline numbers.
int wholeHours(int seconds) => seconds ~/ 3600;

/// Hours with one decimal ("13.6"), for series-sized amounts.
String tenthHours(BuildContext context, int seconds) =>
    oneDecimal(context, seconds / 3600);

/// "1.3": at most one decimal, in the reader's locale.
String oneDecimal(BuildContext context, double value) => NumberFormat(
  '0.#',
  Localizations.localeOf(context).toString(),
).format(value);

/// "7 AM" style hour label in the reader's locale.
String hourLabel(BuildContext context, int hour) =>
    DateFormat.j(Localizations.localeOf(context).toString())
        .format(DateTime(2000, 1, 1, hour));

/// "October 2026".
String monthLabel(BuildContext context, DateTime month) =>
    DateFormat.yMMMM(Localizations.localeOf(context).toString()).format(month);

/// "Oct 12".
String dayLabel(BuildContext context, DateTime day) =>
    DateFormat.MMMd(Localizations.localeOf(context).toString()).format(day);

/// "5 years", "7 months" or "9 days": [bondLength] in words.
String bondSpan(BuildContext context, RecapSeries series) {
  final l10n = context.l10n;
  final span = bondLength(series);
  return switch (span.unit) {
    BondUnit.years => l10n.recapBondYears(span.count),
    BondUnit.months => l10n.recapBondMonths(span.count),
    BondUnit.days => l10n.recapBondDays(span.count),
  };
}
