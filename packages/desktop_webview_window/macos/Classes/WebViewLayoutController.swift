//
//  WebViewLayoutController.swift
//  desktop_webView_window
//
//  Created by Bin Yang on 2021/11/18.
//

import Cocoa
import FlutterMacOS
import WebKit

class WebViewLayoutController: NSViewController {
  private lazy var titleBarController: FlutterViewController = {
    let project = FlutterDartProject()
    project.dartEntrypointArguments = ["web_view_title_bar", "\(viewId)", "\(titleBarTopPadding)"]
    return FlutterViewController(project: project)
  }()

  private lazy var webView: WKWebView = {
    WKWebView()
  }()

  private var javaScriptHandlerNames: [String] = []

  weak var webViewPlugin: DesktopWebviewWindowPlugin?

  private var defaultUserAgent: String?

  private let methodChannel: FlutterMethodChannel

  private let viewId: Int64

  private let titleBarHeight: Int

  private let titleBarTopPadding: Int

  public init(methodChannel: FlutterMethodChannel, viewId: Int64, titleBarHeight: Int, titleBarTopPadding: Int) {
    self.viewId = viewId
    self.methodChannel = methodChannel
    self.titleBarHeight = titleBarHeight
    self.titleBarTopPadding = titleBarTopPadding
    super.init(nibName: "WebViewLayoutController", bundle: Bundle(for: WebViewLayoutController.self))
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    super.loadView()

    addChild(titleBarController)
    titleBarController.view.translatesAutoresizingMaskIntoConstraints = false

    // Register titlebar plugins
    ClientMessageChannelPlugin.register(with: titleBarController.registrar(forPlugin: "DesktopWebviewWindowPlugin"))

    let flutterView = titleBarController.view

    flutterView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(flutterView)

    let constraints = [
      flutterView.topAnchor.constraint(equalTo: view.topAnchor),
      flutterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      flutterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      flutterView.heightAnchor.constraint(equalToConstant: CGFloat(titleBarHeight + titleBarTopPadding)),
    ]

    NSLayoutConstraint.activate(constraints)

    view.addSubview(webView)
    webView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      webView.topAnchor.constraint(equalTo: flutterView.bottomAnchor),
      webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    webView.navigationDelegate = self
    webView.uiDelegate = self

    // TODO(boyan01) Make it configuable from flutter.
    webView.configuration.preferences.javaEnabled = true
    webView.configuration.preferences.minimumFontSize = 12
    webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
    webView.configuration.allowsAirPlayForMediaPlayback = true
    webView.configuration.mediaTypesRequiringUserActionForPlayback = .video

    webView.addObserver(self, forKeyPath: "canGoBack", options: .new, context: nil)
    webView.addObserver(self, forKeyPath: "canGoForward", options: .new, context: nil)
    webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)

    defaultUserAgent = webView.value(forKey: "userAgent") as? String
  }

  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "canGoBack" || keyPath == "canGoForward" {
      methodChannel.invokeMethod("onHistoryChanged", arguments: [
        "id": viewId,
        "canGoBack": webView.canGoBack,
        "canGoForward": webView.canGoForward,
      ] as [String: Any])
    } else if keyPath == "loading" {
      if webView.isLoading {
        methodChannel.invokeMethod("onNavigationStarted", arguments: [
          "id": viewId,
        ])
      } else {
        methodChannel.invokeMethod("onNavigationCompleted", arguments: [
          "id": viewId,
        ])
      }
    }
  }

  func load(url: URL) {
    debugPrint("load url: \(url)")
    webView.load(URLRequest(url: url))
  }

  func addJavascriptInterface(name: String) {
    javaScriptHandlerNames.append(name)
    webView.configuration.userContentController.add(self, name: name)
  }

  func removeJavascriptInterface(name: String) {
    if let index = javaScriptHandlerNames.firstIndex(of: name) {
      javaScriptHandlerNames.remove(at: index)
    }
    webView.configuration.userContentController.removeScriptMessageHandler(forName: name)
  }

  func addScriptToExecuteOnDocumentCreated(javaScript: String) {
    webView.configuration.userContentController.addUserScript(
      WKUserScript(source: javaScript, injectionTime: .atDocumentStart, forMainFrameOnly: true))
  }

  func setApplicationNameForUserAgent(applicationName: String) {
    webView.customUserAgent = (defaultUserAgent ?? "") + applicationName
  }

  func destroy() {
    webView.stopLoading(self)
    webView.removeFromSuperview()
    titleBarController.engine.shutDownEngine()
  }

  func reload() {
    webView.reload()
  }

  func goBack() {
    if webView.canGoBack {
      webView.goBack()
    }
  }

  func goForward() {
    if webView.canGoForward {
      webView.goForward()
    }
  }

  func stopLoading() {
    webView.stopLoading()
  }

  func evaluateJavaScript(javaScriptString: String, completer: @escaping FlutterResult) {
    webView.evaluateJavaScript(javaScriptString) { result, error in
      if let error = error {
        completer(FlutterError(code: "1", message: error.localizedDescription, details: nil))
        return
      }
      completer(result)
    }
  }

  deinit {
    #if DEBUG
      print("\(self) deinited")
    #endif
  }
}

extension WebViewLayoutController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    guard let url = navigationAction.request.url else {
      decisionHandler(.cancel)
      return
    }

    guard ["http", "https", "file"].contains(url.scheme?.lowercased() ?? "") else {
      decisionHandler(.cancel)
      return
    }

    methodChannel.invokeMethod("onUrlRequested", arguments: [
      "id": viewId,
      "url": url.absoluteString,
    ] as [String: Any])

    decisionHandler(.allow)
  }

  func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
    decisionHandler(.allow)
  }
}

extension WebViewLayoutController: WKUIDelegate {
  func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
    methodChannel.invokeMethod(
      "runJavaScriptTextInputPanelWithPrompt",
      arguments: [
        "id": viewId,
        "prompt": prompt,
        "defaultText": defaultText ?? "",
      ] as [String: Any]) { result in
        completionHandler((result as? String) ?? "")
      }
  }

  func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
    if !(navigationAction.targetFrame?.isMainFrame ?? false) {
      webView.load(navigationAction.request)
    }
    return nil
  }
}

extension WebViewLayoutController: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    methodChannel.invokeMethod(
      "onJavaScriptMessage",
      arguments: [
        "id": viewId,
        "name": message.name,
        "body": message.body,
      ])
  }
}
