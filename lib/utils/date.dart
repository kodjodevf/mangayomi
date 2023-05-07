import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mangayomi/views/more/settings/appearance/providers/date_format_state_provider.dart';

String dateFormat(String timestamp,
    {required WidgetRef ref,
    bool useRelativeTimesTamps = true,
    String dateFormat = ""}) {
  final relativeTimestamps = ref.watch(relativeTimesTampsStateProvider);
  final dateFrmt = ref.watch(dateFormatStateProvider);
  final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
  final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  final twoDaysAgo = DateTime(now.year, now.month, now.day - 2);
  final threeDaysAgo = DateTime(now.year, now.month, now.day - 3);
  final fourDaysAgo = DateTime(now.year, now.month, now.day - 4);
  final fiveDaysAgo = DateTime(now.year, now.month, now.day - 5);
  final sixDaysAgo = DateTime(now.year, now.month, now.day - 6);
  final aWeekAgo = DateTime(now.year, now.month, now.day - 7);
  final formatter =
      DateFormat(dateFormat.isEmpty ? dateFrmt : dateFormat, "en");

  if (date == today && useRelativeTimesTamps && relativeTimestamps != 0) {
    return 'Today';
  } else if (date == yesterday &&
      useRelativeTimesTamps &&
      relativeTimestamps != 0) {
    return 'Yesterday';
  } else if (date.isAfter(twoDaysAgo) ||
      date.isAfter(twoDaysAgo) ||
      date.isAfter(threeDaysAgo) ||
      date.isAfter(fourDaysAgo) ||
      date.isAfter(fiveDaysAgo) ||
      date.isAfter(sixDaysAgo) ||
      date.isAfter(aWeekAgo) &&
          useRelativeTimesTamps &&
          useRelativeTimesTamps &&
          relativeTimestamps == 2) {
    final difference = today.difference(date).inDays;
    return difference != 7 ? '$difference days ago' : 'A week ago';
  }
  return formatter.format(date);
}

String dateFormatHour(String timestamp) {
  final dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));

  return DateFormat.Hm("en").format(dateTime);
}

List<String> dateFormatsList = [
  "M/d/y",
  "MM/dd/yy",
  "dd/MM/yy",
  "yyyy-MM-dd",
  "dd MMM yyyy",
  "MMM dd, yyyy"
];

List<String> relativeTimestampsList = [
  "Off",
  "Short (Today, Yesterday)",
  "Long (Short+, n days ago)",
];
