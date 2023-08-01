class MangaModel {
  String? name;

  String? link;

  String? imageUrl;

  String? description;

  String? author;

  int? status;

  List<dynamic>? genre = [];

  String? source;

  String? lang;

  String? baseUrl;

  String? dateFormat;

  String? dateFormatLocale;

  String? apiUrl;

  int? page;

  String? query;

  int? sourceId;

  bool? hasNextPage;

  List<dynamic>? names;
  List<dynamic>? urls;
  List<dynamic>? chaptersScanlators;
  List<dynamic>? chaptersDateUploads;
  List<dynamic>? chaptersVolumes;
  List<dynamic>? chaptersChaps;
  List<dynamic>? images;
  List<dynamic>? statusList;
  MangaModel(
      {this.source = "",
      this.author = "",
      this.genre,
      this.imageUrl = "",
      this.lang = "",
      this.link = "",
      this.name = "",
      this.status = 0,
      this.description = "",
      this.apiUrl = "",
      this.baseUrl = "",
      this.dateFormat = "",
      this.dateFormatLocale = "",
      this.page = 1,
      this.query = "",
      this.sourceId = 0,
      this.names,
      this.chaptersDateUploads,
      this.chaptersScanlators,
      this.urls,
      this.chaptersVolumes,
      this.chaptersChaps,
      this.images,
      this.statusList,
      this.hasNextPage = true});
}

class VideoModel {
  String? url;
  String? quality;
  String? originalUrl;
  Map<String, String>? headers;

  VideoModel({this.url, this.quality, this.originalUrl, this.headers});
}
