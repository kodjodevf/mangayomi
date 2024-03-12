class MChapter {
  String? name;

  String? url;

  String? dateUpload;

  String? scanlator;
  MChapter({this.name, this.url, this.dateUpload, this.scanlator});
  factory MChapter.fromJson(Map<String, dynamic> json) {
    return MChapter(
        name: json['name'],
        url: json['url'],
        dateUpload: json['dateUpload'],
        scanlator: json['scanlator']);
  }
}
