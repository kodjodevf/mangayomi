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
import 'package:mangayomi/utils/platform_utils.dart';

String _buildQueryString(Map<String, List<String>> parameters) {
  final segments = <String>[];
  parameters.forEach((key, values) {
    for (final value in values) {
      segments.add(
        '${Uri.encodeQueryComponent(key)}=${Uri.encodeQueryComponent(value)}',
      );
    }
  });
  return segments.join('&');
}

List<String> _normalizeHttpUrls(Iterable<String> values) {
  final normalized = <String>[];
  final seen = <String>{};
  for (final value in values) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) continue;
    final uri = Uri.tryParse(trimmed);
    if (uri == null) continue;
    if (uri.scheme != 'http' && uri.scheme != 'https') continue;
    final normalizedValue = uri.toString();
    if (seen.add(normalizedValue)) {
      normalized.add(normalizedValue);
    }
  }
  return normalized;
}

(List<String>, List<String>) _extractMagnetFallbacks(String magnetUrl) {
  final uri = Uri.tryParse(magnetUrl);
  if (uri == null || uri.scheme != 'magnet') {
    return (const [], const []);
  }

  final sources = _normalizeHttpUrls([
    ...uri.queryParametersAll['xs'] ?? const [],
    ...uri.queryParametersAll['as'] ?? const [],
  ]);
  final webseeds = _normalizeHttpUrls(uri.queryParametersAll['ws'] ?? const []);
  return (sources, webseeds);
}

List<String> _mergeTorrentFallbacks(
  Iterable<String> base,
  Iterable<String> discovered,
) {
  return _normalizeHttpUrls([...base, ...discovered]);
}

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

  Future<String> getInfohash(
    String url,
    bool isFilePath, {
    List<String> sources = const [],
    List<String> webseeds = const [],
  }) async {
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
      request.fields.addAll({
        for (final source in sources) 'source': source,
        for (final webseed in webseeds) 'webseed': webseed,
      });
      final response = await http.send(request);
      return await response.stream.bytesToString();
    } catch (e) {
      rethrow;
    }
  }

  Future<(List<Video>, String?)> getTorrentPlaylist(
    String? url,
    String? archivePath, {
    List<String> sources = const [],
    List<String> webseeds = const [],
  }) async {
    try {
      final isFilePath = archivePath?.isNotEmpty ?? false;
      final isRunning = await check();
      if (!isRunning) {
        final path = (await StorageProvider().getBtDirectory())!.path;
        final config = jsonEncode({"path": path, "address": "127.0.0.1:0"});
        int port = 0;
        if (isMobile) {
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
      final magnetFallbacks = _extractMagnetFallbacks(url);
      final mergedSources = _mergeTorrentFallbacks(sources, magnetFallbacks.$1);
      final mergedWebseeds = _mergeTorrentFallbacks(
        webseeds,
        magnetFallbacks.$2,
      );
      final remoteTorrentSources = !isMagnet && !isFilePath
          ? _normalizeHttpUrls([url])
          : const <String>[];
      final effectiveSources = _mergeTorrentFallbacks(
        mergedSources,
        remoteTorrentSources,
      );
      String finalUrl = "";
      String? infohash;
      if (!isMagnet) {
        infohash = await getInfohash(
          url,
          isFilePath,
          sources: effectiveSources,
          webseeds: mergedWebseeds,
        );
        finalUrl =
            '$_baseUrl/torrent/play?${_buildQueryString({
              'infohash': [infohash],
              if (effectiveSources.isNotEmpty) 'source': effectiveSources,
              if (mergedWebseeds.isNotEmpty) 'webseed': mergedWebseeds,
            })}';
      } else {
        finalUrl =
            '$_baseUrl/torrent/play?${_buildQueryString({
              'magnet': [url],
              if (effectiveSources.isNotEmpty) 'source': effectiveSources,
              if (mergedWebseeds.isNotEmpty) 'webseed': mergedWebseeds,
            })}';
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
