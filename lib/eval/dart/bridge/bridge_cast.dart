import 'package:d4rt/d4rt.dart';

/// Casts what an extension assigned to a list-typed bridged property, and says
/// something useful when it is not a list.
///
/// The interpreter's own message for a failed cast names two Dart types and
/// stops there. Worse, when the assignment happens inside a callback the
/// interpreter reports it against whatever bridged method was running the
/// callback, so `manga.chapters = xs.toList` inside a `forEach` surfaces as
/// "Native error during bridged method call 'forEach' on List: type
/// 'BridgedMethodCallable' is not a subtype of type 'List<dynamic>?'". That
/// names neither the property nor the mistake, and the extension author has no
/// way to work back to the line.
List<T>? asBridgedList<T>(Object? value, String property) {
  if (value == null) return null;
  if (value is List) return value.cast<T>();
  if (value is Callable) {
    throw ArgumentError(
      '$property expects a list, and was given a method rather than the '
      'result of calling one. A missing () is the usual cause, as in '
      '`$property = something.toList` instead of `$property = '
      'something.toList()`.',
    );
  }
  throw ArgumentError(
    '$property expects a list, and was given ${value.runtimeType}.',
  );
}

/// The map equivalent of [asBridgedList], for the same reason.
Map<K, V>? asBridgedMap<K, V>(Object? value, String property) {
  if (value == null) return null;
  if (value is Map) return value.cast<K, V>();
  if (value is Callable) {
    throw ArgumentError(
      '$property expects a map, and was given a method rather than the result '
      'of calling one. A missing () is the usual cause.',
    );
  }
  throw ArgumentError(
    '$property expects a map, and was given ${value.runtimeType}.',
  );
}
