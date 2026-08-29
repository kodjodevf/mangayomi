import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/download/providers/download_provider.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
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

  /// Select all chapters between the last selected and [clicked] in [allChapters].
  void selectRange(Chapter clicked, List<Chapter> allChapters) {
    if (state.isEmpty) {
      update(clicked);
      return;
    }
    final lastSelected = state.last;
    final lastIdx = allChapters.indexOf(lastSelected);
    final clickedIdx = allChapters.indexOf(clicked);
    if (lastIdx == -1 || clickedIdx == -1) {
      update(clicked);
      return;
    }
    final start = lastIdx < clickedIdx ? lastIdx : clickedIdx;
    final end = lastIdx < clickedIdx ? clickedIdx : lastIdx;
    var newList = List<Chapter>.from(state);
    for (int i = start; i <= end; i++) {
      if (!newList.contains(allChapters[i])) {
        newList.add(allChapters[i]);
      }
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
    return settingsRepository.current.sortChapterList!
            .where((element) => element.mangaId == mangaId)
            .toList()
            .firstOrNull ??
        SortChapter(mangaId: mangaId, index: 1, reverse: false);
  }

  void update(bool reverse, int index) {
    var value = SortChapter()
      ..index = index
      ..mangaId = mangaId
      ..reverse = state.index == index ? !reverse : reverse;
    final settings = settingsRepository.current;
    List<SortChapter>? sortChapterList = [];
    for (var sortChapter in settings.sortChapterList!) {
      if (sortChapter.mangaId != mangaId) {
        sortChapterList.add(sortChapter);
      }
    }
    sortChapterList.add(value);
    settingsRepository.save(settings..sortChapterList = sortChapterList);

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
    return (settingsRepository.current.chapterFilterDownloadedList!
                .where((element) => element.mangaId == mangaId)
                .toList()
                .firstOrNull ??
            ChapterFilterDownloaded(mangaId: mangaId, type: 0))
        .type!;
  }

  void setType(int type) {
    var value = ChapterFilterDownloaded()
      ..type = type
      ..mangaId = mangaId;
    final settings = settingsRepository.current;
    List<ChapterFilterDownloaded>? chapterFilterDownloadedList = [];
    for (var filterChapter in settings.chapterFilterDownloadedList!) {
      if (filterChapter.mangaId != mangaId) {
        chapterFilterDownloadedList.add(filterChapter);
      }
    }
    chapterFilterDownloadedList.add(value);
    settingsRepository.save(
      settings..chapterFilterDownloadedList = chapterFilterDownloadedList,
    );

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
    return (settingsRepository.current.chapterFilterUnreadList!
                .where((element) => element.mangaId == mangaId)
                .toList()
                .firstOrNull ??
            ChapterFilterUnread(mangaId: mangaId, type: 0))
        .type!;
  }

  void setType(int type) {
    var value = ChapterFilterUnread()
      ..type = type
      ..mangaId = mangaId;
    final settings = settingsRepository.current;
    List<ChapterFilterUnread>? chapterFilterUnreadList = [];
    for (var filterChapter in settings.chapterFilterUnreadList!) {
      if (filterChapter.mangaId != mangaId) {
        chapterFilterUnreadList.add(filterChapter);
      }
    }
    chapterFilterUnreadList.add(value);
    settingsRepository.save(
      settings..chapterFilterUnreadList = chapterFilterUnreadList,
    );
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
    return (settingsRepository.current.chapterFilterBookmarkedList!
                .where((element) => element.mangaId == mangaId)
                .toList()
                .firstOrNull ??
            ChapterFilterBookmarked(mangaId: mangaId, type: 0))
        .type!;
  }

  void setType(int type) {
    var value = ChapterFilterBookmarked()
      ..type = type
      ..mangaId = mangaId;
    final settings = settingsRepository.current;
    List<ChapterFilterBookmarked>? chapterFilterBookmarkedList = [];
    for (var filterChapter in settings.chapterFilterBookmarkedList!) {
      if (filterChapter.mangaId != mangaId) {
        chapterFilterBookmarkedList.add(filterChapter);
      }
    }
    chapterFilterBookmarkedList.add(value);
    settingsRepository.save(
      settings..chapterFilterBookmarkedList = chapterFilterBookmarkedList,
    );
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
  bool build({required Manga manga}) {
    final downloadFilterType = ref.watch(
      chapterFilterDownloadedStateProvider(mangaId: manga.id!),
    );
    final unreadFilterType = ref.watch(
      chapterFilterUnreadStateProvider(mangaId: manga.id!),
    );

    final bookmarkedFilterType = ref.watch(
      chapterFilterBookmarkedStateProvider(mangaId: manga.id!),
    );
    final scanlators = ref.watch(scanlatorsFilterStateProvider(manga));
    return downloadFilterType == 0 &&
        unreadFilterType == 0 &&
        bookmarkedFilterType == 0 &&
        scanlators.$2.isEmpty;
  }
}

@riverpod
class ChapterSetIsBookmarkState extends _$ChapterSetIsBookmarkState {
  @override
  void build({required Manga manga}) {}

  void set() {
    final allChapters = <Chapter>[];
    final chapters = ref.watch(chaptersListStateProvider);
    for (var chapter in chapters) {
      chapter.isBookmarked = !chapter.isBookmarked!;
      chapter.updatedAt = DateTime.now().millisecondsSinceEpoch;
      chapter.manga.value = manga;
      allChapters.add(chapter);
    }
    chapterRepository.putAll(allChapters);
    ref.read(isLongPressedStateProvider.notifier).update(false);
    ref.read(chaptersListStateProvider.notifier).clear();
  }
}

@riverpod
class ChapterSetIsReadState extends _$ChapterSetIsReadState {
  @override
  void build({required Manga manga}) {}

  void set() {
    final allChapters = <Chapter>[];
    final chapters = ref.watch(chaptersListStateProvider);
    for (var chapter in chapters) {
      chapter.isRead = !chapter.isRead!;
      chapter.updatedAt = DateTime.now().millisecondsSinceEpoch;
      chapter.manga.value = manga;
      allChapters.add(chapter);
    }
    chapterRepository.putAll(allChapters);
    ref.read(isLongPressedStateProvider.notifier).update(false);
    ref.read(chaptersListStateProvider.notifier).clear();
  }
}

@riverpod
class ChapterSetDownloadState extends _$ChapterSetDownloadState {
  @override
  void build({required Manga manga}) {}

  Future<void> set() async {
    ref.read(isLongPressedStateProvider.notifier).update(false);
    await downloadRepository.transaction(() {
      for (var chapter in ref.watch(chaptersListStateProvider)) {
        final entry = downloadRepository.getByChapterId(chapter.id);
        if (entry == null || !entry.isDownload!) {
          ref.watch(addDownloadToQueueProvider(chapter: chapter));
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

  void set(List<Chapter> chapters) async {
    // Yield to the event loop to avoid setState during build
    await Future(() {});
    state = chapters;
  }
}

@riverpod
class ScanlatorsFilterState extends _$ScanlatorsFilterState {
  @override
  (List<String>, List<String>, List<String>) build(Manga manga) {
    final available = _getScanlators();
    final persisted = (_getFilterScanlator() ?? [])
        .where(available.contains)
        .toList();
    return (available, persisted, persisted);
  }

  List<String> _getScanlators() {
    List<String> scanlators = [];
    for (var a in manga.chapters.toList()) {
      if ((a.scanlator?.isNotEmpty ?? false) &&
          !scanlators.contains(a.scanlator)) {
        scanlators.add(a.scanlator!);
      }
    }

    return scanlators;
  }

  void set(List<String> filterScanlators) async {
    final settings = settingsRepository.current;
    var value = FilterScanlator()
      ..scanlators = filterScanlators
      ..mangaId = manga.id;
    List<FilterScanlator>? filterScanlatorList = [];
    for (var filterScanlator in settings.filterScanlatorList ?? []) {
      if (filterScanlator.mangaId != manga.id) {
        filterScanlatorList.add(filterScanlator);
      }
    }
    filterScanlatorList.add(value);
    settingsRepository.save(settings..filterScanlatorList = filterScanlatorList);
    state = (_getScanlators(), _getFilterScanlator()!, filterScanlators);
  }

  List<String>? _getFilterScanlator() {
    final scanlators = settingsRepository.current.filterScanlatorList ?? [];
    final filter = scanlators
        .where((element) => element.mangaId == manga.id)
        .toList();
    return filter.isEmpty ? null : filter.first.scanlators;
  }

  void setFilteredList(String scanlator) {
    final available = _getScanlators();
    List<String> scanlatorFilteredList = List<String>.from(state.$3);
    if (scanlatorFilteredList.contains(scanlator)) {
      scanlatorFilteredList.remove(scanlator);
    } else {
      scanlatorFilteredList.add(scanlator);
    }
    state = (
      available,
      (_getFilterScanlator() ?? []).where(available.contains).toList(),
      scanlatorFilteredList,
    );
  }
}
