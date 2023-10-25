import 'package:mangayomi/eval/model/m_track.dart';

class MVideo {
  String? url;
  String? quality;
  String? originalUrl;
  Map<String, String>? headers;
  List<MTrack>? subtitles;
  List<MTrack>? audios;
  MVideo(
      {this.url,
      this.quality,
      this.originalUrl,
      this.headers,
      this.subtitles,
      this.audios});
}
