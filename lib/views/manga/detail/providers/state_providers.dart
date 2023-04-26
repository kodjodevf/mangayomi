import 'dart:developer';

import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
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
    return ref.watch(hiveBoxSettings).get(
        "${modelManga.source}/${modelManga.name}-reverseManga",
        defaultValue: false);
  }

  void update(bool value) {
    ref
        .watch(hiveBoxSettings)
        .put("${modelManga.source}/${modelManga.name}-reverseManga", value);
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
    return ref.watch(hiveBoxSettings).get(
        "${modelManga.source}/${modelManga.name}-sortChapterDownload",
        defaultValue: 0);
  }

  void setType(int type) {
    ref.watch(hiveBoxSettings).put(
        "${modelManga.source}/${modelManga.name}-sortChapterDownload", type);
    state = type;
  }

  ModelManga getData() {
    if (getType() == 1) {
      List<ModelChapters> chap = [];
      final chapters = modelManga.chapters;
      for (var i = 0; i < chapters!.length; i++) {
        final modelChapDownload = ref
            .watch(hiveBoxMangaDownloads)
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
      final model = ModelManga(
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
          chapters: chap,
          category: modelManga.category,
          lastRead: modelManga.lastRead);

      return model;
    } else if (getType() == 2) {
      List<ModelChapters> chap = [];
      final chapters = modelManga.chapters;
      for (var i = 0; i < chapters!.length; i++) {
        final modelChapDownload = ref
            .watch(hiveBoxMangaDownloads)
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
      final model = ModelManga(
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
          chapters: chap,
          category: modelManga.category,
          lastRead: modelManga.lastRead);

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
            .watch(hiveBoxMangaDownloads)
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
      final model = ModelManga(
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
          chapters: chap,
          category: modelManga.category,
          lastRead: modelManga.lastRead);
      setType(1);
      return model;
    } else if (state == 1) {
      List<ModelChapters> chap = [];
      final chapters = modelManga.chapters;
      for (var i = 0; i < chapters!.length; i++) {
        final modelChapDownload = ref
            .watch(hiveBoxMangaDownloads)
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
      final model = ModelManga(
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
          chapters: chap,
          category: modelManga.category,
          lastRead: modelManga.lastRead);
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
    return ref.watch(hiveBoxSettings).get(
        "${modelManga.source}/${modelManga.name}-sortChapterUnread",
        defaultValue: 0);
  }

  void setType(int type) {
    ref
        .watch(hiveBoxSettings)
        .put("${modelManga.source}/${modelManga.name}-sortChapterUnread", type);
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
      final model = ModelManga(
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
          chapters: chap,
          category: modelManga.category,
          lastRead: modelManga.lastRead);

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
      final model = ModelManga(
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
          chapters: chap,
          category: modelManga.category,
          lastRead: modelManga.lastRead);

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
      final model = ModelManga(
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
          chapters: chap,
          category: modelManga.category,
          lastRead: modelManga.lastRead);
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
      final model = ModelManga(
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
          chapters: chap,
          category: modelManga.category,
          lastRead: modelManga.lastRead);
      setType(2);
      return model;
    } else {
      setType(0);
      return modelManga;
    }
  }
}

@riverpod
class ChapterFilterBookmarkState extends _$ChapterFilterBookmarkState {
  @override
  int build({required ModelManga modelManga}) {
    state = getType();
    return getType();
  }

  int getType() {
    return ref.watch(hiveBoxSettings).get(
        "${modelManga.source}/${modelManga.name}-sortChapterBookMark",
        defaultValue: 0);
  }

  void setType(int type) {
    ref.watch(hiveBoxSettings).put(
        "${modelManga.source}/${modelManga.name}-sortChapterBookMark", type);
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
      final model = ModelManga(
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
          chapters: chap,
          category: modelManga.category,
          lastRead: modelManga.lastRead);

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
      final model = ModelManga(
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
          chapters: chap,
          category: modelManga.category,
          lastRead: modelManga.lastRead);

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
      final model = ModelManga(
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
          chapters: chap,
          category: modelManga.category,
          lastRead: modelManga.lastRead);
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
      final model = ModelManga(
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
          chapters: chap,
          category: modelManga.category,
          lastRead: modelManga.lastRead);
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
        .read(
            chapterFilterDownloadedStateProvider(modelManga: modelManga).notifier)
        .getData();

    final data2 = ref
        .read(chapterFilterUnreadStateProvider(modelManga: data1).notifier)
        .getData();

    final data3 = ref
        .read(chapterFilterBookmarkStateProvider(modelManga: data2).notifier)
        .getData();

    return data3;
  }

  ModelManga getData() {
    final data1 = ref
        .read(
            chapterFilterDownloadedStateProvider(modelManga: modelManga).notifier)
        .getData();

    final data2 = ref
        .read(chapterFilterUnreadStateProvider(modelManga: data1).notifier)
        .getData();

    final data3 = ref
        .read(chapterFilterBookmarkStateProvider(modelManga: data2).notifier)
        .getData();

    return data3;
  }
}
