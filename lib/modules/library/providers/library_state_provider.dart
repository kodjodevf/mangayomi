import 'package:flutter/material.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/providers/tri_state_filter.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
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
    DisplayType displayType,
    BuildContext context,
  ) {
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

    settingsRepository.save(appSettings);
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

  Settings get settings => settingsRepository.current;

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

      settingsRepository.save(appSettings);
    }
  }
}

@riverpod
class MangaFilterDownloadedState extends _$MangaFilterDownloadedState
    with TriStateFilterField, TriStateFilterCycle {
  @override
  int build({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  }) {
    state = getType();
    return getType();
  }

  @override
  TriStateFilterFields get fields => TriStateFilterFields(
    read: (s, t) => switch (t) {
      ItemType.manga => s.libraryFilterMangasDownloadType!,
      ItemType.anime => s.libraryFilterAnimeDownloadType!,
      _ => s.libraryFilterNovelDownloadType ?? 0,
    },
    write: (s, t, type) => switch (t) {
      ItemType.manga => s..libraryFilterMangasDownloadType = type,
      ItemType.anime => s..libraryFilterAnimeDownloadType = type,
      _ => s..libraryFilterNovelDownloadType = type,
    },
  );
}

@riverpod
class MangaFilterUnreadState extends _$MangaFilterUnreadState
    with TriStateFilterField {
  @override
  int build({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  }) {
    state = getType();
    return getType();
  }

  @override
  TriStateFilterFields get fields => TriStateFilterFields(
    read: (s, t) => switch (t) {
      ItemType.manga => s.libraryFilterMangasUnreadType!,
      ItemType.anime => s.libraryFilterAnimeUnreadType!,
      _ => s.libraryFilterNovelUnreadType ?? 0,
    },
    write: (s, t, type) => switch (t) {
      ItemType.manga => s..libraryFilterMangasUnreadType = type,
      ItemType.anime => s..libraryFilterAnimeUnreadType = type,
      _ => s..libraryFilterNovelUnreadType = type,
    },
  );

  List<Manga> getData() {
    if (getType() == 1) {
      return mangaList
          .where((element) => element.chapters.any((chap) => !chap.isRead!))
          .toList();
    } else if (getType() == 2) {
      return mangaList
          .where((element) => element.chapters.every((chap) => chap.isRead!))
          .toList();
    } else {
      return mangaList;
    }
  }

  List<Manga> update() {
    if (state == 0) {
      final data = mangaList
          .where((element) => element.chapters.any((chap) => !chap.isRead!))
          .toList();
      setType(1);
      return data;
    } else if (state == 1) {
      final data = mangaList
          .where((element) => element.chapters.every((chap) => chap.isRead!))
          .toList();
      setType(2);
      return data;
    } else {
      setType(0);
      return mangaList;
    }
  }
}

@riverpod
class MangaFilterStartedState extends _$MangaFilterStartedState
    with TriStateFilterField {
  @override
  int build({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  }) {
    state = getType();
    return getType();
  }

  @override
  TriStateFilterFields get fields => TriStateFilterFields(
    read: (s, t) => switch (t) {
      ItemType.manga => s.libraryFilterMangasStartedType!,
      ItemType.anime => s.libraryFilterAnimeStartedType!,
      _ => s.libraryFilterNovelStartedType ?? 0,
    },
    write: (s, t, type) => switch (t) {
      ItemType.manga => s..libraryFilterMangasStartedType = type,
      ItemType.anime => s..libraryFilterAnimeStartedType = type,
      _ => s..libraryFilterNovelStartedType = type,
    },
  );

  List<Manga> getData() {
    if (getType() == 1) {
      return mangaList
          .where((element) => element.chapters.any((chap) => !chap.isRead!))
          .toList();
    } else if (getType() == 2) {
      return mangaList
          .where((element) => element.chapters.every((chap) => chap.isRead!))
          .toList();
    } else {
      return mangaList;
    }
  }

  List<Manga> update() {
    if (state == 0) {
      final data = mangaList
          .where((element) => element.chapters.any((chap) => !chap.isRead!))
          .toList();
      setType(1);
      return data;
    } else if (state == 1) {
      final data = mangaList
          .where((element) => element.chapters.every((chap) => chap.isRead!))
          .toList();
      setType(2);
      return data;
    } else {
      setType(0);
      return mangaList;
    }
  }
}

@riverpod
class MangaFilterBookmarkedState extends _$MangaFilterBookmarkedState
    with TriStateFilterField {
  @override
  int build({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  }) {
    state = getType();
    return getType();
  }

  @override
  TriStateFilterFields get fields => TriStateFilterFields(
    read: (s, t) => switch (t) {
      ItemType.manga => s.libraryFilterMangasBookMarkedType!,
      ItemType.anime => s.libraryFilterAnimeBookMarkedType!,
      _ => s.libraryFilterNovelBookMarkedType ?? 0,
    },
    write: (s, t, type) => switch (t) {
      ItemType.manga => s..libraryFilterMangasBookMarkedType = type,
      ItemType.anime => s..libraryFilterAnimeBookMarkedType = type,
      _ => s..libraryFilterNovelBookMarkedType = type,
    },
  );

  List<Manga> getData() {
    if (getType() == 1) {
      return mangaList
          .where(
            (element) => element.chapters.any((chap) => chap.isBookmarked!),
          )
          .toList();
    } else if (getType() == 2) {
      return mangaList
          .where(
            (element) => element.chapters.every((chap) => !chap.isBookmarked!),
          )
          .toList();
    } else {
      return mangaList;
    }
  }

  List<Manga> update() {
    if (state == 0) {
      final data = mangaList
          .where(
            (element) => element.chapters.any((chap) => chap.isBookmarked!),
          )
          .toList();
      setType(1);
      return data;
    } else if (state == 1) {
      final data = mangaList
          .where(
            (element) => element.chapters.every((chap) => !chap.isBookmarked!),
          )
          .toList();
      setType(2);
      return data;
    } else {
      setType(0);
      return mangaList;
    }
  }
}

// ── Completed filter ──────────────────────────────────────────────────────────

@riverpod
class MangaFilterCompletedState extends _$MangaFilterCompletedState
    with TriStateFilterField, TriStateFilterCycle {
  @override
  int build({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  }) {
    state = getType();
    return getType();
  }

  @override
  TriStateFilterFields get fields => TriStateFilterFields(
    read: (s, t) => switch (t) {
      ItemType.manga => s.libraryFilterMangasCompletedType ?? 0,
      ItemType.anime => s.libraryFilterAnimeCompletedType ?? 0,
      _ => s.libraryFilterNovelCompletedType ?? 0,
    },
    write: (s, t, type) => switch (t) {
      ItemType.manga => s..libraryFilterMangasCompletedType = type,
      ItemType.anime => s..libraryFilterAnimeCompletedType = type,
      _ => s..libraryFilterNovelCompletedType = type,
    },
  );
}

// ── Tracking filter ───────────────────────────────────────────────────────────

@riverpod
class MangaFilterTrackingState extends _$MangaFilterTrackingState
    with TriStateFilterField, TriStateFilterCycle {
  @override
  int build({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  }) {
    state = getType();
    return getType();
  }

  @override
  TriStateFilterFields get fields => TriStateFilterFields(
    read: (s, t) => switch (t) {
      ItemType.manga => s.libraryFilterMangasTrackingType ?? 0,
      ItemType.anime => s.libraryFilterAnimeTrackingType ?? 0,
      _ => s.libraryFilterNovelTrackingType ?? 0,
    },
    write: (s, t, type) => switch (t) {
      ItemType.manga => s..libraryFilterMangasTrackingType = type,
      ItemType.anime => s..libraryFilterAnimeTrackingType = type,
      _ => s..libraryFilterNovelTrackingType = type,
    },
  );
}

@riverpod
class MangaFilterSourceState extends _$MangaFilterSourceState {
  @override
  (List<String>, List<String>, List<String>) build({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  }) {
    final available = _getSources();
    final persisted = _getFilterSources().where(available.contains).toList();
    return (available, persisted, persisted);
  }

  List<String> _getSources() {
    final names = <String>{};
    for (final m in mangaList) {
      if (m.source?.isNotEmpty ?? false) {
        names.add(m.source!);
      }
    }
    return names.toList();
  }

  List<String> _getFilterSources() {
    switch (itemType) {
      case ItemType.manga:
        return settings.libraryFilterMangasSourceIds ?? [];
      case ItemType.anime:
        return settings.libraryFilterAnimeSourceIds ?? [];
      default:
        return settings.libraryFilterNovelSourceIds ?? [];
    }
  }

  void _persist(List<String> names) {
    Settings appSettings = Settings();
    switch (itemType) {
      case ItemType.manga:
        appSettings = settings..libraryFilterMangasSourceIds = names;
        break;
      case ItemType.anime:
        appSettings = settings..libraryFilterAnimeSourceIds = names;
        break;
      default:
        appSettings = settings..libraryFilterNovelSourceIds = names;
    }
    settingsRepository.save(appSettings);
  }

  void setFilteredList(String source) {
    final pending = List<String>.from(state.$3);
    if (pending.contains(source)) {
      pending.remove(source);
    } else {
      pending.add(source);
    }
    state = (state.$1, state.$2, pending);
  }

  void set(List<String> names) {
    _persist(names);
    state = (_getSources(), names, names);
  }
}

@riverpod
class MangasFilterResultState extends _$MangasFilterResultState {
  @override
  bool build({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  }) {
    final downloadFilterType = ref.watch(
      mangaFilterDownloadedStateProvider(
        mangaList: mangaList,
        itemType: itemType,
        settings: settings,
      ),
    );
    final unreadFilterType = ref.watch(
      mangaFilterUnreadStateProvider(
        mangaList: mangaList,
        itemType: itemType,
        settings: settings,
      ),
    );
    final startedFilterType = ref.watch(
      mangaFilterStartedStateProvider(
        mangaList: mangaList,
        itemType: itemType,
        settings: settings,
      ),
    );
    final bookmarkedFilterType = ref.watch(
      mangaFilterBookmarkedStateProvider(
        mangaList: mangaList,
        itemType: itemType,
        settings: settings,
      ),
    );
    final completedFilterType = ref.watch(
      mangaFilterCompletedStateProvider(
        mangaList: mangaList,
        itemType: itemType,
        settings: settings,
      ),
    );
    final trackingFilterType = ref.watch(
      mangaFilterTrackingStateProvider(
        mangaList: mangaList,
        itemType: itemType,
        settings: settings,
      ),
    );
    final sourceFilterType = ref
        .watch(
          mangaFilterSourceStateProvider(
            mangaList: mangaList,
            itemType: itemType,
            settings: settings,
          ),
        )
        .$2;
    return downloadFilterType == 0 &&
        unreadFilterType == 0 &&
        startedFilterType == 0 &&
        bookmarkedFilterType == 0 &&
        completedFilterType == 0 &&
        trackingFilterType == 0 &&
        sourceFilterType.isEmpty;
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
    settingsRepository.save(appSettings);
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
    settingsRepository.save(appSettings);
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
    settingsRepository.save(appSettings);
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
    settingsRepository.save(appSettings);
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
    settingsRepository.save(appSettings);
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
    settingsRepository.save(appSettings);
  }
}

@riverpod
class SortLibraryMangaState extends _$SortLibraryMangaState {
  @override
  SortLibraryManga build({
    required ItemType itemType,
    required Settings settings,
  }) {
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
    settingsRepository.save(appSettings);
    state = value;
  }

  void set(int index) {
    final reverse = isReverse();
    update(reverse, index);
  }

  bool isReverse() {
    return state.reverse ?? false;
  }
}

@riverpod
class MangasListState extends _$MangasListState {
  @override
  Set<int> build() => {};

  void update(Manga value) {
    var newSet = Set<int>.from(state);
    if (newSet.contains(value.id)) {
      newSet.remove(value.id);
    } else {
      newSet.add(value.id!);
    }
    if (newSet.isEmpty) {
      ref.read(isLongPressedStateProvider.notifier).update(false);
    }
    state = newSet;
  }

  void selectAll(Manga value) => state = {...state, value.id!};

  void selectSome(Manga value) {
    final newSet = Set<int>.from(state);
    if (newSet.contains(value.id)) {
      newSet.remove(value.id);
    } else {
      newSet.add(value.id!);
    }
    state = newSet;
  }

  void clear() => state = {};
}

@riverpod
class MangasSetIsReadState extends _$MangasSetIsReadState {
  @override
  void build({required Set<int> mangaIds, required bool markAsRead}) {}

  void set() {
    final allChapters = <Chapter>[];
    final allMangas = <Manga>[];
    final now = DateTime.now().millisecondsSinceEpoch;
    for (var mangaid in mangaIds) {
      final manga = mangaRepository.getById(mangaid);
      final chapters = manga.chapters;
      if (chapters.isEmpty) continue;
      if (markAsRead) chapters.last.updateTrackChapterRead(ref);
      for (var chapter in chapters) {
        chapter.isRead = markAsRead;
        if (markAsRead) chapter.lastPageRead = "1";
        chapter.updatedAt = now;
        chapter.manga.value = manga;
        allChapters.add(chapter);
      }
      allMangas.add(manga);
    }

    chapterRepository.writeTransaction(() {
      chapterRepository.putAllSync(allChapters);
      mangaRepository.putAllSync(allMangas);
    });

    ref.read(isLongPressedStateProvider.notifier).update(false);
    ref.read(mangasListStateProvider.notifier).clear();
  }
}
