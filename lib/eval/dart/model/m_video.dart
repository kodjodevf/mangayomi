class MVideo {
  String url;
  String quality;
  String originalUrl;
  Map<String, String>? headers;
  List<MTrack>? subtitles;
  List<MTrack>? audios;

  MVideo(this.url, this.quality, this.originalUrl,
      {this.headers, this.subtitles, this.audios});
}

class MTrack {
  String? file;
  String? label;

  MTrack({this.file, this.label});
}
