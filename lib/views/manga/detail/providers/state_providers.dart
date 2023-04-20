import 'dart:developer';

import 'package:mangayomi/models/model_manga.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'state_providers.g.dart';

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
class ChapterIndexListState extends _$ChapterIndexListState {
  @override
  List<int> build() {
    return [];
  }

  void update(int value) {
    var newList = state.reversed.toList();
    if (newList.contains(value)) {
      newList.remove(value);
    } else {
      newList.add(value);
    }
    if (newList.isEmpty) {
      ref.read(isLongPressedStateProvider.notifier).update(false);
    }
    state = newList;
  }

  void selectAll(int value) {
    var newList = state.reversed.toList();
    if (!newList.contains(value)) {
      newList.add(value);
    }

    state = newList;
  }

  void selectSome(int value) {
    var newList = state.reversed.toList();
    if (newList.contains(value)) {
      newList.remove(value);
    } else {
      newList.add(value);
    }
    state = newList;
  }

  void clear() {
    state = [];
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
