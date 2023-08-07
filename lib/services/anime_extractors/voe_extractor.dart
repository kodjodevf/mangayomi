import 'package:http/http.dart' as http;
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/utils/extensions.dart';
import 'package:mangayomi/utils/xpath_selector.dart';

class VoeExtractor {
  http.Client client = http.Client();

  Future<List<Video>> videosFromUrl(String url, String? quality) async {
    try {
      final response = await client.get(Uri.parse(url));
      final script = xpathSelector(response.body)
          .queryXPath(
              '//script[contains(text(), "const sources") or contains(text(), "var sources")]/text()')
          .attrs;
      if (script.isEmpty) {
        return [];
      }

      final videoUrl =
          script.first!.substringAfter("hls': '").substringBefore("'");
      final resolution =
          script.first!.substringAfter("video_height': ").substringBefore(",");
      final qualityStr = quality ?? "VoeCDN (${resolution}p)";
      return [Video(videoUrl, qualityStr, videoUrl)];
    } catch (_) {
      return [];
    }
  }
}
