import 'package:html/parser.dart' show parse;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/extensions/dom_extensions.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:path/path.dart' as path;

class OkruExtractor {
  final InterceptedClient client = MClient.init(reqcopyWith: {'useDartHttpClient': true});

  Future<List<Video>> videosFromUrl(String url, {String prefix = "", bool fixQualities = true}) async {
    final response = await client.get(Uri.parse(url));
    final document = parse(response.body);
    final videoString = document.selectFirst('div[data-options]')?.attr("data-options");

    if (videoString == null) {
      return [];
    }

    if (videoString.contains('ondemandHls')) {
      final playlistUrl = Uri.parse(
          videoString.substringAfter("ondemandHls\\\":\\\"").substringBefore("\\\"").replaceAll("\\\\u0026", "&"));

      final masterPlaylistResponse = await client.get(playlistUrl);
      final masterPlaylist = masterPlaylistResponse.body;

      const separator = "#EXT-X-STREAM-INF";
      return masterPlaylist.substringAfter(separator).split(separator).map((it) {
        final resolution =
            "${it.substringAfter("RESOLUTION=").substringBefore("\n").substringAfter("x").substringBefore(",")}p";
        final m3u8Host = "${playlistUrl.scheme}://${playlistUrl.host}${path.dirname(playlistUrl.path)}";
        final videoUrl = "$m3u8Host/${it.substringAfter("\n").substringBefore("\n")}";
        return Video(videoUrl, "${prefix.isNotEmpty ? prefix : ""}Okru:$resolution", videoUrl);
      }).toList();
    }

    return [];
  }
}
