import 'dart:io';
import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:http/http.dart' as http;
import 'package:mangayomi/ffi/torrent_server_ffi.dart' as libmtorrentserver_ffi;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'torrent_server.g.dart';

class MTorrentServer {
  final _baseUrl = "http://127.0.0.1:3535";

  Future<bool> removeTorrent(String? inforHash) async {
    if (inforHash == null || inforHash.isEmpty) return false;
    try {
      final res = await http
          .delete(Uri.parse("$_baseUrl/torrent/remove?infohash=$inforHash"));
      if (res.statusCode == 200) {
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> check() async {
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

  Future<String> getInfohash(String url) async {
    try {
      final torrentByte = (await http.get(Uri.parse(url))).bodyBytes;
      var request =
          http.MultipartRequest('POST', Uri.parse('$_baseUrl/torrent/add'));

      request.files.add(http.MultipartFile.fromBytes('file', torrentByte,
          filename: 'file.torrent'));
      http.StreamedResponse response = await request.send();
      return await response.stream.bytesToString();
    } catch (e) {
      rethrow;
    }
  }

  Future<(List<Video>, String?)> getTorrentPlaylist(String url) async {
    final path = (await StorageProvider().getBtDirectory())!.path;
    final isRunning = await check();
    if (!isRunning) {
      if (Platform.isAndroid) {
        const channel =
            MethodChannel('com.kodjodevf.mangayomi.libmtorrentserver');
        channel.invokeMethod('start', {"path": path});
      } else {
        await Isolate.run(() async {
          libmtorrentserver_ffi.start(path);
        });
      }
    }
    bool isMagnet = !url.startsWith("http");
    String finalUrl = "";
    String? infohash;
    if (!isMagnet) {
      infohash = await getInfohash(url);
      finalUrl = "$_baseUrl/torrent/play?infohash=$infohash";
    } else {
      finalUrl = "$_baseUrl/torrent/play?magnet=$url";
    }

    final masterPlaylist = (await http.get(Uri.parse(finalUrl))).body;
    final videoList = <Video>[];
    const separator = "#EXTINF:";
    for (var e in masterPlaylist.substringAfter(separator).split(separator)) {
      final fileName = e.substringAfter("0,").substringBefore("\n");
      if (fileName.isMediaVideo()) {
        var videoUrl = e.substringAfter("\n").substringBefore("\n");
        videoList.add(Video(videoUrl, fileName, videoUrl));
      }
    }

    return (videoList, infohash);
  }
}

@riverpod
Future<bool> mTorrentIsRunning(MTorrentIsRunningRef ref) async {
  return await MTorrentServer().check();
}
