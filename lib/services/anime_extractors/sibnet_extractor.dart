import 'package:http/http.dart' as http;
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/utils/extensions.dart';

class SibnetExtractor {
  final http.Client client = http.Client();

  Future<List<Video>> videosFromUrl(String url) async {
    List<Video> videoList = [];
    try {
      final response = await client.get(Uri.parse(url));
      if (response.statusCode != 200) {
        return [];
      }

      String script = response.body;
      String slug = script
          .substringAfter("player.src")
          .substringAfter("src:")
          .substringAfter("\"")
          .substringBefore("\"");

      String videoUrl =
          slug.contains("http") ? slug : "https://${Uri.parse(url).host}$slug";

      Map<String, String> videoHeaders = {
        "Referer": url,
      };

      videoList.add(
        Video(videoUrl, "Sibnet", videoUrl, headers: videoHeaders),
      );

      return videoList;
    } catch (_) {
      return [];
    }
  }
}
