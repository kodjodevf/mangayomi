import 'package:js_packer/js_packer.dart';
import 'package:http/http.dart' as http;
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/utils/extensions.dart';
import 'package:mangayomi/utils/xpath_selector.dart';

class StreamWishExtractor {
  final http.Client client = http.Client();
  final Map<String, String> headers = {};

  Future<List<Video>> videosFromUrl(String url, String prefix) async {
    final videoList = <Video>[];
    try {
      final response = await client.get(Uri.parse(url), headers: headers);

      final jsEval = xpathSelector(response.body)
          .queryXPath('//script[contains(text(), "m3u8")]/text()')
          .attrs;
      if (jsEval.isEmpty) {
        return [];
      }

      String? masterUrl = _evalJs(jsEval.first!)
          ?.substringAfter('source')
          .substringAfter('file:"')
          .substringBefore('"');

      if (masterUrl == null) return [];

      final playlistHeaders = Map<String, String>.from(headers)
        ..addAll({
          'Accept': '*/*',
          'Host': Uri.parse(masterUrl).host,
          'Origin': 'https://${Uri.parse(url).host}',
          'Referer': 'https://${Uri.parse(url).host}/',
        });

      final masterBase =
          '${'https://${Uri.parse(masterUrl).host}${Uri.parse(masterUrl).path}'.substringBeforeLast('/')}/';

      final masterPlaylistResponse =
          await client.get(Uri.parse(masterUrl), headers: playlistHeaders);
      final masterPlaylist = masterPlaylistResponse.body;

      const separator = '#EXT-X-STREAM-INF:';
      masterPlaylist.substringAfter(separator).split(separator).forEach((it) {
        final quality =
            '$prefix - ${it.substringAfter('RESOLUTION=').substringAfter('x').substringBefore(',')}p ';
        final videoUrl =
            masterBase + it.substringAfter('\n').substringBefore('\n');
        videoList
            .add(Video(videoUrl, quality, videoUrl, headers: playlistHeaders));
      });

      return videoList;
    } catch (_) {
      return [];
    }
  }
}

String? _evalJs(String script) {
  final jsPacker = JSPacker(script);
  return jsPacker.unpack();
}
