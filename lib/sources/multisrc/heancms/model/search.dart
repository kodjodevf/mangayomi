class HeanCmsSearchModel {
  Meta? meta;
  List<Data>? data;

  HeanCmsSearchModel({this.meta, this.data});

  HeanCmsSearchModel.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }
}

class Meta {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;
  int? firstPage;
  String? firstPageUrl;
  String? lastPageUrl;
  String? nextPageUrl;

  Meta({
    this.total,
    this.perPage,
    this.currentPage,
    this.lastPage,
    this.firstPage,
    this.firstPageUrl,
    this.lastPageUrl,
    this.nextPageUrl,
  });

  Meta.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    firstPage = json['first_page'];
    firstPageUrl = json['first_page_url'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
  }
}

class Data {
  String? title;
  int? id;
  String? seriesType;
  String? visibility;
  String? thumbnail;
  String? seriesSlug;
  String? status;
  String? latest;
  String? badge;
  List<Chapters>? chapters;
  Meta? meta;

  Data(
      {this.title,
      this.id,
      this.seriesType,
      this.visibility,
      this.thumbnail,
      this.seriesSlug,
      this.status,
      this.latest,
      this.badge,
      this.chapters,
      this.meta});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
    seriesType = json['series_type'];
    visibility = json['visibility'];
    thumbnail = json['thumbnail'];
    seriesSlug = json['series_slug'];
    status = json['status'];
    latest = json['latest'];
    badge = json['badge'];
    if (json['chapters'] != null) {
      chapters = <Chapters>[];
      json['chapters'].forEach((v) {
        chapters!.add(Chapters.fromJson(v));
      });
    }
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }
}

class Chapters {
  int? id;
  String? index;
  String? chapterName;
  String? chapterSlug;
  String? createdAt;
  String? updatedAt;
  int? seriesId;

  Chapters(
      {this.id,
      this.index,
      this.chapterName,
      this.chapterSlug,
      this.createdAt,
      this.updatedAt,
      this.seriesId});

  Chapters.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    index = json['index'];
    chapterName = json['chapter_name'];
    chapterSlug = json['chapter_slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    seriesId = json['series_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['index'] = index;
    data['chapter_name'] = chapterName;
    data['chapter_slug'] = chapterSlug;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['series_id'] = seriesId;
    return data;
  }
}
