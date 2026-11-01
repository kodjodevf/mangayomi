import 'dart:io';
import 'dart:math';

/// A server asked the download to slow down: 429 Too Many Requests, or 503
/// Service Unavailable. [retryAfter] is how long it asked to wait, when it
/// said.
class RateLimitedException implements Exception {
  final int statusCode;
  final Duration? retryAfter;

  const RateLimitedException(this.statusCode, {this.retryAfter});

  /// The exception for a response with [statusCode] and a `Retry-After`
  /// header of [retryAfter], or null when the status is not one that asks
  /// to slow down.
  static RateLimitedException? fromResponse(
    int statusCode,
    String? retryAfter,
  ) {
    if (statusCode != 429 && statusCode != 503) return null;
    return RateLimitedException(
      statusCode,
      retryAfter: parseRetryAfter(retryAfter),
    );
  }

  @override
  String toString() =>
      'RateLimitedException: status $statusCode'
      '${retryAfter == null ? '' : ', retry after ${retryAfter!.inSeconds} s'}';
}

/// The wait a `Retry-After` header asks for, given in seconds or as an HTTP
/// date; null when there is none or it cannot be read.
Duration? parseRetryAfter(String? value, {DateTime? now}) {
  if (value == null) return null;
  final trimmed = value.trim();
  final seconds = int.tryParse(trimmed);
  if (seconds != null) return Duration(seconds: max(0, seconds));
  try {
    final wait = HttpDate.parse(trimmed).difference(now ?? DateTime.now());
    return wait.isNegative ? Duration.zero : wait;
  } on FormatException {
    return null;
  } on HttpException {
    return null;
  }
}

/// Attempts allowed when the server asks to slow down: more than for other
/// failures, since waiting is what fixes it.
const rateLimitedAttempts = 6;

/// The longest wait between two attempts, whatever the server asks.
const maxRetryDelay = Duration(seconds: 60);

/// How long to wait before attempt [attempt] + 1: what the server asked
/// for, else half a second doubling with each attempt, up to 16 s.
Duration retryDelay(int attempt, {Duration? retryAfter}) {
  if (retryAfter != null) {
    return retryAfter > maxRetryDelay ? maxRetryDelay : retryAfter;
  }
  final ms = 500 * pow(2, max(0, attempt - 1)).toInt();
  return Duration(milliseconds: min(ms, 16000));
}
