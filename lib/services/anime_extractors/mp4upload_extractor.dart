import 'package:http/http.dart' as http;
import 'package:js_packer/js_packer.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/utils/extensions.dart';
import 'package:mangayomi/utils/xpath_selector.dart';

class Mp4uploadExtractor {
  static final RegExp qualityRegex = RegExp(r'\WHEIGHT=(\d+)');
  static const String referer = "https://mp4upload.com/";

  Future<List<Video>> videosFromUrl(String url, Map<String, String> headers,
      {String prefix = '', String suffix = ''}) async {
    final newHeaders = Map<String, String>.from(headers)
      ..addAll({'referer': referer});
    try {
      final response = await http.get(Uri.parse(url), headers: newHeaders);
      String script = "";

      final scriptElementWithEval = xpathSelector(response.body)
          .queryXPath(
              '//script[contains(text(), "eval") and contains(text(), "p,a,c,k,e,d")]/text()')
          .attrs;

      if (scriptElementWithEval.isNotEmpty) {
        script = _evalJs(script)!;
      } else {
        final scriptElementWithSrc = xpathSelector(response.body)
            .queryXPath('//script[contains(text(), "player.src")]/text()')
            .attrs;
        if (scriptElementWithSrc.isNotEmpty) {
          script = scriptElementWithSrc.first!;
        } else {
          return [];
        }
      }

      final videoUrl = script
          .substringAfter('.src(')
          .substringBefore(')')
          .substringAfter('src:')
          .substringAfter('"')
          .substringBefore('"');
      final resolutionMatch = qualityRegex.firstMatch(script);
      final resolution = resolutionMatch?.group(1) ?? 'Unknown resolution';
      final quality = '$prefix Mp4Upload - $resolution $suffix';

      return [
        Video(videoUrl, quality, videoUrl, headers: newHeaders),
      ];
    } catch (_) {
      return [];
    }
  }
}

String? _evalJs(String script) {
  final jsPacker = JSPacker(script);
  return jsPacker.unpack();
}
