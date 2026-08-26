import 'package:mangayomi/src/rust/api/aidoku_wasm.dart' as rust;

import '../util/logger.dart';

/// Key-value storage for source-specific defaults and preferences.
class SettingsStore {
  SettingsStore._();
  static final SettingsStore shared = SettingsStore._();

  final Map<String, Object?> _storage = {};

  Object? object(String key) {
    final value = _storage[key];
    AidokuLogger.debug('SettingsStore', 'object: key="$key" -> $value');
    return value;
  }

  void setValue(String key, Object? value) {
    if (value == null) {
      _storage.remove(key);
      AidokuLogger.debug('SettingsStore', 'setValue: removed key="$key"');
      try {
        rust.setAidokuDefaultSetting(key: key, valueType: 0, value: '');
      } catch (_) {}
    } else {
      _storage[key] = value;
      AidokuLogger.debug('SettingsStore', 'setValue: key="$key" = $value');
      try {
        if (value is bool) {
          rust.setAidokuDefaultSetting(
            key: key,
            valueType: 1,
            value: value.toString(),
          );
        } else if (value is int) {
          rust.setAidokuDefaultSetting(
            key: key,
            valueType: 2,
            value: value.toString(),
          );
        } else if (value is double) {
          rust.setAidokuDefaultSetting(
            key: key,
            valueType: 3,
            value: value.toString(),
          );
        } else if (value is String) {
          rust.setAidokuDefaultSetting(key: key, valueType: 4, value: value);
        } else if (value is List) {
          rust.setAidokuDefaultSetting(
            key: key,
            valueType: 5,
            value: value.toString(),
          );
        }
      } catch (_) {}
    }
  }

  void clear() {
    AidokuLogger.debug('SettingsStore', 'clear: clearing all settings');
    _storage.clear();
  }
}

