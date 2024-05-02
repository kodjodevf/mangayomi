import 'dart:convert';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/xpath_selector.dart';

class VoeExtractor {
  final InterceptedClient client = MClient.init();
  final linkRegex = RegExp(
      r'(http|https)://([\w_-]+(?:\.[\w_-]+)+)([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])');

  final base64Regex = RegExp(r"'.*'");
  Future<List<Video>> videosFromUrl(String url, String? prefix) async {
    try {
      final response = await client.get(Uri.parse(url));
      final script = xpathSelector(response.body)
          .queryXPath(
              '//script[contains(text(), "const sources") or contains(text(), "var sources") or contains(text(), "wc0")]/text()')
          .attrs;
      if (script.isEmpty) {
        return [];
      }

      final scriptContent = script.first!;
      String playlistUrl = "";
      if (scriptContent.contains('sources')) {
        final link =
            RegExp(r"hls': '([^']+)'").firstMatch(scriptContent)?.group(1);
        playlistUrl =
            linkRegex.hasMatch(link!) ? link : utf8.decode(base64.decode(link));
      } else if (scriptContent.contains('wc0')) {
        final base64Match = base64Regex.firstMatch(scriptContent)!.group(0)!;
        final decoded = utf8.decode(base64.decode(base64Match));
        playlistUrl = json.decode(decoded)['file'];
      } else {
        return [];
      }
      final masterPlaylistResponse = await client.get(Uri.parse(playlistUrl));
      final masterPlaylist = masterPlaylistResponse.body;

      const separator = "#EXT-X-STREAM-INF";
      return masterPlaylist
          .substringAfter(separator)
          .split(separator)
          .map((it) {
        final resolution =
            "${it.substringAfter("RESOLUTION=").substringBefore("\n").substringAfter("x").substringBefore(",")}p";
        final videoUrl = it.substringAfter("\n").substringBefore("\n");
        return Video(videoUrl, '${prefix ?? ""}Voe: $resolution', videoUrl);
      }).toList();
    } catch (_) {
      return [];
    }
  }
}
