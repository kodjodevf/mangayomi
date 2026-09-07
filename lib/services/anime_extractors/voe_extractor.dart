import 'dart:convert';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/extensions/dom_extensions.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';

class VoeExtractor {
  VoeExtractor({http.Client? client})
    : client = client ?? MClient.init(reqcopyWith: {'useDartHttpClient': true});

  final http.Client client;
  final linkRegex = RegExp(
    r'(http|https)://([\w_-]+(?:\.[\w_-]+)+)([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])',
  );

  final base64Regex = RegExp(r"'.*'");
  final RegExp scriptBase64Regex = RegExp(
    r"(let|var)\s+\w+\s*=\s*'(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)';",
  );

  Future<List<Video>> videosFromUrl(String url, String? prefix) async {
    try {
      Document document = parse((await client.get(Uri.parse(url))).body);
      var scriptElement = document.selectFirst("script");
      if (scriptElement?.text.contains(
            "if (typeof localStorage !== 'undefined')",
          ) ??
          false) {
        var originalUrl = scriptElement?.text
            .substringAfter("window.location.href = '")
            .substringBefore("';");
        if (originalUrl == null) {
          return [];
        }
        document = parse((await client.get(Uri.parse(originalUrl))).body);
        url = originalUrl;
      }

      final currentPlaylistUrl = await _currentPlaylistUrl(
        document,
        Uri.parse(url),
      );
      var alternativeScript = document
          .select('script')
          ?.where((script) => scriptBase64Regex.hasMatch(script.text))
          .toList();

      Element? script = document.selectFirst(
        "script:contains(const sources), script:contains(var sources), script:contains(wc0)",
      );
      if (currentPlaylistUrl == null && script == null) {
        if (alternativeScript?.isNotEmpty ?? false) {
          script = alternativeScript!.first;
        } else {
          return [];
        }
      }
      final scriptContent = script?.text ?? '';
      String playlistUrl = currentPlaylistUrl ?? "";
      if (playlistUrl.isNotEmpty) {
        // The current VOE payload is decoded above. Keep the legacy branches
        // below for mirrors that still serve the older inline formats.
      } else if (scriptContent.contains('sources')) {
        final link = scriptContent
            .substringAfter("hls': '")
            .substringBefore("'");

        playlistUrl = linkRegex.hasMatch(link)
            ? link
            : utf8.decode(base64.decode(link));
      } else if (scriptContent.contains('wc0') || alternativeScript != null) {
        final base64Match = base64Regex.firstMatch(scriptContent)!.group(0)!;
        final decoded = utf8.decode(base64.decode(base64Match));
        playlistUrl = json.decode(
          alternativeScript != null
              ? String.fromCharCodes(decoded.runes.toList().reversed)
              : decoded,
        )['file'];
      } else {
        return [];
      }
      final uri = Uri.parse(playlistUrl);
      final masterPlaylistResponse = await client.get(uri);
      final masterPlaylist = masterPlaylistResponse.body;

      const separator = "#EXT-X-STREAM-INF";
      return masterPlaylist.substringAfter(separator).split(separator).map((
        it,
      ) {
        final resolution =
            "${it.substringAfter("RESOLUTION=").substringBefore("\n").substringAfter("x").substringBefore(",")}p";
        final line = it.substringAfter("\n").substringBefore("\n");
        final videoUrl = uri.resolve(line).toString();
        return Video(videoUrl, '${prefix ?? ""}Voe: $resolution', videoUrl);
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<String?> _currentPlaylistUrl(Document document, Uri pageUri) async {
    final payloadElement = document.selectFirst(
      'script[type="application/json"]',
    );
    final loaderElement = document.selectFirst(
      'script[type="application/json"] + script[src]',
    );
    final loaderSource = loaderElement?.attributes['src'];
    if (payloadElement == null || loaderSource == null) {
      return null;
    }

    final payload = json.decode(payloadElement.text);
    if (payload is! List || payload.isEmpty || payload.first is! String) {
      return null;
    }

    final loader = await client.get(pageUri.resolve(loaderSource));
    final lookupTableMatch = RegExp(r"\[(?:'\W{2}'\s*(?:,\s*|\])){1,9}")
        .firstMatch(loader.body);
    if (lookupTableMatch == null) {
      return null;
    }
    final lookupTable = RegExp(r"'([^']+)'")
        .allMatches(lookupTableMatch.group(0)!)
        .map((match) => match.group(1)!)
        .toList();

    var encoded = _rot13(payload.first as String);
    for (final marker in lookupTable) {
      encoded = encoded.replaceAll(marker, '');
    }

    final shifted = utf8.decode(base64.decode(base64.normalize(encoded)));
    final reversedBase64 = String.fromCharCodes(
      shifted.codeUnits.map((codeUnit) => codeUnit - 3),
    ).split('').reversed.join();
    final decoded = json.decode(
      utf8.decode(base64.decode(base64.normalize(reversedBase64))),
    );
    if (decoded is! Map) {
      return null;
    }

    for (final key in const ['source', 'file', 'direct_access_url']) {
      final value = decoded[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }
    return null;
  }

  String _rot13(String value) {
    return String.fromCharCodes(
      value.codeUnits.map((codeUnit) {
        if (codeUnit >= 65 && codeUnit <= 90) {
          return (codeUnit - 52) % 26 + 65;
        }
        if (codeUnit >= 97 && codeUnit <= 122) {
          return (codeUnit - 84) % 26 + 97;
        }
        return codeUnit;
      }),
    );
  }
}
