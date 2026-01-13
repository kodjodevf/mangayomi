import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/log/log.dart';

class _IsolateData {
  final SendPort sendPort;
  final RootIsolateToken rootIsolateToken;

  _IsolateData({required this.sendPort, required this.rootIsolateToken});
}

class GetIsolateService {
  bool _isRunning = false;
  Isolate? _getIsolateService;
  ReceivePort? _receivePort;
  StreamSubscription? _receiveSub;
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
    _receiveSub = _receivePort!.listen((message) {
      if (message is SendPort) {
        completer.complete(message);
      }
      if (message is String) {
        if (message.startsWith('LoggerLevel.warning:')) {
          Logger.add(
            LoggerLevel.warning,
            message.replaceFirst('LoggerLevel.warning:', ''),
          );
        } else {
          Logger.add(LoggerLevel.info, message);
        }
        if (kDebugMode) {
          print(message.replaceFirst('LoggerLevel.warning:', ''));
        }
      }
    });

    _sendPort = await completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () => throw StateError('Isolate handshake timed out'),
    );
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
    Zone.current
        .fork(
          specification: ZoneSpecification(
            print: (self, parent, zone, line) {
              isolateData.sendPort.send(line);
            },
          ),
        )
        .run(() async {
          isolateData.sendPort.send(receivePort.sendPort);
          receivePort.listen((message) async {
            if (message is Map<String, dynamic>) {
              final responsePort = message['responsePort'] as SendPort;
              try {
                final url = message['url'] as String?;
                final page = message['page'] as int?;
                final query = message['query'] as String?;
                final filterList = message['filterList'] as List?;
                final source = message['source'] as Source?;
                final proxyServer = message['proxyServer'] as String?;
                final serviceType = message['serviceType'] as String?;
                final useLoggerValue = message['useLogger'] as bool?;
                cfPort = message['cfPort'] as int;
                if (useLoggerValue != null) {
                  useLogger = useLoggerValue;
                }
                final result = await withExtensionService(
                  source!,
                  proxyServer ?? '',
                  (service) async {
                    switch (serviceType) {
                      case 'getDetail':
                        return await service.getDetail(url!);
                      case 'getPopular':
                        return await service.getPopular(page!);
                      case 'getLatestUpdates':
                        return await service.getLatestUpdates(page!);
                      case 'search':
                        return await service.search(query!, page!, filterList!);
                      case 'getVideoList':
                        return await service.getVideoList(url!);
                      case 'getPageList':
                        return await service.getPageList(url!);
                      default:
                        throw Exception('Unknown service type: $serviceType');
                    }
                  },
                );
                responsePort.send({'success': true, 'data': result});
              } catch (e) {
                responsePort.send({'success': false, 'error': e.toString()});
              } finally {
                useLogger = false;
              }
            } else if (message == 'dispose') {
              receivePort.close();
            }
          });
        });
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
    bool? useLogger,
  }) async {
    if (_sendPort == null) {
      throw Exception('Isolate not running');
    }

    final responsePort = ReceivePort();
    final completer = Completer<T>();
    late final StreamSubscription sub;

    // Timeout safeguard
    final timer = Timer(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        sub.cancel();
        responsePort.close();
        completer.completeError('Isolate response timeout');
      }
    });
    sub = responsePort.listen((response) {
      timer.cancel();
      sub.cancel();
      responsePort.close();
      if (response is Map<String, dynamic>) {
        if (response['success'] == true) {
          completer.complete(response['data'] as T);
        } else {
          completer.completeError(response['error']);
        }
      } else {
        completer.completeError('Invalid isolate response: $response');
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
      'useLogger': useLogger,
      'cfPort': cfPort,
    });

    return completer.future;
  }

  Future<void> stop() async {
    if (!_isRunning) {
      return;
    }

    _sendPort?.send('dispose');
    _getIsolateService?.kill(priority: Isolate.immediate);
    await _receiveSub?.cancel();
    _receivePort?.close();
    _receiveSub = null;
    _sendPort = null;
    _getIsolateService = null;
    _receivePort = null;
    _isRunning = false;
  }
}

final getIsolateService = GetIsolateService();
