class GetChapterUrl {
  String? result;
  String? baseUrl;
  Chapter? chapter;

  GetChapterUrl({this.result, this.baseUrl, this.chapter});

  GetChapterUrl.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    baseUrl = json['baseUrl'];
    chapter =
        json['chapter'] != null ? Chapter.fromJson(json['chapter']) : null;
  }
}

class Chapter {
  String? hash;
  List<String>? data;
  List<String>? dataSaver;

  Chapter({this.hash, this.data, this.dataSaver});

  Chapter.fromJson(Map<String, dynamic> json) {
    hash = json['hash'];
    data = json['data'].cast<String>();
    dataSaver = json['dataSaver'].cast<String>();
  }
}
