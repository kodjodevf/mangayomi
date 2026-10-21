import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/utils/log/log.dart';

/// What failed when a source's code was run, kept so a developer sees it on
/// the page ([SourceCodeErrorBanner]) instead of leaving to read the logs.
class SourceCodeError {
  const SourceCodeError({
    required this.what,
    required this.message,
    required this.stack,
  });

  /// Which call failed: "Filters", "Headers"...
  final String what;
  final String message;
  final String stack;

  @override
  String toString() => '$what: $message\n\n$stack';
}

/// The last failure of each source's code, by source id.
///
/// The screens fall back (no filters, no headers...) so a reader is never
/// stopped by a broken source; what fell back is reported here, to the log,
/// and to the console with its stack trace.
class SourceCodeErrors {
  SourceCodeErrors._();

  static final notifier = ValueNotifier<Map<int, SourceCodeError>>(const {});

  static SourceCodeError? of(int? sourceId) =>
      sourceId == null ? null : notifier.value[sourceId];

  static void report(
    Source source,
    String what,
    Object error,
    StackTrace stack,
  ) {
    Logger.add(
      LoggerLevel.error,
      '$what of ${source.name} (${source.lang}) failed: $error',
    );
    debugPrint('[${source.name} ${source.lang}] $what failed: $error\n$stack');
    final id = source.id;
    if (id == null) return;
    final next = SourceCodeError(
      what: what,
      message: error.toString(),
      stack: stack.toString(),
    );
    final current = notifier.value[id];
    if (current?.what == next.what && current?.message == next.message) return;
    // Reported from inside a build; the listeners hear of it after.
    scheduleMicrotask(() => notifier.value = {...notifier.value, id: next});
  }

  /// Forgets [sourceId]'s failure: once its code runs again, or when the
  /// developer dismisses it.
  static void clear(int? sourceId) {
    if (sourceId == null || !notifier.value.containsKey(sourceId)) return;
    scheduleMicrotask(
      () => notifier.value = {...notifier.value}..remove(sourceId),
    );
  }
}
