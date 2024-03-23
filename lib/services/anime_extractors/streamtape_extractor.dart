import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/models/video.dart';
import 'package:html/parser.dart' show parse;
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';

class StreamTapeExtractor {
  Future<List<Video>> videosFromUrl(String url,
      {String quality = "StreamTape"}) async {
    final InterceptedClient client = MClient.init();
    try {
      const baseUrl = "https://streamtape.com/e/";
      final newUrl =
          !url.startsWith(baseUrl) ? "$baseUrl${url.split("/")[4]}" : url;

      final response = await client.get(Uri.parse(newUrl));
      final document = parse(response.body);

      const targetLine = "document.getElementById('robotlink')";
      String script = "";
      final scri = document
          .querySelectorAll("script")
          .where((element) => element.innerHtml.contains(targetLine))
          .map((e) => e.innerHtml)
          .toList();
      if (scri.isEmpty) {
        return [];
      }
      script = scri.first.split("$targetLine.innerHTML = '").last;
      final videoUrl =
          "https:${script.substringBefore("'")}${script.substringAfter("+ ('xcd").substringBefore("'")}";

      return [Video(videoUrl, quality, videoUrl)];
    } catch (_) {
      return [];
    }
  }
}
