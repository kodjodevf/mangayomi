import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/utils/cryptoaes/crypto_aes.dart';
import 'package:mangayomi/utils/extensions.dart';

class RapidCloudExtractor {
  static const serverUrl = ['https://megacloud.tv', 'https://rapid-cloud.co'];
  static const sourceUrl = [
    '/embed-2/ajax/e-1/getSources?id=',
    '/ajax/embed-6-v2/getSources?id='
  ];
  static const sourceSpliter = ['/e-1/', '/embed-6-v2/'];
  static const sourceKey = ['1', '6'];

  final http.Client client = http.Client();

  Future<(String, String)> cipherTextCleaner(String data, String type) async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/Claudemirovsky/keys/e$type/key'));
    final List indexPairs = json.decode(response.body);

    String password = '';
    String ciphertext = data;
    int currentIndex = 0;

    for (List item in indexPairs) {
      final start = item.first + currentIndex;
      final end = start + item.last;
      final passSubstr = data.substring(start, end);
      password += passSubstr;
      ciphertext = ciphertext.replaceFirst(passSubstr, '');
      currentIndex += item[1] as int;
    }
    return (ciphertext, password);
  }

  Future<String> decrypt(String ciphered, String type) async {
    final result = await cipherTextCleaner(ciphered, type);

    final res = CryptoAES.decryptAESCryptoJS(result.$1, result.$2);

    return res;
  }

  Future<List<Video>> videosFromUrl(String url, String name) async {
    try {
      final type = url.startsWith('https://megacloud.tv') ? 0 : 1;
      final keyType = sourceKey[type];

      final id = url.split(sourceSpliter[type]).last.split('?').first;
      final srcRes =
          await http.get(Uri.parse('${serverUrl[type]}${sourceUrl[type]}$id'));
      final data = Data.fromJson(json.decode(srcRes.body));

      final decrypted = json.decode(await decrypt(data.sources!, keyType));
      final videoList = <Video>[];
      final fileURL = decrypted[0]["file"];
      const separator = "#EXT-X-STREAM-INF:";
      final masterPlaylistResponse = await http.get(Uri.parse(fileURL));
      final masterPlaylist = masterPlaylistResponse.body;
      if (masterPlaylist.contains(separator) && decrypted[0]["type"] == "hls") {
        for (var it
            in masterPlaylist.substringAfter(separator).split(separator)) {
          final quality =
              "${it.substringAfter("RESOLUTION=").substringAfter("x").substringBefore(",").substringBefore("\n")}p";

          var videoUrl = it.substringAfter("\n").substringBefore("\n");

          if (!videoUrl.startsWith("http")) {
            videoUrl =
                "${fileURL.split("/").sublist(0, fileURL.split("/").length - 1).join("/")}/$videoUrl";
          }

          videoList.add(Video(videoUrl, "$name - $quality", videoUrl,
              subtitles: data.tracks != null && data.tracks!.isEmpty
                  ? []
                  : data.tracks!
                      .map((e) => Track(e.file ?? "", e.label ?? ""))
                      .toList()));
        }
      } else {
        videoList.add(Video(fileURL, name, fileURL,
            subtitles: data.tracks != null && data.tracks!.isEmpty
                ? []
                : data.tracks!
                    .map((e) => Track(e.file ?? "", e.label ?? ""))
                    .toList()));
      }
      return videoList;
    } catch (_) {
      return [];
    }
  }
}

class Tracks {
  String? file;
  String? label;

  Tracks({
    this.file,
    this.label,
  });

  Tracks.fromJson(Map<String, dynamic> json) {
    file = json['file'];
    label = json['label'];
  }
}

class Data {
  String? sources;
  List<Tracks>? tracks;
  bool? encrypted;

  Data({
    this.sources,
    this.tracks,
    this.encrypted,
  });

  Data.fromJson(Map<String, dynamic> json) {
    sources = json['sources'];
    if (json['tracks'] != null) {
      tracks = <Tracks>[];
      json['tracks'].forEach((v) {
        tracks!.add(Tracks.fromJson(v));
      });
    }
    encrypted = json['encrypted'];
  }
}
