import 'package:http_interceptor/http_interceptor.dart';
import 'package:js_packer/js_packer.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/services/http/interceptor.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/xpath_selector.dart';

class FilemoonExtractor {
  final InterceptedClient client = MInterceptor.init();

  Future<List<Video>> videosFromUrl(
      String url, String prefix, String suffix) async {
    prefix = prefix.isEmpty ? "Filemoon " : prefix;
    try {
      final response = await client.get(Uri.parse(url));

      final jsEval = xpathSelector(response.body)
          .queryXPath('//script[contains(text(), "eval")]/text()')
          .attr;

      final unpacked = JSPacker(jsEval!).unpack() ?? "";

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
          "$prefix - $resolution $suffix",
          videoUrl,
          headers: videoHeaders,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }
}
