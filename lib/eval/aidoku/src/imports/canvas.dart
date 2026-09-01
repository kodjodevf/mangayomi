import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:wasd/wasd.dart';

import '../interpreter/memory_helper.dart';
import '../store/global_store.dart';

class CanvasContext {
  CanvasContext(int width, int height) : image = img.Image(width: width, height: height);

  img.Image image;
}

class CanvasImports {
  CanvasImports({required this.store, required this.memoryHelper});

  final GlobalStore store;
  final MemoryHelper memoryHelper;

  static const namespace = 'canvas';

  ModuleImports build() {
    return {
      'new_context': ImportExportKind.function((args) {
        final width = (args[0] as num).toDouble();
        final height = (args[1] as num).toDouble();
        return newContext(width, height);
      }),
      'set_transform': ImportExportKind.function((args) {
        return 0;
      }),
      'draw_image': ImportExportKind.function((args) {
        final contextPtr = (args[0] as num).toInt();
        final imagePtr = (args[1] as num).toInt();
        final dstX = (args[2] as num).toDouble();
        final dstY = (args[3] as num).toDouble();
        final dstWidth = (args[4] as num).toDouble();
        final dstHeight = (args[5] as num).toDouble();
        return drawImage(contextPtr, imagePtr, dstX, dstY, dstWidth, dstHeight);
      }),
      'copy_image': ImportExportKind.function((args) {
        final contextPtr = (args[0] as num).toInt();
        final imagePtr = (args[1] as num).toInt();
        final srcX = (args[2] as num).toDouble();
        final srcY = (args[3] as num).toDouble();
        final srcWidth = (args[4] as num).toDouble();
        final srcHeight = (args[5] as num).toDouble();
        final dstX = (args[6] as num).toDouble();
        final dstY = (args[7] as num).toDouble();
        final dstWidth = (args[8] as num).toDouble();
        final dstHeight = (args[9] as num).toDouble();
        return copyImage(
          contextPtr,
          imagePtr,
          srcX,
          srcY,
          srcWidth,
          srcHeight,
          dstX,
          dstY,
          dstWidth,
          dstHeight,
        );
      }),
      'fill': ImportExportKind.function((args) => 0),
      'stroke': ImportExportKind.function((args) => 0),
      'draw_text': ImportExportKind.function((args) => 0),
      'get_image': ImportExportKind.function((args) {
        final contextPtr = (args[0] as num).toInt();
        return getImage(contextPtr);
      }),
      'new_font': ImportExportKind.function((args) => 1),
      'system_font': ImportExportKind.function((args) => 1),
      'load_font': ImportExportKind.function((args) => 1),
      'new_image': ImportExportKind.function((args) {
        final dataPtr = (args[0] as num).toInt();
        final dataLen = (args[1] as num).toInt();
        return newImage(dataPtr, dataLen);
      }),
      'get_image_data': ImportExportKind.function((args) {
        final imagePtr = (args[0] as num).toInt();
        return getImageData(imagePtr);
      }),
      'get_image_width': ImportExportKind.function((args) {
        final imagePtr = (args[0] as num).toInt();
        return getImageWidth(imagePtr);
      }),
      'get_image_height': ImportExportKind.function((args) {
        final imagePtr = (args[0] as num).toInt();
        return getImageHeight(imagePtr);
      }),
    };
  }

  int newContext(double width, double height) {
    if (width <= 0 || height <= 0) return -6; // invalidBounds
    final ctx = CanvasContext(width.toInt(), height.toInt());
    return store.store(ctx);
  }

  img.Image? _resolveImage(int imagePtr) {
    final item = store.fetch(imagePtr);
    if (item is img.Image) return item;
    if (item is Uint8List) {
      final decoded = img.decodeImage(item);
      if (decoded != null) {
        store.set(imagePtr, decoded);
        return decoded;
      }
    }
    return null;
  }

  int drawImage(
    int contextPtr,
    int imagePtr,
    double dstX,
    double dstY,
    double dstWidth,
    double dstHeight,
  ) {
    final ctx = store.fetch(contextPtr);
    if (ctx is! CanvasContext) return -1; // invalidContext
    final src = _resolveImage(imagePtr);
    if (src == null) return -3; // invalidImage

    img.Image toDraw = src;
    if (dstWidth.toInt() != src.width || dstHeight.toInt() != src.height) {
      toDraw = img.copyResize(src, width: dstWidth.toInt(), height: dstHeight.toInt());
    }

    img.compositeImage(ctx.image, toDraw, dstX: dstX.toInt(), dstY: dstY.toInt());
    return 0; // success
  }

  int copyImage(
    int contextPtr,
    int imagePtr,
    double srcX,
    double srcY,
    double srcWidth,
    double srcHeight,
    double dstX,
    double dstY,
    double dstWidth,
    double dstHeight,
  ) {
    final ctx = store.fetch(contextPtr);
    if (ctx is! CanvasContext) return -1;
    final src = _resolveImage(imagePtr);
    if (src == null) return -3;

    final cropped = img.copyCrop(
      src,
      x: srcX.toInt(),
      y: srcY.toInt(),
      width: srcWidth.toInt(),
      height: srcHeight.toInt(),
    );

    img.Image toDraw = cropped;
    if (dstWidth.toInt() != cropped.width || dstHeight.toInt() != cropped.height) {
      toDraw = img.copyResize(cropped, width: dstWidth.toInt(), height: dstHeight.toInt());
    }

    img.compositeImage(ctx.image, toDraw, dstX: dstX.toInt(), dstY: dstY.toInt());
    return 0;
  }

  int getImage(int contextPtr) {
    final ctx = store.fetch(contextPtr);
    if (ctx is! CanvasContext) return -1;
    return store.store(ctx.image);
  }

  int newImage(int dataPtr, int dataLen) {
    if (dataPtr < 0 || dataLen <= 0) return -11; // invalidData
    try {
      final bytes = memoryHelper.readBytes(dataPtr, dataLen);
      final image = img.decodeImage(bytes);
      if (image == null) return -3; // invalidImage
      return store.store(image);
    } catch (_) {
      return -11;
    }
  }

  int getImageData(int imagePtr) {
    final item = store.fetch(imagePtr);
    if (item is Uint8List) {
      return store.store(item);
    }
    if (item is img.Image) {
      final pngBytes = Uint8List.fromList(img.encodePng(item));
      return store.store(pngBytes);
    }
    return -2;
  }

  double getImageWidth(int imagePtr) {
    final image = _resolveImage(imagePtr);
    return image != null ? image.width.toDouble() : 0.0;
  }

  double getImageHeight(int imagePtr) {
    final image = _resolveImage(imagePtr);
    return image != null ? image.height.toDouble() : 0.0;
  }
}
