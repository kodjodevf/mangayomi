/// Key-value storage for source-specific defaults and preferences.
class SettingsStore {
  SettingsStore._();
  static final SettingsStore shared = SettingsStore._();

  final Map<String, Object?> _storage = {};

  Object? object(String key) => _storage[key];

  void setValue(String key, Object? value) {
    if (value == null) {
      _storage.remove(key);
    } else {
      _storage[key] = value;
    }
  }

  void clear() => _storage.clear();
}
