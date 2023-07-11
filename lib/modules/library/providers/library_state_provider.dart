import 'package:flutter/material.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'library_state_provider.g.dart';

@riverpod
class LibraryDisplayTypeState extends _$LibraryDisplayTypeState {
  @override
  String build() {
    return isar.settings.getSync(227)!.displayType.name;
  }

  DisplayType getLibraryDisplayTypeValue(String value) {
    return value == DisplayType.compactGrid.name
        ? DisplayType.compactGrid
        : value == DisplayType.list.name
            ? DisplayType.list
            : value == DisplayType.comfortableGrid.name
                ? DisplayType.comfortableGrid
                : DisplayType.coverOnlyGrid;
  }

  String getLibraryDisplayTypeName(String displayType, BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    return displayType == DisplayType.compactGrid.name
        ? l10n.compact_grid
        : displayType == DisplayType.list.name
            ? l10n.list
            : displayType == DisplayType.comfortableGrid.name
                ? l10n.comfortable_grid
                : l10n.cover_only_grid;
  }

  void setLibraryDisplayType(DisplayType displayType) {
    final settings = isar.settings.getSync(227)!;
    state = displayType.name;
    isar.writeTxnSync(() {
      isar.settings.putSync(settings..displayType = displayType);
    });
  }
}

@riverpod
class MangaFilterDownloadedState extends _$MangaFilterDownloadedState {
  @override
  int build({required List<Manga> mangaList}) {
    state = getType();
    return getType();
  }

  int getType() {
    return isar.settings.getSync(227)!.libraryFilterMangasDownloadType!;
  }

  void setType(int type) {
    final settings = isar.settings.getSync(227)!;
    isar.writeTxnSync(() {
      isar.settings.putSync(settings..libraryFilterMangasDownloadType = type);
    });
    state = type;
  }

  update() {
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
class MangaFilterUnreadState extends _$MangaFilterUnreadState {
  @override
  int build({required List<Manga> mangaList}) {
    state = getType();
    return getType();
  }

  int getType() {
    return isar.settings.getSync(227)!.libraryFilterMangasUnreadType!;
  }

  void setType(int type) {
    final settings = isar.settings.getSync(227)!;
    isar.writeTxnSync(() {
      isar.settings.putSync(settings..libraryFilterMangasUnreadType = type);
    });
    state = type;
  }

  List<Manga> getData() {
    if (getType() == 1) {
      final data = mangaList.where((element) {
        List list = [];
        for (var chap in element.chapters) {
          if (!chap.isRead!) {
            list.add(true);
          }
        }
        return list.isNotEmpty;
      }).toList();
      return data;
    } else if (getType() == 2) {
      final data = mangaList.where((element) {
        List list = [];
        for (var chap in element.chapters) {
          if (chap.isRead!) {
            list.add(true);
          }
        }
        return list.length == element.chapters.length;
      }).toList();
      return data;
    } else {
      return mangaList;
    }
  }

  update() {
    if (state == 0) {
      final data = mangaList.where((element) {
        List list = [];
        for (var chap in element.chapters) {
          if (!chap.isRead!) {
            list.add(true);
          }
        }
        return list.isNotEmpty;
      }).toList();
      setType(1);
      return data;
    } else if (state == 1) {
      final data = mangaList.where((element) {
        List list = [];
        for (var chap in element.chapters) {
          if (chap.isRead!) {
            list.add(true);
          }
        }
        return list.length == element.chapters.length;
      }).toList();
      setType(2);
      return data;
    } else {
      setType(0);
      return mangaList;
    }
  }
}

@riverpod
class MangaFilterStartedState extends _$MangaFilterStartedState {
  @override
  int build({required List<Manga> mangaList}) {
    state = getType();
    return getType();
  }

  int getType() {
    return isar.settings.getSync(227)!.libraryFilterMangasStartedType!;
  }

  void setType(int type) {
    final settings = isar.settings.getSync(227)!;
    isar.writeTxnSync(() {
      isar.settings.putSync(settings..libraryFilterMangasStartedType = type);
    });
    state = type;
  }

  List<Manga> getData() {
    if (getType() == 1) {
      final data = mangaList.where((element) {
        List list = [];
        for (var chap in element.chapters) {
          if (!chap.isRead!) {
            list.add(true);
          }
        }
        return list.isNotEmpty;
      }).toList();
      return data;
    } else if (getType() == 2) {
      final data = mangaList.where((element) {
        List list = [];
        for (var chap in element.chapters) {
          if (chap.isRead!) {
            list.add(true);
          }
        }
        return list.length == element.chapters.length;
      }).toList();
      return data;
    } else {
      return mangaList;
    }
  }

  List<Manga> update() {
    if (state == 0) {
      final data = mangaList.where((element) {
        List list = [];
        for (var chap in element.chapters) {
          if (!chap.isRead!) {
            list.add(true);
          }
        }
        return list.isNotEmpty;
      }).toList();
      setType(1);
      return data;
    } else if (state == 1) {
      final data = mangaList.where((element) {
        List list = [];
        for (var chap in element.chapters) {
          if (chap.isRead!) {
            list.add(true);
          }
        }
        return list.length == element.chapters.length;
      }).toList();
      setType(2);
      return data;
    } else {
      setType(0);
      return mangaList;
    }
  }
}

@riverpod
class MangaFilterBookmarkedState extends _$MangaFilterBookmarkedState {
  @override
  int build({required List<Manga> mangaList}) {
    state = getType();
    return getType();
  }

  int getType() {
    return isar.settings.getSync(227)!.libraryFilterMangasBookMarkedType!;
  }

  void setType(int type) {
    final settings = isar.settings.getSync(227)!;
    isar.writeTxnSync(() {
      isar.settings.putSync(settings..libraryFilterMangasBookMarkedType = type);
    });
    state = type;
  }

  List<Manga> getData() {
    if (getType() == 1) {
      final data = mangaList.where((element) {
        List list = [];
        for (var chap in element.chapters) {
          if (chap.isBookmarked!) {
            list.add(true);
          }
        }
        return list.isNotEmpty;
      }).toList();
      return data;
    } else if (getType() == 2) {
      final data = mangaList.where((element) {
        List list = [];
        for (var chap in element.chapters) {
          if (!chap.isBookmarked!) {
            list.add(true);
          }
        }
        return list.length == element.chapters.length;
      }).toList();
      return data;
    } else {
      return mangaList;
    }
  }

  List<Manga> update() {
    if (state == 0) {
      final data = mangaList.where((element) {
        List list = [];
        for (var chap in element.chapters) {
          if (chap.isBookmarked!) {
            list.add(true);
          }
        }
        return list.isNotEmpty;
      }).toList();
      setType(1);
      return data;
    } else if (state == 1) {
      final data = mangaList.where((element) {
        List list = [];
        for (var chap in element.chapters) {
          if (!chap.isBookmarked!) {
            list.add(true);
          }
        }
        return list.length == element.chapters.length;
      }).toList();
      setType(2);
      return data;
    } else {
      setType(0);
      return mangaList;
    }
  }
}

@riverpod
class MangasFilterResultState extends _$MangasFilterResultState {
  @override
  bool build({required List<Manga> mangaList}) {
    final downloadFilterType =
        ref.watch(mangaFilterDownloadedStateProvider(mangaList: mangaList));
    final unreadFilterType =
        ref.watch(mangaFilterUnreadStateProvider(mangaList: mangaList));
    final startedFilterType =
        ref.watch(mangaFilterStartedStateProvider(mangaList: mangaList));
    final bookmarkedFilterType =
        ref.watch(mangaFilterBookmarkedStateProvider(mangaList: mangaList));
    return downloadFilterType == 0 &&
        unreadFilterType == 0 &&
        startedFilterType == 0 &&
        bookmarkedFilterType == 0;
  }
}

@riverpod
class LibraryShowCategoryTabsState extends _$LibraryShowCategoryTabsState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.libraryShowCategoryTabs!;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227)!;
    state = value;
    isar.writeTxnSync(() {
      isar.settings.putSync(settings..libraryShowCategoryTabs = value);
    });
  }
}

@riverpod
class LibraryDownloadedChaptersState extends _$LibraryDownloadedChaptersState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.libraryDownloadedChapters!;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227)!;
    state = value;
    isar.writeTxnSync(() {
      isar.settings.putSync(settings..libraryDownloadedChapters = value);
    });
  }
}

@riverpod
class LibraryLanguageState extends _$LibraryLanguageState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.libraryShowLanguage!;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227)!;
    state = value;
    isar.writeTxnSync(() {
      isar.settings.putSync(settings..libraryShowLanguage = value);
    });
  }
}

@riverpod
class LibraryLocalSourceState extends _$LibraryLocalSourceState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.libraryLocalSource ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227)!;
    state = value;
    isar.writeTxnSync(() {
      isar.settings.putSync(settings..libraryShowLanguage = value);
    });
  }
}

@riverpod
class LibraryShowNumbersOfItemsState extends _$LibraryShowNumbersOfItemsState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.libraryShowNumbersOfItems!;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227)!;
    state = value;
    isar.writeTxnSync(() {
      isar.settings.putSync(settings..libraryShowNumbersOfItems = value);
    });
  }
}

@riverpod
class LibraryShowContinueReadingButtonState
    extends _$LibraryShowContinueReadingButtonState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.libraryShowContinueReadingButton!;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227)!;
    state = value;
    isar.writeTxnSync(() {
      isar.settings.putSync(settings..libraryShowContinueReadingButton = value);
    });
  }
}

@riverpod
class SortLibraryMangaState extends _$SortLibraryMangaState {
  @override
  SortLibraryManga build() {
    return isar.settings.getSync(227)!.sortLibraryManga ?? SortLibraryManga();
  }

  void update(bool reverse, int index) {
    var value = SortLibraryManga()
      ..index = index
      ..reverse = state.index == index ? !reverse : reverse;

    isar.writeTxnSync(() {
      final settings = isar.settings.getSync(227)!;
      isar.settings.putSync(settings..sortLibraryManga = value);
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
class MangasListState extends _$MangasListState {
  @override
  List<int> build() {
    return [];
  }

  void update(Manga value) {
    var newList = state.reversed.toList();
    if (newList.contains(value.id)) {
      newList.remove(value.id);
    } else {
      newList.add(value.id!);
    }
    if (newList.isEmpty) {
      ref.read(isLongPressedMangaStateProvider.notifier).update(false);
    }
    state = newList;
  }

  void selectAll(Manga value) {
    var newList = state.reversed.toList();
    if (!newList.contains(value.id)) {
      newList.add(value.id!);
    }

    state = newList;
  }

  void selectSome(Manga value) {
    var newList = state.reversed.toList();
    if (newList.contains(value.id)) {
      newList.remove(value.id);
    } else {
      newList.add(value.id!);
    }
    state = newList;
  }

  void clear() {
    state = [];
  }
}

@riverpod
class IsLongPressedMangaState extends _$IsLongPressedMangaState {
  @override
  bool build() {
    return false;
  }

  void update(bool value) {
    state = value;
  }
}

@riverpod
class MangasSetIsReadState extends _$MangasSetIsReadState {
  @override
  build({required List<int> mangaIds}) {}

  set() {
    for (var mangaid in mangaIds) {
      final manga = isar.mangas.getSync(mangaid)!;
      final chapters = manga.chapters;
      isar.writeTxnSync(() {
        for (var chapter in chapters) {
          chapter.isRead = true;
          isar.chapters.putSync(chapter..manga.value = manga);
          chapter.manga.saveSync();
        }
      });
    }

    ref.read(isLongPressedMangaStateProvider.notifier).update(false);
    ref.read(mangasListStateProvider.notifier).clear();
  }
}

@riverpod
class MangasSetUnReadState extends _$MangasSetUnReadState {
  @override
  build({required List<int> mangaIds}) {}

  set() {
    for (var mangaid in mangaIds) {
      final manga = isar.mangas.getSync(mangaid)!;
      final chapters = manga.chapters;
      isar.writeTxnSync(() {
        for (var chapter in chapters) {
          chapter.isRead = false;
          isar.chapters.putSync(chapter..manga.value = manga);
          chapter.manga.saveSync();
        }
      });
    }

    ref.read(isLongPressedMangaStateProvider.notifier).update(false);
    ref.read(mangasListStateProvider.notifier).clear();
  }
}
