class Video {
  final String url;
  final String quality;
  final String originalUrl;
  final Map<String, String>? headers;
  final List<Track>? subtitles;
  final List<Track>? audios;

  Video(this.url, this.quality, this.originalUrl,
      {this.headers, this.subtitles, this.audios});
}

class Track {
  final String? file;
  final String? label;

  Track(this.file, this.label);
}
