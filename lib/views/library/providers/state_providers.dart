import 'package:flutter_riverpod/flutter_riverpod.dart';

final reverseStateProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);

final sortedValueStateProvider = StateProvider.autoDispose<String>(
  (ref) => 'Alphabetically',
);
