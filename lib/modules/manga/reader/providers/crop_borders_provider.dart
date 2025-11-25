import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/src/rust/api/image.dart';
import 'package:mangayomi/src/rust/frb_generated.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'crop_borders_provider.g.dart';

@Riverpod(keepAlive: false)
Future<Uint8List?> cropBorders(
  Ref ref, {
  required UChapDataPreload data,
  required bool cropBorder,
}) async {
  Uint8List? imageBytes;

  if (cropBorder) {
    imageBytes = await data.getImageBytes;

    if (imageBytes == null) {
      return null;
    }

    return imgCropIsolate.process(imageBytes);
  }
  return null;
}

class ImageCropIsolate {
  bool _isRunning = false;
  Isolate? _rustIsolate;
  ReceivePort? _receivePort;
  SendPort? _sendPort;

  Future<void> start() async {
    if (!_isRunning) {
      try {
        await _initRustIsolate();
      } catch (_) {
        await stop();
      }
    }
  }

  Future<void> _initRustIsolate() async {
    _receivePort = ReceivePort();

    _rustIsolate = await Isolate.spawn(
      _rustIsolateEntryPoint,
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

  static Future<void> _rustIsolateEntryPoint(SendPort mainSendPort) async {
    await RustLib.init();

    final receivePort = ReceivePort();
    mainSendPort.send(receivePort.sendPort);
    receivePort.listen((message) async {
      if (message is Map<String, dynamic>) {
        try {
          final imageBytes = message['imageBytes'] as Uint8List;
          final responsePort = message['responsePort'] as SendPort;

          final croppedImage = processCropImage(image: imageBytes);

          responsePort.send({'success': true, 'data': croppedImage});
        } catch (e) {
          final responsePort = message['responsePort'] as SendPort;
          responsePort.send({'success': false, 'error': e.toString()});
        }
      } else if (message == 'dispose') {
        RustLib.dispose();
        receivePort.close();
      }
    });
  }

  Future<Uint8List?> process(Uint8List imageBytes) async {
    await start();
    if (_sendPort == null) {
      if (kDebugMode) {
        print('Image crop isolate is not running');
      }
      return null;
    }

    final responsePort = ReceivePort();
    final completer = Completer<Uint8List?>();

    responsePort.listen((response) {
      responsePort.close();
      if (response is Map<String, dynamic>) {
        if (response['success'] == true) {
          completer.complete(response['data'] as Uint8List);
        } else {
          if (kDebugMode) {
            print('Image cropping failed: ${response['error']}');
          }
          completer.complete(Future.value(null));
        }
      }
    });

    _sendPort!.send({
      'imageBytes': imageBytes,
      'responsePort': responsePort.sendPort,
    });

    return completer.future;
  }

  Future<void> stop() async {
    if (!_isRunning) {
      return;
    }

    _sendPort?.send('dispose');
    _rustIsolate?.kill(priority: Isolate.immediate);
    _receivePort?.close();
    _sendPort = null;
    _rustIsolate = null;
    _receivePort = null;
    _isRunning = false;
  }
}

final imgCropIsolate = ImageCropIsolate();
