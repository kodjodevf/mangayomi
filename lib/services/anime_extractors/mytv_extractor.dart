import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/utils/extensions.dart';

class MytvExtractor {
  final http.Client client = http.Client();

  Future<List<Video>> videosFromUrl(String url) async {
    try {
      final response = await client.get(Uri.parse(url));
      final document = parse(response.body);
      final videoList = <Video>[];

      document.querySelectorAll("script").forEach((script) {
        if (script.text.contains("CreatePlayer(\"v")) {
          final videosString = script.text;
          final videoUrl = videosString
              .substringAfter("\"v=")
              .substringBefore("\\u0026tp=video")
              .replaceAll("%26", "&")
              .replaceAll("%3a", ":")
              .replaceAll("%2f", "/")
              .replaceAll("%3f", "?")
              .replaceAll("%3d", "=");

          if (!videoUrl.contains("https:")) {
            videoList.add(Video(videoUrl, "Stream", videoUrl));
          } else {
            videoList.add(Video(videoUrl, "Mytv", videoUrl));
          }
        }
      });

      return videoList;
    } catch (_) {
      return [];
    }
  }
}
