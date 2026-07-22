import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';

/// Required parameters to decode an image region
class DecodeParams {
  final String filePath;
  final int left;
  final int top;
  final int right;
  final int bottom;
  final int sampleSize;
  final bool cropBorders;

  DecodeParams({
    required this.filePath,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
    required this.sampleSize,
    this.cropBorders = false,
  });

  Map<String, dynamic> toJson() => {
    "filePath": filePath,
    "left": left,
    "top": top,
    "right": right,
    "bottom": bottom,
    "sampleSize": sampleSize,
    "cropBorders": cropBorders,
  };
  factory DecodeParams.fromJson(Map<String, dynamic> json) {
    return DecodeParams(
      bottom: json['bottom'],
      filePath: json['filePath'],
      left: json['left'],
      top: json['top'],
      right: json['right'],
      sampleSize: json['sampleSize'],
      cropBorders: json['cropBorders'] ?? false,
    );
  }
}

/// Result returned after decoding a region
class DecodeResult {
  final int? pointerAddress;
  final int width;
  final int height;
  final String? error;

  DecodeResult({
    this.pointerAddress,
    this.width = 0,
    this.height = 0,
    this.error,
  });
}

/// FFI interop interface with the native C++ library.
/// Manages loading the dynamic library and asynchronous execution
/// of decoding tasks in background Isolates.
class FfiImageDecoder {
  static DynamicLibrary? _dylib;

  bool _isRunning = false;
  Isolate? _cIsolate;
  ReceivePort? _receivePort;
  SendPort? _sendPort;

  final List<_DecodeJob> _queue = [];
  // Max concurrent decode jobs sent to the isolate.
  // 3 parallel jobs keeps tile throughput high without overloading memory.
  static const int _maxConcurrent = 3;
  int _activeJobs = 0;

  void cancel(Object token) {
    _queue.removeWhere((job) {
      if (job.cancelToken == token) {
        if (!job.completer.isCompleted) {
          if (job.action == 'getDimensions') {
            job.completer.complete(null);
          } else {
            job.completer.complete(DecodeResult(error: 'Cancelled'));
          }
        }
        return true;
      }
      return false;
    });
  }

  Future<void> start() async {
    if (!_isRunning) {
      try {
        await _initCIsolate();
      } catch (e, stackTrace) {
        if (kDebugMode) {
          print('Error starting FFI isolate: $e');
          print(stackTrace);
        }
        await stop();
      }
    }
  }

  Future<void> _initCIsolate() async {
    _receivePort = ReceivePort();

    _cIsolate = await Isolate.spawn(
      _cIsolateEntryPoint,
      _receivePort!.sendPort,
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

  static DynamicLibrary get dylib {
    if (_dylib == null) {
      if (Platform.isAndroid) {
        _dylib = DynamicLibrary.open("libsubsampling_scale_image_view.so");
      } else if (Platform.isIOS || Platform.isMacOS) {
        try {
          _dylib = DynamicLibrary.open(
            "subsampling_scale_image_view.framework/subsampling_scale_image_view",
          );
        } catch (_) {
          _dylib = DynamicLibrary.process();
        }
      } else {
        _dylib = DynamicLibrary.process();
      }
    }
    return _dylib!;
  }

  static final Pointer<Opaque> Function(
    Pointer<Utf8>,
    bool,
    Pointer<Int32>,
    Pointer<Int32>,
  )
  _initDecoder = dylib
      .lookupFunction<
        Pointer<Opaque> Function(
          Pointer<Utf8>,
          Bool,
          Pointer<Int32>,
          Pointer<Int32>,
        ),
        Pointer<Opaque> Function(
          Pointer<Utf8>,
          bool,
          Pointer<Int32>,
          Pointer<Int32>,
        )
      >('init_decoder');

  static final bool Function(
    Pointer<Opaque>,
    int,
    int,
    int,
    int,
    int,
    Pointer<Uint8>,
  )
  _decodeRegion = dylib
      .lookupFunction<
        Bool Function(
          Pointer<Opaque>,
          Int32,
          Int32,
          Int32,
          Int32,
          Int32,
          Pointer<Uint8>,
        ),
        bool Function(Pointer<Opaque>, int, int, int, int, int, Pointer<Uint8>)
      >('decode_region');

  static final void Function(Pointer<Opaque>) _freeDecoder = dylib
      .lookupFunction<
        Void Function(Pointer<Opaque>),
        void Function(Pointer<Opaque>)
      >('free_decoder');

  /// Decodes a specific region of the image asynchronously in a background Isolate.
  /// This prevents blocking the main UI thread during disk reads and decoding.
  static Future<void> _cIsolateEntryPoint(SendPort mainSendPort) async {
    final receivePort = ReceivePort();
    mainSendPort.send(receivePort.sendPort);

    // LRU Cache using LinkedHashMap for O(1) access, insertion, and ordering.
    // Keys are inserted in access order; to evict, remove first entry.
    final Map<String, Pointer<Opaque>> cachedContexts = {};
    final Map<String, List<int>> cachedDimensions = {};
    // lruOrder tracks insertion order; LinkedHashMap isn't directly available in isolate
    // so we use a plain Map (Dart Maps maintain insertion order since Dart 2) as O(1) ordered set.
    final Map<String, bool> lruOrder = {};
    const int maxCacheSize = 10;

    receivePort.listen((message) async {
      if (message is Map<String, dynamic>) {
        final responsePort = message['responsePort'] as SendPort;
        final action = message['action'] as String?;
        final params = DecodeParams.fromJson(message['params']);

        final key = "${params.filePath}_${params.cropBorders}";
        Pointer<Opaque> ctx = cachedContexts[key] ?? Pointer.fromAddress(0);
        int imgWidth = 0;
        int imgHeight = 0;

        if (ctx.address == 0) {
          // LRU Eviction: O(1) — remove first (oldest) entry from ordered map
          if (cachedContexts.length >= maxCacheSize) {
            final oldestKey = lruOrder.keys.first;
            lruOrder.remove(oldestKey);
            final oldestCtx = cachedContexts.remove(oldestKey);
            cachedDimensions.remove(oldestKey);
            if (oldestCtx != null && oldestCtx.address != 0) {
              _freeDecoder(oldestCtx);
            }
          }

          final Pointer<Utf8> pathPtr = params.filePath.toNativeUtf8();
          final Pointer<Int32> wPtr = calloc<Int32>();
          final Pointer<Int32> hPtr = calloc<Int32>();
          try {
            final Pointer<Opaque> newCtx = _initDecoder(
              pathPtr,
              params.cropBorders,
              wPtr,
              hPtr,
            );
            if (newCtx.address == 0) {
              responsePort.send({
                'success': false,
                'error':
                    "Failed to initialize decoder for file: ${params.filePath}",
              });
              return;
            }
            ctx = newCtx;
            cachedContexts[key] = ctx;
            lruOrder[key] = true; // O(1) insertion at end
            imgWidth = wPtr.value;
            imgHeight = hPtr.value;
            cachedDimensions[key] = [imgWidth, imgHeight];
          } catch (e) {
            responsePort.send({
              'success': false,
              'error': "Error initializing FFI decoder: $e",
            });
            return;
          } finally {
            calloc.free(pathPtr);
            calloc.free(wPtr);
            calloc.free(hPtr);
          }
        } else {
          // Update LRU order: O(1) — remove and re-insert at end
          lruOrder.remove(key);
          lruOrder[key] = true;
          final dims = cachedDimensions[key]!;
          imgWidth = dims[0];
          imgHeight = dims[1];
        }

        if (action == 'getDimensions') {
          responsePort.send({
            'success': true,
            'width': imgWidth,
            'height': imgHeight,
          });
          return;
        }

        // Calculates required size for destination pixel buffer (RGBA)
        final int rectWidth = params.right - params.left;
        final int rectHeight = params.bottom - params.top;
        final int destWidth = rectWidth ~/ params.sampleSize;
        final int destHeight = rectHeight ~/ params.sampleSize;
        final int bufferSize = destWidth * destHeight * 4;

        final Pointer<Uint8> rgbaBuffer = calloc<Uint8>(bufferSize);

        try {
          final bool success = _decodeRegion(
            ctx,
            params.left,
            params.top,
            params.right,
            params.bottom,
            params.sampleSize,
            rgbaBuffer,
          );

          if (!success) {
            calloc.free(rgbaBuffer);
            responsePort.send({'error': "Region decoding failed."});
            return;
          }

          responsePort.send({
            'success': true,
            'pointerAddress': rgbaBuffer.address,
            'width': imgWidth,
            'height': imgHeight,
          });
        } catch (e) {
          calloc.free(rgbaBuffer);
          responsePort.send({'success': false, 'error': "FFI error: $e"});
        }
      } else if (message == 'dispose') {
        for (final ctx in cachedContexts.values) {
          if (ctx.address != 0) {
            _freeDecoder(ctx);
          }
        }
        cachedContexts.clear();
        lruOrder.clear();
        cachedDimensions.clear();
        receivePort.close();
      }
    });
  }

  Future<DecodeResult?> decodeRegionAsync(
    DecodeParams params, {
    Object? cancelToken,
  }) async {
    await start();
    if (_sendPort == null) {
      if (kDebugMode) {
        print('FfiImageDecoder isolate is not running');
      }
      return null;
    }

    final completer = Completer<DecodeResult?>();
    final job = _DecodeJob(
      params: params,
      completer: completer,
      cancelToken: cancelToken,
    );

    _queue.add(job);
    _processNext();

    return completer.future;
  }

  Future<List<int>?> getImageDimensionsAsync(
    String filePath, {
    bool cropBorders = false,
    Object? cancelToken,
  }) async {
    await start();
    if (_sendPort == null) {
      if (kDebugMode) {
        print('FfiImageDecoder isolate is not running');
      }
      return null;
    }

    final completer = Completer<List<int>?>();
    final job = _DecodeJob(
      params: DecodeParams(
        filePath: filePath,
        left: 0,
        top: 0,
        right: 0,
        bottom: 0,
        sampleSize: 1,
        cropBorders: cropBorders,
      ),
      completer: completer,
      cancelToken: cancelToken,
      action: 'getDimensions',
    );

    _queue.add(job);
    _processNext();

    return completer.future;
  }

  void _processNext() {
    // Dispatch up to _maxConcurrent jobs simultaneously.
    while (_activeJobs < _maxConcurrent && _queue.isNotEmpty) {
      // Priority ordering:
      //  1. getDimensions jobs first (they block image init)
      //  2. High sampleSize (base/overview layer) before fine detail tiles
      //  3. LIFO within same priority (last-added tile = most recently needed)
      _queue.sort((a, b) {
        final aPriority = a.action == 'getDimensions'
            ? 1000
            : a.params.sampleSize;
        final bPriority = b.action == 'getDimensions'
            ? 1000
            : b.params.sampleSize;
        return bPriority.compareTo(
          aPriority,
        ); // descending: highest priority last for removeLast
      });

      final job = _queue.removeLast();
      _activeJobs++;

      final responsePort = ReceivePort();
      responsePort.listen((response) {
        responsePort.close();
        _activeJobs--;

        if (!job.completer.isCompleted) {
          if (response is Map<String, dynamic>) {
            if (response['success'] == true) {
              if (job.action == 'getDimensions') {
                job.completer.complete([
                  response['width'] as int,
                  response['height'] as int,
                ]);
              } else {
                final pointerAddress = response['pointerAddress'] as int?;
                job.completer.complete(
                  DecodeResult(
                    pointerAddress: pointerAddress,
                    width: response['width'] as int,
                    height: response['height'] as int,
                  ),
                );
              }
            } else {
              if (kDebugMode) {
                print('Image job failed: ${response['error']}');
              }
              if (job.action == 'getDimensions') {
                job.completer.complete(null);
              } else {
                job.completer.complete(DecodeResult(error: response['error']));
              }
            }
          } else {
            job.completer.complete(null);
          }
        }

        _processNext();
      });

      _sendPort!.send({
        'action': job.action,
        'params': job.params.toJson(),
        'responsePort': responsePort.sendPort,
      });
    }
  }

  bool getImageDimensions(
    String filePath,
    List<int> outSize, {
    bool cropBorders = false,
  }) {
    final Pointer<Utf8> pathPtr = filePath.toNativeUtf8();
    final Pointer<Int32> wPtr = calloc<Int32>();
    final Pointer<Int32> hPtr = calloc<Int32>();

    try {
      final Pointer<Opaque> ctx = _initDecoder(
        pathPtr,
        cropBorders,
        wPtr,
        hPtr,
      );
      if (ctx.address == 0) return false;

      outSize[0] = wPtr.value;
      outSize[1] = hPtr.value;
      _freeDecoder(ctx);
      return true;
    } catch (_) {
      return false;
    } finally {
      calloc.free(pathPtr);
      calloc.free(wPtr);
      calloc.free(hPtr);
    }
  }

  Future<void> stop() async {
    if (!_isRunning) {
      return;
    }

    _sendPort?.send('dispose');
    _cIsolate?.kill(priority: Isolate.immediate);
    _receivePort?.close();
    _sendPort = null;
    _cIsolate = null;
    _receivePort = null;
    _isRunning = false;

    for (final job in _queue) {
      if (!job.completer.isCompleted) {
        if (job.action == 'getDimensions') {
          job.completer.complete(null);
        } else {
          job.completer.complete(DecodeResult(error: 'Cancelled'));
        }
      }
    }
    _queue.clear();
  }
}

class _DecodeJob {
  final DecodeParams params;
  final Completer<dynamic> completer;
  final Object? cancelToken;
  final String? action;

  _DecodeJob({
    required this.params,
    required this.completer,
    this.cancelToken,
    this.action,
  });
}

final ffiImageDecoder = FfiImageDecoder();
