import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

/// One error the app caught and kept so it can be reported later.
///
/// This is deliberately small. It holds what a maintainer needs to act on an
/// error — what it was, where it happened, which build — and nothing about
/// what the reader was reading.
@immutable
class CrashReport {
  const CrashReport({
    required this.time,
    required this.source,
    required this.error,
    this.stack,
    this.screen,
  });

  /// When it was caught, local time.
  final DateTime time;

  /// Which of the app's error handlers caught it, e.g. `FlutterError`.
  final String source;

  /// The exception, already redacted.
  final String error;

  /// The stack, already redacted and trimmed. Null when there wasn't one.
  final String? stack;

  /// The route the app was on, e.g. `/mangaDetail`. Null before the first
  /// navigation.
  final String? screen;

  /// A plain sentence naming the likely cause, or null when the error does not
  /// match anything recognisable.
  String? get likelyCause => describeLikelyCause(error);

  /// The first line of [error], which is the part worth putting in a title.
  String get summary {
    final line = error.split('\n').first.trim();
    return line.length <= 120 ? line : '${line.substring(0, 117)}...';
  }

  Map<String, dynamic> toJson() => {
    'time': time.toIso8601String(),
    'source': source,
    'error': error,
    if (stack != null) 'stack': stack,
    if (screen != null) 'screen': screen,
  };

  static CrashReport? fromJson(Map<String, dynamic> json) {
    final time = DateTime.tryParse(json['time'] as String? ?? '');
    final error = json['error'] as String?;
    if (time == null || error == null) return null;
    return CrashReport(
      time: time,
      source: json['source'] as String? ?? 'unknown',
      error: error,
      stack: json['stack'] as String?,
      screen: json['screen'] as String?,
    );
  }
}

/// Turns an error into a sentence a reader can act on, or null when it is not
/// one of the shapes this app produces often enough to name.
///
/// This is a guess presented as a guess. It exists so a report says something
/// more useful than the exception's class name, not to replace the stack.
String? describeLikelyCause(String error) {
  final e = error.toLowerCase();
  if (e.contains('cloudflare') || e.contains('ddos-guard')) {
    return 'The source is behind Cloudflare and the check did not pass. '
        'Opening the source in the built-in browser once usually clears it.';
  }
  if (e.contains('socketexception') ||
      e.contains('failed host lookup') ||
      e.contains('connection closed') ||
      e.contains('connection refused')) {
    return 'The app could not reach the network or the source was unreachable.';
  }
  if (e.contains('timeoutexception') || e.contains('timed out')) {
    return 'A request took too long to answer.';
  }
  if (e.contains('handshakeexception') || e.contains('certificate')) {
    return 'The secure connection to the source could not be established.';
  }
  if (e.contains('isarerror') && e.contains('transaction')) {
    return 'A database write ran inside another one. This is an app bug, not '
        'something the reader did.';
  }
  if (e.contains('isarerror')) {
    return 'The database rejected an operation.';
  }
  if (e.contains('filesystemexception') || e.contains('permission denied')) {
    return 'A file could not be read or written, often a storage permission.';
  }
  if (e.contains('failed to load') && e.contains('http')) {
    return 'An image could not be loaded. The source may need headers the '
        'extension is not sending, or the link may have expired.';
  }
  if (e.contains('unimplementederror')) {
    return 'Something the app asked for is not implemented on this platform.';
  }
  if (e.contains('rangeerror') || e.contains('null check operator')) {
    return 'The app assumed something was there and it was not. This is an app '
        'bug.';
  }
  return null;
}

/// Strips anything from [text] that identifies the reader or what they were
/// reading, so a report can be sent without sending their library with it.
///
/// URLs keep their host and lose their path, which is what makes a source
/// recognisable without naming a title. Home directories become `~`, which
/// also removes the account name from every file path in a stack.
String redact(String text) {
  var out = text.replaceAllMapped(
    RegExp(r'https?://([^\s/"\)]+)(/[^\s"\)]*)?'),
    (m) => 'https://${m.group(1)}/...',
  );
  out = out.replaceAll(RegExp(r'/(?:Users|home)/[^/\s]+'), '~');
  out = out.replaceAll(
    RegExp(r'C:\\Users\\[^\\\s]+', caseSensitive: false),
    '~',
  );
  // Anything that looks like a credential, in a header dump or a query.
  out = out.replaceAllMapped(
    RegExp(
      r'(authorization|cookie|token|api[_-]?key|password|secret)'
      r'''(["']?\s*[:=]\s*["']?)([^\s,;"'}\)]+)''',
      caseSensitive: false,
    ),
    (m) => '${m.group(1)}${m.group(2)}<removed>',
  );
  return out;
}

/// The errors the app caught, kept across launches so they can be reported.
///
/// Recording is on for everyone. It is not the verbose log behind the "Enable
/// logs" setting — that stays off by default and stays opt-in. This keeps only
/// caught errors, at most [_max] of them, in a file of a few kilobytes, and
/// none of it leaves the device unless the reader sends it.
class CrashReports {
  CrashReports._();

  static const _max = 10;
  static const _fileName = 'crash_reports.json';

  static final List<CrashReport> _reports = [];

  /// Recorded before [init] found somewhere to put them. The handlers are
  /// installed before storage is resolved, so a startup error arrives with
  /// nowhere to go and waits here.
  static final List<CrashReport> _pending = [];
  static File? _file;
  static String? _screen;
  static bool _seen = false;
  static bool _loaded = false;

  /// The route the app is on, fed by [CrashRouteObserver].
  static set screen(String? value) => _screen = value;

  /// Everything kept, newest last.
  static List<CrashReport> get reports => List.unmodifiable(_reports);

  /// The most recent error, or null when nothing has gone wrong.
  static CrashReport? get latest => _reports.isEmpty ? null : _reports.last;

  /// Whether there is something the reader has not been shown yet.
  static bool get hasUnseen => _reports.isNotEmpty && !_seen;

  /// Loads what earlier runs recorded. Anything recorded before this runs is
  /// kept in memory and written out here, so an error during startup is not
  /// lost just because storage was not ready yet.
  static Future<void> init(Directory? directory) {
    final future = _init(directory);
    _ready = future;
    return future;
  }

  /// Completes once what earlier runs recorded has been loaded, so anything
  /// asking whether there is something to report waits for the answer rather
  /// than racing it.
  static Future<void> get ready => _ready ?? Future.value();
  static Future<void>? _ready;

  static Future<void> _init(Directory? directory) async {
    if (directory == null) return;
    _file = File(p.join(directory.path, _fileName));
    _reports.clear();
    try {
      if (await _file!.exists()) {
        final decoded = jsonDecode(await _file!.readAsString());
        if (decoded is List) {
          for (final entry in decoded) {
            if (entry is! Map) continue;
            final report = CrashReport.fromJson(
              Map<String, dynamic>.from(entry),
            );
            if (report != null) _reports.add(report);
          }
        }
      }
    } catch (_) {
      // A corrupt file is not worth a crash inside the crash reporter.
      _reports.clear();
    }
    _seen = _reports.isEmpty;
    final hadPending = _pending.isNotEmpty;
    _reports.addAll(_pending);
    _pending.clear();
    _loaded = true;
    _trim();
    if (hadPending) _flush();
  }

  /// Records one caught error.
  ///
  /// Called from error handlers, so it must not throw and must not await:
  /// anything that fails here would be an error raised while handling an
  /// error.
  static void record({
    required String source,
    required Object error,
    StackTrace? stack,
    String? screen,
  }) {
    try {
      final report = CrashReport(
        time: DateTime.now(),
        source: source,
        error: redact(error.toString()),
        stack: stack == null ? null : _trimStack(redact(stack.toString())),
        // A native crash is reported on the launch after it happened, so it
        // has to say where it was rather than where we are now.
        screen: screen ?? _screen,
      );
      _reports.add(report);
      if (!_loaded) _pending.add(report);
      _seen = false;
      _trim();
      _flush();
    } catch (_) {}
  }

  /// Marks what is kept as shown, so the banner stops offering it.
  static void markSeen() {
    _seen = true;
  }

  /// Throws everything away, at the reader's request.
  static void clear() {
    _reports.clear();
    _pending.clear();
    _seen = true;
    _flush();
  }

  /// Puts the reporter back to how a fresh process finds it. All of this is
  /// process-global, so a test that wants a second launch has to say so.
  @visibleForTesting
  static void resetForTest() {
    _reports.clear();
    _pending.clear();
    _file = null;
    _screen = null;
    _seen = false;
    _loaded = false;
    _ready = null;
  }

  static void _trim() {
    if (_reports.length > _max) {
      _reports.removeRange(0, _reports.length - _max);
    }
  }

  static void _flush() {
    final file = _file;
    if (file == null) return;
    try {
      file.writeAsStringSync(
        jsonEncode(_reports.map((e) => e.toJson()).toList()),
        flush: true,
      );
    } catch (_) {}
  }

  /// Keeps the frames that point at this app plus a little context. A full
  /// stack is mostly framework frames and does not fit in a prefilled issue.
  static String _trimStack(String stack) {
    const maxLines = 24;
    final lines = stack.split('\n');
    if (lines.length <= maxLines) return stack.trim();
    return [
      ...lines.take(maxLines),
      '... ${lines.length - maxLines} more frames',
    ].join('\n').trim();
  }
}
