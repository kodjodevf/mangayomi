import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/providers/storage_provider.dart';

class _IsolateData {
  final SendPort sendPort;
  final RootIsolateToken rootIsolateToken;

  _IsolateData({required this.sendPort, required this.rootIsolateToken});
}

class GetIsolateService {
  bool _isRunning = false;
  Isolate? _getIsolateService;
  ReceivePort? _receivePort;
  SendPort? _sendPort;

  Future<void> start() async {
    if (!_isRunning) {
      try {
        await _initGetIsolateService();
      } catch (_) {
        await stop();
      }
    }
  }

  Future<void> _initGetIsolateService() async {
    _receivePort = ReceivePort();

    final rootToken = RootIsolateToken.instance!;

    _getIsolateService = await Isolate.spawn(
      _getIsolateServiceEntryPoint,
      _IsolateData(
        sendPort: _receivePort!.sendPort,
        rootIsolateToken: rootToken,
      ),
    );

    final completer = Completer<SendPort>();
    _receivePort!.listen((message) {
      if (message is SendPort) {
        completer.complete(message);
      }
    });

    _sendPort = await completer.future;
    _isRunning = true;
  }

  static Future<void> _getIsolateServiceEntryPoint(
    _IsolateData isolateData,
  ) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(
      isolateData.rootIsolateToken,
    );

    await initializeDateFormatting();

    isar = await StorageProvider().initDB(null, inspector: kDebugMode);

    final receivePort = ReceivePort();
    isolateData.sendPort.send(receivePort.sendPort);

    await for (var message in receivePort) {
      if (message is Map<String, dynamic>) {
        try {
          final url = message['url'] as String?;
          final page = message['page'] as int?;
          final query = message['query'] as String?;
          final filterList = message['filterList'] as List?;
          final source = message['source'] as Source?;
          final proxyServer = message['proxyServer'] as String?;
          final serviceType = message['serviceType'] as String?;
          final responsePort = message['responsePort'] as SendPort;

          if (serviceType == 'getDetail') {
            final result = await getExtensionService(
              source!,
              proxyServer ?? '',
            ).getDetail(url!);
            responsePort.send({'success': true, 'data': result});
          } else if (serviceType == 'getPopular') {
            final result = await getExtensionService(
              source!,
              proxyServer ?? '',
            ).getPopular(page!);
            responsePort.send({'success': true, 'data': result});
          } else if (serviceType == 'getLatestUpdates') {
            final result = await getExtensionService(
              source!,
              proxyServer ?? '',
            ).getLatestUpdates(page!);
            responsePort.send({'success': true, 'data': result});
          } else if (serviceType == 'search') {
            final result = await getExtensionService(
              source!,
              proxyServer ?? '',
            ).search(query!, page!, filterList!);
            responsePort.send({'success': true, 'data': result});
          } else if (serviceType == 'getVideoList') {
            final result = await getExtensionService(
              source!,
              proxyServer ?? '',
            ).getVideoList(url!);
            responsePort.send({'success': true, 'data': result});
          } else if (serviceType == 'getPageList') {
            final result = await getExtensionService(
              source!,
              proxyServer ?? '',
            ).getPageList(url!);
            responsePort.send({'success': true, 'data': result});
          }
        } catch (e) {
          final responsePort = message['responsePort'] as SendPort;
          responsePort.send({'success': false, 'error': e.toString()});
        }
      } else if (message == 'dispose') {
        break;
      }
    }
  }

  Future<T> get<T>({
    String? url,
    int? page,
    String? query,
    List<dynamic>? filterList,
    Source? source,
    String? serviceType,
    String? proxyServer,
    bool? autoUpdateExtensions,
    String? androidProxyServer,
  }) async {
    if (_sendPort == null) {
      throw Exception('Isolate not running');
    }

    final responsePort = ReceivePort();
    final completer = Completer<T>();

    responsePort.listen((response) {
      responsePort.close();
      if (response is Map<String, dynamic>) {
        if (response['success'] == true) {
          completer.complete(response['data'] as T);
        } else {
          completer.completeError(response['error']);
        }
      }
    });

    _sendPort!.send({
      'url': url,
      'page': page,
      'query': query,
      'filterList': filterList,
      'serviceType': serviceType,
      'source': source,
      'proxyServer': proxyServer,
      'responsePort': responsePort.sendPort,
    });

    return completer.future;
  }

  Future<void> stop() async {
    if (!_isRunning) {
      return;
    }

    _sendPort?.send('dispose');
    _getIsolateService?.kill(priority: Isolate.immediate);
    _receivePort?.close();
    _sendPort = null;
    _getIsolateService = null;
    _receivePort = null;
    _isRunning = false;
  }
}

final getIsolateService = GetIsolateService();
