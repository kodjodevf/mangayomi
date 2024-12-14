import 'dart:convert';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/extensions/dom_extensions.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:path/path.dart' as path;

class VoeExtractor {
  final InterceptedClient client = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  final linkRegex = RegExp(r'(http|https)://([\w_-]+(?:\.[\w_-]+)+)([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])');

  final base64Regex = RegExp(r"'.*'");
  final RegExp scriptBase64Regex =
      RegExp(r"(let|var)\s+\w+\s*=\s*'(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)';");

  Future<List<Video>> videosFromUrl(String url, String? prefix) async {
    try {
      Document document = parse((await client.get(Uri.parse(url))).body);
      var scriptElement = document.selectFirst("script");
      if (scriptElement?.text.contains("if (typeof localStorage !== 'undefined')") ?? false) {
        var originalUrl = scriptElement?.text.substringAfter("window.location.href = '").substringBefore("';");
        if (originalUrl == null) {
          return [];
        }
        document = parse((await client.get(Uri.parse(originalUrl))).body);
      }
      var alternativeScript = document
          .select('script')
          ?.where(
            (script) => scriptBase64Regex.hasMatch(script.text),
          )
          .toList();

      Element? script =
          document.selectFirst("script:contains(const sources), script:contains(var sources), script:contains(wc0)");
      if (script == null) {
        if (alternativeScript?.isNotEmpty ?? false) {
          script = alternativeScript!.first;
        } else {
          return [];
        }
      }
      final scriptContent = script.text;
      String playlistUrl = "";
      if (scriptContent.contains('sources')) {
        final link = scriptContent.substringAfter("hls': '").substringBefore("'");

        playlistUrl = linkRegex.hasMatch(link) ? link : utf8.decode(base64.decode(link));
      } else if (scriptContent.contains('wc0') || alternativeScript != null) {
        final base64Match = base64Regex.firstMatch(scriptContent)!.group(0)!;
        final decoded = utf8.decode(base64.decode(base64Match));
        playlistUrl = json.decode(
            alternativeScript != null ? String.fromCharCodes(decoded.runes.toList().reversed) : decoded)['file'];
      } else {
        return [];
      }
      final uri = Uri.parse(playlistUrl);
      final m3u8Host = "${uri.scheme}://${uri.host}${path.dirname(uri.path)}";
      final masterPlaylistResponse = await client.get(uri);
      final masterPlaylist = masterPlaylistResponse.body;

      const separator = "#EXT-X-STREAM-INF";
      return masterPlaylist.substringAfter(separator).split(separator).map((it) {
        final resolution =
            "${it.substringAfter("RESOLUTION=").substringBefore("\n").substringAfter("x").substringBefore(",")}p";
        final line = it.substringAfter("\n").substringBefore("\n");
        final videoUrl = line.startsWith("http") ? line : "$m3u8Host/${line.replaceFirst("/", "")}";
        return Video(videoUrl, '${prefix ?? ""}Voe: $resolution', videoUrl);
      }).toList();
    } catch (_) {
      return [];
    }
  }
}
