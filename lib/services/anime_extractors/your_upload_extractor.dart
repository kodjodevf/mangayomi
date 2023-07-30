import 'package:http/http.dart' as http;
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/utils/extensions.dart';
import 'package:mangayomi/utils/xpath_selector.dart';

class YourUploadExtractor {
  http.Client client = http.Client();

  Future<List<Video>> videosFromUrl(String url, Map<String, String> headers,
      {String name = "YourUpload", String prefix = ""}) async {
    final newHeaders = Map<String, String>.from(headers);
    newHeaders["referer"] = "https://www.yourupload.com/";

    try {
      final response = await client.get(Uri.parse(url), headers: newHeaders);
      final baseData = xpathSelector(response.body)
          .queryXPath('//script[contains(text(), "jwplayerOptions")]/text()')
          .attrs;
      if (baseData.isNotEmpty) {
        final basicUrl =
            baseData.first!.substringAfter("file: '").substringBefore("',");
        final quality = prefix + name;
        return [Video(basicUrl, quality, basicUrl, headers: newHeaders)];
      } else {
        return [];
      }
    } catch (_) {
      return [];
    }
  }
}
