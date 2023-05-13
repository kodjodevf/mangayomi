class PopularMangaModelComick {
  int? id;
  String? hid;
  String? slug;
  String? title;
  String? rating;
  String? bayesianRating;
  int? ratingCount;
  int? followCount;
  String? desc;
  double? lastChapter;
  bool? translationCompleted;
  int? viewCount;
  String? contentRating;
  int? demographic;
  List<int>? genres;
  int? userFollowCount;
  int? year;
  List<MdTitles>? mdTitles;
  List<MdCovers>? mdCovers;
  MuComics? muComics;
  String? coverUrl;

  PopularMangaModelComick(
      {this.id,
      this.hid,
      this.slug,
      this.title,
      this.rating,
      this.bayesianRating,
      this.ratingCount,
      this.followCount,
      this.desc,
      this.lastChapter,
      this.translationCompleted,
      this.viewCount,
      this.contentRating,
      this.demographic,
      this.genres,
      this.userFollowCount,
      this.year,
      this.mdTitles,
      this.mdCovers,
      this.muComics,
      this.coverUrl});

  PopularMangaModelComick.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hid = json['hid'];
    slug = json['slug'];
    title = json['title'];
    rating = json['rating'];
    bayesianRating = json['bayesian_rating'];
    ratingCount = json['rating_count'];
    followCount = json['follow_count'];
    desc = json['desc'];
    lastChapter = double.parse(json['last_chapter'].toString());
    translationCompleted = json['translation_completed'];
    viewCount = json['view_count'];
    contentRating = json['content_rating'];
    demographic = json['demographic'];
    genres = json['genres'].cast<int>();
    userFollowCount = json['user_follow_count'];
    year = json['year'];
    if (json['md_titles'] != null) {
      mdTitles = <MdTitles>[];
      json['md_titles'].forEach((v) {
        mdTitles!.add(MdTitles.fromJson(v));
      });
    }
    if (json['md_covers'] != null) {
      mdCovers = <MdCovers>[];
      json['md_covers'].forEach((v) {
        mdCovers!.add(MdCovers.fromJson(v));
      });
    }
    muComics =
        json['mu_comics'] != null ? MuComics.fromJson(json['mu_comics']) : null;
    coverUrl = json['cover_url'];
  }
}

class MdTitles {
  String? title;

  MdTitles({this.title});

  MdTitles.fromJson(Map<String, dynamic> json) {
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    return data;
  }
}

class MdCovers {
  int? w;
  int? h;
  String? b2key;

  MdCovers({this.w, this.h, this.b2key});

  MdCovers.fromJson(Map<String, dynamic> json) {
    w = json['w'];
    h = json['h'];
    b2key = json['b2key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['w'] = w;
    data['h'] = h;
    data['b2key'] = b2key;
    return data;
  }
}

class MuComics {
  int? year;

  MuComics({this.year});

  MuComics.fromJson(Map<String, dynamic> json) {
    year = json['year'];
  }
}
