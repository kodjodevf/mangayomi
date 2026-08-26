/// Error types originating from Aidoku WebAssembly sources.
sealed class SourceError implements Exception {
  const SourceError();

  factory SourceError.fromCode(int code, [String? message]) {
    switch (code) {
      case -2:
        return const SourceErrorUnimplemented();
      case -3:
        return const SourceErrorNetwork();
      case -4:
        return const SourceErrorHtml();
      case -5:
        return const SourceErrorJs();
      case -6:
        return const SourceErrorCanvas();
      case -7:
        return const SourceErrorUtf8();
      case -8:
        return const SourceErrorJsonParse();
      case -9:
        return const SourceErrorDeserialize();
      default:
        if (message != null && message.isNotEmpty) {
          return SourceErrorMessage(message);
        }
        return const SourceErrorMissingResult();
    }
  }
}

class SourceErrorMissingResult extends SourceError {
  const SourceErrorMissingResult();
  @override
  String toString() => 'SourceError: missing result';
}

class SourceErrorUnimplemented extends SourceError {
  const SourceErrorUnimplemented();
  @override
  String toString() => 'SourceError: unimplemented';
}

class SourceErrorNetwork extends SourceError {
  const SourceErrorNetwork();
  @override
  String toString() => 'SourceError: network error';
}

class SourceErrorMessage extends SourceError {
  const SourceErrorMessage(this.message);
  final String message;
  @override
  String toString() => 'SourceError: $message';
}

class SourceErrorHtml extends SourceError {
  const SourceErrorHtml();
  @override
  String toString() => 'SourceError: HTML parse/query error';
}

class SourceErrorJs extends SourceError {
  const SourceErrorJs();
  @override
  String toString() => 'SourceError: JavaScript evaluation error';
}

class SourceErrorCanvas extends SourceError {
  const SourceErrorCanvas();
  @override
  String toString() => 'SourceError: canvas error';
}

class SourceErrorUtf8 extends SourceError {
  const SourceErrorUtf8();
  @override
  String toString() => 'SourceError: UTF-8 encoding error';
}

class SourceErrorJsonParse extends SourceError {
  const SourceErrorJsonParse();
  @override
  String toString() => 'SourceError: JSON parse error';
}

class SourceErrorDeserialize extends SourceError {
  const SourceErrorDeserialize();
  @override
  String toString() => 'SourceError: deserialization error';
}
