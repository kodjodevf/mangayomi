import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/ffi/torrent_server_ffi.dart' as libmtorrentserver_ffi;

class MTorrentServer {
  final http = MClient.init();
  Future<bool> removeTorrent(String? inforHash) async {
    if (inforHash == null || inforHash.isEmpty) return false;
    try {
      final res = await http.delete(
        Uri.parse("$_baseUrl/torrent/remove?infohash=$inforHash"),
      );
      if (res.statusCode == 200) {
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> check() async {
    if (_baseUrl == "http://127.0.0.1:0") return false;
    try {
      final res = await http.get(Uri.parse("$_baseUrl/"));
      if (res.statusCode == 200) {
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<String> getInfohash(String url, bool isFilePath) async {
    try {
      final torrentByte = isFilePath
          ? File(url).readAsBytesSync()
          : (await http.get(Uri.parse(url))).bodyBytes;
      var request = MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/torrent/add'),
      );

      request.files.add(
        MultipartFile.fromBytes('file', torrentByte, filename: 'file.torrent'),
      );
      final response = await http.send(request);
      return await response.stream.bytesToString();
    } catch (e) {
      rethrow;
    }
  }

  Future<(List<Video>, String?)> getTorrentPlaylist(
    String? url,
    String? archivePath,
  ) async {
    try {
      final isFilePath = archivePath?.isNotEmpty ?? false;
      final isRunning = await check();
      if (!isRunning) {
        final path = (await StorageProvider().getBtDirectory())!.path;
        final config = jsonEncode({"path": path, "address": "127.0.0.1:0"});
        int port = 0;
        if (Platform.isAndroid || Platform.isIOS) {
          const channel = MethodChannel(
            'com.kodjodevf.mangayomi.libmtorrentserver',
          );
          port = await channel.invokeMethod('start', {"config": config});
        } else {
          port = await Isolate.run(() async {
            return libmtorrentserver_ffi.start(config);
          });
        }
        _setBtServerPort(port);
      }
      url = isFilePath ? archivePath! : url!;
      bool isMagnet = url.startsWith("magnet:?");
      String finalUrl = "";
      String? infohash;
      if (!isMagnet) {
        infohash = await getInfohash(url, isFilePath);
        finalUrl = "$_baseUrl/torrent/play?infohash=$infohash";
      } else {
        finalUrl = "$_baseUrl/torrent/play?magnet=$url";
      }

      final masterPlaylist = (await http.get(Uri.parse(finalUrl))).body;
      final videoList = <Video>[];
      const separator = "#EXTINF:";
      for (var e in masterPlaylist.substringAfter(separator).split(separator)) {
        final fileName = e.substringAfter("-1,").substringBefore("\n");
        if (fileName.isMediaVideo()) {
          var videoUrl = e.substringAfter("\n").substringBefore("\n");
          videoList.add(Video(videoUrl, fileName, videoUrl));
        }
      }

      return (videoList, infohash);
    } catch (e) {
      rethrow;
    }
  }
}

String get _baseUrl {
  final settings = isar.settings.getSync(227);
  final port = settings!.btServerPort ?? 0;
  final address = settings.btServerAddress ?? "127.0.0.1";
  return "http://$address:$port";
}

void _setBtServerPort(int newPort) {
  isar.writeTxnSync(
    () => isar.settings.putSync(
      isar.settings.getSync(227)!
        ..btServerPort = newPort
        ..updatedAt = DateTime.now().millisecondsSinceEpoch,
    ),
  );
}
