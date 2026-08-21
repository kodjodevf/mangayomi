import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_connection_status_provider.g.dart';

enum SyncConnectionStatus { notConfigured, checking, connected, unauthorized, unreachable }

@riverpod
class SyncConnectionState extends _$SyncConnectionState {
  @override
  SyncConnectionStatus build({required int syncId}) {
    final prefs = ref.watch(synchingProvider(syncId: syncId));
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
    final server = prefs.server ?? '';
    final authToken = prefs.authToken ?? '';
    if (server.isEmpty || authToken.isEmpty) {
      state = SyncConnectionStatus.notConfigured;
      return;
    }
    state = SyncConnectionStatus.checking;
    _check(server, authToken);
  }

  Future<void> _check(String server, String authToken) async {
    final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
    final url = server.endsWith('/')
        ? server.substring(0, server.length - 1)
        : server;
    SyncConnectionStatus result;
    try {
      final response = await http
          .get(Uri.parse('$url/api/settings'), headers: {'Cookie': 'id=$authToken'})
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
