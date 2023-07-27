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
  String build({required bool isManga}) {
    return isManga
        ? isar.settings.getSync(227)!.displayType.name
        : isar.settings.getSync(227)!.animeDisplayType.name;
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
    Settings settings = isar.settings.getSync(227)!;
    state = displayType.name;
    if (isManga) {
      settings = settings..displayType = displayType;
    } else {
      settings = settings..animeDisplayType = displayType;
    }

    isar.writeTxnSync(() {
      isar.settings.putSync(settings);
    });
  }
}

@riverpod
class MangaFilterDownloadedState extends _$MangaFilterDownloadedState {
  @override
  int build({required List<Manga> mangaList, required bool isManga}) {
    state = getType();
    return getType();
  }

  int getType() {
    return isManga
        ? isar.settings.getSync(227)!.libraryFilterMangasDownloadType!
        : isar.settings.getSync(227)!.libraryFilterAnimeDownloadType ?? 0;
  }

  void setType(int type) {
    Settings settings = isar.settings.getSync(227)!;
    if (isManga) {
      settings = settings..libraryFilterMangasDownloadType = type;
    } else {
      settings = settings..libraryFilterAnimeDownloadType = type;
    }
    isar.writeTxnSync(() {
      isar.settings.putSync(settings);
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
  int build({required List<Manga> mangaList, required bool isManga}) {
    state = getType();
    return getType();
  }

  int getType() {
    return isManga
        ? isar.settings.getSync(227)!.libraryFilterMangasUnreadType!
        : isar.settings.getSync(227)!.libraryFilterAnimeUnreadType ?? 0;
  }

  void setType(int type) {
    Settings settings = isar.settings.getSync(227)!;
    if (isManga) {
      settings = settings..libraryFilterMangasUnreadType = type;
    } else {
      settings = settings..libraryFilterAnimeUnreadType = type;
    }
    isar.writeTxnSync(() {
      isar.settings.putSync(settings);
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
  int build({required List<Manga> mangaList, required bool isManga}) {
    state = getType();
    return getType();
  }

  int getType() {
    return isManga
        ? isar.settings.getSync(227)!.libraryFilterMangasStartedType!
        : isar.settings.getSync(227)!.libraryFilterAnimeStartedType ?? 0;
  }

  void setType(int type) {
    Settings settings = isar.settings.getSync(227)!;
    if (isManga) {
      settings = settings..libraryFilterMangasStartedType = type;
    } else {
      settings = settings..libraryFilterAnimeStartedType = type;
    }
    isar.writeTxnSync(() {
      isar.settings.putSync(settings);
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
  int build({required List<Manga> mangaList, required bool isManga}) {
    state = getType();
    return getType();
  }

  int getType() {
    return isManga
        ? isar.settings.getSync(227)!.libraryFilterMangasBookMarkedType!
        : isar.settings.getSync(227)!.libraryFilterAnimeBookMarkedType ?? 0;
  }

  void setType(int type) {
    Settings settings = isar.settings.getSync(227)!;
    if (isManga) {
      settings = settings..libraryFilterMangasBookMarkedType = type;
    } else {
      settings = settings..libraryFilterAnimeBookMarkedType = type;
    }
    isar.writeTxnSync(() {
      isar.settings.putSync(settings);
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
  bool build({required List<Manga> mangaList, required bool isManga}) {
    final downloadFilterType = ref.watch(mangaFilterDownloadedStateProvider(
        mangaList: mangaList, isManga: isManga));
    final unreadFilterType = ref.watch(
        mangaFilterUnreadStateProvider(mangaList: mangaList, isManga: isManga));
    final startedFilterType = ref.watch(mangaFilterStartedStateProvider(
        mangaList: mangaList, isManga: isManga));
    final bookmarkedFilterType = ref.watch(mangaFilterBookmarkedStateProvider(
        mangaList: mangaList, isManga: isManga));
    return downloadFilterType == 0 &&
        unreadFilterType == 0 &&
        startedFilterType == 0 &&
        bookmarkedFilterType == 0;
  }
}

@riverpod
class LibraryShowCategoryTabsState extends _$LibraryShowCategoryTabsState {
  @override
  bool build({required bool isManga}) {
    return isManga
        ? isar.settings.getSync(227)!.libraryShowCategoryTabs!
        : isar.settings.getSync(227)!.animeLibraryShowCategoryTabs ?? false;
  }

  void set(bool value) {
    Settings settings = isar.settings.getSync(227)!;
    if (isManga) {
      settings = settings..libraryShowCategoryTabs = value;
    } else {
      settings = settings..animeLibraryShowCategoryTabs = value;
    }
    state = value;
    isar.writeTxnSync(() {
      isar.settings.putSync(settings);
    });
  }
}

@riverpod
class LibraryDownloadedChaptersState extends _$LibraryDownloadedChaptersState {
  @override
  bool build({required bool isManga}) {
    return isManga
        ? isar.settings.getSync(227)!.libraryDownloadedChapters!
        : isar.settings.getSync(227)!.animeLibraryDownloadedChapters ?? false;
  }

  void set(bool value) {
    Settings settings = isar.settings.getSync(227)!;
    if (isManga) {
      settings = settings..libraryDownloadedChapters = value;
    } else {
      settings = settings..animeLibraryDownloadedChapters = value;
    }
    state = value;
    isar.writeTxnSync(() {
      isar.settings.putSync(settings);
    });
  }
}

@riverpod
class LibraryLanguageState extends _$LibraryLanguageState {
  @override
  bool build({required bool isManga}) {
    return isManga
        ? isar.settings.getSync(227)!.libraryShowLanguage!
        : isar.settings.getSync(227)!.animeLibraryShowLanguage ?? false;
  }

  void set(bool value) {
    Settings settings = isar.settings.getSync(227)!;
    if (isManga) {
      settings = settings..libraryShowLanguage = value;
    } else {
      settings = settings..animeLibraryShowLanguage = value;
    }
    state = value;
    isar.writeTxnSync(() {
      isar.settings.putSync(settings);
    });
  }
}

@riverpod
class LibraryLocalSourceState extends _$LibraryLocalSourceState {
  @override
  bool build({required bool isManga}) {
    return isManga
        ? isar.settings.getSync(227)!.libraryLocalSource ?? false
        : isar.settings.getSync(227)!.animeLibraryLocalSource ?? false;
  }

  void set(bool value) {
    Settings settings = isar.settings.getSync(227)!;
    if (isManga) {
      settings = settings..libraryShowLanguage = value;
    } else {
      settings = settings..animeLibraryShowLanguage = value;
    }
    state = value;
    isar.writeTxnSync(() {
      isar.settings.putSync(settings);
    });
  }
}

@riverpod
class LibraryShowNumbersOfItemsState extends _$LibraryShowNumbersOfItemsState {
  @override
  bool build({required bool isManga}) {
    return isManga
        ? isar.settings.getSync(227)!.libraryShowNumbersOfItems!
        : isar.settings.getSync(227)!.animeLibraryShowNumbersOfItems ?? false;
  }

  void set(bool value) {
    Settings settings = isar.settings.getSync(227)!;
    if (isManga) {
      settings = settings..libraryShowNumbersOfItems = value;
    } else {
      settings = settings..animeLibraryShowNumbersOfItems = value;
    }
    state = value;
    isar.writeTxnSync(() {
      isar.settings.putSync(settings);
    });
  }
}

@riverpod
class LibraryShowContinueReadingButtonState
    extends _$LibraryShowContinueReadingButtonState {
  @override
  bool build({required bool isManga}) {
    return isManga
        ? isar.settings.getSync(227)!.libraryShowContinueReadingButton!
        : isar.settings.getSync(227)!.animeLibraryShowContinueReadingButton ??
            false;
  }

  void set(bool value) {
    Settings settings = isar.settings.getSync(227)!;
    if (isManga) {
      settings = settings..libraryShowContinueReadingButton = value;
    } else {
      settings = settings..animeLibraryShowContinueReadingButton = value;
    }
    state = value;
    isar.writeTxnSync(() {
      isar.settings.putSync(settings);
    });
  }
}

@riverpod
class SortLibraryMangaState extends _$SortLibraryMangaState {
  @override
  SortLibraryManga build({required bool isManga}) {
    return isManga
        ? isar.settings.getSync(227)!.sortLibraryManga ?? SortLibraryManga()
        : isar.settings.getSync(227)!.sortLibraryAnime ?? SortLibraryManga();
  }

  void update(bool reverse, int index) {
    var value = SortLibraryManga()
      ..index = index
      ..reverse = state.index == index ? !reverse : reverse;
    Settings settings = isar.settings.getSync(227)!;
    if (isManga) {
      settings = settings..sortLibraryManga = value;
    } else {
      settings = settings..sortLibraryAnime = value;
    }
    isar.writeTxnSync(() {
      final settings = isar.settings.getSync(227)!;
      isar.settings.putSync(settings);
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
