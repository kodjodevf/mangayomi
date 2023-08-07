import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/utils/extensions.dart';

class OkruExtractor {
  final http.Client client = http.Client();

  String fixQuality(String quality) {
    final qualities = {
      'ultra': '2160p',
      'quad': '1440p',
      'full': '1080p',
      'hd': '720p',
      'sd': '480p',
      'low': '360p',
      'lowest': '240p',
      'mobile': '144p',
    };
    return qualities[quality.toLowerCase()] ?? quality;
  }

  Future<List<Video>> videosFromUrl(String url,
      {String prefix = '', bool fixQualities = true}) async {
    try {
      final response = await client.get(Uri.parse(url));
      final document = parse(response.body);
      final videosString = document
              .querySelector('div[data-options]')
              ?.attributes['data-options']!
              .substringAfter("\\\"videos\\\":[{\\\"name\\\":\\\"")
              .substringBefore(']') ??
          '';

      List<Video> videoList = [];
      List<String> values =
          videosString.split("{\\\"name\\\":\\\"").reversed.toList();
      for (var value in values) {
        final videoUrl = value
            .substringAfter("url\\\":\\\"")
            .substringBefore("\\\"")
            .replaceAll(r'\\\u0026', '&');
        final quality = value.substringBefore("\\\"");
        final fixedQuality = fixQualities ? fixQuality(quality) : quality;
        final videoQuality =
            '${prefix.isNotEmpty ? '$prefix ' : ''}Okru - $fixedQuality';
        if (videoUrl.startsWith('https://')) {
          videoList.add(Video(videoUrl, videoQuality, videoUrl));
        }
      }
      return videoList;
    } catch (_) {
      return [];
    }
  }
}
