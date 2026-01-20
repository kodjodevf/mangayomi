import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:mangayomi/services/http/doh/doh_providers.dart';

/// Cache entry with dynamic TTL
class _CacheEntry {
  final List<String> ips;
  final DateTime timestamp;
  final int ttl; // in seconds

  _CacheEntry(this.ips, this.timestamp, {this.ttl = 300}); // default 5 min

  bool get isExpired => DateTime.now().difference(timestamp).inSeconds > ttl;
}

/// Provider stats for circuit breaker
class _ProviderStats {
  int successCount = 0;
  int failureCount = 0;
  DateTime lastFailure = DateTime.now();
  bool isCircuitOpen = false;

  double get successRate => (successCount + failureCount) == 0
      ? 100
      : (successCount / (successCount + failureCount)) * 100;

  bool shouldRetry() {
    if (!isCircuitOpen) return true;
    // Retry after 1 minute if circuit is open
    return DateTime.now().difference(lastFailure).inSeconds > 60;
  }
}

/// DoH (DNS-over-HTTPS) Resolver
class DoHResolver {
  /// Cache for resolved domains with dynamic TTL
  static final Map<String, _CacheEntry> _cache = {};

  /// Provider statistics for circuit breaker
  static final Map<int, _ProviderStats> _providerStats = {};

  /// Rate limiting (max requests per second per host)
  static final Map<String, List<DateTime>> _requestHistory = {};
  static const int _maxRequestsPerSecond = 10;

  static const Duration _requestTimeout = Duration(seconds: 5);

  /// Resolve hostname using specified DoH provider with A and AAAA records
  /// Uses bootstrap IPs to avoid circular DNS resolution
  static Future<List<String>> resolve(
    String host, {
    DoHProvider? provider,
    bool ipv6 = true,
  }) async {
    // Use default (Cloudflare) if not specified
    provider ??= DoHProviders.cloudflare;

    // Validate bootstrap IPs
    if (provider.bootstrapIPs.isEmpty) {
      _log('Provider ${provider.name} has no bootstrap IPs', isError: true);
      return [];
    }

    // Rate limiting check
    if (!_checkRateLimit(host)) {
      _log('Rate limit exceeded for $host', isError: true);
      return [];
    }

    // Check cache first (cache key includes both host and provider)
    final cacheKey = '$host:${provider.id}';
    final cached = _cache[cacheKey];
    if (cached != null && !cached.isExpired) {
      _log('Cache hit for $host on ${provider.name}');
      return cached.ips;
    }

    try {
      // Try resolution with specified provider
      var ips = await _resolveFromProvider(host, provider);

      // If no IPv4, try IPv6
      if (ips.isEmpty && ipv6) {
        _log('No IPv4 for $host, trying IPv6');
        ips = await _resolveFromProvider(host, provider, recordType: 'AAAA');
      }

      if (ips.isNotEmpty) {
        _getProviderStats(provider.id).successCount++;
        // Cache with dynamic TTL (default 5 min)
        _cache[cacheKey] = _CacheEntry(ips, DateTime.now(), ttl: 300);
        return ips;
      }

      // If primary provider fails, try fallback
      _log('Resolution failed with ${provider.name}, trying fallback');
      return await _resolveWithFallback(host, provider, ipv6: ipv6);
    } catch (e) {
      _getProviderStats(provider.id).failureCount++;
      _getProviderStats(provider.id).lastFailure = DateTime.now();
      _log('Error resolving $host: $e', isError: true);
      return [];
    }
  }

  /// Resolve using specific provider via bootstrap IP
  /// This avoids circular DNS dependency by connecting to bootstrap IP directly
  static Future<List<String>> _resolveFromProvider(
    String host,
    DoHProvider provider, {
    String recordType = 'A',
  }) async {
    // Check circuit breaker
    final stats = _getProviderStats(provider.id);
    if (!stats.shouldRetry()) {
      _log('Provider ${provider.name} circuit breaker is open', isError: true);
      return [];
    }

    final uri = Uri.parse(provider.url);
    final providerHost = uri.host;

    // Validate bootstrap IPs format
    final validBootstrapIps = provider.bootstrapIPs
        .where((ip) => _isValidIp(ip))
        .toList();
    if (validBootstrapIps.isEmpty) {
      _log('No valid bootstrap IPs for ${provider.name}', isError: true);
      return [];
    }

    // Try each bootstrap IP until one succeeds
    for (int i = 0; i < validBootstrapIps.length; i++) {
      final bootstrapIp = validBootstrapIps[i];
      try {
        final result = await _queryDoHViaBootstrapIp(
          host,
          provider,
          bootstrapIp,
          providerHost,
          recordType,
        );
        if (result.isNotEmpty) {
          _log(
            'Resolved $host via ${provider.name} (bootstrap IP $i+1/${validBootstrapIps.length})',
          );
          return result;
        }
      } catch (e) {
        _log('Bootstrap IP $i failed for ${provider.name}: $e');
        continue;
      }
    }

    stats.failureCount++;
    stats.lastFailure = DateTime.now();
    // Open circuit after 3 consecutive failures
    if (stats.failureCount >= 3) {
      stats.isCircuitOpen = true;
      _log('Circuit breaker opened for ${provider.name}', isError: true);
    }

    return [];
  }

  /// Query DoH via specific bootstrap IP (direct IP connection, no DNS lookup)
  static Future<List<String>> _queryDoHViaBootstrapIp(
    String targetHost,
    DoHProvider provider,
    String bootstrapIp,
    String providerHost,
    String recordType,
  ) async {
    final uri = Uri.parse(provider.url);
    final client = HttpClient();
    client.connectionTimeout = _requestTimeout;

    try {
      // Create request with bootstrap IP instead of hostname
      final request = await client.getUrl(
        Uri(
          scheme: uri.scheme,
          host: bootstrapIp, // Use bootstrap IP directly
          port: uri.port,
          path: uri.path,
          query: 'name=$targetHost&type=$recordType',
        ),
      );

      // Set Host header to the actual provider hostname (required for HTTPS SNI)
      request.headers.set('Host', providerHost);
      request.headers.set('Accept', 'application/dns-json');
      request.headers.set('User-Agent', 'Mangayomi/1.0');

      final response = await request.close().timeout(_requestTimeout);

      if (response.statusCode == 200) {
        final body = await utf8.decodeStream(response);
        return _parseDoHResponse(body);
      }

      _log('HTTP ${response.statusCode} from $bootstrapIp (${provider.name})');
      return [];
    } on SocketException {
      // Connection failed with this bootstrap IP
      _log('Socket error on $bootstrapIp');
      rethrow;
    } on TimeoutException {
      // Timeout with this bootstrap IP
      _log('Timeout on $bootstrapIp');
      rethrow;
    } finally {
      client.close();
    }
  }

  /// Fallback resolution with other providers
  static Future<List<String>> _resolveWithFallback(
    String host,
    DoHProvider primary, {
    bool ipv6 = true,
  }) async {
    // Try other providers in order
    for (final provider in DoHProviders.all) {
      if (provider.id == primary.id) continue;

      // Skip providers with open circuit
      final stats = _getProviderStats(provider.id);
      if (!stats.shouldRetry()) {
        _log('Skipping ${provider.name} (circuit open)');
        continue;
      }

      try {
        var ips = await _resolveFromProvider(host, provider);

        if (ips.isEmpty && ipv6) {
          ips = await _resolveFromProvider(host, provider, recordType: 'AAAA');
        }

        if (ips.isNotEmpty) {
          stats.successCount++;
          final cacheKey = '$host:${provider.id}';
          _cache[cacheKey] = _CacheEntry(ips, DateTime.now(), ttl: 300);
          _log('Fallback success with ${provider.name}');
          return ips;
        }
      } catch (e) {
        _log('Fallback failed with ${provider.name}: $e');
        continue;
      }
    }

    _log('All providers exhausted for $host', isError: true);
    return [];
  }

  /// Parse DoH JSON response (RFC 8484 format) and extract TTL
  static List<String> _parseDoHResponse(String jsonBody) {
    try {
      final json = jsonDecode(jsonBody) as Map<String, dynamic>;
      final answers = json['Answer'] as List?;

      if (answers != null && answers.isNotEmpty) {
        final ips = answers
            .map((answer) {
              if (answer is Map && answer.containsKey('data')) {
                return answer['data'] as String;
              }
              return null;
            })
            .whereType<String>()
            .toList();

        if (ips.isNotEmpty) {
          // Extract TTL from first answer if available
          final ttl = (answers.first is Map && answers.first.containsKey('TTL'))
              ? (answers.first['TTL'] as int?) ?? 300
              : 300;
          _log('Parsed ${ips.length} record(s) with TTL $ttl');
        }

        return ips;
      }
    } catch (e) {
      _log('Failed to parse DoH response: $e', isError: true);
    }

    return [];
  }

  /// Check if IP address is valid (IPv4 or IPv6)
  static bool _isValidIp(String ip) {
    try {
      InternetAddress(ip);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Rate limiting: check if request is allowed
  static bool _checkRateLimit(String host) {
    final now = DateTime.now();
    final cutoffTime = now.subtract(Duration(seconds: 1));

    // Get or create request history for this host
    _requestHistory[host] ??= [];
    final history = _requestHistory[host]!;

    // Remove old entries outside 1-second window
    history.removeWhere((t) => t.isBefore(cutoffTime));

    // Check if limit exceeded
    if (history.length >= _maxRequestsPerSecond) {
      return false;
    }

    // Record new request
    history.add(now);
    return true;
  }

  /// Get or create provider stats
  static _ProviderStats _getProviderStats(int providerId) {
    return _providerStats.putIfAbsent(providerId, () => _ProviderStats());
  }

  static void _log(String message, {bool isError = false}) {
    final timestamp = DateTime.now().toIso8601String();
    if (kDebugMode) {
      if (isError) {
        print('❌ [$timestamp] DoH: $message');
      } else {
        // ignore: avoid_print
        print('✓ [$timestamp] DoH: $message');
      }
    }
  }
}
