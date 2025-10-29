// ignore_for_file: library_private_types_in_public_api

import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

class _ValueNotifier<T> extends riverpod.Notifier<T> {
  _ValueNotifier(this._initialValue);
  final T _initialValue;

  @override
  abstract T state;

  @override
  T build() => _initialValue;
}

/// Returns a NotifierProvider for the given value creator.
// ignore: non_constant_identifier_names
riverpod.NotifierProvider<_ValueNotifier<T>, T> StateProvider<T>(
  T Function() create,
) {
  return riverpod.NotifierProvider<_ValueNotifier<T>, T>(
    () => _ValueNotifier<T>(create()),
  );
}
