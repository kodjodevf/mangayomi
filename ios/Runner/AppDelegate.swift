import UIKit
import Flutter
import Libmtorrentserver
import app_links

@main
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
                      var error: NSError?
                      let mPort = UnsafeMutablePointer<Int>.allocate(capacity: MemoryLayout<Int>.stride)
                      if LibmtorrentserverStart(config, mPort, &error){
                          result(mPort.pointee)
                      }else{
                          result(FlutterError(code: "ERROR", message: error.debugDescription, details: nil))
                      }
                  default:
                      result(FlutterMethodNotImplemented)
                  }
              })

    GeneratedPluginRegistrant.register(with: self)

    if let url = AppLinks.shared.getLink(launchOptions: launchOptions) {
      AppLinks.shared.handleLink(url: url)
      return true
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
