import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/download/providers/download_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'state_providers.g.dart';

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
  SortChapter build({required int mangaId}) {
    return isar.settings
        .getSync(227)!
        .sortChapterList!
        .where((element) => element.mangaId == mangaId)
        .toList()
        .first;
  }

  void update(bool reverse, int index) {
    var value = SortChapter()
      ..index = index
      ..mangaId = mangaId
      ..reverse = state.index == index ? !reverse : reverse;
    final settings = isar.settings.getSync(227)!;
    List<SortChapter>? sortChapterList = [];
    for (var sortChapter in settings.sortChapterList!) {
      if (sortChapter.mangaId != mangaId) {
        sortChapterList.add(sortChapter);
      }
    }
    sortChapterList.add(value);
    isar.writeTxnSync(() {
      isar.settings.putSync(settings..sortChapterList = sortChapterList);
    });

    state = value;
  }

  void set(int index) {
    final reverse = isReverse();
    update(reverse, index);
  }

  bool isReverse() {
    return state.reverse!;
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
    return isar.settings
        .getSync(227)!
        .chapterFilterDownloadedList!
        .where((element) => element.mangaId == mangaId)
        .toList()
        .first
        .type!;
  }

  void setType(int type) {
    var value = ChapterFilterDownloaded()
      ..type = type
      ..mangaId = mangaId;
    final settings = isar.settings.getSync(227)!;
    List<ChapterFilterDownloaded>? chapterFilterDownloadedList = [];
    for (var filterChapter in settings.chapterFilterDownloadedList!) {
      if (filterChapter.mangaId != mangaId) {
        chapterFilterDownloadedList.add(filterChapter);
      }
    }
    chapterFilterDownloadedList.add(value);
    isar.writeTxnSync(() {
      isar.settings.putSync(
          settings..chapterFilterDownloadedList = chapterFilterDownloadedList);
    });

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
    return isar.settings
        .getSync(227)!
        .chapterFilterUnreadList!
        .where((element) => element.mangaId == mangaId)
        .toList()
        .first
        .type!;
  }

  void setType(int type) {
    var value = ChapterFilterUnread()
      ..type = type
      ..mangaId = mangaId;
    final settings = isar.settings.getSync(227)!;
    List<ChapterFilterUnread>? chapterFilterUnreadList = [];
    for (var filterChapter in settings.chapterFilterUnreadList!) {
      if (filterChapter.mangaId != mangaId) {
        chapterFilterUnreadList.add(filterChapter);
      }
    }
    chapterFilterUnreadList.add(value);
    isar.writeTxnSync(() {
      isar.settings
          .putSync(settings..chapterFilterUnreadList = chapterFilterUnreadList);
    });
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
    return isar.settings
        .getSync(227)!
        .chapterFilterBookmarkedList!
        .where((element) => element.mangaId == mangaId)
        .toList()
        .first
        .type!;
  }

  void setType(int type) {
    var value = ChapterFilterBookmarked()
      ..type = type
      ..mangaId = mangaId;
    final settings = isar.settings.getSync(227)!;
    List<ChapterFilterBookmarked>? chapterFilterBookmarkedList = [];
    for (var filterChapter in settings.chapterFilterBookmarkedList!) {
      if (filterChapter.mangaId != mangaId) {
        chapterFilterBookmarkedList.add(filterChapter);
      }
    }
    chapterFilterBookmarkedList.add(value);
    isar.writeTxnSync(() {
      isar.settings.putSync(
          settings..chapterFilterBookmarkedList = chapterFilterBookmarkedList);
    });
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
    isar.writeTxnSync(() {
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
    isar.txnSync(() {
      for (var chapter in ref.watch(chaptersListStateProvider)) {
        final entries = isar.downloads
            .filter()
            .idIsNotNull()
            .chapterIdEqualTo(chapter.id)
            .findAllSync();
        if (entries.isEmpty || !entries.first.isDownload!) {
          ref.watch(downloadChapterProvider(chapter: chapter));
        }
      }
    });

    ref.read(chaptersListStateProvider.notifier).clear();
  }
}

@riverpod
class ChaptersListttState extends _$ChaptersListttState {
  @override
  List<Chapter> build() {
    return [];
  }

  set(List<Chapter> chapters) async {
    await Future.delayed(const Duration(milliseconds: 10));
    state = chapters;
  }
}
