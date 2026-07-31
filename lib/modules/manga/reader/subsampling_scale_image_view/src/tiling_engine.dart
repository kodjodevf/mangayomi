import 'dart:ui' as ui;
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
  List<int> sortedKeys = [];

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
    sortedKeys = [];
    fullImageSampleSize = baseSampleSize;
    int sampleSize = fullImageSampleSize;

    while (true) {
      final tile = Tile(
        sRect: ui.Rect.fromLTRB(0, 0, sWidth.toDouble(), sHeight.toDouble()),
        sampleSize: sampleSize,
      );

      tile.visible = (sampleSize == fullImageSampleSize);
      tileMap[sampleSize] = [tile];

      if (sampleSize == 1) {
        break;
      } else {
        sampleSize = sampleSize ~/ 2;
      }
    }
    sortedKeys = tileMap.keys.toList()..sort((a, b) => b.compareTo(a));
  }

  /// Updates visibility and loads tiles.
  /// Keeps loaded tiles visible without disposing them on scroll to ensure 0 FFI overhead during panning.
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
    for (final entry in tileMap.entries) {
      final tiles = entry.value;

      for (final tile in tiles) {
        if (tile.sampleSize == targetSampleSize) {
          tile.visible = true;
          if (!tile.loading && tile.image == null) {
            loadTileCallback(tile);
          }
        } else if (tile.sampleSize != fullImageSampleSize) {
          tile.visible = false;
          tile.dispose();
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
    sortedKeys.clear();
  }
}
