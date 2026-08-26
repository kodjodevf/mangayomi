/// Reading what a JS source reported when it went wrong.
///
/// `flutter_qjs` reports a failure by returning a `JsEvalResult` with `isError`
/// set. It does not throw. Code that ignores the returned value therefore
/// cannot tell a working source from a broken one, which is how a source that
/// failed to evaluate ended up looking like a source that returned nothing:
/// "Video list is empty" (#873).
library;

/// Whether [message] is the base class saying a source does not implement an
/// optional method, rather than the source going wrong.
///
/// `MProvider` throws `"<name> not implemented"` on purpose for anything a
/// source chooses not to define, and falling back to a default there is
/// correct. Everything else has to reach the reader.
bool isNotImplementedError(String message) =>
    message.contains('not implemented');

/// What to tell the reader when a source fails.
///
/// Names the source and repeats what it actually said. The old behaviour was
/// either silence or a JSON parse failure, neither of which says which source
/// broke, or why, or that the problem is the source at all.
String jsExtensionErrorMessage({
  required String sourceName,
  required String whileDoing,
  required String reported,
}) {
  final detail = reported.trim();
  return 'Extension "$sourceName" failed while $whileDoing'
      '${detail.isEmpty ? '' : ': $detail'}';
}
