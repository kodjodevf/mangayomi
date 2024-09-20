// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:path/path.dart' as path;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:convert/convert.dart';

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

  Future<(List<TsInfo>, Uint8List?, Uint8List?, int?)> getTsList() async {
    Uint8List? key;
    Uint8List? iv;
    int? mediaSequence;
    final uri = Uri.parse(m3u8Url);
    final m3u8Host = "${uri.scheme}://${uri.host}${path.dirname(uri.path)}";
    final m3u8Body = await _getM3u8Body(m3u8Url);
    final tsList = _parseTsList(m3u8Host, m3u8Body);
    mediaSequence = _extractMediaSequence(m3u8Body);
    if (kDebugMode) {
      print("Total TS files to download: ${tsList.length}");
    }
    final (tsKey, tsIv) = await _getM3u8KeyAndIv(m3u8Body);
    if (tsKey?.isNotEmpty ?? false) {
      if (kDebugMode) {
        print("TS Key: $tsKey");
      }
      key = tsKey;
    }
    if (tsIv != null) {
      if (kDebugMode) {
        print("TS Iv: $tsIv");
      }
      iv = Uint8List.fromList(hex.decode(tsIv.replaceFirst("0x", "")));
    }
    if (mediaSequence != null) {
      if (kDebugMode) {
        print("Media sequence: $mediaSequence");
      }
    }
    return (tsList, key, iv, mediaSequence);
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
    List<TsInfo> tsList = [];
    int index = 0;
    for (final line in lines) {
      if (!line.startsWith("#") && line.isNotEmpty) {
        index++;
        final tsUrl = line.startsWith("http")
            ? line
            : "$host/${line.replaceFirst("/", "")}";
        tsList.add(TsInfo("TS_$index", tsUrl));
      }
    }
    return tsList;
  }

  Future<(Uint8List?, String?)> _getM3u8KeyAndIv(String m3u8Body) async {
    final uri = Uri.parse(m3u8Url);
    final m3u8Host = "${uri.scheme}://${uri.host}${path.dirname(uri.path)}";
    final lines = m3u8Body.split("\n");
    for (final line in lines) {
      if (line.contains("#EXT-X-KEY")) {
        final (keyUrl, iv) = _extractKeyAttributes(line, m3u8Host);
        if (keyUrl != null) {
          final response = await MClient.httpClient()
              .get(Uri.parse(keyUrl), headers: headers);
          if (response.statusCode == 200) {
            return (response.bodyBytes, iv);
          }
        } else {
          break;
        }
      }
    }
    return (null, null);
  }

  (String?, String?) _extractKeyAttributes(String content, String host) {
    final keyPattern = RegExp(
        r'#EXT-X-KEY:METHOD=AES-128(?:,URI="([^"]+)")?(?:,IV=0x([A-F0-9]+))?',
        caseSensitive: false);
    final match = keyPattern.firstMatch(content);

    String? uri = match?.group(1);
    if (uri != null) {
      if (!uri.contains("http")) {
        uri = "$host/$uri";
      }
    }
    final iv = match?.group(2);

    return (uri, iv);
  }

  Uint8List _aesDecrypt(int sequence, Uint8List encrypted, Uint8List key,
      {Uint8List? iv}) {
    if (iv == null) {
      iv = Uint8List(16);
      ByteData.view(iv.buffer).setUint64(8, sequence);
    }

    final encrypter = encrypt.Encrypter(
        encrypt.AES(encrypt.Key(key), mode: encrypt.AESMode.cbc));

    try {
      final decrypted = encrypter.decryptBytes(encrypt.Encrypted(encrypted),
          iv: encrypt.IV(iv));

      return Uint8List.fromList(decrypted);
    } catch (e) {
      throw ArgumentError('Decryption failed: $e');
    }
  }

  int? _extractMediaSequence(String content) {
    final lines = content.split('\n');
    for (var line in lines) {
      if (line.startsWith('#EXT-X-MEDIA-SEQUENCE')) {
        final sequenceStr = line.substringAfter(':');
        return int.tryParse(sequenceStr.trim());
      }
    }
    return null;
  }

  Future<void> mergeTsToMp4(String fileName, String directory) async {
    await Isolate.run(() async {
      List<String> tsPathList = [];
      final outFile = File(fileName).openWrite();
      final dir = Directory(directory);
      await for (var entity in dir.list()) {
        if (entity is File && entity.path.endsWith('.ts')) {
          tsPathList.add(entity.path);
        }
      }
      tsPathList.sort((a, b) =>
          int.parse(a.substringAfter("TS_").substringBefore(".")).compareTo(
              int.parse(b.substringAfter("TS_").substringBefore("."))));
      for (var path in tsPathList) {
        final bytes = await File(path).readAsBytes();
        outFile.add(bytes);
      }
      await outFile.flush();
      await outFile.close();
      await dir.delete(recursive: true);
    });
  }

  Future<void> processBytes(File newFile, Uint8List? tsKey, Uint8List? tsIv,
      int? m3u8Sequence) async {
    Uint8List bytes = await newFile.readAsBytes();
    if (tsKey != null) {
      final index =
          int.parse(newFile.path.substringAfter("TS_").substringBefore("."));
      bytes = _aesDecrypt((m3u8Sequence ?? 1) + (index - 1), bytes, tsKey,
          iv: tsIv);
    }

    await newFile.writeAsBytes(bytes);
  }
}
