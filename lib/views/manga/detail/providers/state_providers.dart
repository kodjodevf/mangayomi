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
        lastPageRead: "");
  }

  void update(ModelChapters chapters) {
    state = chapters;
  }
}

@riverpod
class ChapterNameListState extends _$ChapterNameListState {
  @override
  List<String> build() {
    return [];
  }

  void update(String value) {
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

  void selectAll(String value) {
    var newList = state.reversed.toList();
    if (!newList.contains(value)) {
      newList.add(value);
    }

    state = newList;
  }

  void selectSome(String value) {
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
class ReverseMangaState extends _$ReverseMangaState {
  @override
  bool build({required ModelManga modelManga}) {
    return ref.watch(hiveBoxSettingsProvider).get(
        "${modelManga.source}/${modelManga.name}-reverseChapter",
        defaultValue: false);
  }

  void update(bool value) {
    ref
        .watch(hiveBoxSettingsProvider)
        .put("${modelManga.source}/${modelManga.name}-reverseChapter", value);
    state = value;
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
      final chapters = modelManga.chapters;
      for (var i = 0; i < chapters!.length; i++) {
        final modelChapDownload = ref
            .watch(hiveBoxMangaDownloadsProvider)
            .get(chapters[i].name, defaultValue: null);
        if (modelChapDownload != null && modelChapDownload.isDownload == true) {
          chap.add(ModelChapters(
              name: chapters[i].name,
              url: chapters[i].url,
              dateUpload: chapters[i].dateUpload,
              isBookmarked: chapters[i].isBookmarked,
              scanlator: chapters[i].scanlator,
              isRead: chapters[i].isRead,
              lastPageRead: chapters[i].lastPageRead));
        }
      }
      final model =
          modelMangaWithNewChapValue(modelManga: modelManga, chapters: chap);

      return model;
    } else if (getType() == 2) {
      List<ModelChapters> chap = [];
      final chapters = modelManga.chapters;
      for (var i = 0; i < chapters!.length; i++) {
        final modelChapDownload = ref
            .watch(hiveBoxMangaDownloadsProvider)
            .get(chapters[i].name, defaultValue: null);
        if (!(modelChapDownload != null &&
            modelChapDownload.isDownload == true)) {
          chap.add(ModelChapters(
              name: chapters[i].name,
              url: chapters[i].url,
              dateUpload: chapters[i].dateUpload,
              isBookmarked: chapters[i].isBookmarked,
              scanlator: chapters[i].scanlator,
              isRead: chapters[i].isRead,
              lastPageRead: chapters[i].lastPageRead));
        }
      }
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
      final chapters = modelManga.chapters;
      for (var i = 0; i < chapters!.length; i++) {
        final modelChapDownload = ref
            .watch(hiveBoxMangaDownloadsProvider)
            .get(chapters[i].name, defaultValue: null);
        if (modelChapDownload != null && modelChapDownload.isDownload == true) {
          chap.add(ModelChapters(
              name: chapters[i].name,
              url: chapters[i].url,
              dateUpload: chapters[i].dateUpload,
              isBookmarked: chapters[i].isBookmarked,
              scanlator: chapters[i].scanlator,
              isRead: chapters[i].isRead,
              lastPageRead: chapters[i].lastPageRead));
        }
      }
      final model =
          modelMangaWithNewChapValue(modelManga: modelManga, chapters: chap);
      setType(1);
      return model;
    } else if (state == 1) {
      List<ModelChapters> chap = [];
      final chapters = modelManga.chapters;
      for (var i = 0; i < chapters!.length; i++) {
        final modelChapDownload = ref
            .watch(hiveBoxMangaDownloadsProvider)
            .get(chapters[i].name, defaultValue: null);
        if (!(modelChapDownload != null &&
            modelChapDownload.isDownload == true)) {
          chap.add(ModelChapters(
              name: chapters[i].name,
              url: chapters[i].url,
              dateUpload: chapters[i].dateUpload,
              isBookmarked: chapters[i].isBookmarked,
              scanlator: chapters[i].scanlator,
              isRead: chapters[i].isRead,
              lastPageRead: chapters[i].lastPageRead));
        }
      }
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
      final chapters = modelManga.chapters;
      for (var i = 0; i < chapters!.length; i++) {
        if (!chapters[i].isRead) {
          chap.add(ModelChapters(
              name: chapters[i].name,
              url: chapters[i].url,
              dateUpload: chapters[i].dateUpload,
              isBookmarked: chapters[i].isBookmarked,
              scanlator: chapters[i].scanlator,
              isRead: chapters[i].isRead,
              lastPageRead: chapters[i].lastPageRead));
        }
      }
      final model =
          modelMangaWithNewChapValue(modelManga: modelManga, chapters: chap);

      return model;
    } else if (getType() == 2) {
      List<ModelChapters> chap = [];
      final chapters = modelManga.chapters;
      for (var i = 0; i < chapters!.length; i++) {
        if (chapters[i].isRead) {
          chap.add(ModelChapters(
              name: chapters[i].name,
              url: chapters[i].url,
              dateUpload: chapters[i].dateUpload,
              isBookmarked: chapters[i].isBookmarked,
              scanlator: chapters[i].scanlator,
              isRead: chapters[i].isRead,
              lastPageRead: chapters[i].lastPageRead));
        }
      }
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
      final chapters = modelManga.chapters;
      for (var i = 0; i < chapters!.length; i++) {
        if (!chapters[i].isRead) {
          chap.add(ModelChapters(
              name: chapters[i].name,
              url: chapters[i].url,
              dateUpload: chapters[i].dateUpload,
              isBookmarked: chapters[i].isBookmarked,
              scanlator: chapters[i].scanlator,
              isRead: chapters[i].isRead,
              lastPageRead: chapters[i].lastPageRead));
        }
      }
      final model =
          modelMangaWithNewChapValue(modelManga: modelManga, chapters: chap);
      setType(1);
      return model;
    } else if (state == 1) {
      List<ModelChapters> chap = [];
      final chapters = modelManga.chapters;
      for (var i = 0; i < chapters!.length; i++) {
        if (chapters[i].isRead) {
          chap.add(ModelChapters(
              name: chapters[i].name,
              url: chapters[i].url,
              dateUpload: chapters[i].dateUpload,
              isBookmarked: chapters[i].isBookmarked,
              scanlator: chapters[i].scanlator,
              isRead: chapters[i].isRead,
              lastPageRead: chapters[i].lastPageRead));
        }
      }
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
      final chapters = modelManga.chapters;
      for (var i = 0; i < chapters!.length; i++) {
        if (chapters[i].isBookmarked) {
          chap.add(ModelChapters(
              name: chapters[i].name,
              url: chapters[i].url,
              dateUpload: chapters[i].dateUpload,
              isBookmarked: chapters[i].isBookmarked,
              scanlator: chapters[i].scanlator,
              isRead: chapters[i].isRead,
              lastPageRead: chapters[i].lastPageRead));
        }
      }
      final model =
          modelMangaWithNewChapValue(modelManga: modelManga, chapters: chap);

      return model;
    } else if (getType() == 2) {
      List<ModelChapters> chap = [];
      final chapters = modelManga.chapters;
      for (var i = 0; i < chapters!.length; i++) {
        if (!chapters[i].isBookmarked) {
          chap.add(ModelChapters(
              name: chapters[i].name,
              url: chapters[i].url,
              dateUpload: chapters[i].dateUpload,
              isBookmarked: chapters[i].isBookmarked,
              scanlator: chapters[i].scanlator,
              isRead: chapters[i].isRead,
              lastPageRead: chapters[i].lastPageRead));
        }
      }
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
      final chapters = modelManga.chapters;
      for (var i = 0; i < chapters!.length; i++) {
        if (chapters[i].isBookmarked) {
          chap.add(ModelChapters(
              name: chapters[i].name,
              url: chapters[i].url,
              dateUpload: chapters[i].dateUpload,
              isBookmarked: chapters[i].isBookmarked,
              scanlator: chapters[i].scanlator,
              isRead: chapters[i].isRead,
              lastPageRead: chapters[i].lastPageRead));
        }
      }
      final model =
          modelMangaWithNewChapValue(modelManga: modelManga, chapters: chap);
      setType(1);
      return model;
    } else if (state == 1) {
      List<ModelChapters> chap = [];
      final chapters = modelManga.chapters;
      for (var i = 0; i < chapters!.length; i++) {
        if (!chapters[i].isBookmarked) {
          chap.add(ModelChapters(
              name: chapters[i].name,
              url: chapters[i].url,
              dateUpload: chapters[i].dateUpload,
              isBookmarked: chapters[i].isBookmarked,
              scanlator: chapters[i].scanlator,
              isRead: chapters[i].isRead,
              lastPageRead: chapters[i].lastPageRead));
        }
      }
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
      chapters: chapters,
      categories: modelManga.categories,
      lastRead: modelManga.lastRead);
}

@riverpod
class ChapterSetIsBookmarkState extends _$ChapterSetIsBookmarkState {
  @override
  build({required ModelManga modelManga}) {}

  set() {
    final entries = ref
        .watch(hiveBoxMangaProvider)
        .get('${modelManga.lang}-${modelManga.link}', defaultValue: modelManga);
    for (var name in ref.watch(chapterNameListStateProvider)) {
      List<ModelChapters> chap = [];
      for (var i = 0; i < modelManga.chapters!.length; i++) {
        chap.add(ModelChapters(
            name: entries!.chapters![i].name,
            url: entries.chapters![i].url,
            dateUpload: entries.chapters![i].dateUpload,
            isBookmarked: name == entries.chapters![i].name
                ? entries.chapters![i].isBookmarked
                    ? false
                    : true
                : entries.chapters![i].isBookmarked,
            scanlator: entries.chapters![i].scanlator,
            isRead: entries.chapters![i].isRead,
            lastPageRead: entries.chapters![i].lastPageRead));
      }
      final model =
          modelMangaWithNewChapValue(modelManga: modelManga, chapters: chap);
      ref
          .watch(hiveBoxMangaProvider)
          .put('${modelManga.lang}-${modelManga.link}', model);
    }
  }
}

@riverpod
class ChapterSetIsReadState extends _$ChapterSetIsReadState {
  @override
  build({required ModelManga modelManga}) {}

  set() {
    final entries = ref
        .watch(hiveBoxMangaProvider)
        .get('${modelManga.lang}-${modelManga.link}', defaultValue: modelManga);
    for (var name in ref.watch(chapterNameListStateProvider)) {
      List<ModelChapters> chap = [];
      for (var i = 0; i < modelManga.chapters!.length; i++) {
        chap.add(ModelChapters(
            name: entries!.chapters![i].name,
            url: entries.chapters![i].url,
            dateUpload: entries.chapters![i].dateUpload,
            isBookmarked: entries.chapters![i].isBookmarked,
            scanlator: entries.chapters![i].scanlator,
            isRead: name == entries.chapters![i].name
                ? entries.chapters![i].isRead
                    ? false
                    : true
                : entries.chapters![i].isRead,
            lastPageRead: entries.chapters![i].lastPageRead));
      }

      final model =
          modelMangaWithNewChapValue(modelManga: modelManga, chapters: chap);
      ref
          .watch(hiveBoxMangaProvider)
          .put('${modelManga.lang}-${modelManga.link}', model);
    }
  }
}

@riverpod
class ChapterSetDownloadState extends _$ChapterSetDownloadState {
  @override
  build({required ModelManga modelManga}) {}

  set() {
    List<int> indexList = [];
    for (var name in ref.watch(chapterNameListStateProvider)) {
      for (var i = 0; i < modelManga.chapters!.length; i++) {
        if (modelManga.chapters![i].name == name) {
          indexList.add(i);
        }
      }
    }
    for (var idx in indexList) {
      final entries = ref
          .watch(hiveBoxMangaDownloadsProvider)
          .values
          .where((element) =>
              element.modelManga.chapters![element.index].name ==
              modelManga.chapters![idx].name)
          .toList();
      if (entries.isEmpty) {
        ref.watch(downloadChapterProvider(modelManga: modelManga, index: idx));
      } else {
        if (!entries.first.isDownload) {
          ref.watch(
              downloadChapterProvider(modelManga: modelManga, index: idx));
        }
      }
    }
  }
}
