import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:mangayomi/utils/platform_utils.dart';

/// Bounds the memory held by decoded page images (`UChapDataPreload.decodedImage`).
///
/// Those images used to be kept for every page that had ever been shown, until
/// the whole chapter was evicted. On a chapter with many small pages that grows
/// without limit, and decoded pixels (4 bytes each, RGBA) are exactly the kind
/// of memory a low-RAM iPhone gets killed for.
///
/// This keeps the most recently used decoded images up to a byte budget and
/// releases the least recently used ones beyond it. Releasing only drops the
/// decoded pixels: the file stays in the on-disk cache, so scrolling back
/// re-decodes from disk and never re-downloads. A page that is on screen holds
/// its own clone of the image, so releasing the shared copy never blanks it.
class DecodedImageBudget {
  DecodedImageBudget({required this.maxBytes});

  /// Shared instance used by the reader.
  static final DecodedImageBudget instance = DecodedImageBudget(
    maxBytes: isMobile ? mobileBudgetBytes : desktopBudgetBytes,
  );

  /// Tune these to trade scroll-back smoothness against memory.
  static const int mobileBudgetBytes = 128 << 20;
  static const int desktopBudgetBytes = 512 << 20;

  final int maxBytes;

  // Insertion order == recency order (oldest first).
  final LinkedHashMap<Object, _Entry> _entries = LinkedHashMap();
  int _totalBytes = 0;

  int get totalBytes => _totalBytes;
  int get count => _entries.length;

  /// Registers (or re-registers) [owner] as holding [bytes] and marks it most
  /// recently used. Releases older owners while over budget, never [owner].
  void register(Object owner, int bytes, VoidCallback release) {
    final old = _entries.remove(owner);
    if (old != null) _totalBytes -= old.bytes;
    _entries[owner] = _Entry(bytes, release);
    _totalBytes += bytes;
    _trim(keep: owner);
  }

  /// Marks [owner] as most recently used without changing its size.
  void touch(Object owner) {
    final entry = _entries.remove(owner);
    if (entry != null) _entries[owner] = entry;
  }

  /// Forgets [owner] (its image was disposed by someone else).
  void unregister(Object owner) {
    final entry = _entries.remove(owner);
    if (entry != null) _totalBytes -= entry.bytes;
  }

  void _trim({required Object keep}) {
    while (_totalBytes > maxBytes && _entries.length > 1) {
      final oldestKey = _entries.keys.first;
      if (identical(oldestKey, keep)) break;
      final entry = _entries.remove(oldestKey)!;
      _totalBytes -= entry.bytes;
      entry.release();
    }
  }
}

class _Entry {
  _Entry(this.bytes, this.release);
  final int bytes;
  final VoidCallback release;
}
