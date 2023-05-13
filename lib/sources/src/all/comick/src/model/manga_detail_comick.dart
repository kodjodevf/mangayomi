class MangaDetailModelComick {
  FirstChap? firstChap;
  Comic? comic;
  List? artists;
  List? authors;
  List<String>? langList;

  List? genres;
  bool? matureContent;
  bool? checkVol2Chap1;

  MangaDetailModelComick(
      {this.firstChap,
      this.comic,
      this.artists,
      this.authors,
      this.langList,
      this.genres,
      this.matureContent,
      this.checkVol2Chap1});

  MangaDetailModelComick.fromJson(Map<String, dynamic> json) {
    firstChap = json['firstChap'] != null
        ? FirstChap.fromJson(json['firstChap'])
        : null;
    comic = json['comic'] != null ? Comic.fromJson(json['comic']) : null;
    if (json['artists'] != null) {
      artists = json['artists'];
    }
    if (json['authors'] != null) {
      authors = json['authors'];
    }

    if (json['genres'] != null) {
      genres = json['genres'];
    }
    matureContent = json['matureContent'];
    checkVol2Chap1 = json['checkVol2Chap1'];
  }
}

class FirstChap {
  String? chap;
  String? hid;
  String? lang;
  List<String>? groupName;

  FirstChap({
    this.chap,
    this.hid,
    this.lang,
    this.groupName,
  });

  FirstChap.fromJson(Map<String, dynamic> json) {
    chap = json['chap'];
    hid = json['hid'];
    lang = json['lang'];
  }
}

class Comic {
  int? id;
  String? hid;
  String? title;
  String? country;
  int? status;

  double? lastChapter;
  int? chapterCount;
  int? demographic;
  bool? hentai;
  int? userFollowCount;
  int? followRank;
  int? commentCount;
  int? followCount;
  String? desc;
  String? parsed;
  String? slug;
  int? year;
  String? bayesianRating;
  int? ratingCount;
  String? contentRating;
  bool? translationCompleted;
  bool? chapterNumbersResetOnNewVolumeManual;

  String? iso6391;
  String? langName;
  String? langNative;
  String? coverUrl;

  Comic(
      {this.id,
      this.hid,
      this.title,
      this.country,
      this.status,
      this.lastChapter,
      this.chapterCount,
      this.demographic,
      this.hentai,
      this.userFollowCount,
      this.followRank,
      this.commentCount,
      this.followCount,
      this.desc,
      this.parsed,
      this.slug,
      this.year,
      this.bayesianRating,
      this.ratingCount,
      this.contentRating,
      this.translationCompleted,
      this.chapterNumbersResetOnNewVolumeManual,
      this.iso6391,
      this.langName,
      this.langNative,
      this.coverUrl});

  Comic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hid = json['hid'];
    title = json['title'];
    country = json['country'];
    status = json['status'];

    // lastChapter = double.parse(json['last_chapter'].toString());
    chapterCount = json['chapter_count'];
    demographic = json['demographic'];
    hentai = json['hentai'];
    userFollowCount = json['user_follow_count'];
    followRank = json['follow_rank'];
    commentCount = json['comment_count'];
    followCount = json['follow_count'];
    desc = json['desc'];
    // parsed = json['parsed'];
    slug = json['slug'];
    // year = json['year'];
    // bayesianRating = json['bayesian_rating'];
    // ratingCount = json['rating_count'];
    // contentRating = json['content_rating'];
    // translationCompleted = json['translation_completed'];
    // chapterNumbersResetOnNewVolumeManual =
    //     json['chapter_numbers_reset_on_new_volume_manual'];

    // iso6391 = json['iso639_1'];
    // langName = json['lang_name'];
    // langNative = json['lang_native'];
    coverUrl = json['cover_url'];
  }
}

class Artists {
  String? name;
  String? slug;

  Artists({this.name, this.slug});

  Artists.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    slug = json['slug'];
  }
}
