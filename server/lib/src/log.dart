// What the server says while it runs, on stderr, so stdout stays for what a
// command was asked to print.
import 'dart:io';

enum LogLevel { fine, info, error }

class Log {
  const Log({this.level = LogLevel.info, this.sink}) : _silent = false;

  const Log.silent() : level = LogLevel.error, sink = null, _silent = true;

  final LogLevel level;
  final IOSink? sink;
  final bool _silent;

  void fine(String message) => _write(LogLevel.fine, message);

  void info(String message) => _write(LogLevel.info, message);

  void error(String message, [Object? error, StackTrace? stack]) =>
      _write(LogLevel.error, [message, ?error, ?stack].join('\n'));

  void _write(LogLevel at, String message) {
    if (_silent || at.index < level.index) return;
    final time = DateTime.now().toIso8601String().substring(0, 19);
    (sink ?? stderr).writeln(
      '$time ${at.name.toUpperCase().padRight(5)} $message',
    );
  }
}
