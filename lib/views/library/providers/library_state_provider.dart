import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'library_state_provider.g.dart';

@riverpod
class LibraryReverseListState extends _$LibraryReverseListState {
  @override
  bool build() {
    return ref
        .watch(hiveBoxSettingsProvider)
        .get('libraryReverseList', defaultValue: false)!;
  }

  void set(bool value) {
    state = value;
    ref.watch(hiveBoxSettingsProvider).put('libraryReverseList', value);
  }
}

@riverpod
class LibraryDisplayTypeState extends _$LibraryDisplayTypeState {
  @override
  String build() {
    return ref
        .watch(hiveBoxSettingsProvider)
        .get('displayType', defaultValue: DisplayType.coverOnlyGrid.name)!;
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

  String getLibraryDisplayTypeName(String displayType) {
    return displayType == DisplayType.compactGrid.name
        ? 'Compact grid'
        : displayType == DisplayType.list.name
            ? 'List'
            : displayType == DisplayType.comfortableGrid.name
                ? 'Comfortable grid'
                : 'Cover-only grid';
  }

  void setLibraryDisplayType(DisplayType displayType) {
    state = displayType.name;
    ref.watch(hiveBoxSettingsProvider).put('displayType', displayType.name);
  }
}

enum DisplayType {
  compactGrid,
  comfortableGrid,
  coverOnlyGrid,
  list,
}

@riverpod
class MangaFilterDownloadedState extends _$MangaFilterDownloadedState {
  @override
  int build({required List<ModelManga> mangaList}) {
    state = getType();
    return getType();
  }

  int getType() {
    return ref
        .watch(hiveBoxSettingsProvider)
        .get("filterMangaDownload", defaultValue: 0);
  }

  void setType(int type) {
    ref.watch(hiveBoxSettingsProvider).put("filterMangaDownload", type);
    state = type;
  }

  List<ModelManga> getData() {
    if (getType() == 1) {
      final data = mangaList.where((element) {
        List list = [];
        for (var chap in element.chapters!) {
          final modelChapDownload = ref
              .watch(hiveBoxMangaDownloadsProvider)
              .get(chap.name, defaultValue: null);
          if (modelChapDownload != null &&
              modelChapDownload.isDownload == true) {
            list.add(true);
          }
        }
        return list.isNotEmpty;
      }).toList();

      return data;
    } else if (getType() == 2) {
      final data = mangaList.where((element) {
        List list = [];
        for (var chap in element.chapters!) {
          final modelChapDownload = ref
              .watch(hiveBoxMangaDownloadsProvider)
              .get(chap.name, defaultValue: null);
          if (modelChapDownload == null ||
              modelChapDownload.isDownload == false) {
            list.add(true);
          }
        }
        return list.length == element.chapters!.length;
      }).toList();
      return data;
    } else {
      return mangaList;
    }
  }

  List<ModelManga> update() {
    if (state == 0) {
      final data = mangaList.where((element) {
        List list = [];
        for (var chap in element.chapters!) {
          final modelChapDownload = ref
              .watch(hiveBoxMangaDownloadsProvider)
              .get(chap.name, defaultValue: null);
          if (modelChapDownload != null &&
              modelChapDownload.isDownload == true) {
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
        for (var chap in element.chapters!) {
          final modelChapDownload = ref
              .watch(hiveBoxMangaDownloadsProvider)
              .get(chap.name, defaultValue: null);
          if (modelChapDownload == null ||
              modelChapDownload.isDownload == false) {
            list.add(true);
          }
        }
        return list.length == element.chapters!.length;
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
class MangaFilterUnreadState extends _$MangaFilterUnreadState {
  @override
  int build({required List<ModelManga> mangaList}) {
    state = getType();
    return getType();
  }

  int getType() {
    return ref
        .watch(hiveBoxSettingsProvider)
        .get("filterMangaUnread", defaultValue: 0);
  }

  void setType(int type) {
    ref.watch(hiveBoxSettingsProvider).put("filterMangaUnread", type);
    state = type;
  }

  List<ModelManga> getData() {
    if (getType() == 1) {
      final data = mangaList.where((element) {
        List list = [];
        for (var chap in element.chapters!) {
          if (!chap.isRead) {
            list.add(true);
          }
        }
        return list.isNotEmpty;
      }).toList();
      return data;
    } else if (getType() == 2) {
      final data = mangaList.where((element) {
        List list = [];
        for (var chap in element.chapters!) {
          if (chap.isRead) {
            list.add(true);
          }
        }
        return list.length == element.chapters!.length;
      }).toList();
      return data;
    } else {
      return mangaList;
    }
  }

  List<ModelManga> update() {
    if (state == 0) {
      final data = mangaList.where((element) {
        List list = [];
        for (var chap in element.chapters!) {
          if (!chap.isRead) {
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
        for (var chap in element.chapters!) {
          if (chap.isRead) {
            list.add(true);
          }
        }
        return list.length == element.chapters!.length;
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
  int build({required List<ModelManga> mangaList}) {
    state = getType();
    return getType();
  }

  int getType() {
    return ref
        .watch(hiveBoxSettingsProvider)
        .get("filterMangaStarted", defaultValue: 0);
  }

  void setType(int type) {
    ref.watch(hiveBoxSettingsProvider).put("filterMangaStarted", type);
    state = type;
  }

  List<ModelManga> getData() {
    if (getType() == 1) {
      final data = mangaList.where((element) {
        List list = [];
        for (var chap in element.chapters!) {
          if (!chap.isRead) {
            list.add(true);
          }
        }
        return list.isNotEmpty;
      }).toList();
      return data;
    } else if (getType() == 2) {
      final data = mangaList.where((element) {
        List list = [];
        for (var chap in element.chapters!) {
          if (chap.isRead) {
            list.add(true);
          }
        }
        return list.length == element.chapters!.length;
      }).toList();
      return data;
    } else {
      return mangaList;
    }
  }

  List<ModelManga> update() {
    if (state == 0) {
      final data = mangaList.where((element) {
        List list = [];
        for (var chap in element.chapters!) {
          if (!chap.isRead) {
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
        for (var chap in element.chapters!) {
          if (chap.isRead) {
            list.add(true);
          }
        }
        return list.length == element.chapters!.length;
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
  int build({required List<ModelManga> mangaList}) {
    state = getType();
    return getType();
  }

  int getType() {
    return ref
        .watch(hiveBoxSettingsProvider)
        .get("filterMangaBookMarked", defaultValue: 0);
  }

  void setType(int type) {
    ref.watch(hiveBoxSettingsProvider).put("filterMangaBookMarked", type);
    state = type;
  }

  List<ModelManga> getData() {
    if (getType() == 1) {
      final data = mangaList.where((element) {
        List list = [];
        for (var chap in element.chapters!) {
          if (chap.isBookmarked) {
            list.add(true);
          }
        }
        return list.isNotEmpty;
      }).toList();
      return data;
    } else if (getType() == 2) {
      final data = mangaList.where((element) {
        List list = [];
        for (var chap in element.chapters!) {
          if (!chap.isBookmarked) {
            list.add(true);
          }
        }
        return list.length == element.chapters!.length;
      }).toList();
      return data;
    } else {
      return mangaList;
    }
  }

  List<ModelManga> update() {
    if (state == 0) {
      final data = mangaList.where((element) {
        List list = [];
        for (var chap in element.chapters!) {
          if (chap.isBookmarked) {
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
        for (var chap in element.chapters!) {
          if (!chap.isBookmarked) {
            list.add(true);
          }
        }
        return list.length == element.chapters!.length;
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
class MangaFilterResultState extends _$MangaFilterResultState {
  @override
  List<ModelManga> build({required List<ModelManga> mangaList}) {
    final data1 = ref
        .read(mangaFilterDownloadedStateProvider(mangaList: mangaList).notifier)
        .getData();

    final data2 = ref
        .read(mangaFilterUnreadStateProvider(mangaList: data1).notifier)
        .getData();

    final data3 = ref
        .read(mangaFilterStartedStateProvider(mangaList: data2).notifier)
        .getData();
    final data4 = ref
        .read(mangaFilterBookmarkedStateProvider(mangaList: data3).notifier)
        .getData();

    return data4;
  }

  bool isNotFiltering() {
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
    return ref
        .watch(hiveBoxSettingsProvider)
        .get('libraryShowCategoryTabs', defaultValue: false)!;
  }

  void set(bool value) {
    state = value;
    ref.watch(hiveBoxSettingsProvider).put('libraryShowCategoryTabs', value);
  }
}

@riverpod
class LibraryDownloadedChaptersState extends _$LibraryDownloadedChaptersState {
  @override
  bool build() {
    return ref
        .watch(hiveBoxSettingsProvider)
        .get('libraryDownloadedChapters', defaultValue: false)!;
  }

  void set(bool value) {
    state = value;
    ref.watch(hiveBoxSettingsProvider).put('libraryDownloadedChapters', value);
  }
}

@riverpod
class LibraryLanguageState extends _$LibraryLanguageState {
  @override
  bool build() {
    return ref
        .watch(hiveBoxSettingsProvider)
        .get('libraryLanguage', defaultValue: false)!;
  }

  void set(bool value) {
    state = value;
    ref.watch(hiveBoxSettingsProvider).put('libraryLanguage', value);
  }
}

@riverpod
class LibraryShowNumbersOfItemsState extends _$LibraryShowNumbersOfItemsState {
  @override
  bool build() {
    return ref
        .watch(hiveBoxSettingsProvider)
        .get('libraryShowNumbersOfItems', defaultValue: false)!;
  }

  void set(bool value) {
    state = value;
    ref.watch(hiveBoxSettingsProvider).put('libraryShowNumbersOfItems', value);
  }
}

@riverpod
class LibraryShowContinueReadingButtonState
    extends _$LibraryShowContinueReadingButtonState {
  @override
  bool build() {
    return ref
        .watch(hiveBoxSettingsProvider)
        .get('libraryShowContinueReadingButton', defaultValue: false)!;
  }

  void set(bool value) {
    state = value;
    ref
        .watch(hiveBoxSettingsProvider)
        .put('libraryShowContinueReadingButton', value);
  }
}

