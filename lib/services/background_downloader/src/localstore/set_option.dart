part of 'localstore.dart';

/// An options class that configures the behavior of set() calls in
/// [DocumentRef].
final class SetOptions {
  final bool _merge;

  /// Changes the behavior of a set() call to only replace the values specified
  /// in its data argument.
  bool get merge => _merge;

  /// Creates a [SetOptions] instance.
  SetOptions({bool merge = false}) : _merge = merge;
}
