import 'package:mangayomi/repositories/settings_repository.dart';

/// Accessor for the external Cloudflare-bypass proxy URL (FlareSolverr /
/// Byparr), e.g. `http://localhost:8191/v1`.
///
/// Stored on the Settings collection (`cfProxyUrl`), alongside the rest of the
/// app's preferences.
class CfProxyStore {
  /// The saved proxy URL, or an empty string if none.
  static String get url => settingsRepository.current.cfProxyUrl ?? '';

  /// Persists [value] as the proxy URL.
  static void setUrl(String value) {
    settingsRepository.update((s) => s.cfProxyUrl = value);
  }
}
