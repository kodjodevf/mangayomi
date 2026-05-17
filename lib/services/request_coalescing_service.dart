/// Request Coalescing Service
/// Prevents duplicate simultaneous network requests by reusing in-flight requests.
/// 
/// Usage:
/// ```dart
/// final result = await RequestCoalescingService.coalesce(
///   'search:Naruto:MangaSource1',
///   () => searchManga('Naruto', source: mangaSource1),
/// );
/// ```

import 'dart:async';

/// Service to coalesce duplicate simultaneous requests
class RequestCoalescingService {
  static final RequestCoalescingService _instance = 
      RequestCoalescingService._internal();
  
  factory RequestCoalescingService() {
    return _instance;
  }
  
  RequestCoalescingService._internal();
  
  /// Map of cache keys to pending request futures
  final Map<String, Future<dynamic>> _pendingRequests = {};
  
  /// Map of cache keys to request metadata for debugging
  final Map<String, _RequestMetadata> _requestMetadata = {};

  /// Coalesce multiple requests with the same cache key into a single request
  /// 
  /// If a request with the same [cacheKey] is already in-flight, returns
  /// the existing future instead of making a new request. This prevents
  /// duplicate network calls when multiple widgets request the same data
  /// simultaneously (e.g., rapid navigation).
  /// 
  /// Parameters:
  /// - [cacheKey]: Unique identifier for this request (e.g., 'search:query:source')
  /// - [requestFn]: Async function that performs the actual request
  /// - [timeoutDuration]: Optional timeout for the request (default: 30 seconds)
  /// 
  /// Returns: The result of [requestFn], either fresh or from coalesced request
  /// 
  /// Example:
  /// ```dart
  /// final items = await RequestCoalescingService().coalesce(
  ///   'manga:search:$query:${source.id}',
  ///   () async => await source.search(query),
  ///   timeoutDuration: Duration(seconds: 30),
  /// );
  /// ```
  Future<T> coalesce<T>(
    String cacheKey,
    Future<T> Function() requestFn, {
    Duration timeoutDuration = const Duration(seconds: 30),
  }) async {
    // Check if same request is already in-flight
    if (_pendingRequests.containsKey(cacheKey)) {
      _requestMetadata[cacheKey]?.coalescedRequestCount++;
      print('[RequestCoalescing] Reusing in-flight request for: $cacheKey');
      try {
        return await (_pendingRequests[cacheKey] as Future<T>)
            .timeout(timeoutDuration);
      } catch (e) {
        print('[RequestCoalescing] Coalesced request failed: $e');
        rethrow;
      }
    }

    // Start new request
    print('[RequestCoalescing] Starting new request for: $cacheKey');
    
    _requestMetadata[cacheKey] = _RequestMetadata(
      cacheKey: cacheKey,
      startTime: DateTime.now(),
      coalescedRequestCount: 0,
    );

    final completer = Completer<dynamic>();
    _pendingRequests[cacheKey] = completer.future;

    try {
      final result = await requestFn().timeout(timeoutDuration);
      
      final duration = DateTime.now()
          .difference(_requestMetadata[cacheKey]!.startTime);
      final coalescedCount = _requestMetadata[cacheKey]!.coalescedRequestCount;
      
      print('[RequestCoalescing] Request completed in ${duration.inMilliseconds}ms '
            'with $coalescedCount coalesced requests for: $cacheKey');
      
      completer.complete(result);
      return result as T;
    } catch (e) {
      print('[RequestCoalescing] Request failed: $e for: $cacheKey');
      completer.completeError(e);
      rethrow;
    } finally {
      // Clean up after request completes
      _pendingRequests.remove(cacheKey);
      _requestMetadata.remove(cacheKey);
    }
  }

  /// Clear all pending requests (useful for testing or forcing fresh fetches)
  void clear() {
    _pendingRequests.clear();
    _requestMetadata.clear();
    print('[RequestCoalescing] Cleared all pending requests');
  }

  /// Get number of currently in-flight requests
  int get pendingRequestCount => _pendingRequests.length;

  /// Get metrics for debugging
  Map<String, dynamic> getMetrics() {
    return {
      'pendingRequestCount': _pendingRequests.length,
      'totalRequestsTracked': _requestMetadata.length,
      'pendingKeys': _pendingRequests.keys.toList(),
    };
  }
}

/// Metadata for tracking request metrics
class _RequestMetadata {
  final String cacheKey;
  final DateTime startTime;
  int coalescedRequestCount;

  _RequestMetadata({
    required this.cacheKey,
    required this.startTime,
    required this.coalescedRequestCount,
  });
}
