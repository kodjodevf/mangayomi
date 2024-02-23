import 'package:flutter/material.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'library_state_provider.g.dart';

@riverpod
class LibraryDisplayTypeState extends _$LibraryDisplayTypeState {
  @override
  DisplayType build({required bool isManga, required Settings settings}) {
    return isManga ? settings.displayType : settings.animeDisplayType;
  }

  String getLibraryDisplayTypeName(
      DisplayType displayType, BuildContext context) {
    final l10n = context.l10n;
    return switch (displayType) {
      DisplayType.compactGrid => l10n.compact_grid,
      DisplayType.comfortableGrid => l10n.comfortable_grid,
      DisplayType.coverOnlyGrid => l10n.cover_only_grid,
      _ => l10n.list,
    };
  }

  void setLibraryDisplayType(DisplayType displayType) {
    Settings appSettings = Settings();

    state = displayType;
    if (isManga) {
      appSettings = settings..displayType = displayType;
    } else {
      appSettings = settings..animeDisplayType = displayType;
    }

    isar.writeTxnSync(() {
      isar.settings.putSync(appSettings);
    });
  }
}

@riverpod
class MangaFilterDownloadedState extends _$MangaFilterDownloadedState {
  @override
  int build(
      {required List<Manga> mangaList,
      required bool isManga,
      required Settings settings}) {
    state = getType();
    return getType();
  }

  int getType() {
    return isManga
        ? settings.libraryFilterMangasDownloadType!
        : settings.libraryFilterAnimeDownloadType ?? 0;
  }

  void setType(int type) {
    Settings appSettings = Settings();
    if (isManga) {
      appSettings = settings..libraryFilterMangasDownloadType = type;
    } else {
      appSettings = settings..libraryFilterAnimeDownloadType = type;
    }
    isar.writeTxnSync(() {
      isar.settings.putSync(appSettings);
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
  int build(
      {required List<Manga> mangaList,
      required bool isManga,
      required Settings settings}) {
    state = getType();
    return getType();
  }

  int getType() {
    return isManga
        ? settings.libraryFilterMangasUnreadType!
        : settings.libraryFilterAnimeUnreadType ?? 0;
  }

  void setType(int type) {
    Settings appSettings = Settings();
    if (isManga) {
      appSettings = settings..libraryFilterMangasUnreadType = type;
    } else {
      appSettings = settings..libraryFilterAnimeUnreadType = type;
    }
    isar.writeTxnSync(() {
      isar.settings.putSync(appSettings);
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
  int build(
      {required List<Manga> mangaList,
      required bool isManga,
      required Settings settings}) {
    state = getType();
    return getType();
  }

  int getType() {
    return isManga
        ? settings.libraryFilterMangasStartedType!
        : settings.libraryFilterAnimeStartedType ?? 0;
  }

  void setType(int type) {
    Settings appSettings = Settings();
    if (isManga) {
      appSettings = settings..libraryFilterMangasStartedType = type;
    } else {
      appSettings = settings..libraryFilterAnimeStartedType = type;
    }
    isar.writeTxnSync(() {
      isar.settings.putSync(appSettings);
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
  int build(
      {required List<Manga> mangaList,
      required bool isManga,
      required Settings settings}) {
    state = getType();
    return getType();
  }

  int getType() {
    return isManga
        ? settings.libraryFilterMangasBookMarkedType!
        : settings.libraryFilterAnimeBookMarkedType ?? 0;
  }

  void setType(int type) {
    Settings appSettings = Settings();
    if (isManga) {
      appSettings = settings..libraryFilterMangasBookMarkedType = type;
    } else {
      appSettings = settings..libraryFilterAnimeBookMarkedType = type;
    }
    isar.writeTxnSync(() {
      isar.settings.putSync(appSettings);
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
  bool build(
      {required List<Manga> mangaList,
      required bool isManga,
      required Settings settings}) {
    final downloadFilterType = ref.watch(mangaFilterDownloadedStateProvider(
        mangaList: mangaList, isManga: isManga, settings: settings));
    final unreadFilterType = ref.watch(mangaFilterUnreadStateProvider(
        mangaList: mangaList, isManga: isManga, settings: settings));
    final startedFilterType = ref.watch(mangaFilterStartedStateProvider(
        mangaList: mangaList, isManga: isManga, settings: settings));
    final bookmarkedFilterType = ref.watch(mangaFilterBookmarkedStateProvider(
        mangaList: mangaList, isManga: isManga, settings: settings));
    return downloadFilterType == 0 &&
        unreadFilterType == 0 &&
        startedFilterType == 0 &&
        bookmarkedFilterType == 0;
  }
}

@riverpod
class LibraryShowCategoryTabsState extends _$LibraryShowCategoryTabsState {
  @override
  bool build({required bool isManga, required Settings settings}) {
    return isManga
        ? settings.libraryShowCategoryTabs!
        : settings.animeLibraryShowCategoryTabs ?? false;
  }

  void set(bool value) {
    Settings appSettings = Settings();
    if (isManga) {
      appSettings = settings..libraryShowCategoryTabs = value;
    } else {
      appSettings = settings..animeLibraryShowCategoryTabs = value;
    }
    state = value;
    isar.writeTxnSync(() {
      isar.settings.putSync(appSettings);
    });
  }
}

@riverpod
class LibraryDownloadedChaptersState extends _$LibraryDownloadedChaptersState {
  @override
  bool build({required bool isManga, required Settings settings}) {
    return isManga
        ? settings.libraryDownloadedChapters!
        : settings.animeLibraryDownloadedChapters ?? false;
  }

  void set(bool value) {
    Settings appSettings = Settings();
    if (isManga) {
      appSettings = settings..libraryDownloadedChapters = value;
    } else {
      appSettings = settings..animeLibraryDownloadedChapters = value;
    }
    state = value;
    isar.writeTxnSync(() {
      isar.settings.putSync(appSettings);
    });
  }
}

@riverpod
class LibraryLanguageState extends _$LibraryLanguageState {
  @override
  bool build({required bool isManga, required Settings settings}) {
    return isManga
        ? settings.libraryShowLanguage!
        : settings.animeLibraryShowLanguage ?? false;
  }

  void set(bool value) {
    Settings appSettings = Settings();
    if (isManga) {
      appSettings = settings..libraryShowLanguage = value;
    } else {
      appSettings = settings..animeLibraryShowLanguage = value;
    }
    state = value;
    isar.writeTxnSync(() {
      isar.settings.putSync(appSettings);
    });
  }
}

@riverpod
class LibraryLocalSourceState extends _$LibraryLocalSourceState {
  @override
  bool build({required bool isManga, required Settings settings}) {
    return isManga
        ? settings.libraryLocalSource ?? false
        : settings.animeLibraryLocalSource ?? false;
  }

  void set(bool value) {
    Settings appSettings = Settings();
    if (isManga) {
      appSettings = settings..libraryShowLanguage = value;
    } else {
      appSettings = settings..animeLibraryShowLanguage = value;
    }
    state = value;
    isar.writeTxnSync(() {
      isar.settings.putSync(appSettings);
    });
  }
}

@riverpod
class LibraryShowNumbersOfItemsState extends _$LibraryShowNumbersOfItemsState {
  @override
  bool build({required bool isManga, required Settings settings}) {
    return isManga
        ? settings.libraryShowNumbersOfItems!
        : settings.animeLibraryShowNumbersOfItems ?? false;
  }

  void set(bool value) {
    Settings appSettings = Settings();
    if (isManga) {
      appSettings = settings..libraryShowNumbersOfItems = value;
    } else {
      appSettings = settings..animeLibraryShowNumbersOfItems = value;
    }
    state = value;
    isar.writeTxnSync(() {
      isar.settings.putSync(appSettings);
    });
  }
}

@riverpod
class LibraryShowContinueReadingButtonState
    extends _$LibraryShowContinueReadingButtonState {
  @override
  bool build({required bool isManga, required Settings settings}) {
    return isManga
        ? settings.libraryShowContinueReadingButton!
        : settings.animeLibraryShowContinueReadingButton ?? false;
  }

  void set(bool value) {
    Settings appSettings = Settings();
    if (isManga) {
      appSettings = settings..libraryShowContinueReadingButton = value;
    } else {
      appSettings = settings..animeLibraryShowContinueReadingButton = value;
    }
    state = value;
    isar.writeTxnSync(() {
      isar.settings.putSync(appSettings);
    });
  }
}

@riverpod
class SortLibraryMangaState extends _$SortLibraryMangaState {
  @override
  SortLibraryManga build({required bool isManga, required Settings settings}) {
    return isManga
        ? settings.sortLibraryManga ?? SortLibraryManga()
        : settings.sortLibraryAnime ?? SortLibraryManga();
  }

  void update(bool reverse, int index) {
    Settings appSettings = Settings();
    var value = SortLibraryManga()
      ..index = index
      ..reverse = state.index == index ? !reverse : reverse;

    if (isManga) {
      appSettings = settings..sortLibraryManga = value;
    } else {
      appSettings = settings..sortLibraryAnime = value;
    }
    isar.writeTxnSync(() {
      isar.settings.putSync(appSettings);
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
  void build({required List<int> mangaIds}) {}

  void set() {
    for (var mangaid in mangaIds) {
      final manga = isar.mangas.getSync(mangaid)!;
      final chapters = manga.chapters;
      if (chapters.isNotEmpty) {
        chapters.last.updateTrackChapterRead(ref);
        isar.writeTxnSync(() {
          for (var chapter in chapters) {
            chapter.isRead = true;
            chapter.lastPageRead = "1";
            isar.chapters.putSync(chapter..manga.value = manga);
            chapter.manga.saveSync();
          }
        });
      }
    }

    ref.read(isLongPressedMangaStateProvider.notifier).update(false);
    ref.read(mangasListStateProvider.notifier).clear();
  }
}

@riverpod
class MangasSetUnReadState extends _$MangasSetUnReadState {
  @override
  void build({required List<int> mangaIds}) {}

  void set() {
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
