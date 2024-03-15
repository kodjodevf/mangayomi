import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/extension/providers/extension_preferences_providers.dart';

class JsPreferences {
  late JavascriptRuntime runtime;
  late Source? source;
  JsPreferences(this.runtime, this.source);

  init() {
    runtime.onMessage('getPreferenceValue', (dynamic args)  {
      return  getPreferenceValue(source!.id!, args[0]);
    });
    runtime.onMessage('getPrefStringValue', (dynamic args)  {
      return getSourcePreferenceStringValue(source!.id!, args[0], args[1]);
    });
    runtime.onMessage('setPrefStringValue', (dynamic args)  {
      return setSourcePreferenceStringValue(source!.id!, args[0], args[1]);
    });

    runtime.evaluate('''
async function getPreferenceValue(key) {
    const result = await sendMessage(
        "getPreferenceValue",
        JSON.stringify([key])
    );
    return result;
}
async function getPrefStringValue(key,defaultValue) {
    const result = await sendMessage(
        "getPrefStringValue",
        JSON.stringify([key,defaultValue])
    );
    return result;
}
async function setPrefStringValue(key,defaultValue) {
    const result = await sendMessage(
        "setPrefStringValue",
        JSON.stringify([key,defaultValue])
    );
    return result;
}
''');
  }
}
