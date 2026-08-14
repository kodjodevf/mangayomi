import UIKit
import Flutter
import Libmtorrentserver

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// Called once, when the implicit engine is created.
  ///
  /// Everything here used to live in `didFinishLaunchingWithOptions`, which is
  /// the reason Picture in Picture was disabled: PiP opens a second `UIScene`,
  /// that re-entered launch, and re-running plugin registration segfaulted.
  /// This callback fires once per engine rather than once per scene, so a
  /// second scene is now harmless.
  ///
  /// It also removes the `window?.rootViewController as! FlutterViewController`
  /// force-cast the channel used to need. Under `UIScene` the app delegate owns
  /// no window, so that cast would crash outright.
  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let mChannel = FlutterMethodChannel(
      name: "com.kodjodevf.mangayomi.libmtorrentserver",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    mChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      switch call.method {
      case "start":
        let args = call.arguments as? Dictionary<String, Any>
        let config = args?["config"] as? String
        var error: NSError?
        let mPort = UnsafeMutablePointer<Int>.allocate(capacity: MemoryLayout<Int>.stride)
        if LibmtorrentserverStart(config, mPort, &error) {
          result(mPort.pointee)
        } else {
          result(FlutterError(code: "ERROR", message: error.debugDescription, details: nil))
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    })
  }
}

// Deep links are no longer opened from here. app_links conforms to
// FlutterSceneLifeCycleDelegate and FlutterSceneDelegate forwards
// scene:willConnectToSession:options: to it, so it picks up both cold-start and
// warm links itself. The old AppLinks.shared.getLink(launchOptions:) block read
// launch options that UIScene never populates.
