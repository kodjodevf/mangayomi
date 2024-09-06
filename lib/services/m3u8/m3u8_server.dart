import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

Future<HttpServer> m3u8Server(
    {required String m3u8Content, required String episodeFolderPath}) async {
  final handler =
      const Pipeline().addMiddleware(logRequests()).addHandler((request) {
    return _handleRequest(request, m3u8Content, episodeFolderPath);
  });
  final server = await io.serve(handler, 'localhost', 3000);
  if (kDebugMode) {
    print(
        '[INFO-M3U8_SERVER] Listening on running on http://${server.address.host}:${server.port}');
  }

  return server;
}

Response _handleRequest(
    Request request, String m3u8Content, String episodeFolderPath) {
  if (request.url.path == 'index.m3u8') {
    return Response.ok(m3u8Content,
        headers: {'Content-Type': 'application/vnd.apple.mpegurl'});
  }
  if (request.url.path.endsWith('.ts')) {
    final tsFilePath = '$episodeFolderPath/${request.url.pathSegments.last}';
    final file = File(tsFilePath);

    if (file.existsSync()) {
      return Response.ok(file.openRead(), headers: {
        'Content-Type': 'video/MP2T',
      });
    } else {
      return Response.notFound('File not found');
    }
  }

  return Response.notFound('Not exist');
}
