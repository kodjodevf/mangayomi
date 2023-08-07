import 'package:http/http.dart' as http;
import 'package:js_packer/js_packer.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/utils/extensions.dart';
import 'package:mangayomi/utils/xpath_selector.dart';

class FilemoonExtractor {
  final http.Client client = http.Client();

  Future<List<Video>> videosFromUrl(String url, String prefix) async {
    prefix = prefix.isEmpty ? "Filemoon - " : prefix;
    try {
      final response = await client.get(Uri.parse(url));

      final jsEval = xpathSelector(response.body)
          .queryXPath('//script[contains(text(), "eval")]/text()')
          .attr;

      final unpacked = _evalJs(jsEval!) ?? '';

      final masterUrl = unpacked.isNotEmpty
          ? unpacked.substringAfter('{file:"').substringBefore('"}')
          : '';

      if (masterUrl.isEmpty) {
        return [];
      }

      final masterPlaylistResponse = await client.get(Uri.parse(masterUrl));
      final masterPlaylist = masterPlaylistResponse.body;

      final videoHeaders = {
        'Referer': url,
        'Origin': 'https://${Uri.parse(url).host}',
      };

      const separator = '#EXT-X-STREAM-INF:';
      final playlists = masterPlaylist.split(separator).sublist(1);

      return playlists.map((playlist) {
        final resolution =
            '${playlist.substringAfter('RESOLUTION=').substringAfter('x').substringBefore(',').trim()}p';
        final videoUrl = playlist.split('\n')[1].trim();

        return Video(
          videoUrl,
          "$prefix - $resolution",
          videoUrl,
          headers: videoHeaders,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }
}

String? _evalJs(String script) {
  final jsPacker = JSPacker(script);
  return jsPacker.unpack();
}
