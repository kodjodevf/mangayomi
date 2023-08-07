import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:mangayomi/models/video.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:html/parser.dart' as parser;
import 'package:mangayomi/utils/extensions.dart';

class GogoCdnExtractor {
  final http.Client client = http.Client();
  final JsonCodec json = const JsonCodec();

  Future<List<Video>> videosFromUrl(String serverUrl) async {
    try {
      final response = await client.get(Uri.parse(serverUrl));
      final document = response.body;

      Document parsedResponse = parser.parse(response.body);
      final iv = parsedResponse
          .querySelector('div.wrapper')!
          .attributes["class"]!
          .split('container-')
          .last;

      final secretKey = parsedResponse
          .querySelector('body[class]')!
          .attributes["class"]!
          .split('container-')
          .last;
      RegExp(r'container-(\d+)').firstMatch(document)?.group(1);
      final decryptionKey =
          RegExp(r'videocontent-(\d+)').firstMatch(document)?.group(1);
      final encryptAjaxParams = _cryptoHandler(
        RegExp(r'data-value="([^"]+)').firstMatch(document)?.group(1) ?? "",
        Uint8List.fromList(iv.codeUnits),
        Uint8List.fromList(secretKey.codeUnits),
        encrypt: false,
      ).substringAfter("&");

      final httpUrl = Uri.parse(serverUrl);
      final host = "https://${httpUrl.host}/";
      final id = httpUrl.queryParameters['id'];
      final encryptedId = _cryptoHandler(
        id ?? "",
        Uint8List.fromList(iv.codeUnits),
        Uint8List.fromList(secretKey.codeUnits),
      );

      final token = httpUrl.queryParameters['token'];
      final qualityPrefix = token != null ? "Gogostream - " : "Vidstreaming - ";

      final encryptAjaxUrl =
          "${host}encrypt-ajax.php?id=$encryptedId&$encryptAjaxParams&alias=$id";

      final encryptAjaxResponse = await client.get(Uri.parse(encryptAjaxUrl),
          headers: {"X-Requested-With": "XMLHttpRequest"});
      final jsonResponse = encryptAjaxResponse.body;
      final data = json.decode(jsonResponse)["data"];
      final decryptedData = _cryptoHandler(
          data ?? "",
          Uint8List.fromList(iv.codeUnits),
          Uint8List.fromList(decryptionKey!.codeUnits),
          encrypt: false);
      final videoList = <Video>[];
      final autoList = <Video>[];
      final array = json.decode(decryptedData)["source"];
      if (array != null &&
          array is List &&
          array.length == 1 &&
          array[0]["type"] == "hls") {
        final fileURL = array[0]["file"].toString().trim();
        const separator = "#EXT-X-STREAM-INF:";
        final masterPlaylistResponse = await client.get(Uri.parse(fileURL));
        final masterPlaylist = masterPlaylistResponse.body;
        if (masterPlaylist.contains(separator)) {
          for (var it
              in masterPlaylist.substringAfter(separator).split(separator)) {
            final quality =
                "${it.substringAfter("RESOLUTION=").substringAfter("x").substringBefore(",").substringBefore("\n")}p";

            var videoUrl = it.substringAfter("\n").substringBefore("\n");

            if (!videoUrl.startsWith("http")) {
              videoUrl =
                  "${fileURL.split("/").sublist(0, fileURL.split("/").length - 1).join("/")}/$videoUrl";
            }
            videoList.add(Video(videoUrl, "$qualityPrefix$quality", videoUrl));
          }
        } else {
          videoList.add(Video(fileURL, "${qualityPrefix}Original", fileURL));
        }
      } else if (array != null && array is List) {
        for (var it in array) {
          final label =
              it["label"].toString().toLowerCase().trim().replaceAll(" ", "");
          final fileURL = it["file"].toString().trim();
          final videoHeaders = {"Referer": serverUrl};
          if (label == "auto") {
            autoList.add(Video(fileURL, "$qualityPrefix$label", fileURL,
                headers: videoHeaders));
          } else {
            videoList.add(Video(fileURL, "$qualityPrefix$label", fileURL,
                headers: videoHeaders));
          }
        }
      }
      return videoList + autoList;
    } catch (e) {
      return [];
    }
  }

  String _cryptoHandler(
    String string,
    Uint8List iv,
    Uint8List secretKeyString, {
    bool encrypt = true,
  }) {
    if (encrypt) {
      final encryptt = _encrypt(
          String.fromCharCodes(secretKeyString), String.fromCharCodes(iv));
      final aa = encryptt.$1.encrypt(string, iv: encryptt.$2);
      return aa.base64;
    } else {
      final encryptt = _encrypt(
          String.fromCharCodes(secretKeyString), String.fromCharCodes(iv));
      final aa = encryptt.$1.decrypt64(string, iv: encryptt.$2);
      return aa;
    }
  }
}

(encrypt.Encrypter, encrypt.IV) _encrypt(String keyy, String ivv) {
  final key = encrypt.Key.fromUtf8(keyy);
  final iv = encrypt.IV.fromUtf8(ivv);
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
  return (encrypter, iv);
}
