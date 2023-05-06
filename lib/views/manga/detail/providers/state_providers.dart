import 'dart:convert';
import 'dart:developer';

import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/views/manga/download/providers/download_provider.dart';
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
        lastPageRead: "",
        mangaId: null);
  }

  void update(ModelChapters chapters) {
    state = chapters;
  }
}

@riverpod
class ChapterIdsListState extends _$ChapterIdsListState {
  @override
  List<ModelChapters> build() {
    return [];
  }

  void update(ModelChapters value) {
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

  void selectAll(ModelChapters value) {
    var newList = state.reversed.toList();
    if (!newList.contains(value)) {
      newList.add(value);
    }

    state = newList;
  }

  void selectSome(ModelChapters value) {
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
class ReverseChapterState extends _$ReverseChapterState {
  @override
  dynamic build({required int mangaId}) {
    return ref.watch(hiveBoxSettingsProvider).get("$mangaId-reverseChapterMap",
        defaultValue: {"reverse": false, "index": 2});
  }

  void update(bool reverse, int index) {
    var value = {
      "reverse": state['index'] == index ? !reverse : reverse,
      "index": index
    };
    ref.watch(hiveBoxSettingsProvider).put("$mangaId-reverseChapterMap", value);
    state = value;
  }

  void set(int index) {
    final reverse = ref
        .read(reverseChapterStateProvider(mangaId: mangaId).notifier)
        .isReverse();
    final sortBySource = ref.watch(sortBySourceStateProvider(mangaId: mangaId));
    final sortByChapterNumber =
        ref.watch(sortByChapterNumberStateProvider(mangaId: mangaId));
    final sortByUploadDate =
        ref.watch(sortByUploadDateStateProvider(mangaId: mangaId));
    update(reverse, index);
    if (index == 0) {
      ref
          .read(sortBySourceStateProvider(mangaId: mangaId).notifier)
          .update(!sortBySource);
    } else if (index == 1) {
      ref
          .read(sortByChapterNumberStateProvider(mangaId: mangaId).notifier)
          .update(!sortByChapterNumber);
    } else {
      ref
          .read(sortByUploadDateStateProvider(mangaId: mangaId).notifier)
          .update(!sortByUploadDate);
    }
  }

  bool isReverse() {
    return state["reverse"];
  }
}

@riverpod
class ChapterFilterDownloadedState extends _$ChapterFilterDownloadedState {
  @override
  int build({required int mangaId}) {
    state = getType();
    return getType();
  }

  int getType() {
    return ref
        .watch(hiveBoxSettingsProvider)
        .get("$mangaId-filterChapterDownload", defaultValue: 0);
  }

  void setType(int type) {
    ref
        .watch(hiveBoxSettingsProvider)
        .put("$mangaId-filterChapterDownload", type);
    state = type;
  }

  void update() {
    if (state == 0) {
      setType(1);
    } else if (state == 1) {
      setType(2);
    } else {
      setType(0);
    }
  }
}

@riverpod
class ChapterFilterUnreadState extends _$ChapterFilterUnreadState {
  @override
  int build({required int mangaId}) {
    state = getType();
    return getType();
  }

  int getType() {
    return ref
        .watch(hiveBoxSettingsProvider)
        .get("$mangaId-filterChapterUnread", defaultValue: 0);
  }

  void setType(int type) {
    ref
        .watch(hiveBoxSettingsProvider)
        .put("$mangaId-filterChapterUnread", type);
    state = type;
  }

  void update() {
    if (state == 0) {
      setType(1);
    } else if (state == 1) {
      setType(2);
    } else {
      setType(0);
    }
  }
}

@riverpod
class ChapterFilterBookmarkedState extends _$ChapterFilterBookmarkedState {
  @override
  int build({required int mangaId}) {
    state = getType();
    return getType();
  }

  int getType() {
    return ref
        .watch(hiveBoxSettingsProvider)
        .get("$mangaId-filterChapterBookMark", defaultValue: 0);
  }

  void setType(int type) {
    ref
        .watch(hiveBoxSettingsProvider)
        .put("$mangaId-filterChapterBookMark", type);
    state = type;
  }

  void update() {
    if (state == 0) {
      setType(1);
    } else if (state == 1) {
      setType(2);
    } else {
      setType(0);
    }
  }
}

@riverpod
class ChapterFilterResultState extends _$ChapterFilterResultState {
  @override
  bool build({required int mangaId}) {
    final downloadFilterType =
        ref.watch(chapterFilterDownloadedStateProvider(mangaId: mangaId));
    final unreadFilterType =
        ref.watch(chapterFilterUnreadStateProvider(mangaId: mangaId));

    final bookmarkedFilterType =
        ref.watch(chapterFilterBookmarkedStateProvider(mangaId: mangaId));
    return downloadFilterType == 0 &&
        unreadFilterType == 0 &&
        bookmarkedFilterType == 0;
  }
}

ModelManga modelMangaWithNewChapValue(
    {required ModelManga modelManga, required List<ModelChapters>? chapters}) {
  return ModelManga(
      imageUrl: modelManga.imageUrl,
      name: modelManga.name,
      genre: modelManga.genre,
      author: modelManga.author,
      description: modelManga.description,
      status: modelManga.status,
      favorite: modelManga.favorite,
      link: modelManga.link,
      source: modelManga.source,
      lang: modelManga.lang,
      dateAdded: modelManga.dateAdded,
      lastUpdate: modelManga.lastUpdate,
      categories: modelManga.categories,
      lastRead: modelManga.lastRead);
}

@riverpod
class ChapterSetIsBookmarkState extends _$ChapterSetIsBookmarkState {
  @override
  build({required ModelManga modelManga}) {}

  set() async {
    final chapters = ref.watch(chapterIdsListStateProvider);
    await isar.writeTxn(() async {
      for (var chapter in chapters) {
        chapter.isBookmarked = !chapter.isBookmarked!;
        await isar.modelChapters.put(chapter..manga.value = modelManga);
        await chapter.manga.save();
      }
    });
    ref.read(isLongPressedStateProvider.notifier).update(false);
    ref.read(chapterIdsListStateProvider.notifier).clear();
  }
}

@riverpod
class ChapterSetIsReadState extends _$ChapterSetIsReadState {
  @override
  build({required ModelManga modelManga}) {}

  set() async {
    final chapters = ref.watch(chapterIdsListStateProvider);
    await isar.writeTxn(() async {
      for (var chapter in chapters) {
        chapter.isRead = !chapter.isRead!;
        await isar.modelChapters.put(chapter..manga.value = modelManga);
        await chapter.manga.save();
      }
    });
    ref.read(isLongPressedStateProvider.notifier).update(false);
    ref.read(chapterIdsListStateProvider.notifier).clear();
  }
}

@riverpod
class ChapterSetDownloadState extends _$ChapterSetDownloadState {
  @override
  build({required ModelManga modelManga}) {}

  set() {
    ref.read(isLongPressedStateProvider.notifier).update(false);
    List<int> indexList = [];
    for (var name in ref.watch(chapterIdsListStateProvider)) {
      for (var i = 0; i < modelManga.chapters.length; i++) {
        if ("$i" == name) {
          indexList.add(i);
        }
      }
    }
    for (var idx in indexList) {
      // final entries = ref
      //     .watch(hiveBoxMangaDownloadsProvider)
      //     .values
      //     .where((element) =>
      //         element.modelManga.chapters.toList()[element.index].name ==
      //         modelManga.chapters.toList()[idx].name)
      //     .toList();
      // if (entries.isEmpty) {
      //   // ref.watch(downloadChapterProvider(modelManga: modelManga, index: idx));
      // } else {
      //   if (!entries.first.isDownload) {
      //     // ref.watch(
      //     //     downloadChapterProvider(modelManga: modelManga, index: idx));
      //   }
      // }
    }
    ref.read(chapterIdsListStateProvider.notifier).clear();
  }
}

@riverpod
class SortByUploadDateState extends _$SortByUploadDateState {
  @override
  bool build({required int mangaId}) {
    return ref
        .watch(hiveBoxSettingsProvider)
        .get("$mangaId-sortByUploadDateChapter", defaultValue: false);
  }

  void update(bool value) {
    ref
        .watch(hiveBoxSettingsProvider)
        .put("$mangaId-sortByUploadDateChapter", value);
    state = value;
  }
}

@riverpod
class SortBySourceState extends _$SortBySourceState {
  @override
  bool build({required int mangaId}) {
    return ref
        .watch(hiveBoxSettingsProvider)
        .get("$mangaId-sortBySourceChapter", defaultValue: false);
  }

  void update(bool value) {
    ref
        .watch(hiveBoxSettingsProvider)
        .put("$mangaId-sortBySourceChapter", value);
    state = value;
  }
}

@riverpod
class SortByChapterNumberState extends _$SortByChapterNumberState {
  @override
  bool build({required int mangaId}) {
    return ref
        .watch(hiveBoxSettingsProvider)
        .get("$mangaId-sortByChapterNumberChapter", defaultValue: false);
  }

  void update(bool value) {
    ref
        .watch(hiveBoxSettingsProvider)
        .put("$mangaId-sortByChapterNumberChapter", value);
    state = value;
  }
}
