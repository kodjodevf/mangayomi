class Video {
  final String url;
  final String quality;
  final String originalUrl;
  final Map<String, String>? headers;
  final List<Track>? subtitles;

  Video(this.url, this.quality, this.originalUrl,
      {this.headers, this.subtitles});
}

class Track {
  final String? file;
  final String? label;

  Track(this.file, this.label);
}
