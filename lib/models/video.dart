import 'package:mangayomi/eval/javascript/http.dart';

class Video {
  String url;
  String quality;
  String originalUrl;
  Map<String, String>? headers;
  List<Track>? subtitles;
  List<Track>? audios;

  Video(this.url, this.quality, this.originalUrl,
      {this.headers, this.subtitles, this.audios});
  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(json['url'], json['quality'], json['originalUrl'],
        headers: (json['headers'] as Map?).toMapStringString,
        subtitles: json['subtitles'] != null
            ? (json['subtitles'] as List).map((e) => Track.fromJson(e)).toList()
            : [],
        audios: json['audios'] != null
            ? (json['audios'] as List).map((e) => Track.fromJson(e)).toList()
            : []);
  }
  Map<String, dynamic> toJson() => {
        'url': url,
        'quality': quality,
        'originalUrl': originalUrl,
        'headers': headers,
        'subtitles': subtitles?.map((e) => e.toJson()).toList(),
        'audios': audios?.map((e) => e.toJson()).toList(),
      };
}

class Track {
  String? file;
  String? label;

  Track({this.file, this.label});
  Track.fromJson(Map<String, dynamic> json) {
    file = json['file'];
    label = json['label'];
  }
  Map<String, dynamic> toJson() => {'file': file, 'label': label};
}
