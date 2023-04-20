import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'state_providers.g.dart';
// final reverseMangaStateProvider = StateProvider.autoDispose<bool>(
//   (ref) => false,
// );

// final sortedMangaValueStateProvider = StateProvider.autoDispose<String>(
//   (ref) => 'By source',
// );

@riverpod
class ChapterModelState extends _$ChapterModelState {
  @override
  ModelChapters build() {
    return ModelChapters(
        name: "",
        url: "",
        dateUpload: "",
        isBookmarked: false,
        scanlator: "",
        isRead: false,
        lastPageRead: "");
  }

  void update(ModelChapters chapters) {
    state = chapters;
  }
}

@riverpod
class ChapterIndexState extends _$ChapterIndexState {
  @override
  int build() {
    return -1;
  }

  void update(int value) {
    state = value;
  }
}

@riverpod
class IsLongPressedState extends _$IsLongPressedState {
  @override
  bool build() {
    return false;
  }

  void update(bool value) {
    state = value;
  }
}

@riverpod
class IsExtendedState extends _$IsExtendedState {
  @override
  bool build() {
    return true;
  }

  void update(bool value) {
    state = value;
  }
}

@riverpod
class ReverseMangaState extends _$ReverseMangaState {
  @override
  bool build() {
    return false;
  }

  void update(bool value) {
    state = value;
  }
}
