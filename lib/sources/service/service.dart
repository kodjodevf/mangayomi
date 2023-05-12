import 'package:mangayomi/models/chapter.dart';

abstract class MangaYomiServices {
  List<String?> url = [];
  List<String?> name = [];
  List<String?> image = [];
  List<String> genre = [];
  String? author;
  String? status;
  List<String> chapterTitle = [];
  List<String> chapterUrl = [];
  List<String> chapterDate = [];
  String? description;
  List<Chapter> chapters = [];
  List<String> scanlators = [];
  List pageUrls = [];

  GetMangaModel mangaRes() {
    return GetMangaModel(
      name: name,
      url: url,
      image: image,
    );
  }

  GetMangaDetailModel mangadetailRes(
      {required String imageUrl,
      required String url,
      required String title,
      required String source}) {
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
    return GetMangaDetailModel(
      status: status,
      genre: genre,
      author: author,
      description: description,
      name: title,
      url: url,
      source: source,
      imageUrl: imageUrl,
      chapters: chapters,
    );
  }

  Future<GetMangaModel?> getPopularManga(
      {required String source, required int page});
  Future<GetMangaDetailModel?> getMangaDetail(
      {required String imageUrl,
      required String url,
      required String title,
      required String lang,
      required String source});
  Future<List<dynamic>?> getMangaChapterUrl({
    required Chapter chapter,
  });
  Future<GetMangaModel?> searchManga(
      {required String source, required String query});
}



class GetMangaModel {
  late List<String?> url;
  late List<String?> name;
  late List<String?> image;
  GetMangaModel({
    required this.name,
    required this.url,
    required this.image,
  });
}

class GetMangaDetailModel {
  List<String> genre = [];
  List<Chapter> chapters = [];
  String? author;
  String? status;
  String? source;
  String? url;
  String? name;
  String? imageUrl;
  String? description;
  GetMangaDetailModel({
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
