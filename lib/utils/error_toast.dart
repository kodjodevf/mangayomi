import 'package:go_router/go_router.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/services/crash_report.dart';
import 'package:mangayomi/utils/localized_message.dart';

/// Tells the reader something went wrong without putting a stack trace on
/// their screen.
///
/// Several callers used to toast `'$e\n$s'`, which on a phone is a wall of
/// interpreter frames covering the whole display and saying nothing anyone can
/// act on. The stack is worth keeping, just not there: it goes to
/// [CrashReports], and the toast offers a way through to it.
void toastError(
  Object error, {
  StackTrace? stack,
  String source = 'caught',
  int seconds = 6,
}) {
  CrashReports.record(source: source, error: error, stack: stack);
  botToast(
    errorToastMessage(error),
    second: seconds,
    maxLines: 3,
    detailsLabel: localizedMessage((l10n) => l10n.error_reports_banner_action),
    onDetails: () => navigatorKey.currentContext?.push('/errorReports'),
  );
}

/// The one line of [error] worth showing, redacted and capped.
///
/// Interpreter errors are the long ones: the first line carries the message
/// and everything after it is frames.
String errorToastMessage(Object error, {int maxLength = 180}) {
  final first = redact(error.toString())
      .split('\n')
      .map((line) => line.trim())
      .firstWhere((line) => line.isNotEmpty, orElse: () => '');
  if (first.isEmpty) return error.runtimeType.toString();
  return first.length <= maxLength
      ? first
      : '${first.substring(0, maxLength - 1)}…';
}
