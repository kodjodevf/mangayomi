import 'dart:convert';
import 'dart:developer';

import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/views/manga/download/providers/download_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'state_providers.g.dart';

@riverpod
class ChapterModelState extends _$ChapterModelState {
  @override
  Chapter build() {
    return Chapter(
        name: "",
        url: "",
        dateUpload: "",
        isBookmarked: false,
        scanlator: "",
        isRead: false,
        lastPageRead: "",
        mangaId: null);
  }

  void update(Chapter chapters) {
    state = chapters;
  }
}

@riverpod
class ChaptersListState extends _$ChaptersListState {
  @override
  List<Chapter> build() {
    return [];
  }

  void update(Chapter value) {
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

  void selectAll(Chapter value) {
    var newList = state.reversed.toList();
    if (!newList.contains(value)) {
      newList.add(value);
    }

    state = newList;
  }

  void selectSome(Chapter value) {
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
class SortChapterState extends _$SortChapterState {
  @override
  dynamic build({required int mangaId}) {
    return ref.watch(hiveBoxSettingsProvider).get("$mangaId-sortChapterMap",
        defaultValue: {"reverse": false, "index": 2});
  }

  void update(bool reverse, int index) {
    var value = {
      "reverse": state['index'] == index ? !reverse : reverse,
      "index": index
    };
    ref.watch(hiveBoxSettingsProvider).put("$mangaId-sortChapterMap", value);
    state = value;
  }

  void set(int index) {
    final reverse = isReverse();
    update(reverse, index);
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

Manga mangaWithNewChapValue(
    {required Manga manga, required List<Chapter>? chapters}) {
  return Manga(
    imageUrl: manga.imageUrl,
    name: manga.name,
    genre: manga.genre,
    author: manga.author,
    description: manga.description,
    status: manga.status,
    favorite: manga.favorite,
    link: manga.link,
    source: manga.source,
    lang: manga.lang,
    dateAdded: manga.dateAdded,
    lastUpdate: manga.lastUpdate,
    categories: manga.categories,
  );
}

@riverpod
class ChapterSetIsBookmarkState extends _$ChapterSetIsBookmarkState {
  @override
  build({required Manga manga}) {}

  set() {
    final chapters = ref.watch(chaptersListStateProvider);
    isar.writeTxnSync(() {
      for (var chapter in chapters) {
        chapter.isBookmarked = !chapter.isBookmarked!;
        isar.chapters.putSync(chapter..manga.value = manga);
        chapter.manga.saveSync();
      }
    });
    ref.read(isLongPressedStateProvider.notifier).update(false);
    ref.read(chaptersListStateProvider.notifier).clear();
  }
}

@riverpod
class ChapterSetIsReadState extends _$ChapterSetIsReadState {
  @override
  build({required Manga manga}) {}

  set() {
    final chapters = ref.watch(chaptersListStateProvider);
    isar.writeTxnSync(() async {
      for (var chapter in chapters) {
        chapter.isRead = !chapter.isRead!;
        isar.chapters.putSync(chapter..manga.value = manga);
        chapter.manga.saveSync();
      }
    });
    ref.read(isLongPressedStateProvider.notifier).update(false);
    ref.read(chaptersListStateProvider.notifier).clear();
  }
}

@riverpod
class ChapterSetDownloadState extends _$ChapterSetDownloadState {
  @override
  build({required Manga manga}) {}

  set() {
    ref.read(isLongPressedStateProvider.notifier).update(false);
    for (var chapter in ref.watch(chaptersListStateProvider)) {
      final entries = ref
          .watch(hiveBoxMangaDownloadsProvider)
          .values
          .where((element) =>
              "${element.mangaId}/${element.chapterId}" ==
              "${manga.id}/${chapter.id}")
          .toList();
      if (entries.isEmpty || !entries.first.isDownload) {
        ref.watch(downloadChapterProvider(chapter: chapter));
      }
    }
    ref.read(chaptersListStateProvider.notifier).clear();
  }
}
