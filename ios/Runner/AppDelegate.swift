import UIKit
import Flutter
import Libmtorrentserver

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let mChannel = FlutterMethodChannel(name: "com.kodjodevf.mangayomi.libmtorrentserver", binaryMessenger: controller.binaryMessenger)
              mChannel.setMethodCallHandler({
                  (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                  switch call.method {
                  case "start":
                      let args = call.arguments as? Dictionary<String, Any>
                      let config = args?["config"] as? String
                      LibmtorrentserverStart(config)
                  default:
                      result(FlutterMethodNotImplemented)
                  }
              })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
