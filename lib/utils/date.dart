import 'package:intl/intl.dart';

dateFormat(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  final twoDaysAgo = DateTime(now.year, now.month, now.day - 2);
  final formatter = DateFormat('dd/MM/yyyy');

  if (date == today) {
    return 'Today';
  } else if (date == yesterday) {
    return 'Yesterday';
  } else if (date.isAfter(twoDaysAgo)) {
    final difference = today.difference(date).inDays;
    return '$difference days ago';
  } else {
    return formatter.format(date).toString();
  }
}
