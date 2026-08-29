// ignore_for_file: non_nullable_equals_parameter, depend_on_referenced_packages, implementation_imports
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui show Codec, ImmutableBuffer;

import 'package:extended_image_library/src/extended_image_provider.dart';
import 'package:extended_image_library/src/platform.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/avif.dart';
import 'package:path/path.dart';
import 'package:extended_image_library/src/network/extended_network_image_provider.dart'
    as image_provider;

// NOTE: encoded image bytes are intentionally NOT cached in memory here.
// The on-disk cache plus Flutter's decoded imageCache already cover repeat
// loads; an extra encoded-bytes layer only added ~50MB of resident memory.

/// Cache metadata for LRU eviction
class _CacheMetadata {
  final String path;
  final int size;
  final DateTime lastAccessed;

  _CacheMetadata({
    required this.path,
    required this.size,
    required this.lastAccessed,
  });
}

/// Global cache manager
class _CacheManager {
  static const _maxCacheSize = 500 * 1024 * 1024; // 500MB
  static final Map<String, DateTime> _lastEvictionCheck = {};
  static const _evictionThrottleInterval = Duration(minutes: 10);
  static bool _isEvicting = false;

  static Future<int> getCacheSize(Directory cacheDir) async {
    if (!await cacheDir.exists()) return 0;

    int totalSize = 0;
    try {
      await for (final entity in cacheDir.list(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
    } catch (_) {}
    return totalSize;
  }

  /// Triggers cache eviction asynchronously in the background without blocking the UI
  static void evictOldestIfNeededThrottled(Directory cacheDir) {
    final now = DateTime.now();
    final lastCheck = _lastEvictionCheck[cacheDir.path];
    if (lastCheck != null &&
        now.difference(lastCheck) < _evictionThrottleInterval) {
      return;
    }
    _lastEvictionCheck[cacheDir.path] = now;
    unawaited(evictOldestIfNeeded(cacheDir));
  }

  static Future<void> evictOldestIfNeeded(Directory cacheDir) async {
    if (_isEvicting) return;
    _isEvicting = true;
    try {
      final size = await getCacheSize(cacheDir);
      if (size <= _maxCacheSize) return;

      // Collect all cache files with metadata
      final List<_CacheMetadata> files = [];
      await for (final entity in cacheDir.list(recursive: true)) {
        if (entity is File) {
          try {
            final stat = await entity.stat();
            final lastTime = stat.accessed.isAfter(stat.modified)
                ? stat.accessed
                : stat.modified;
            files.add(
              _CacheMetadata(
                path: entity.path,
                size: stat.size,
                lastAccessed: lastTime,
              ),
            );
          } catch (_) {}
        }
      }

      // Sort by last accessed/modified (oldest first)
      files.sort((a, b) => a.lastAccessed.compareTo(b.lastAccessed));

      // Delete until under limit
      int currentSize = size;
      for (final file in files) {
        if (currentSize <= _maxCacheSize) break;
        try {
          final f = File(file.path);
          if (await f.exists()) {
            await f.delete();
            currentSize -= file.size;
          }
        } catch (e) {
          if (kDebugMode) print('Failed to delete cache file: $e');
        }
      }
    } catch (e) {
      if (kDebugMode) print('Error during cache eviction: $e');
    } finally {
      _isEvicting = false;
    }
  }
}

class CustomExtendedNetworkImageProvider
    extends ImageProvider<image_provider.ExtendedNetworkImageProvider>
    with ExtendedImageProvider<image_provider.ExtendedNetworkImageProvider>
    implements image_provider.ExtendedNetworkImageProvider {
  /// Deduplication map for in-flight image downloads to prevent multiple concurrent HTTP GET requests for the same URL
  static final Map<String, Future<Uint8List?>> _inFlightRequests = {};

  /// Creates an object that fetches the image at the given URL.
  ///
  /// The arguments must not be null.
  CustomExtendedNetworkImageProvider(
    this.url, {
    this.scale = 1.0,
    this.headers,
    this.cache = true,
    this.retries = 3,
    this.timeLimit,
    this.timeRetry = const Duration(milliseconds: 100),
    this.cacheKey,
    this.printError = true,
    this.cacheRawData = false,
    this.cancelToken,
    this.imageCacheName,
    this.imageCacheFolderName,
    this.cacheMaxAge = const Duration(days: 30),
    this.showCloudFlareError = false,
  });

  /// The name of [ImageCache], you can define custom [ImageCache] to store this provider.
  @override
  final String? imageCacheName;

  /// Whether cache raw data if you need to get raw data directly.
  /// For example, we need raw image data to edit,
  /// but [ui.Image.toByteData()] is very slow. So we cache the image
  /// data here.
  @override
  final bool cacheRawData;

  /// The time limit to request image
  @override
  final Duration? timeLimit;

  /// The time to retry to request
  @override
  final int retries;

  /// The time duration to retry to request
  @override
  final Duration timeRetry;

  /// Whether cache image to local
  @override
  final bool cache;

  /// The URL from which the image will be fetched.
  @override
  final String url;

  /// The scale to place in the [ImageInfo] object of the image.
  @override
  final double scale;

  /// The HTTP headers that will be used with [HttpClient.get] to fetch image from network.
  @override
  final Map<String, String>? headers;

  /// The token to cancel network request
  @override
  final CancellationToken? cancelToken;

  /// Custom cache key
  @override
  final String? cacheKey;

  /// print error
  @override
  final bool printError;

  /// The max duration to cache image.
  /// After this time the cache is expired and the image is reloaded.
  @override
  final Duration? cacheMaxAge;

  final bool showCloudFlareError;

  final String? imageCacheFolderName;

  @override
  ImageStreamCompleter loadImage(
    image_provider.ExtendedNetworkImageProvider key,
    ImageDecoderCallback decode,
  ) {
    // Ownership of this controller is handed off to [_loadAsync]; it is that
    // method's responsibility to close the controller's stream when the image
    // has been loaded or an error is thrown.
    final StreamController<ImageChunkEvent> chunkEvents =
        StreamController<ImageChunkEvent>();

    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(
        key as CustomExtendedNetworkImageProvider,
        chunkEvents,
        decode,
      ),
      scale: key.scale,
      chunkEvents: chunkEvents.stream,
      debugLabel: key.url,
      informationCollector: () {
        return <DiagnosticsNode>[
          DiagnosticsProperty<ImageProvider>('Image provider', this),
          DiagnosticsProperty<image_provider.ExtendedNetworkImageProvider>(
            'Image key',
            key,
          ),
        ];
      },
    );
  }

  @override
  Future<CustomExtendedNetworkImageProvider> obtainKey(
    ImageConfiguration configuration,
  ) {
    return SynchronousFuture<CustomExtendedNetworkImageProvider>(this);
  }

  @override
  Future<ui.Codec> instantiateImageCodec(
    Uint8List data,
    ImageDecoderCallback decode,
  ) async {
    try {
      return await super.instantiateImageCodec(data, decode);
    } catch (_) {
      if (!Platform.isIOS || !isAvifImage(data)) rethrow;
      final png = await decodeAvifToPng(data);
      return decode(await ui.ImmutableBuffer.fromUint8List(png));
    }
  }

  Future<ui.Codec> _loadAsync(
    CustomExtendedNetworkImageProvider key,
    StreamController<ImageChunkEvent> chunkEvents,
    ImageDecoderCallback decode,
  ) async {
    assert(key == this);
    final String md5Key = cacheKey ?? keyToMd5(key.url);
    ui.Codec? result;
    // Kept so the final error, if any, says why instead of just "failed" —
    // both attempts below were previously swallowing the real exception.
    Object? lastError;
    if (cache) {
      try {
        final Uint8List? data = await _loadCache(key, chunkEvents, md5Key);
        if (data != null) {
          result = await instantiateImageCodec(data, decode);
        }
      } catch (e) {
        lastError = e;
        if (kDebugMode) {
          print(e);
        }
      }
    }

    if (result == null) {
      try {
        final Uint8List? data = await _loadNetworkWithDeduplication(
          key,
          chunkEvents,
          md5Key,
        );
        if (data != null) {
          result = await instantiateImageCodec(data, decode);
        }
      } catch (e) {
        lastError = e;
        if (kDebugMode) {
          print(e);
        }
      }
    }

    //Failed to load
    if (result == null) {
      //result = await ui.instantiateImageCodec(kTransparentImage);
      return Future<ui.Codec>.error(
        StateError(
          'Failed to load $url.${lastError != null ? ' Cause: $lastError' : ''}',
        ),
      );
    }

    return result;
  }

  /// Helper to deduplicate in-flight network downloads for non-cached or fallback requests
  Future<Uint8List?> _loadNetworkWithDeduplication(
    CustomExtendedNetworkImageProvider key,
    StreamController<ImageChunkEvent>? chunkEvents,
    String md5Key,
  ) async {
    final existingRequest = _inFlightRequests[md5Key];
    if (existingRequest != null) {
      return await existingRequest;
    }

    final future = _loadNetwork(key, chunkEvents);
    _inFlightRequests[md5Key] = future;
    try {
      return await future;
    } finally {
      _inFlightRequests.remove(md5Key);
    }
  }

  /// Get the image from cache folder with in-flight deduplication.
  Future<Uint8List?> _loadCache(
    CustomExtendedNetworkImageProvider key,
    StreamController<ImageChunkEvent>? chunkEvents,
    String md5Key,
  ) async {
    final Directory cacheImagesDirectory = await StorageProvider()
        .createCacheDirectory(imageCacheFolderName);
    Uint8List? data;
    final File cacheFile = File(join(cacheImagesDirectory.path, md5Key));

    // exist, try to find cache image file
    if (await cacheFile.exists()) {
      if (key.cacheMaxAge != null) {
        final DateTime now = DateTime.now();
        final DateTime lastModified = await cacheFile.lastModified();
        if (now.difference(lastModified) > key.cacheMaxAge!) {
          try {
            await cacheFile.delete();
          } catch (_) {}
        } else {
          data = await cacheFile.readAsBytes();
          // Update last modified timestamp asynchronously for LRU tracking
          unawaited(cacheFile.setLastModified(now).catchError((_) {}));
        }
      } else {
        data = await cacheFile.readAsBytes();
        unawaited(cacheFile.setLastModified(DateTime.now()).catchError((_) {}));
      }
    }

    // load from network with in-flight request coalescing
    if (data == null) {
      final existingRequest = _inFlightRequests[md5Key];
      if (existingRequest != null) {
        return await existingRequest;
      }

      final future = _loadNetwork(key, chunkEvents);
      _inFlightRequests[md5Key] = future;

      try {
        data = await future;
        if (data != null) {
          try {
            // cache image file
            await File(join(cacheImagesDirectory.path, md5Key))
                .writeAsBytes(data);
            // Evict old cache in background if needed (throttled)
            _CacheManager.evictOldestIfNeededThrottled(cacheImagesDirectory);
          } catch (_) {}
        }
      } finally {
        _inFlightRequests.remove(md5Key);
      }
    }

    return data;
  }

  /// Get the image from network.
  Future<Uint8List?> _loadNetwork(
    CustomExtendedNetworkImageProvider key,
    StreamController<ImageChunkEvent>? chunkEvents,
  ) async {
    try {
      final Uri resolved = Uri.base.resolve(key.url);
      final StreamedResponse? response = await _tryGetResponse(resolved);

      if (response == null || response.statusCode != HttpStatus.ok) {
        return null;
      }

      final int total = response.contentLength ?? 0;
      final BytesBuilder bytesBuilder = BytesBuilder(copy: false);
      int received = 0;

      await for (final chunk in response.stream) {
        bytesBuilder.add(chunk);
        received += chunk.length;
        chunkEvents?.add(
          ImageChunkEvent(
            cumulativeBytesLoaded: received,
            expectedTotalBytes: total > 0 ? total : null,
          ),
        );
      }

      final Uint8List bytes = bytesBuilder.takeBytes();
      if (bytes.isEmpty) {
        return await Future<Uint8List>.error(
          StateError('NetworkImage is an empty file: $resolved'),
        );
      }

      return bytes;
    } on OperationCanceledError catch (_) {
      if (kDebugMode) {
        print('User cancel request $url.');
      }
      return Future<Uint8List>.error(StateError('User cancel request $url.'));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      await chunkEvents?.close();
    }
    return null;
  }

  Future<StreamedResponse> _getResponse(Uri resolved) async {
    // Optimize headers for better caching and compression
    final optimizedHeaders = {
      ...?headers,
      'Accept-Encoding': 'gzip, deflate, br',
      'Accept': 'image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8',
      'Connection': 'keep-alive',
    };

    var request = Request('GET', resolved);
    request.headers.addAll(optimizedHeaders);

    StreamedResponse response = await MClient.init(
      showCloudFlareError: showCloudFlareError,
    ).send(request);

    if (response.statusCode != HttpStatus.ok) {
      final retryRequest = Request('GET', resolved);
      retryRequest.headers.addAll(optimizedHeaders);
      final res = await MClient.init(
        reqcopyWith: {'useDartHttpClient': true},
        showCloudFlareError: showCloudFlareError,
      ).send(retryRequest);
      return res;
    }

    return response;
  }

  // Http get with cancel, exponential backoff retry
  Future<StreamedResponse?> _tryGetResponse(Uri resolved) async {
    cancelToken?.throwIfCancellationRequested();

    int attempt = 0;
    while (attempt < retries) {
      try {
        return await CancellationTokenSource.register(
          cancelToken,
          _getResponse(resolved),
        );
      } catch (e) {
        attempt++;
        if (attempt >= retries) {
          rethrow;
        }

        // Exponential backoff: 100ms, 200ms, 400ms, 800ms, etc.
        final backoffDelay = Duration(
          milliseconds: timeRetry.inMilliseconds * (1 << attempt),
        );

        if (kDebugMode) {
          print(
            'Retry attempt $attempt/$retries after ${backoffDelay.inMilliseconds}ms',
          );
        }

        await Future.delayed(backoffDelay);
        cancelToken?.throwIfCancellationRequested();
      }
    }

    return null;
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is CustomExtendedNetworkImageProvider &&
        url == other.url &&
        scale == other.scale &&
        cacheRawData == other.cacheRawData &&
        timeLimit == other.timeLimit &&
        cancelToken == other.cancelToken &&
        timeRetry == other.timeRetry &&
        cache == other.cache &&
        cacheKey == other.cacheKey &&
        //headers == other.headers &&
        retries == other.retries &&
        imageCacheName == other.imageCacheName &&
        cacheMaxAge == other.cacheMaxAge;
  }

  @override
  int get hashCode => Object.hash(
    url,
    scale,
    cacheRawData,
    timeLimit,
    cancelToken,
    timeRetry,
    cache,
    cacheKey,
    //headers,
    retries,
    imageCacheName,
    cacheMaxAge,
  );

  @override
  String toString() => '$runtimeType("$url", scale: $scale)';

  @override
  /// Get network image data from cached
  Future<Uint8List?> getNetworkImageData({
    StreamController<ImageChunkEvent>? chunkEvents,
  }) async {
    final String uId = cacheKey ?? keyToMd5(url);

    if (cache) {
      return await _loadCache(this, chunkEvents, uId);
    }

    return await _loadNetworkWithDeduplication(this, chunkEvents, uId);
  }

  @override
  WebHtmlElementStrategy get webHtmlElementStrategy =>
      WebHtmlElementStrategy.fallback;
}
