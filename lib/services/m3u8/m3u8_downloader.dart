import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:path/path.dart' as path;

class TsInfo {
  final String name;
  final String url;
  TsInfo(this.name, this.url);
}

class M3u8Downloader {
  final String m3u8Url;
  final String downloadDir;
  final Map<String, String>? headers;
  M3u8Downloader(
      {required this.m3u8Url,
      required this.downloadDir,
      required this.headers});

  Future<(List<TsInfo>, String?)> getTsList() async {
    String? key;
    final uri = Uri.parse(m3u8Url);
    final m3u8Host = "${uri.scheme}://${uri.host}${path.dirname(uri.path)}";
    final m3u8Body = await _getM3u8Body(m3u8Url);
    final tsList = _parseTsList(m3u8Host, m3u8Body);
    if (kDebugMode) {
      print("Total TS files to download: ${tsList.length}");
    }
    String? tsKey = await getM3u8Key(m3u8Body);
    if (tsKey?.isNotEmpty ?? false) {
      if (kDebugMode) {
        print("TS Key: $tsKey");
      }
      key = tsKey;
    }
    return (tsList, key);
  }

  Future<String> _getM3u8Body(
    String url,
  ) async {
    final response =
        await MClient.httpClient().get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to load m3u8 body");
    }
  }

  List<TsInfo> _parseTsList(String host, String body) {
    final lines = body.split("\n");
    final tsList = <TsInfo>[];
    int index = 0;
    String allText = "";
    for (final line in lines) {
      if (!line.startsWith("#") && line.isNotEmpty) {
        index++;
        final tsUrl = line.startsWith("http")
            ? line
            : "$host/${line.replaceFirst("/", "")}";
        allText += "http://localhost:3000/TS_$index.ts\n";
        tsList.add(TsInfo("TS_$index", tsUrl));
      } else {
        allText += "$line\n";
      }
    }
    Directory(downloadDir).createSync(recursive: true);
    File("$downloadDir/index.m3u8").writeAsStringSync(allText);
    return tsList;
  }

  Future<String?> getM3u8Key(String m3u8Body) async {
    final uri = Uri.parse(m3u8Url);
    final m3u8Host = "${uri.scheme}://${uri.host}${path.dirname(uri.path)}";
    final lines = m3u8Body.split("\n");
    for (final line in lines) {
      if (line.contains("#EXT-X-KEY")) {
        final keyUrl = _extractKeyUrl(m3u8Host, line);
        final response =
            await MClient.httpClient().get(Uri.parse(keyUrl), headers: headers);
        if (response.statusCode == 200) {
          return response.body;
        }
      }
    }
    return null;
  }

  String _extractKeyUrl(String host, String line) {
    final uriPos = line.indexOf("URI");
    final quotationMarkPos = line.lastIndexOf("\"");
    var keyUrl = line.substring(uriPos, quotationMarkPos).split("\"")[1];
    if (!line.contains("http")) {
      keyUrl = "$host/$keyUrl";
    }
    return keyUrl;
  }
}
