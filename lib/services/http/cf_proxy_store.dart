import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';

/// Accessor for the external Cloudflare-bypass proxy URL (FlareSolverr /
/// Byparr), e.g. `http://localhost:8191/v1`.
///
/// Stored on the Settings collection (`cfProxyUrl`), alongside the rest of the
/// app's preferences.
class CfProxyStore {
  /// The saved proxy URL, or an empty string if none.
  static String get url => isar.settings.getSync(227)?.cfProxyUrl ?? '';

  /// Persists [value] as the proxy URL.
  static void setUrl(String value) {
    isar.writeTxnSync(() {
      final settings = isar.settings.getSync(227);
      if (settings != null) {
        isar.settings.putSync(settings..cfProxyUrl = value);
      }
    });
  }
}
