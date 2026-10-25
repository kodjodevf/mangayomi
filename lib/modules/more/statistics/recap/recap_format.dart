import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

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
