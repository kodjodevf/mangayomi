import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
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

String _normalizeInfoHash(String hash) =>
    MTorrentServer.normalizeInfoHash(hash);

class MTorrentServer {
  static String normalizeInfoHash(String hash) {
    final clean = hash.trim();
    if (clean.length == 40) return clean.toLowerCase();
    if (clean.length == 32) {
      const base32Chars = 'abcdefghijklmnopqrstuvwxyz234567';
      final lower = clean.toLowerCase();
      int buffer = 0;
      int bitsLeft = 0;
      final bytes = <int>[];
      for (int i = 0; i < lower.length; i++) {
        final val = base32Chars.indexOf(lower[i]);
        if (val < 0) return clean;
        buffer = (buffer << 5) | val;
        bitsLeft += 5;
        if (bitsLeft >= 8) {
          bitsLeft -= 8;
          bytes.add((buffer >> bitsLeft) & 0xFF);
        }
      }
      if (bytes.length == 20) {
        return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
      }
    }
    return clean;
  }

  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  Future<bool> removeTorrent(String? inforHash) async {
    if (inforHash == null || inforHash.isEmpty) return false;
    final cleanHash = normalizeInfoHash(inforHash);
    try {
      final res = await http.delete(
        Uri.parse("$_baseUrl/torrent/remove?infohash=$cleanHash"),
      );
      if (res.statusCode == 200 || res.statusCode == 202) {
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<List<String>> getActiveTorrents() async {
    try {
      final res = await http.get(Uri.parse("$_baseUrl/torrent/torrents"));
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        if (decoded is List) {
          return decoded
              .map((e) => e['infoHash']?.toString())
              .whereType<String>()
              .map(_normalizeInfoHash)
              .toList();
        }
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<void> removeAllTorrents() async {
    try {
      final torrents = await getActiveTorrents();
      for (final hash in torrents) {
        await removeTorrent(hash);
      }
    } catch (_) {}
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
          if (infohash == null || infohash.isEmpty) {
            final h = Uri.tryParse(videoUrl)?.queryParameters['infohash'];
            if (h != null && h.isNotEmpty) {
              infohash = _normalizeInfoHash(h);
            }
          }
        }
      }

      if (infohash == null || infohash.isEmpty) {
        final match = RegExp(
          r'urn:btih:([a-zA-Z0-9]+)',
          caseSensitive: false,
        ).firstMatch(url);
        if (match != null) {
          infohash = _normalizeInfoHash(match.group(1)!);
        }
      }

      return (videoList, infohash);
    } catch (e) {
      rethrow;
    }
  }
}

String get _baseUrl {
  final settings = settingsRepository.current;
  final port = settings.btServerPort ?? 0;
  final address = settings.btServerAddress ?? "127.0.0.1";
  return "http://$address:$port";
}

void _setBtServerPort(int newPort) {
  settingsRepository.update((s) => s.btServerPort = newPort);
}
