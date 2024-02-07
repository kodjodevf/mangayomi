//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <desktop_webview_window/desktop_webview_window_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) desktop_webview_window_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "DesktopWebviewWindowPlugin");
  desktop_webview_window_plugin_register_with_registrar(desktop_webview_window_registrar);
}
