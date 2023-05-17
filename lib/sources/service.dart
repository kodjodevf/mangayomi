import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';

abstract class MangaYomiServices {
  List<String?> url = [];
  List<String?> name = [];
  List<String?> image = [];
  List<String> genre = [];
  String? author = "";
  String? status = "";
  List<String> statusList = [];
  List<String> chapterTitle = [];
  List<String> chapterUrl = [];
  List<String> chapterDate = [];
  String? description = "";
  List<Chapter> chapters = [];
  List<String> scanlators = [];
  List<String> pageUrls = [];
  List<GetManga> mangaList = [];
  List<GetManga> mangaRes() {
    for (var i = 0; i < name.length; i++) {
      mangaList.add(GetManga(
          genre: genre,
          author: author,
          status: statusList.isEmpty ? "" : statusList[i],
          chapters: chapters,
          imageUrl: image[i],
          description: description,
          url: url[i],
          name: name[i],
          source: ""));
    }
    return mangaList;
  }

  GetManga mangadetailRes({required GetManga manga, required String source}) {
    if (chapterDate.isNotEmpty &&
        chapterTitle.isNotEmpty &&
        chapterUrl.isNotEmpty) {
      for (var i = 0; i < chapterUrl.length; i++) {
        chapters.add(Chapter(
            name: chapterTitle[i],
            url: chapterUrl[i],
            dateUpload: chapterDate[i],
            isBookmarked: false,
            scanlator: scanlators.isEmpty ? "" : scanlators[i],
            isRead: false,
            lastPageRead: '',
            mangaId: null));
      }
    }
    return GetManga(
      status: status,
      genre: genre,
      author: author,
      description: description,
      name: manga.name,
      url: manga.url,
      source: source,
      imageUrl: manga.imageUrl,
      chapters: chapters,
    );
  }

  Future<List<GetManga?>> getPopularManga(
      {required String source,
      required int page,
      required AutoDisposeFutureProviderRef ref});
  Future<GetManga?> getMangaDetail(
      {required GetManga manga,
      required String lang,
      required String source,
      required AutoDisposeFutureProviderRef ref});
  Future<List<String>?> getChapterUrl(
      {required Chapter chapter, required AutoDisposeFutureProviderRef ref});
  Future<List<GetManga?>> searchManga(
      {required String source,
      required String query,
      required AutoDisposeFutureProviderRef ref});
}

class GetManga {
  List<String> genre = [];
  List<Chapter> chapters = [];
  String? author;
  String? status;
  String? source;
  String? url;
  String? name;
  String? imageUrl;
  String? description;
  GetManga({
    required this.genre,
    required this.author,
    required this.status,
    required this.chapters,
    required this.imageUrl,
    required this.description,
    required this.url,
    required this.name,
    required this.source,
  });
}
