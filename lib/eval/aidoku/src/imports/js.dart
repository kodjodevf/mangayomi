import 'package:wasd/wasd.dart';

import '../interpreter/memory_helper.dart';
import '../postcard/postcard_writer.dart';
import '../store/global_store.dart';

class JsImports {
  JsImports({
    required this.store,
    required this.memoryHelper,
    required this.webViewNamespace,
    this.printHandler,
  });

  final GlobalStore store;
  final MemoryHelper memoryHelper;
  final String webViewNamespace;
  final void Function(String message)? printHandler;

  static const namespace = 'js';

  ModuleImports build() {
    return {
      'context_create': ImportExportKind.function((args) => store.store('js_context')),
      'context_eval': ImportExportKind.function((args) {
        return -1; // missingResult
      }),
      'context_eval_async': ImportExportKind.function((args) {
        return -1;
      }),
      'context_get': ImportExportKind.function((args) {
        return -1;
      }),
      'webview_create': ImportExportKind.function((args) => store.store('webview_handler')),
      'webview_set_rule_list': ImportExportKind.function((args) => 0),
      'webview_load': ImportExportKind.function((args) => 0),
      'webview_load_html': ImportExportKind.function((args) => 0),
      'webview_wait_for_load': ImportExportKind.function((args) => 0),
      'webview_eval': ImportExportKind.function((args) => -1),
      'webview_eval_async': ImportExportKind.function((args) => -1),
      'webview_add_user_script': ImportExportKind.function((args) => 0),
      'webview_get_cookies': ImportExportKind.function((args) {
        final writer = PostcardWriter();
        writer.writeList<void>([], (w, _) {});
        return store.store(writer.toBytes());
      }),
      'webview_delete_cookie': ImportExportKind.function((args) => 0),
    };
  }
}
