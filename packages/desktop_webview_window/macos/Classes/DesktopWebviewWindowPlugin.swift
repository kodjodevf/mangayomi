import Cocoa
import FlutterMacOS
import WebKit

private var viewId: Int64 = 0

public class DesktopWebviewWindowPlugin: NSObject, FlutterPlugin {
  private let methodChannel: FlutterMethodChannel

  private var webviews: [Int64: WebviewWindowController] = [:]

  public init(methodChannel: FlutterMethodChannel) {
    self.methodChannel = methodChannel
    super.init()
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "webview_window", binaryMessenger: registrar.messenger)
    let instance = DesktopWebviewWindowPlugin(methodChannel: channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
    ClientMessageChannelPlugin.register(with: registrar)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "create":
      guard let argument = call.arguments as? [String: Any?] else {
        result(FlutterError(code: "0", message: "arg is not map", details: nil))
        return
      }
      let width = argument["windowWidth"] as? Int ?? 1280
      let height = argument["windowHeight"] as? Int ?? 720
      let title = argument["title"] as? String ?? ""
      let titleBarHeight = argument["titleBarHeight"] as? Int ?? 50
      let titleBarTopPadding = argument["titleBarTopPadding"] as? Int ?? 0

      let controller = WebviewWindowController(
        viewId: viewId, methodChannel: methodChannel,
        width: width, height: height, title: title,
        titleBarHeight: titleBarHeight, titleBarTopPadding: titleBarTopPadding
      )
      controller.webviewPlugin = self
      webviews[viewId] = controller
      controller.showWindow(nil)
      result(viewId)
      viewId += 1
      break
    case "launch":
      guard let argument = call.arguments as? [String: Any?] else {
        result(FlutterError(code: "0", message: "arg is not map", details: nil))
        return
      }

      guard let viewId = argument["viewId"] as? Int64 else {
        result(FlutterError(code: "0", message: "param viewId not found", details: nil))
        return
      }

      guard let url = argument["url"] as? String else {
        result(FlutterError(code: "0", message: "param url not found", details: nil))
        return
      }

      guard let parsedUrl = URL(string: url) else {
        result(FlutterError(code: "0", message: "failed to parse \(url)", details: nil))
        return
      }

      guard let wc = webviews[viewId] else {
        result(FlutterError(code: "0", message: "can not find webview for id: \(viewId)", details: nil))
        return
      }
      wc.webViewController.load(url: parsedUrl)
      result(nil)
      break
    case "registerJavaScripInterface":
      guard let argument = call.arguments as? [String: Any?] else {
        result(FlutterError(code: "0", message: "arg is not map", details: nil))
        return
      }
      guard let viewId = argument["viewId"] as? Int64 else {
        result(FlutterError(code: "0", message: "param viewId not found", details: nil))
        return
      }
      guard let name = argument["name"] as? String else {
        result(FlutterError(code: "0", message: "param name not found", details: nil))
        return
      }
      guard let wc = webviews[viewId] else {
        result(FlutterError(code: "0", message: "can not find webview for id: \(viewId)", details: nil))
        return
      }
      wc.webViewController.addJavascriptInterface(name: name)
      result(nil)
      break
    case "unregisterJavaScripInterface":
      guard let argument = call.arguments as? [String: Any?] else {
        result(FlutterError(code: "0", message: "arg is not map", details: nil))
        return
      }
      guard let viewId = argument["viewId"] as? Int64 else {
        result(FlutterError(code: "0", message: "param viewId not found", details: nil))
        return
      }
      guard let name = argument["name"] as? String else {
        result(FlutterError(code: "0", message: "param name not found", details: nil))
        return
      }
      guard let wc = webviews[viewId] else {
        result(FlutterError(code: "0", message: "can not find webview for id: \(viewId)", details: nil))
        return
      }
      wc.webViewController.addJavascriptInterface(name: name)
      result(nil)
      break
    case "clearAll":
      WKWebsiteDataStore.default().removeData(
        ofTypes: [WKWebsiteDataTypeCookies, WKWebsiteDataTypeLocalStorage],
        modifiedSince: .distantPast,
        completionHandler: {
          result(nil)
        })
      break
    case "setBrightness":
      guard let argument = call.arguments as? [String: Any?] else {
        result(FlutterError(code: "0", message: "arg is not map", details: nil))
        return
      }
      guard let viewId = argument["viewId"] as? Int64 else {
        result(FlutterError(code: "0", message: "param viewId not found", details: nil))
        return
      }
      guard let wc = webviews[viewId] else {
        result(FlutterError(code: "0", message: "can not find webview for id: \(viewId)", details: nil))
        return
      }
      let brightness = argument["brightness"] as? Int ?? -1
      wc.setAppearance(brightness: brightness)
      result(nil)
      break
    case "addScriptToExecuteOnDocumentCreated":
      guard let argument = call.arguments as? [String: Any?] else {
        result(FlutterError(code: "0", message: "arg is not map", details: nil))
        return
      }
      guard let viewId = argument["viewId"] as? Int64 else {
        result(FlutterError(code: "0", message: "param viewId not found", details: nil))
        return
      }
      guard let wc = webviews[viewId] else {
        result(FlutterError(code: "0", message: "can not find webview for id: \(viewId)", details: nil))
        return
      }
      guard let javaScript = argument["javaScript"] as? String else {
        result(FlutterError(code: "0", message: "param javaScript not found", details: nil))
        return
      }
      wc.webViewController.addScriptToExecuteOnDocumentCreated(javaScript: javaScript)
      result(nil)
      break
    case "setApplicationNameForUserAgent":
      guard let argument = call.arguments as? [String: Any?] else {
        result(FlutterError(code: "0", message: "arg is not map", details: nil))
        return
      }
      guard let viewId = argument["viewId"] as? Int64 else {
        result(FlutterError(code: "0", message: "param viewId not found", details: nil))
        return
      }
      guard let wc = webviews[viewId] else {
        result(FlutterError(code: "0", message: "can not find webview for id: \(viewId)", details: nil))
        return
      }
      guard let applicationName = argument["applicationName"] as? String else {
        result(FlutterError(code: "0", message: "param applicationName not found", details: nil))
        return
      }
      wc.webViewController.setApplicationNameForUserAgent(applicationName: applicationName)
      result(nil)
      break
    case "back":
      guard let argument = call.arguments as? [String: Any?] else {
        result(FlutterError(code: "0", message: "arg is not map", details: nil))
        return
      }
      guard let viewId = argument["viewId"] as? Int64 else {
        result(FlutterError(code: "0", message: "param viewId not found", details: nil))
        return
      }
      guard let wc = webviews[viewId] else {
        result(FlutterError(code: "0", message: "can not find webview for id: \(viewId)", details: nil))
        return
      }
      wc.webViewController.goBack()
      break
    case "forward":
      guard let argument = call.arguments as? [String: Any?] else {
        result(FlutterError(code: "0", message: "arg is not map", details: nil))
        return
      }
      guard let viewId = argument["viewId"] as? Int64 else {
        result(FlutterError(code: "0", message: "param viewId not found", details: nil))
        return
      }
      guard let wc = webviews[viewId] else {
        result(FlutterError(code: "0", message: "can not find webview for id: \(viewId)", details: nil))
        return
      }
      wc.webViewController.goForward()
      break
    case "reload":
      guard let argument = call.arguments as? [String: Any?] else {
        result(FlutterError(code: "0", message: "arg is not map", details: nil))
        return
      }
      guard let viewId = argument["viewId"] as? Int64 else {
        result(FlutterError(code: "0", message: "param viewId not found", details: nil))
        return
      }
      guard let wc = webviews[viewId] else {
        result(FlutterError(code: "0", message: "can not find webview for id: \(viewId)", details: nil))
        return
      }
      wc.webViewController.reload()
      break
    case "stop":
      guard let argument = call.arguments as? [String: Any?] else {
        result(FlutterError(code: "0", message: "arg is not map", details: nil))
        return
      }
      guard let viewId = argument["viewId"] as? Int64 else {
        result(FlutterError(code: "0", message: "param viewId not found", details: nil))
        return
      }
      guard let wc = webviews[viewId] else {
        result(FlutterError(code: "0", message: "can not find webview for id: \(viewId)", details: nil))
        return
      }
      wc.webViewController.stopLoading()
      break
    case "close":
      guard let argument = call.arguments as? [String: Any?] else {
        result(FlutterError(code: "0", message: "arg is not map", details: nil))
        return
      }
      guard let viewId = argument["viewId"] as? Int64 else {
        result(FlutterError(code: "0", message: "param viewId not found", details: nil))
        return
      }
      guard let wc = webviews[viewId] else {
        result(FlutterError(code: "0", message: "can not find webview for id: \(viewId)", details: nil))
        return
      }
      wc.close()
      break
    case "evaluateJavaScript":
      guard let argument = call.arguments as? [String: Any?] else {
        result(FlutterError(code: "0", message: "arg is not map", details: nil))
        return
      }
      guard let viewId = argument["viewId"] as? Int64 else {
        result(FlutterError(code: "0", message: "param viewId not found", details: nil))
        return
      }
      guard let wc = webviews[viewId] else {
        result(FlutterError(code: "0", message: "can not find webview for id: \(viewId)", details: nil))
        return
      }
      guard let js = argument["javaScriptString"] as? String else {
        result(FlutterError(code: "0", message: "param javaScriptString not found", details: nil))
        return
      }
      wc.webViewController.evaluateJavaScript(javaScriptString: js, completer: result)
      break
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  func onWebviewWindowClose(viewId: Int64, wc: WebviewWindowController) {
    webviews.removeValue(forKey: viewId)
  }
}
