//
//  MessageChannelPlugin.swift
//  desktop_webview_window
//
//  Created by Bin Yang on 2021/11/19.
//

import FlutterMacOS
import Foundation

public class ClientMessageChannelPlugin: NSObject, FlutterPlugin {
  public init(methodChannel: FlutterMethodChannel) {
    self.methodChannel = methodChannel
    super.init()
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "webview_message/client_channel", binaryMessenger: registrar.messenger)
    let instance = ClientMessageChannelPlugin(methodChannel: channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
    ServerMessageChannel.shared.addClient(client: instance)
  }

  private let methodChannel: FlutterMethodChannel

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    ServerMessageChannel.shared.dispatchMethodCall(call: call, from: self)
    // this is a boardcast, so we complete this with sucess.
    result(nil)
  }

  fileprivate func invokeMethod(_ call: FlutterMethodCall) {
    methodChannel.invokeMethod(call.method, arguments: call.arguments)
  }
}

class ServerMessageChannel {
  static let shared: ServerMessageChannel = ServerMessageChannel()

  private var clients: [ClientMessageChannelPlugin] = []

  func addClient(client: ClientMessageChannelPlugin) {
    clients.append(client)
  }

  func removeClient(client: ClientMessageChannelPlugin) {
    if let index = clients.firstIndex(of: client) {
      clients.remove(at: index)
    }
  }

  func dispatchMethodCall(call: FlutterMethodCall, from clientFrom: ClientMessageChannelPlugin) {
    for client in clients {
      if client != clientFrom {
        client.invokeMethod(call)
      }
    }
  }
}
