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
import 'dart:async';
import 'package:synchronized/synchronized.dart';

class MTorrentServer {
  static final MTorrentServer _instance = MTorrentServer._internal();
  factory MTorrentServer() => _instance;
  MTorrentServer._internal();
  final _lock = Lock();

  bool _isRunning = false;
  int? _serverPort;

  final http = MClient.init();
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
    if (!_isRunning || _serverPort == null) return false;
    try {
      final res = await http
          .get(Uri.parse("http://127.0.0.1:$_serverPort"))
          .timeout(const Duration(seconds: 5));
      return res.statusCode < 500;
    } catch (_) {
      return false;
    }
  }

  Future<String> getInfohash(String url, bool isFilePath) async {
    try {
      final torrentByte = isFilePath
          ? File(url).readAsBytesSync()
          : (await http.get(Uri.parse(url))).bodyBytes;
      var request =
          MultipartRequest('POST', Uri.parse('$_baseUrl/torrent/add'));

      request.files.add(MultipartFile.fromBytes('file', torrentByte,
          filename: 'file.torrent'));
      final response = await http.send(request);
      return await response.stream.bytesToString();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> startMServer() async {
    if (_isRunning) return;
    if (!_isRunning) {
      final path = (await StorageProvider().getBtDirectory())!.path;
      final config = jsonEncode({"path": path, "address": "127.0.0.1:0"});
      try {
        if (Platform.isAndroid || Platform.isIOS) {
          const channel =
              MethodChannel('com.kodjodevf.mangayomi.libmtorrentserver');
          _serverPort = await channel.invokeMethod('start', {"config": config});
        } else {
          _serverPort = await Isolate.run(() async {
            return libmtorrentserver_ffi.start(config);
          });
        }
        _setBtServerPort(_serverPort!);
        _isRunning = true;
      } catch (e) {
        _isRunning = false;
        _serverPort = null;
      }
    }
  }

  Future<void> stopMServer() async {
    if (!_isRunning) return;

    try {
      if (Platform.isAndroid || Platform.isIOS) {
        const channel =
            MethodChannel('com.kodjodevf.mangayomi.libmtorrentserver');
        await channel.invokeMethod('stop');
      } else {
        await Isolate.run(() async {
          await libmtorrentserver_ffi.stop();
        });
      }
      _isRunning = false;
      _serverPort = null;
      _setBtServerPort(0);
    } catch (e) {
      _isRunning = false;
      _serverPort = null;
      _setBtServerPort(0);
    }
  }

  Future<void> ensureRunning() async {
    await _lock.synchronized(() async {
      int retries = 3;
      while (retries > 0) {
        if (await check()) {
          return;
        }
        await startMServer();
        await Future.delayed(const Duration(seconds: 2));
        retries--;
      }
      throw Exception("Failed to start torrent server after multiple attempts");
    });
  }

  Future<(List<Video>, String?)> getTorrentPlaylist(
      String? url, String? archivePath) async {
    try {
      final isFilePath = archivePath?.isNotEmpty ?? false;
      await ensureRunning();
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

  String getBaseUrl() {
    final settings = isar.settings.getSync(227);
    final port = settings!.btServerPort ?? 0;
    final address = settings.btServerAddress ?? "127.0.0.1";
    return "http://$address:$port";
  }
}

String get _baseUrl {
  final settings = isar.settings.getSync(227);
  final port = settings!.btServerPort ?? 0;
  final address = settings.btServerAddress ?? "127.0.0.1";
  return "http://$address:$port";
}

void _setBtServerPort(int newPort) {
  isar.writeTxnSync(() => isar.settings
      .putSync(isar.settings.getSync(227)!..btServerPort = newPort));
}
