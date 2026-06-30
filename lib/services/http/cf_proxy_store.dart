import 'package:hive/hive.dart';

/// Persists the URL of an external Cloudflare-bypass proxy
/// (FlareSolverr / Byparr), e.g. `http://localhost:8191/v1`.
///
/// Stored in Hive rather than the Isar `Settings` collection so the feature
/// needs no generated schema field. The box is opened once at startup (see
/// [openBox]); reads return an empty string when it isn't open (e.g. a
/// background isolate), which callers treat as "no proxy configured".
class CfProxyStore {
  static const _boxName = 'cf_prefs';
  static const _urlKey = 'cf_proxy_url';

  /// Opens the backing box. Called once during app startup.
  static Future<void> openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
  }

  /// The saved proxy URL, or an empty string if none / box not open.
  static String get url => Hive.isBoxOpen(_boxName)
      ? (Hive.box(_boxName).get(_urlKey, defaultValue: '') as String)
      : '';

  /// Persists [value] as the proxy URL (best-effort if the box is open).
  static void setUrl(String value) {
    if (Hive.isBoxOpen(_boxName)) {
      Hive.box(_boxName).put(_urlKey, value);
    }
  }
}
