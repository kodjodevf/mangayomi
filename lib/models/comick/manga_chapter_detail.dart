class MangaChapterModelComick {
  List<Chapters>? chapters;
  int? total;

  MangaChapterModelComick({this.chapters, this.total});

  MangaChapterModelComick.fromJson(Map<String, dynamic> json) {
    if (json['chapters'] != null) {
      chapters = <Chapters>[];
      json['chapters'].forEach((v) {
        chapters!.add(Chapters.fromJson(v));
      });
    }
    total = json['total'];
  }
}

class Chapters {
  int? id;
  String? chap;
  String? title;
  String? vol;
  String? slug;
  String? lang;
  String? createdAt;
  String? updatedAt;
  int? upCount;
  int? downCount;
  List<dynamic>? groupName;
  String? hid;
  List<MdGroups>? mdGroups;

  Chapters(
      {this.id,
      this.chap,
      this.title,
      this.vol,
      this.slug,
      this.lang,
      this.createdAt,
      this.updatedAt,
      this.upCount,
      this.downCount,
      this.groupName,
      this.hid,
      this.mdGroups});

  Chapters.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chap = json['chap'];
    title = json['title'];
    vol = json['vol'];
    slug = json['slug'];
    lang = json['lang'];
    createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
    // upCount = json['up_count'];
    // downCount = json['down_count'];
    groupName = json['group_name'] ?? [];
    hid = json['hid'];
    // if (json['md_groups'] != null) {
    //   mdGroups = <MdGroups>[];
    //   json['md_groups'].forEach((v) {
    //     mdGroups!.add(MdGroups.fromJson(v));
    //   });
    // }
  }
}

class MdGroups {
  String? slug;
  String? title;

  MdGroups({this.slug, this.title});

  MdGroups.fromJson(Map<String, dynamic> json) {
    slug = json['slug'];
    title = json['title'];
  }
}
