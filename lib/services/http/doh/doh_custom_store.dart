import 'package:mangayomi/repositories/settings_repository.dart';

/// Accessor for the user's custom DNS-over-HTTPS endpoint URL.
///
/// Stored on the Settings collection (`customDohUrl`), next to the DoH provider
/// selection, alongside the rest of the app's preferences.
class DohCustomStore {
  /// The saved custom DoH URL, or an empty string if none.
  static String get url => settingsRepository.current.customDohUrl ?? '';

  /// Persists [value] as the custom DoH URL.
  static void setUrl(String value) {
    settingsRepository.update((s) => s.customDohUrl = value);
  }
}
