import 'package:hive/hive.dart';

/// Persists the user's custom DNS-over-HTTPS endpoint URL.
///
/// Stored in Hive rather than the Isar `Settings` collection so the feature
/// doesn't require a new generated schema field. The box is opened once at
/// startup (see `openBox`); reads return an empty string when it isn't open
/// (e.g. a background isolate), which the callers treat as "no custom URL".
class DohCustomStore {
  static const _boxName = 'network_prefs';
  static const _urlKey = 'custom_doh_url';

  /// Opens the backing box. Called once during app startup.
  static Future<void> openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
  }

  /// The saved custom DoH URL, or an empty string if none / box not open.
  static String get url => Hive.isBoxOpen(_boxName)
      ? (Hive.box(_boxName).get(_urlKey, defaultValue: '') as String)
      : '';

  /// Persists [value] as the custom DoH URL (best-effort if the box is open).
  static void setUrl(String value) {
    if (Hive.isBoxOpen(_boxName)) {
      Hive.box(_boxName).put(_urlKey, value);
    }
  }
}
