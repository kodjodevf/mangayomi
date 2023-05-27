class MangaSearchModelComick {
  String? title;
  String? hid;
  int? id;
  String? slug;
  String? rating;
  int? ratingCount;
  int? followCount;
  int? userFollowCount;
  String? contentRating;
  int? demographic;
  List<MdCovers>? mdCovers;
  String? highlight;
  String? coverUrl;

  MangaSearchModelComick(
      {this.title,
      this.hid,
      this.id,
      this.slug,
      this.rating,
      this.ratingCount,
      this.followCount,
      this.userFollowCount,
      this.contentRating,
      this.demographic,
      this.mdCovers,
      this.highlight,
      this.coverUrl});

  MangaSearchModelComick.fromJson(Map<String, dynamic> json) {
    title = json['title'];

    slug = json['slug'];
    hid = json['hid'];

    coverUrl = json['cover_url'];
  }
}

class MdCovers {
  String? vol;
  int? w;
  int? h;
  String? b2key;

  MdCovers({this.vol, this.w, this.h, this.b2key});

  MdCovers.fromJson(Map<String, dynamic> json) {
    vol = json['vol'];
    w = json['w'];
    h = json['h'];
    b2key = json['b2key'];
  }
}
