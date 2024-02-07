//
// Created by boyan on 11/23/21.
//


#include "message_channel_plugin.h"

#include <set>

#include "glib.h"

namespace {

class ClientMessageChannelPlugin {

 public:
  explicit ClientMessageChannelPlugin(FlMethodChannel *channel);

  void DispatchMethodCall(FlMethodCall *call) {
    auto *name = fl_method_call_get_name(call);
    auto *args = fl_method_call_get_args(call);
    fl_method_channel_invoke_method(channel_, name, args, nullptr, nullptr, nullptr);
  }

  ~ClientMessageChannelPlugin();

 private:
  FlMethodChannel *channel_;
};

class ServerMessageChannelPlugin {

 public:

  void AddClient(ClientMessageChannelPlugin *client) {
    clients_.insert(client);
  }

  void RemoveClient(ClientMessageChannelPlugin *client) {
    clients_.erase(client);
  }

  void DispatchMethodCall(FlMethodCall *call, ClientMessageChannelPlugin *client_from) {
    for (auto client: clients_) {
      if (client != client_from) {
        client->DispatchMethodCall(call);
      }
    }
  }

 private:
  std::set<ClientMessageChannelPlugin *> clients_;

};

ServerMessageChannelPlugin *g_server_message_channel_plugin = nullptr;

ClientMessageChannelPlugin::ClientMessageChannelPlugin(FlMethodChannel *channel) : channel_(channel) {
  g_object_ref(channel_);
  g_server_message_channel_plugin->AddClient(this);
}

ClientMessageChannelPlugin::~ClientMessageChannelPlugin() {
  g_object_unref(channel_);
  g_server_message_channel_plugin->RemoveClient(this);
}

void client_plugin_proxy_dispatch_method_call(FlMethodChannel *channel, FlMethodCall *call, gpointer user_data) {
  auto *client = static_cast<ClientMessageChannelPlugin *>(user_data);
  g_assert(g_server_message_channel_plugin);
  g_server_message_channel_plugin->DispatchMethodCall(call, client);
  fl_method_call_respond_success(call, nullptr, nullptr);
}

}

void client_message_channel_plugin_register_with_registrar(FlPluginRegistrar *registrar) {
  if (!g_server_message_channel_plugin) {
    g_server_message_channel_plugin = new ServerMessageChannelPlugin();
  }
  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  FlMethodChannel *channel = fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                                                   "webview_message/client_channel",
                                                   FL_METHOD_CODEC(codec));
  auto *client_message_channel_plugin = new ClientMessageChannelPlugin(channel);
  fl_method_channel_set_method_call_handler(channel,
                                            client_plugin_proxy_dispatch_method_call,
                                            client_message_channel_plugin,
                                            [](gpointer pointer) {
                                              delete static_cast<ClientMessageChannelPlugin *>(pointer);
                                            });
}
