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

/// Whether [error] is a thing that goes wrong rather than a thing that is
/// broken.
///
/// A cover that 404s, a CDN that times out, a source that is down: these are
/// expected on a network, they already show as a broken image in the UI, and
/// nothing in the app needs changing when one happens. They still reach
/// FlutterError.onError, though, because an ImageProvider reports a failed
/// load whether or not the widget drew a placeholder for it.
///
/// Left unfiltered they raise the "something went wrong" banner and get filed
/// as bugs. Issues #915 and #916 are exactly that: two reports about images
/// not loading from a CDN, sent through the reporter as if the app had
/// crashed.
///
/// These are still recorded, because "images stopped loading" is worth being
/// able to look up. They just do not interrupt anybody.
bool isExpectedFailure(Object error) {
  final text = error.toString().toLowerCase();
  return text.contains('failed to load http') ||
      text.contains('socketexception') ||
      text.contains('failed host lookup') ||
      text.contains('connection closed') ||
      text.contains('connection reset') ||
      text.contains('connection refused') ||
      text.contains('timeoutexception') ||
      text.contains('handshakeexception') ||
      // What a half-downloaded or non-image response decodes to. #927 shows
      // the sequence plainly in its own recent-errors block: two failed
      // MangaDex page loads, then this, seconds apart. It is the same failure
      // one step further along, not a separate bug.
      text.contains('could not decompress image') ||
      text.contains('invalid image data') ||
      // The Rust HTTP stack's transport errors, which are the same network
      // failures one layer down. #933 is one of these.
      text.contains('rhttpunknownexception') ||
      text.contains('hyper_util') ||
      text.contains('statuscode: 5');
}

/// Whether [error] came from an extension rather than from the app.
///
/// Extensions are third-party code the app runs in an interpreter, and when
/// one is wrong the fix belongs in the repository it came from. #914 is an
/// extension calling `.toList()` on a Map, filed here because the reporter had
/// no way to tell the difference and the app offered them a button.
///
/// d4rt prefixes everything it raises with "Runtime Error:", and wraps
/// failures inside bridged calls with a recognisable phrase, so this can be
/// told apart from an app bug with reasonable confidence.
bool isExtensionFailure(Object error) {
  final text = error.toString();
  return
  // d4rt, the Dart interpreter
  text.startsWith('Runtime Error:') ||
      text.startsWith('SourceCodeException:') ||
      text.contains('Native error during bridged method call') ||
      text.contains('Undefined property or method') ||
      // Mihon extensions, which are Kotlin and fail their own way. #935 is a
      // source answering 500 and the extension's deserialisation reporting a
      // missing field, named by its JVM package.
      text.contains('eu.kanade.tachiyomi.extension') ||
      text.contains("is required for type with serial name") ||
      // LNReader plugins. #936 is a plugin returning a novel with no path.
      // The old wording is still matched because reports keep arriving from
      // builds that predate the clearer message.
      text.contains('path is null') ||
      text.contains('returned a novel with no path');
}

/// A stable key for "this same thing went wrong again".
///
/// The first line only, with digits flattened, so two runs of the same fault
/// match even though their addresses, ids and timestamps differ. #917 and #918
/// are one crash reported twice by one person, which is what this is for.
String fingerprintOf(Object error) {
  final first = error.toString().split('\n').first.trim();
  return first.replaceAll(RegExp(r'\d+'), '#').toLowerCase();
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

  /// Fingerprints the reader has already opened a report for. Kept so the
  /// same fault is not filed twice, which is what #917 and #918 are.
  static final Set<String> _reported = {};

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
        // Earlier builds wrote a bare list. Read it rather than throwing the
        // reader's history away on upgrade.
        final entries = decoded is List
            ? decoded
            : (decoded is Map ? decoded['reports'] as List? : null) ?? const [];
        for (final entry in entries) {
          if (entry is! Map) continue;
          final report = CrashReport.fromJson(Map<String, dynamic>.from(entry));
          if (report != null) _reports.add(report);
        }
        if (decoded is Map) {
          for (final f in (decoded['reported'] as List?) ?? const []) {
            if (f is String) _reported.add(f);
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
  }) {
    try {
      final report = CrashReport(
        time: DateTime.now(),
        source: source,
        error: redact(error.toString()),
        stack: stack == null ? null : _trimStack(redact(stack.toString())),
        screen: _screen,
      );
      _reports.add(report);
      if (!_loaded) _pending.add(report);
      // Kept, but it does not raise the banner: nothing here needs the
      // reader's attention or a bug report.
      if (!isExpectedFailure(error)) _seen = false;
      _trim();
      _flush();
    } catch (_) {}
  }

  /// Whether this fault has already been sent somewhere.
  static bool wasReported(CrashReport report) =>
      _reported.contains(fingerprintOf(report.error));

  /// Records that the reader opened a report for this fault.
  static void markReported(CrashReport report) {
    _reported.add(fingerprintOf(report.error));
    _flush();
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
    _reported.clear();
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
        jsonEncode({
          'reports': _reports.map((e) => e.toJson()).toList(),
          'reported': _reported.toList(),
        }),
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
