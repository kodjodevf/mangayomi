#if os(iOS)
import Flutter
#else
import FlutterMacOS
#endif
import Foundation

/// Bridges [HTTPInterception] to the app's `DarwinRequestInterceptor`.
public final class RemoteWebViewInterceptorPlugin: NSObject, FlutterPlugin, InterceptionDecider {
    private let channel: FlutterMethodChannel

    private init(channel: FlutterMethodChannel) {
        self.channel = channel
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        #if os(iOS)
        let messenger = registrar.messenger()
        #else
        let messenger = registrar.messenger
        #endif
        let channel = FlutterMethodChannel(name: "mangayomi/remote_webview_interceptor", binaryMessenger: messenger)
        let instance = RemoteWebViewInterceptorPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.publish(instance)
        HTTPInterception.decider = instance
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "install":
            HTTPInterception.decider = self
            result(HTTPInterception.install())
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func shouldInterceptRequest(_ request: [String: Any], completion: @escaping ([String: Any]?) -> Void) {
        channel.invokeMethod("shouldInterceptRequest", arguments: request) { answer in
            // Anything but a response map (no answer, an error, no handler)
            // means the request loads from the network.
            guard var response = answer as? [String: Any] else {
                completion(nil)
                return
            }
            if let body = response["body"] as? FlutterStandardTypedData {
                response["body"] = body.data
            }
            completion(response)
        }
    }
}
