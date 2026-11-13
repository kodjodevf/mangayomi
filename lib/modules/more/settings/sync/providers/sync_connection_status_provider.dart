import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/services/sync/sync_transport.dart';
import 'package:mangayomi/services/sync_host/sync_secrets.dart';
import 'package:mangayomi/src/rust/api/sync_host.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_connection_status_provider.g.dart';

enum SyncConnectionStatus {
  notConfigured,
  checking,
  connected,
  unauthorized,
  unreachable,
}

@riverpod
class SyncConnectionState extends _$SyncConnectionState {
  @override
  SyncConnectionStatus build({required int syncId}) {
    final prefs = ref.watch(synchingProvider(syncId: syncId));
    final host = _hostStatus(prefs);
    if (host != null) return host;
    final server = prefs.server ?? '';
    final authToken = prefs.authToken ?? '';
    if (server.isEmpty || authToken.isEmpty) {
      return SyncConnectionStatus.notConfigured;
    }
    _check(server, authToken);
    return SyncConnectionStatus.checking;
  }

  void recheck() {
    final prefs = ref.read(synchingProvider(syncId: syncId));
    final host = _hostStatus(prefs);
    if (host != null) {
      state = host;
      return;
    }
    final server = prefs.server ?? '';
    final authToken = prefs.authToken ?? '';
    if (server.isEmpty || authToken.isEmpty) {
      state = SyncConnectionStatus.notConfigured;
      return;
    }
    state = SyncConnectionStatus.checking;
    _check(server, authToken);
  }

  /// For a host: this device's own is always there; another device's is
  /// checked in the background. Null when [prefs] is not about a host.
  SyncConnectionStatus? _hostStatus(SyncPreference prefs) {
    if (prefs.server == SyncPreference.thisDeviceHost) {
      return SyncConnectionStatus.connected;
    }
    final fingerprint = prefs.hostFingerprint;
    if (fingerprint == null) return null;
    _checkHost(prefs.peerAddresses, fingerprint);
    return SyncConnectionStatus.checking;
  }

  /// A sync that asks for nothing: answered when the host is there and
  /// still knows this device.
  Future<void> _checkHost(List<String> addresses, String fingerprint) async {
    SyncConnectionStatus result;
    try {
      if (addresses.isEmpty) throw StateError('No host address');
      final identity = await SyncSecrets().identity();
      final response = await PeerSyncTransport.trying(
        addresses,
        (address) => SyncPeerClient(
          identity: identity,
          baseUrl: address,
          hostFingerprint: fingerprint,
          timeoutSeconds: 6,
        ),
      ).postSync({'since': _maxSafeInteger});
      result = response != null
          ? SyncConnectionStatus.connected
          : SyncConnectionStatus.unauthorized;
    } catch (_) {
      // Unreachable is the answer here, shown as such: not an error.
      result = SyncConnectionStatus.unreachable;
    }
    if (ref.mounted) state = result;
  }

  static const _maxSafeInteger = 9007199254740991;

  Future<void> _check(String server, String authToken) async {
    final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
    final url = server.endsWith('/')
        ? server.substring(0, server.length - 1)
        : server;
    SyncConnectionStatus result;
    try {
      final response = await http
          .get(
            Uri.parse('$url/api/account/settings'),
            headers: {
              'Cookie': 'id=$authToken',
              'Authorization': 'Bearer $authToken',
            },
          )
          .timeout(const Duration(seconds: 6));
      if (response.statusCode == 200 || response.statusCode == 404) {
        result = SyncConnectionStatus.connected;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        result = SyncConnectionStatus.unauthorized;
      } else {
        result = SyncConnectionStatus.unreachable;
      }
    } catch (_) {
      result = SyncConnectionStatus.unreachable;
    }
    if (ref.mounted) {
      state = result;
    }
  }
}
