import 'package:flutter_riverpod/flutter_riverpod.dart';

final reverseMangaStateProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);

final sortedMangaValueStateProvider = StateProvider.autoDispose<String>(
  (ref) => 'By source',
);
