class Video {
  String url;
  String quality;
  String originalUrl;
  Map<String, String>? headers;
  List<Track>? subtitles;
  List<Track>? audios;

  Video(this.url, this.quality, this.originalUrl,
      {this.headers, this.subtitles, this.audios});
}

class Track {
  String? file;
  String? label;

  Track({this.file, this.label});
}
