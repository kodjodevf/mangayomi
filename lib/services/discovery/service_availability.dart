import 'dart:io';

/// A metadata service that discovery can ask.
enum DiscoveryService {
  anilist('AniList'),
  kitsu('Kitsu');

  const DiscoveryService(this.label);
  final String label;
}

/// Thrown when a metadata service will not answer, carrying whatever reason it
/// gave.
///
/// The point is the [reason]: AniList answers a disabled API with a 403 and a
/// sentence explaining itself, and passing that through is the difference
/// between "Request timed out" and "AniList has temporarily disabled their
/// API".
class DiscoveryUnavailable implements Exception {
  DiscoveryUnavailable(this.service, this.reason, {this.retryAfter});

  final DiscoveryService service;
  final String reason;

  /// When the service may be worth asking again.
  final DateTime? retryAfter;

  @override
  String toString() => '${service.label} is unavailable: $reason';
}

/// Remembers which services are refusing, so the app stops asking.
///
/// A service returning 403 because it is shedding load does not want to be
/// retried on every screen build, and the reader does not want to wait for a
/// request that is going to fail. After one refusal the next calls fail
/// immediately with the reason the service itself gave, until the cooldown
/// expires.
class ServiceAvailability {
  ServiceAvailability._();

  static const _cooldown = Duration(minutes: 10);
  static final Map<DiscoveryService, DiscoveryUnavailable> _down = {};

  /// The recorded refusal for [service], or null when it is worth asking.
  static DiscoveryUnavailable? outage(DiscoveryService service) {
    final recorded = _down[service];
    if (recorded == null) return null;
    final until = recorded.retryAfter;
    if (until != null && DateTime.now().isAfter(until)) {
      _down.remove(service);
      return null;
    }
    return recorded;
  }

  /// Whether [service] is worth asking right now.
  static bool isAvailable(DiscoveryService service) => outage(service) == null;

  /// Records that [service] refused, and returns the exception to throw.
  static DiscoveryUnavailable markDown(
    DiscoveryService service,
    String reason, {
    Duration? cooldown,
  }) {
    final outage = DiscoveryUnavailable(
      service,
      reason,
      retryAfter: DateTime.now().add(cooldown ?? _cooldown),
    );
    _down[service] = outage;
    return outage;
  }

  /// Records that [service] answered, clearing any refusal.
  static void markUp(DiscoveryService service) => _down.remove(service);

  static void clearForTest() => _down.clear();
}

/// Whether [error] is the network failing rather than the service refusing.
///
/// Both end the request, but only the second is worth remembering: a service
/// is not down because this device lost its connection.
bool isNetworkFailure(Object error) =>
    error is SocketException ||
    error is HttpException ||
    error.toString().toLowerCase().contains('failed host lookup');

/// The reason AniList is refusing, or null when this is a normal answer.
///
/// A refusal is a 403 or a 5xx. AniList puts a sentence in the body explaining
/// itself — "The AniList API has been temporarily disabled due to severe
/// stability issues" — and that sentence is what the reader should be told, so
/// it is preferred over anything this code could invent.
String? anilistRefusal(int statusCode, Map<String, dynamic>? body) {
  if (statusCode != 403 && statusCode < 500) return null;
  final errors = body?["errors"];
  if (errors is List) {
    for (final error in errors) {
      final message = (error is Map ? error["message"] : null) as String?;
      if (message != null && message.trim().isNotEmpty) return message.trim();
    }
  }
  return statusCode == 403
      ? "refused the request (HTTP 403)"
      : "is having server trouble (HTTP $statusCode)";
}
