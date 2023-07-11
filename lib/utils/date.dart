import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/date_format_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

String dateFormat(String? timestamp,
    {required WidgetRef ref,
    required BuildContext context,
    String? stringDate,
    bool forHistoryValue = false,
    bool useRelativeTimesTamps = true,
    String dateFormat = ""}) {
  final l10n = l10nLocalizations(context)!;
  final locale = currentLocale(context);
  final relativeTimestamps = ref.watch(relativeTimesTampsStateProvider);
  final dateFrmt = ref.watch(dateFormatStateProvider);
  final dateTime = stringDate != null
      ? DateTime.parse(stringDate)
      : DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp!));
  stringDate = null;
  final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
  if (stringDate == null) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final twoDaysAgo = DateTime(now.year, now.month, now.day - 2);
    final threeDaysAgo = DateTime(now.year, now.month, now.day - 3);
    final fourDaysAgo = DateTime(now.year, now.month, now.day - 4);
    final fiveDaysAgo = DateTime(now.year, now.month, now.day - 5);
    final sixDaysAgo = DateTime(now.year, now.month, now.day - 6);
    final aWeekAgo = DateTime(now.year, now.month, now.day - 7);
    final formatter = DateFormat(
        dateFormat.isEmpty ? dateFrmt : dateFormat, locale.toLanguageTag());

    if (date == today && useRelativeTimesTamps && relativeTimestamps != 0) {
      return l10n.today;
    } else if (date == yesterday &&
        useRelativeTimesTamps &&
        relativeTimestamps != 0) {
      return l10n.yesterday;
    } else if (useRelativeTimesTamps && relativeTimestamps == 2) {
      if (date.isAfter(twoDaysAgo) ||
          date.isAfter(twoDaysAgo) ||
          date.isAfter(threeDaysAgo) ||
          date.isAfter(fourDaysAgo) ||
          date.isAfter(fiveDaysAgo) ||
          date.isAfter(sixDaysAgo) ||
          date.isAfter(aWeekAgo)) {
        final difference = today.difference(date).inDays;
        return difference != 7 ? l10n.n_days_ago(difference) : l10n.a_week_ago;
      }
    }
    return forHistoryValue
        ? DateTime(dateTime.year, dateTime.month, dateTime.day).toString()
        : formatter.format(date);
  }
  return date.toString();
}

String dateFormatHour(String timestamp, BuildContext context) {
  final locale = currentLocale(context);
  final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));

  return DateFormat.Hm(locale.toLanguageTag()).format(dateTime);
}

List<String> dateFormatsList = [
  "M/d/y",
  "MM/dd/yy",
  "dd/MM/yy",
  "yyyy-MM-dd",
  "dd MMM yyyy",
  "MMM dd, yyyy"
];

List<String> relativeTimestampsList(BuildContext context) {
  final l10n = l10nLocalizations(context)!;
  return [
    l10n.off,
    l10n.relative_timestamp_short,
    l10n.relative_timestamp_long,
  ];
}
