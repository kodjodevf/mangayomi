import 'package:html/parser.dart' show parse;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/extensions/dom_extensions.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';

class OkruExtractor {
  final InterceptedClient client = MClient.init();

  Future<List<Video>> videosFromUrl(String url,
      {String prefix = "", bool fixQualities = true}) async {
    final response = await client.get(Uri.parse(url));
    final document = parse(response.body);
    final videoString =
        document.selectFirst('div[data-options]')?.attr("data-options");

    if (videoString == null) {
      return [];
    }

    if (videoString.contains('ondemandHls')) {
      final playlistUrl = Uri.parse(videoString
          .substringAfter("ondemandHls\\\":\\\"")
          .substringBefore("\\\"")
          .replaceAll("\\\\u0026", "&"));
      final masterPlaylistResponse = await client.get(playlistUrl);
      final masterPlaylist = masterPlaylistResponse.body;

      const separator = "#EXT-X-STREAM-INF";
      return masterPlaylist
          .substringAfter(separator)
          .split(separator)
          .map((it) {
        final resolution =
            "${it.substringAfter("RESOLUTION=").substringBefore("\n").substringAfter("x").substringBefore(",")}p";
        final videoUrl = "${Uri(
          scheme: playlistUrl.scheme,
          host: playlistUrl.host,
          pathSegments: playlistUrl.pathSegments
              .sublist(0, playlistUrl.pathSegments.length - 1),
        ).toString()}/${it.substringAfter("\n").substringBefore("\n")}";
        return Video(videoUrl,
            "${prefix.isNotEmpty ? prefix : ""}Okru:$resolution", videoUrl);
      }).toList();
    }

    return [];
  }

  String resolveUrl(Uri uri, String url) {
    return "${Uri(
      scheme: uri.scheme,
      host: uri.host,
      pathSegments: uri.pathSegments.sublist(0, uri.pathSegments.length - 1),
    ).toString()}/$url";
  }
}
