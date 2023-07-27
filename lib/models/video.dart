class Video {
  final String url;
  final String quality;
  final String originalUrl;
  final Map<String, String>? headers;

  Video(this.url, this.quality, this.originalUrl, {this.headers});
}