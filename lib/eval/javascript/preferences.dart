import 'package:js_interpreter/js_interpreter.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/extension/providers/extension_preferences_providers.dart';

class JsPreferences {
  late JSInterpreter runtime;
  late Source? source;
  JsPreferences(this.runtime, this.source);

  void init() {
    runtime.onMessage('get', (dynamic args) {
      return getPreferenceValue(source!.id!, args[0]);
    });
    runtime.onMessage('getString', (dynamic args) {
      return getSourcePreferenceStringValue(source!.id!, args[0], args[1]);
    });
    runtime.onMessage('setString', (dynamic args) {
      return setSourcePreferenceStringValue(source!.id!, args[0], args[1]);
    });

    runtime.eval('''
class SharedPreferences {
    get(key) {
        return sendMessage(
            "get",
            key
        );
    }
    getString(key, defaultValue) {
        return sendMessage(
            "getString",
            key, defaultValue
        );
    }
    setString(key, defaultValue) {
        return sendMessage(
            "setString",
            key, defaultValue
        );
    }
}
''');
  }
}
