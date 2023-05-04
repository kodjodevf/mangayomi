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
  dynamic build({required ModelManga modelManga}) {
    return ref.watch(hiveBoxSettingsProvider).get(
        "${modelManga.source}/${modelManga.name}-reverseChapterMap",
        defaultValue: {"reverse": false, "index": 0});
  }

  void update(bool reverse, int index) {
    var value = {
      "reverse": state['index'] == index ? !reverse : reverse,
      "index": index
    };
    ref.watch(hiveBoxSettingsProvider).put(
        "${modelManga.source}/${modelManga.name}-reverseChapterMap", value);
    state = value;
  }

  void set(int index) {
    final reverse = ref
        .read(reverseChapterStateProvider(modelManga: modelManga).notifier)
        .isReverse();
    final sortBySource =
        ref.watch(sortBySourceStateProvider(modelManga: modelManga));
    final sortByChapterNumber =
        ref.watch(sortByChapterNumberStateProvider(modelManga: modelManga));
    final sortByUploadDate =
        ref.watch(sortByUploadDateStateProvider(modelManga: modelManga));
    update(reverse, index);
    if (index == 0) {
      ref
          .read(sortBySourceStateProvider(modelManga: modelManga).notifier)
          .update(!sortBySource);
    } else if (index == 1) {
      ref
          .read(
              sortByChapterNumberStateProvider(modelManga: modelManga).notifier)
          .update(!sortByChapterNumber);
    } else {
      ref
          .read(sortByUploadDateStateProvider(modelManga: modelManga).notifier)
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
  int build({required ModelManga modelManga}) {
    state = getType();
    return getType();
  }

  int getType() {
    return ref.watch(hiveBoxSettingsProvider).get(
        "${modelManga.source}/${modelManga.name}-filterChapterDownload",
        defaultValue: 0);
  }

  void setType(int type) {
    ref.watch(hiveBoxSettingsProvider).put(
        "${modelManga.source}/${modelManga.name}-filterChapterDownload", type);
    state = type;
  }

  ModelManga getData() {
    if (getType() == 1) {
      List<ModelChapters> chap = [];
      // chap = modelManga.chapters.where((element) {
      //   final modelChapDownload = ref
      //       .watch(hiveBoxMangaDownloadsProvider)
      //       .get(element.name, defaultValue: null);
      //   return modelChapDownload != null &&
      //       modelChapDownload.isDownload == true;
      // }).toList();
      final model =
          modelMangaWithNewChapValue(modelManga: modelManga, chapters: chap);

      return model;
    } else if (getType() == 2) {
      List<ModelChapters> chap = [];
      // chap = modelManga.chapters.where((element) {
      //   final modelChapDownload = ref
      //       .watch(hiveBoxMangaDownloadsProvider)
      //       .get(element.name, defaultValue: null);
      //   return !(modelChapDownload != null &&
      //       modelChapDownload.isDownload == true);
      // }).toList();
      final model =
          modelMangaWithNewChapValue(modelManga: modelManga, chapters: chap);

      return model;
    } else {
      return modelManga;
    }
  }

  ModelManga update() {
    if (state == 0) {
      List<ModelChapters> chap = [];
      // chap = modelManga.chapters!.where((element) {
      //   final modelChapDownload = ref
      //       .watch(hiveBoxMangaDownloadsProvider)
      //       .get(element.name, defaultValue: null);
      //   return modelChapDownload != null &&
      //       modelChapDownload.isDownload == true;
      // }).toList();
      final model =
          modelMangaWithNewChapValue(modelManga: modelManga, chapters: chap);
      setType(1);
      return model;
    } else if (state == 1) {
      List<ModelChapters> chap = [];
      // chap = modelManga.chapters!.where((element) {
      //   final modelChapDownload = ref
      //       .watch(hiveBoxMangaDownloadsProvider)
      //       .get(element.name, defaultValue: null);
      //   return !(modelChapDownload != null &&
      //       modelChapDownload.isDownload == true);
      // }).toList();
      final model =
          modelMangaWithNewChapValue(modelManga: modelManga, chapters: chap);
      setType(2);
      return model;
    } else {
      setType(0);
      return modelManga;
    }
  }
}

@riverpod
class ChapterFilterUnreadState extends _$ChapterFilterUnreadState {
  @override
  int build({required ModelManga modelManga}) {
    state = getType();
    return getType();
  }

  int getType() {
    return ref.watch(hiveBoxSettingsProvider).get(
        "${modelManga.source}/${modelManga.name}-filterChapterUnread",
        defaultValue: 0);
  }

  void setType(int type) {
    ref.watch(hiveBoxSettingsProvider).put(
        "${modelManga.source}/${modelManga.name}-filterChapterUnread", type);
    state = type;
  }

  ModelManga getData() {
    if (getType() == 1) {
      List<ModelChapters> chap = [];
      chap = modelManga.chapters
          .where((element) => element.isRead == false)
          .toList();
      final model =
          modelMangaWithNewChapValue(modelManga: modelManga, chapters: chap);

      return model;
    } else if (getType() == 2) {
      List<ModelChapters> chap = [];
      chap = modelManga.chapters
          .where((element) => element.isRead == true)
          .toList();
      final model =
          modelMangaWithNewChapValue(modelManga: modelManga, chapters: chap);

      return model;
    } else {
      return modelManga;
    }
  }

  ModelManga update() {
    if (state == 0) {
      List<ModelChapters> chap = [];
      chap = modelManga.chapters
          .where((element) => element.isRead == false)
          .toList();
      final model =
          modelMangaWithNewChapValue(modelManga: modelManga, chapters: chap);
      setType(1);
      return model;
    } else if (state == 1) {
      List<ModelChapters> chap = [];
      chap = modelManga.chapters
          .where((element) => element.isRead == false)
          .toList();
      final model =
          modelMangaWithNewChapValue(modelManga: modelManga, chapters: chap);
      setType(2);
      return model;
    } else {
      setType(0);
      return modelManga;
    }
  }
}

@riverpod
class ChapterFilterBookmarkedState extends _$ChapterFilterBookmarkedState {
  @override
  int build({required ModelManga modelManga}) {
    state = getType();
    return getType();
  }

  int getType() {
    return ref.watch(hiveBoxSettingsProvider).get(
        "${modelManga.source}/${modelManga.name}-filterChapterBookMark",
        defaultValue: 0);
  }

  void setType(int type) {
    ref.watch(hiveBoxSettingsProvider).put(
        "${modelManga.source}/${modelManga.name}-filterChapterBookMark", type);
    state = type;
  }

  ModelManga getData() {
    if (getType() == 1) {
      List<ModelChapters> chap = [];
      chap = modelManga.chapters
          .where((element) => element.isBookmarked == true)
          .toList();
      final model =
          modelMangaWithNewChapValue(modelManga: modelManga, chapters: chap);
      return model;
    } else if (getType() == 2) {
      List<ModelChapters> chap = [];
      chap = modelManga.chapters
          .where((element) => element.isBookmarked == false)
          .toList();
      final model =
          modelMangaWithNewChapValue(modelManga: modelManga, chapters: chap);

      return model;
    } else {
      return modelManga;
    }
  }

  ModelManga update() {
    if (state == 0) {
      List<ModelChapters> chap = [];
      chap = modelManga.chapters
          .where((element) => element.isBookmarked == true)
          .toList();
      final model =
          modelMangaWithNewChapValue(modelManga: modelManga, chapters: chap);
      setType(1);
      return model;
    } else if (state == 1) {
      List<ModelChapters> chap = [];
      chap = modelManga.chapters
          .where((element) => element.isBookmarked == false)
          .toList();
      final model =
          modelMangaWithNewChapValue(modelManga: modelManga, chapters: chap);
      setType(2);
      return model;
    } else {
      setType(0);
      return modelManga;
    }
  }
}

@riverpod
class ChapterFilterResultState extends _$ChapterFilterResultState {
  @override
  ModelManga build({required ModelManga modelManga}) {
    int indexSelected =
        ref.watch(reverseChapterStateProvider(modelManga: modelManga))["index"];
    final data1 = ref
        .read(chapterFilterDownloadedStateProvider(modelManga: modelManga)
            .notifier)
        .getData();

    final data2 = ref
        .read(chapterFilterUnreadStateProvider(modelManga: data1).notifier)
        .getData();

    final data3 = ref
        .read(chapterFilterBookmarkedStateProvider(modelManga: data2).notifier)
        .getData();
    if (indexSelected == 0) {
      data3.chapters.toList().sort(
        (a, b) {
          return b.scanlator!.compareTo(a.scanlator!);
        },
      );
    } else if (indexSelected == 1) {
      // data3.chapters!.sort(
      //   (a, b) {
      //     return a.dateUpload!.compareTo(b.dateUpload!);
      //   },
      // );
    } else {
      data3.chapters.toList().sort(
        (a, b) {
          return a.dateUpload!.compareTo(b.dateUpload!);
        },
      );
    }
    return data3;
  }

  bool isNotFiltering() {
    final downloadFilterType =
        ref.watch(chapterFilterDownloadedStateProvider(modelManga: modelManga));
    final unreadFilterType =
        ref.watch(chapterFilterUnreadStateProvider(modelManga: modelManga));

    final bookmarkedFilterType =
        ref.watch(chapterFilterBookmarkedStateProvider(modelManga: modelManga));
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
  bool build({required ModelManga modelManga}) {
    return ref.watch(hiveBoxSettingsProvider).get(
        "${modelManga.source}/${modelManga.name}-sortByUploadDateChapter",
        defaultValue: false);
  }

  void update(bool value) {
    ref.watch(hiveBoxSettingsProvider).put(
        "${modelManga.source}/${modelManga.name}-sortByUploadDateChapter",
        value);
    state = value;
  }
}

@riverpod
class SortBySourceState extends _$SortBySourceState {
  @override
  bool build({required ModelManga modelManga}) {
    return ref.watch(hiveBoxSettingsProvider).get(
        "${modelManga.source}/${modelManga.name}-sortBySourceChapter",
        defaultValue: false);
  }

  void update(bool value) {
    ref.watch(hiveBoxSettingsProvider).put(
        "${modelManga.source}/${modelManga.name}-sortBySourceChapter", value);
    state = value;
  }
}

@riverpod
class SortByChapterNumberState extends _$SortByChapterNumberState {
  @override
  bool build({required ModelManga modelManga}) {
    return ref.watch(hiveBoxSettingsProvider).get(
        "${modelManga.source}/${modelManga.name}-sortByChapterNumberChapter",
        defaultValue: false);
  }

  void update(bool value) {
    ref.watch(hiveBoxSettingsProvider).put(
        "${modelManga.source}/${modelManga.name}-sortByChapterNumberChapter",
        value);
    state = value;
  }
}
