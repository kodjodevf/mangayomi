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

class _IsolateWorker {
  Isolate? isolate;
  ReceivePort? receivePort;
  StreamSubscription? receiveSub;
  SendPort? sendPort;
  bool isBusy = false;

  Future<void> start(RootIsolateToken rootToken) async {
    receivePort = ReceivePort();
    isolate = await Isolate.spawn(
      GetIsolateService._getIsolateServiceEntryPoint,
      _IsolateData(
        sendPort: receivePort!.sendPort,
        rootIsolateToken: rootToken,
      ),
    );

    final completer = Completer<SendPort>();
    receiveSub = receivePort!.listen((message) {
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

    sendPort = await completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () => throw StateError('Isolate handshake timed out'),
    );
  }

  Future<void> stop() async {
    sendPort?.send('dispose');
    isolate?.kill(priority: Isolate.immediate);
    await receiveSub?.cancel();
    receivePort?.close();
  }
}

class GetIsolateService {
  bool _isRunning = false;
  final List<_IsolateWorker> _workers = [];
  final List<Completer<_IsolateWorker>> _pendingWorkers = [];
  static const int _poolSize = 4;

  Future<void> start() async {
    if (!_isRunning) {
      try {
        final rootToken = RootIsolateToken.instance!;
        for (int i = 0; i < _poolSize; i++) {
          final worker = _IsolateWorker();
          await worker.start(rootToken);
          _workers.add(worker);
        }
        _isRunning = true;
      } catch (_) {
        await stop();
      }
    }
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
                      case 'getHeaders':
                        return Future.value(service.getHeaders());
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

  Future<_IsolateWorker> _getAvailableWorker() async {
    if (!_isRunning) {
      throw Exception('Isolate service not running');
    }
    for (final worker in _workers) {
      if (!worker.isBusy) {
        worker.isBusy = true;
        return worker;
      }
    }
    final completer = Completer<_IsolateWorker>();
    _pendingWorkers.add(completer);
    return completer.future;
  }

  void _releaseWorker(_IsolateWorker worker) {
    worker.isBusy = false;
    if (_pendingWorkers.isNotEmpty) {
      final next = _pendingWorkers.removeAt(0);
      worker.isBusy = true;
      next.complete(worker);
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
    bool? useLogger,
  }) async {
    if (!_isRunning) {
      await start();
    }

    final worker = await _getAvailableWorker();
    final responsePort = ReceivePort();
    final completer = Completer<T>();
    late final StreamSubscription sub;

    final timer = Timer(const Duration(seconds: 40), () {
      if (!completer.isCompleted) {
        sub.cancel();
        responsePort.close();
        _releaseWorker(worker);
        completer.completeError('Isolate response timeout');
      }
    });

    sub = responsePort.listen((response) {
      timer.cancel();
      sub.cancel();
      responsePort.close();
      _releaseWorker(worker);
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

    try {
      worker.sendPort!.send({
        'url': ?url,
        'page': ?page,
        'query': ?query,
        'filterList': ?filterList,
        'serviceType': ?serviceType,
        'source': ?source,
        'proxyServer': ?proxyServer,
        'responsePort': responsePort.sendPort,
        'useLogger': ?useLogger,
        'cfPort': cfPort,
      });
    } catch (e) {
      timer.cancel();
      sub.cancel();
      responsePort.close();
      _releaseWorker(worker);
      completer.completeError(e);
    }

    return completer.future;
  }

  Future<void> stop() async {
    if (!_isRunning) {
      return;
    }

    for (final worker in _workers) {
      await worker.stop();
    }
    _workers.clear();
    for (final pending in _pendingWorkers) {
      if (!pending.isCompleted) {
        pending.completeError(StateError('Isolate service stopped'));
      }
    }
    _pendingWorkers.clear();
    _isRunning = false;
  }
}

final getIsolateService = GetIsolateService();
