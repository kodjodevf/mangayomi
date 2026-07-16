import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';

/// Accessor for the user's custom DNS-over-HTTPS endpoint URL.
///
/// Stored on the Settings collection (`customDohUrl`), next to the DoH provider
/// selection, alongside the rest of the app's preferences.
class DohCustomStore {
  /// The saved custom DoH URL, or an empty string if none.
  static String get url => isar.settings.getSync(227)?.customDohUrl ?? '';

  /// Persists [value] as the custom DoH URL.
  static void setUrl(String value) {
    isar.writeTxnSync(() {
      final settings = isar.settings.getSync(227);
      if (settings != null) {
        isar.settings.putSync(settings..customDohUrl = value);
      }
    });
  }
}
