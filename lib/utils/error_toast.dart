import 'package:flutter/foundation.dart';
import 'package:mangayomi/core/navigation/app_navigator.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/services/crash_report.dart';
import 'package:mangayomi/utils/localized_message.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/utils/log/logger.dart';

/// Keeps a caught error where it can be found later: in [CrashReports], which
/// is always on, and in the verbose log when "Enable logs" is turned on.
///
/// Use this for any error that is handled without reaching the global
/// handlers in `main.dart`, otherwise it is only visible if the handled
/// branch also shows a toast.
///
/// In a debug build or with developer mode on, the error is also printed as
/// it is, tokens included: the log file is redacted, the console is where a
/// developer needs the real request.
void recordError(
  Object error, {
  StackTrace? stack,
  required String source,
  LogLevel level = LogLevel.error,
}) {
  CrashReports.record(source: source, error: error, stack: stack);
  if (kDebugMode || _developerMode()) {
    debugPrint('[$source] $error${stack == null ? '' : '\n$stack'}');
  }
  final trace = stack == null ? '' : '\n${redact(stack.toString())}';
  AppLogger.log('$source: ${redact(error.toString())}$trace', logLevel: level);
}

bool _readingDeveloperMode = false;

/// Whether developer mode is on. Reading the settings can itself fail and
/// record that error, which comes back here: that inner call answers false.
bool _developerMode() {
  if (_readingDeveloperMode) return false;
  _readingDeveloperMode = true;
  try {
    return settingsRepository.currentOrNull?.developerMode ?? false;
  } finally {
    _readingDeveloperMode = false;
  }
}

/// Tells the reader something went wrong without putting a stack trace on
/// their screen.
///
/// Several callers used to toast `'$e\n$s'`, which on a phone is a wall of
/// interpreter frames covering the whole display and saying nothing anyone can
/// act on. The stack is worth keeping, just not there: it goes to
/// [CrashReports] and the log, and the toast offers a way through to it.
void toastError(
  Object error, {
  StackTrace? stack,
  String source = 'caught',
  int seconds = 6,
}) {
  recordError(error, stack: stack, source: source);
  botToast(
    errorToastMessage(error),
    tone: ShioriToastTone.error,
    second: seconds,
    maxLines: 3,
    detailsLabel: localizedMessage((l10n) => l10n.error_reports_banner_action),
    onDetails: () => AppNavigator.push('/errorReports'),
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
