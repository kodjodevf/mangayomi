import 'package:flutter_riverpod/flutter_riverpod.dart';

final reverseStateProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);

final displayValueStateProvider = StateProvider.autoDispose<String>(
  (ref) => 'Compact grid',
);
