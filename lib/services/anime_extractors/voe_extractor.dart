import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/services/http/interceptor.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/xpath_selector.dart';

class VoeExtractor {
  final InterceptedClient client = MInterceptor.init();

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
