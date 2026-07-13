import 'dart:ui' as ui;
import 'coordinate_transformer.dart';
import 'ffi_image_decoder.dart';

/// Represents an image tile in the grid
class Tile {
  final ui.Rect sRect;
  final int sampleSize;
  bool visible = false;
  bool loading = false;
  ui.Image? image;

  Tile({required this.sRect, required this.sampleSize});

  /// Releases the graphical memory of the tile
  void dispose() {
    image?.dispose();
    image = null;
    if (loading) {
      ffiImageDecoder.cancel(this);
      loading = false;
    }
  }
}

/// Manages tiling partition and memory recycling
class TilingEngine {
  Map<int, List<Tile>> tileMap = {};
  int fullImageSampleSize = 1;

  /// Initializes the tile grid for different sampleSizes (powers of 2)
  void initialiseTileMap({
    required int sWidth,
    required int sHeight,
    required double maxTileWidth,
    required double maxTileHeight,
    required int baseSampleSize,
    required double viewWidth,
    required double viewHeight,
  }) {
    // Clears the old grid
    dispose();

    tileMap = {};
    fullImageSampleSize = baseSampleSize;
    int sampleSize = fullImageSampleSize;

    while (true) {
      int xTiles = 1;
      int yTiles = 1;

      int sTileWidth = sWidth ~/ xTiles;
      int sTileHeight = sHeight ~/ yTiles;

      int subTileWidth = sTileWidth ~/ sampleSize;
      int subTileHeight = sTileHeight ~/ sampleSize;

      // Increases the number of horizontal tiles if necessary
      while (subTileWidth + xTiles + 1 > maxTileWidth ||
          (subTileWidth > viewWidth * 1.25 &&
              sampleSize < fullImageSampleSize)) {
        xTiles += 1;
        sTileWidth = sWidth ~/ xTiles;
        subTileWidth = sTileWidth ~/ sampleSize;
      }

      // Increases the number of vertical tiles if necessary
      while (subTileHeight + yTiles + 1 > maxTileHeight ||
          (subTileHeight > viewHeight * 1.25 &&
              sampleSize < fullImageSampleSize)) {
        yTiles += 1;
        sTileHeight = sHeight ~/ yTiles;
        subTileHeight = sTileHeight ~/ sampleSize;
      }

      List<Tile> tileGrid = [];
      for (int x = 0; x < xTiles; x++) {
        for (int y = 0; y < yTiles; y++) {
          final tileLeft = x * sTileWidth;
          final tileTop = y * sTileHeight;
          final tileRight = (x == xTiles - 1) ? sWidth : (x + 1) * sTileWidth;
          final tileBottom = (y == yTiles - 1)
              ? sHeight
              : (y + 1) * sTileHeight;

          final tile = Tile(
            sRect: ui.Rect.fromLTRB(
              tileLeft.toDouble(),
              tileTop.toDouble(),
              tileRight.toDouble(),
              tileBottom.toDouble(),
            ),
            sampleSize: sampleSize,
          );

          // The base layer is visible by default
          tile.visible = (sampleSize == fullImageSampleSize);
          tileGrid.add(tile);
        }
      }

      tileMap[sampleSize] = tileGrid;

      if (sampleSize == 1) {
        break;
      } else {
        sampleSize = sampleSize ~/ 2;
      }
    }
  }

  /// Updates visibility and loads/recycles tiles based on the viewport
  void refreshRequiredTiles({
    required double scale,
    required ui.Offset vTranslate,
    required ui.Size viewSize,
    required int rotation,
    required int sWidth,
    required int sHeight,
    required int targetSampleSize,
    required Function(Tile tile) loadTileCallback,
  }) {
    final transformer = CoordinateTransformer(
      scale: scale,
      vTranslate: vTranslate,
      rotation: rotation,
      sWidth: sWidth,
      sHeight: sHeight,
    );

    // Screen viewport
    final viewRect = ui.Rect.fromLTWH(0, 0, viewSize.width, viewSize.height);

    for (final entry in tileMap.entries) {
      final _ = entry.key;
      final tiles = entry.value;

      for (final tile in tiles) {
        // Recycles tiles that are too detailed or too blurry (which are not the base layer)
        if (tile.sampleSize < targetSampleSize ||
            (tile.sampleSize > targetSampleSize &&
                tile.sampleSize != fullImageSampleSize)) {
          tile.visible = false;
          tile.dispose();
          continue;
        }

        if (tile.sampleSize == targetSampleSize) {
          // Checks if the tile overlaps the screen
          final tileViewRect = transformer.sourceToViewRect(tile.sRect);
          final isVisibleOnScreen = viewRect.overlaps(tileViewRect);

          if (isVisibleOnScreen) {
            tile.visible = true;
            if (!tile.loading && tile.image == null) {
              loadTileCallback(tile);
            }
          } else if (tile.sampleSize != fullImageSampleSize) {
            // Offscreen and not base layer -> recycle
            tile.visible = false;
            tile.dispose();
          }
        } else if (tile.sampleSize == fullImageSampleSize) {
          // The base layer always remains visible in the background
          tile.visible = true;
        }
      }
    }
  }

  /// Determines if the base layer is completely loaded
  bool isBaseLayerReady() {
    final baseGrid = tileMap[fullImageSampleSize];
    if (baseGrid == null || baseGrid.isEmpty) return false;
    for (final tile in baseGrid) {
      if (tile.image == null) return false;
    }
    return true;
  }

  /// Disposes of all tiles
  void dispose() {
    for (final grid in tileMap.values) {
      for (final tile in grid) {
        tile.dispose();
      }
    }
    tileMap.clear();
  }
}
