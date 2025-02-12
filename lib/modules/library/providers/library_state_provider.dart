import 'package:flutter/material.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'library_state_provider.g.dart';

@riverpod
class LibraryDisplayTypeState extends _$LibraryDisplayTypeState {
  @override
  DisplayType build({required ItemType itemType, required Settings settings}) {
    switch (itemType) {
      case ItemType.manga:
        return settings.displayType;
      case ItemType.anime:
        return settings.animeDisplayType;
      default:
        return settings.novelDisplayType;
    }
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

    switch (itemType) {
      case ItemType.manga:
        appSettings = settings..displayType = displayType;
        break;
      case ItemType.anime:
        appSettings = settings..animeDisplayType = displayType;
        break;
      default:
        appSettings = settings..novelDisplayType = displayType;
    }

    isar.writeTxnSync(() {
      isar.settings.putSync(appSettings);
    });
  }
}

@riverpod
class LibraryGridSizeState extends _$LibraryGridSizeState {
  @override
  int? build({required ItemType itemType}) {
    switch (itemType) {
      case ItemType.manga:
        return settings.mangaGridSize;
      case ItemType.anime:
        return settings.animeGridSize;
      default:
        return settings.novelGridSize;
    }
  }

  Settings get settings {
    return isar.settings.getSync(227)!;
  }

  void set(int? value, {bool end = false}) {
    Settings appSettings = Settings();

    state = value;
    if (end) {
      switch (itemType) {
        case ItemType.manga:
          appSettings = settings..mangaGridSize = value;
          break;
        case ItemType.anime:
          appSettings = settings..animeGridSize = value;
          break;
        default:
          appSettings = settings..novelGridSize = value;
      }

      isar.writeTxnSync(() {
        isar.settings.putSync(appSettings);
      });
    }
  }
}

@riverpod
class MangaFilterDownloadedState extends _$MangaFilterDownloadedState {
  @override
  int build(
      {required List<Manga> mangaList,
      required ItemType itemType,
      required Settings settings}) {
    state = getType();
    return getType();
  }

  int getType() {
    switch (itemType) {
      case ItemType.manga:
        return settings.libraryFilterMangasDownloadType!;
      case ItemType.anime:
        return settings.libraryFilterAnimeDownloadType!;
      default:
        return settings.libraryFilterNovelDownloadType ?? 0;
    }
  }

  void setType(int type) {
    Settings appSettings = Settings();
    switch (itemType) {
      case ItemType.manga:
        appSettings = settings..libraryFilterMangasDownloadType = type;
        break;
      case ItemType.anime:
        appSettings = settings..libraryFilterAnimeDownloadType = type;
        break;
      default:
        appSettings = settings..libraryFilterNovelDownloadType = type;
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
      required ItemType itemType,
      required Settings settings}) {
    state = getType();
    return getType();
  }

  int getType() {
    switch (itemType) {
      case ItemType.manga:
        return settings.libraryFilterMangasUnreadType!;
      case ItemType.anime:
        return settings.libraryFilterAnimeUnreadType!;
      default:
        return settings.libraryFilterNovelUnreadType ?? 0;
    }
  }

  void setType(int type) {
    Settings appSettings = Settings();
    switch (itemType) {
      case ItemType.manga:
        appSettings = settings..libraryFilterMangasUnreadType = type;
        break;
      case ItemType.anime:
        appSettings = settings..libraryFilterAnimeUnreadType = type;
        break;
      default:
        appSettings = settings..libraryFilterNovelUnreadType = type;
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
      required ItemType itemType,
      required Settings settings}) {
    state = getType();
    return getType();
  }

  int getType() {
    switch (itemType) {
      case ItemType.manga:
        return settings.libraryFilterMangasStartedType!;
      case ItemType.anime:
        return settings.libraryFilterAnimeStartedType!;
      default:
        return settings.libraryFilterNovelStartedType ?? 0;
    }
  }

  void setType(int type) {
    Settings appSettings = Settings();
    switch (itemType) {
      case ItemType.manga:
        appSettings = settings..libraryFilterMangasStartedType = type;
        break;
      case ItemType.anime:
        appSettings = settings..libraryFilterAnimeStartedType = type;
        break;
      default:
        appSettings = settings..libraryFilterNovelStartedType = type;
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
      required ItemType itemType,
      required Settings settings}) {
    state = getType();
    return getType();
  }

  int getType() {
    switch (itemType) {
      case ItemType.manga:
        return settings.libraryFilterMangasBookMarkedType!;
      case ItemType.anime:
        return settings.libraryFilterAnimeBookMarkedType!;
      default:
        return settings.libraryFilterNovelBookMarkedType ?? 0;
    }
  }

  void setType(int type) {
    Settings appSettings = Settings();
    switch (itemType) {
      case ItemType.manga:
        appSettings = settings..libraryFilterMangasBookMarkedType = type;
        break;
      case ItemType.anime:
        appSettings = settings..libraryFilterAnimeBookMarkedType = type;
        break;
      default:
        appSettings = settings..libraryFilterNovelBookMarkedType = type;
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
      required ItemType itemType,
      required Settings settings}) {
    final downloadFilterType = ref.watch(mangaFilterDownloadedStateProvider(
        mangaList: mangaList, itemType: itemType, settings: settings));
    final unreadFilterType = ref.watch(mangaFilterUnreadStateProvider(
        mangaList: mangaList, itemType: itemType, settings: settings));
    final startedFilterType = ref.watch(mangaFilterStartedStateProvider(
        mangaList: mangaList, itemType: itemType, settings: settings));
    final bookmarkedFilterType = ref.watch(mangaFilterBookmarkedStateProvider(
        mangaList: mangaList, itemType: itemType, settings: settings));
    return downloadFilterType == 0 &&
        unreadFilterType == 0 &&
        startedFilterType == 0 &&
        bookmarkedFilterType == 0;
  }
}

@riverpod
class LibraryShowCategoryTabsState extends _$LibraryShowCategoryTabsState {
  @override
  bool build({required ItemType itemType, required Settings settings}) {
    switch (itemType) {
      case ItemType.manga:
        return settings.libraryShowCategoryTabs!;
      case ItemType.anime:
        return settings.animeLibraryShowCategoryTabs!;
      default:
        return settings.novelLibraryShowCategoryTabs ?? false;
    }
  }

  void set(bool value) {
    Settings appSettings = Settings();
    switch (itemType) {
      case ItemType.manga:
        appSettings = settings..libraryShowCategoryTabs = value;
        break;
      case ItemType.anime:
        appSettings = settings..animeLibraryShowCategoryTabs = value;
        break;
      default:
        appSettings = settings..novelLibraryShowCategoryTabs = value;
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
  bool build({required ItemType itemType, required Settings settings}) {
    switch (itemType) {
      case ItemType.manga:
        return settings.libraryDownloadedChapters!;
      case ItemType.anime:
        return settings.animeLibraryDownloadedChapters!;
      default:
        return settings.novelLibraryDownloadedChapters ?? false;
    }
  }

  void set(bool value) {
    Settings appSettings = Settings();
    switch (itemType) {
      case ItemType.manga:
        appSettings = settings..libraryDownloadedChapters = value;
        break;
      case ItemType.anime:
        appSettings = settings..animeLibraryDownloadedChapters = value;
        break;
      default:
        appSettings = settings..novelLibraryDownloadedChapters = value;
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
  bool build({required ItemType itemType, required Settings settings}) {
    switch (itemType) {
      case ItemType.manga:
        return settings.libraryShowLanguage!;
      case ItemType.anime:
        return settings.animeLibraryShowLanguage!;
      default:
        return settings.novelLibraryShowLanguage ?? false;
    }
  }

  void set(bool value) {
    Settings appSettings = Settings();
    switch (itemType) {
      case ItemType.manga:
        appSettings = settings..libraryShowLanguage = value;
        break;
      case ItemType.anime:
        appSettings = settings..animeLibraryShowLanguage = value;
        break;
      default:
        appSettings = settings..novelLibraryShowLanguage = value;
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
  bool build({required ItemType itemType, required Settings settings}) {
    switch (itemType) {
      case ItemType.manga:
        return settings.libraryLocalSource ?? false;
      case ItemType.anime:
        return settings.animeLibraryLocalSource ?? false;
      default:
        return settings.novelLibraryLocalSource ?? false;
    }
  }

  void set(bool value) {
    Settings appSettings = Settings();
    switch (itemType) {
      case ItemType.manga:
        appSettings = settings..libraryLocalSource = value;
        break;
      case ItemType.anime:
        appSettings = settings..animeLibraryLocalSource = value;
        break;
      default:
        appSettings = settings..novelLibraryLocalSource = value;
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
  bool build({required ItemType itemType, required Settings settings}) {
    switch (itemType) {
      case ItemType.manga:
        return settings.libraryShowNumbersOfItems!;
      case ItemType.anime:
        return settings.animeLibraryShowNumbersOfItems!;
      default:
        return settings.novelLibraryShowNumbersOfItems ?? false;
    }
  }

  void set(bool value) {
    Settings appSettings = Settings();
    switch (itemType) {
      case ItemType.manga:
        appSettings = settings..libraryShowNumbersOfItems = value;
        break;
      case ItemType.anime:
        appSettings = settings..animeLibraryShowNumbersOfItems = value;
        break;
      default:
        appSettings = settings..novelLibraryShowNumbersOfItems = value;
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
  bool build({required ItemType itemType, required Settings settings}) {
    switch (itemType) {
      case ItemType.manga:
        return settings.libraryShowContinueReadingButton!;
      case ItemType.anime:
        return settings.animeLibraryShowContinueReadingButton!;
      default:
        return settings.novelLibraryShowContinueReadingButton ?? false;
    }
  }

  void set(bool value) {
    Settings appSettings = Settings();
    switch (itemType) {
      case ItemType.manga:
        appSettings = settings..libraryShowContinueReadingButton = value;
        break;
      case ItemType.anime:
        appSettings = settings..animeLibraryShowContinueReadingButton = value;
        break;
      default:
        appSettings = settings..novelLibraryShowContinueReadingButton = value;
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
  SortLibraryManga build(
      {required ItemType itemType, required Settings settings}) {
    switch (itemType) {
      case ItemType.manga:
        return settings.sortLibraryManga ?? SortLibraryManga();
      case ItemType.anime:
        return settings.sortLibraryAnime ?? SortLibraryManga();
      default:
        return settings.sortLibraryNovel ?? SortLibraryManga();
    }
  }

  void update(bool reverse, int index) {
    Settings appSettings = Settings();
    var value = SortLibraryManga()
      ..index = index
      ..reverse = state.index == index ? !reverse : reverse;

    switch (itemType) {
      case ItemType.manga:
        appSettings = settings..sortLibraryManga = value;
        break;
      case ItemType.anime:
        appSettings = settings..sortLibraryAnime = value;
        break;
      default:
        appSettings = settings..sortLibraryNovel = value;
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
            ref.read(synchingProvider(syncId: 1).notifier).addChangedPart(
                ActionType.updateChapter, chapter.id, chapter.toJson(), false);
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
          ref.read(synchingProvider(syncId: 1).notifier).addChangedPart(
              ActionType.updateChapter, chapter.id, chapter.toJson(), false);
        }
      });
    }

    ref.read(isLongPressedMangaStateProvider.notifier).update(false);
    ref.read(mangasListStateProvider.notifier).clear();
  }
}
