import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/extension/providers/extension_preferences_providers.dart';

class JsPreferences {
  late JavascriptRuntime runtime;
  late Source? source;
  JsPreferences(this.runtime, this.source);

  init() {
    runtime.onMessage('get', (dynamic args)  {
      return  getPreferenceValue(source!.id!, args[0]);
    });
    runtime.onMessage('getString', (dynamic args)  {
      return getSourcePreferenceStringValue(source!.id!, args[0], args[1]);
    });
    runtime.onMessage('setString', (dynamic args)  {
      return setSourcePreferenceStringValue(source!.id!, args[0], args[1]);
    });

    runtime.evaluate('''
class SharedPreferences {
    get(key) {
        return sendMessage(
            "get",
            JSON.stringify([key])
        );
    }
    getString(key, defaultValue) {
        return sendMessage(
            "getString",
            JSON.stringify([key, defaultValue])
        );
    }
    setString(key, defaultValue) {
        return sendMessage(
            "setString",
            JSON.stringify([key, defaultValue])
        );
    }
}
''');
  }
}
