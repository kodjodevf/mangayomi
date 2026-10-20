import UIKit
import Flutter
import AVFoundation
import MediaPlayer
import Libmtorrentserver
import UniformTypeIdentifiers

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate, UIDocumentPickerDelegate, UIAdaptivePresentationControllerDelegate {
  private var activeBackgroundTasks: [String: UIBackgroundTaskIdentifier] = [:]
  private let localDirectoryBookmarksKey =
    "com.kodjodevf.mangayomi.local_directory_bookmarks"
  private var localDirectoryPickerResult: FlutterResult?
  private weak var localDirectoryPickerController: UIDocumentPickerViewController?
  private var activeSecurityScopedUrls: [String: URL] = [:]
  // The reader's volume-button page turns (VolumeKeys on the Dart side).
  // iOS cannot take the buttons, so the volume is watched and set back to
  // half after each press; it is given back as it was when they are let go.
  private var volumeKeysChannel: FlutterMethodChannel?
  private var volumeObservation: NSKeyValueObservation?
  private var volumeView: MPVolumeView?
  private var volumeBeforeReading: Float = 0.5
  private var audioCategoryBeforeReading: AVAudioSession.Category?
  private var audioModeBeforeReading: AVAudioSession.Mode = .default
  private var audioOptionsBeforeReading: AVAudioSession.CategoryOptions = []
  private var settingVolume = false
  // The screen's brightness before a reader set its own, given back on
  // "reset".
  private var brightnessBeforeReading: CGFloat?
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let messenger = engineBridge.applicationRegistrar.messenger()

    let mChannel = FlutterMethodChannel(
      name: "com.kodjodevf.mangayomi.libmtorrentserver",
      binaryMessenger: messenger
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

    let backgroundTaskChannel = FlutterMethodChannel(
      name: "com.kodjodevf.mangayomi.background_task",
      binaryMessenger: messenger
    )
    backgroundTaskChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      switch call.method {
      case "begin":
        let args = call.arguments as? Dictionary<String, Any>
        let name = args?["name"] as? String ?? "Mangayomi background task"
        let identifier = UUID().uuidString
        var task: UIBackgroundTaskIdentifier = .invalid
        task = UIApplication.shared.beginBackgroundTask(withName: name) {
          if task != .invalid {
            UIApplication.shared.endBackgroundTask(task)
          }
          self?.activeBackgroundTasks.removeValue(forKey: identifier)
        }
        if task == .invalid {
          result(nil)
        } else {
          self?.activeBackgroundTasks[identifier] = task
          result(identifier)
        }
      case "end":
        let args = call.arguments as? Dictionary<String, Any>
        guard let identifier = args?["identifier"] as? String,
              let task = self?.activeBackgroundTasks.removeValue(forKey: identifier) else {
          result(nil)
          return
        }
        UIApplication.shared.endBackgroundTask(task)
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    })

    let volumeChannel = FlutterMethodChannel(
      name: "com.kodjodevf.mangayomi.volume_keys",
      binaryMessenger: messenger
    )
    volumeKeysChannel = volumeChannel
    volumeChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      switch call.method {
      case "enable":
        self?.enableVolumeKeys()
        result(nil)
      case "disable":
        self?.disableVolumeKeys()
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    })

    let brightnessChannel = FlutterMethodChannel(
      name: "com.kodjodevf.mangayomi.screen_brightness",
      binaryMessenger: messenger
    )
    brightnessChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      guard let self else { return result(nil) }
      switch call.method {
      case "set":
        if let value = call.arguments as? Double {
          if self.brightnessBeforeReading == nil {
            self.brightnessBeforeReading = UIScreen.main.brightness
          }
          UIScreen.main.brightness = CGFloat(min(max(value, 0.01), 1))
        }
        result(nil)
      case "get":
        result(Double(UIScreen.main.brightness))
      case "reset":
        if let before = self.brightnessBeforeReading {
          UIScreen.main.brightness = before
          self.brightnessBeforeReading = nil
        }
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    })

    let localDirectoryChannel = FlutterMethodChannel(
      name: "com.kodjodevf.mangayomi.local_directory_access",
      binaryMessenger: messenger
    )
    localDirectoryChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      switch call.method {
      case "pickDirectory":
        self?.pickLocalDirectory(result: result)
      case "listDirectory":
        guard let args = call.arguments as? Dictionary<String, Any>,
              let path = args["path"] as? String else {
          result(FlutterError(code: "invalid_args", message: "Missing path", details: nil))
          return
        }
        result(self?.listLocalDirectory(path: path) ?? [])
      default:
        result(FlutterMethodNotImplemented)
      }
    })
  }

  private func enableVolumeKeys() {
    guard volumeObservation == nil else { return }
    let session = AVAudioSession.sharedInstance()
    // outputVolume only reports changes while the session is active. Ambient
    // and mixing, so nothing another app is playing is interrupted; the
    // session as it was is put back when the buttons are let go, so the
    // video player keeps its own.
    audioCategoryBeforeReading = session.category
    audioModeBeforeReading = session.mode
    audioOptionsBeforeReading = session.categoryOptions
    try? session.setCategory(.ambient, options: [.mixWithOthers])
    try? session.setActive(true)
    volumeBeforeReading = session.outputVolume

    // Off screen and nearly transparent: present, so the system shows no
    // volume panel, and its slider is how the volume is set back.
    let view = MPVolumeView(frame: CGRect(x: -2000, y: -2000, width: 1, height: 1))
    view.alpha = 0.01
    keyWindow()?.addSubview(view)
    volumeView = view

    // Half, so a press either way changes it.
    setSystemVolume(0.5)
    volumeObservation = session.observe(\.outputVolume, options: [.old, .new]) {
      [weak self] _, change in
      guard let self, !self.settingVolume,
            let new = change.newValue, let old = change.oldValue, new != old else { return }
      DispatchQueue.main.async {
        self.volumeKeysChannel?.invokeMethod("press", arguments: new > old ? "up" : "down")
        self.setSystemVolume(0.5)
      }
    }
  }

  private func disableVolumeKeys() {
    guard volumeObservation != nil else { return }
    volumeObservation?.invalidate()
    volumeObservation = nil
    setSystemVolume(volumeBeforeReading)
    if let category = audioCategoryBeforeReading {
      try? AVAudioSession.sharedInstance().setCategory(
        category, mode: audioModeBeforeReading, options: audioOptionsBeforeReading)
      audioCategoryBeforeReading = nil
    }
    // Let the slider apply the volume before the view goes.
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
      self?.volumeView?.removeFromSuperview()
      self?.volumeView = nil
    }
  }

  /// Sets the system volume through the hidden volume view's slider; the
  /// change it causes is not taken for a press.
  private func setSystemVolume(_ value: Float) {
    guard let slider = volumeView?.subviews.compactMap({ $0 as? UISlider }).first else { return }
    settingVolume = true
    DispatchQueue.main.async {
      slider.value = value
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
        self?.settingVolume = false
      }
    }
  }

  private func keyWindow() -> UIWindow? {
    return UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap(\.windows)
      .first(where: \.isKeyWindow)
  }

  private func pickLocalDirectory(result: @escaping FlutterResult) {
    if localDirectoryPickerResult != nil {
      result(FlutterError(code: "multiple_request", message: "A directory picker is already open", details: nil))
      return
    }

    localDirectoryPickerResult = result
    let picker: UIDocumentPickerViewController
    if #available(iOS 14.0, *) {
      picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.folder], asCopy: false)
    } else {
      picker = UIDocumentPickerViewController(documentTypes: ["public.folder"], in: .open)
    }
    picker.allowsMultipleSelection = false
    picker.delegate = self
    picker.presentationController?.delegate = self
    localDirectoryPickerController = picker
    let rootController = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap(\.windows)
      .first(where: \.isKeyWindow)?
      .rootViewController
    guard let rootController else {
      localDirectoryPickerResult = nil
      localDirectoryPickerController = nil
      result(FlutterError(
        code: "presentation_failed",
        message: "No active iOS window is available",
        details: nil
      ))
      return
    }
    rootController.present(picker, animated: true)
  }

  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    guard controller === localDirectoryPickerController else { return }
    defer {
      localDirectoryPickerController = nil
      localDirectoryPickerResult = nil
    }
    guard let result = localDirectoryPickerResult,
          let url = urls.first else {
      localDirectoryPickerResult?(nil)
      return
    }
    result(registerSecurityScopedDirectory(url: url))
  }

  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    guard controller === localDirectoryPickerController else { return }
    localDirectoryPickerResult?(nil)
    localDirectoryPickerController = nil
    localDirectoryPickerResult = nil
  }

  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    localDirectoryPickerResult?(nil)
    localDirectoryPickerController = nil
    localDirectoryPickerResult = nil
  }

  private func registerSecurityScopedDirectory(url: URL) -> Any {
    let accessed = url.startAccessingSecurityScopedResource()
    var isDirectory: ObjCBool = false
    guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory),
          isDirectory.boolValue else {
      if accessed {
        url.stopAccessingSecurityScopedResource()
      }
      return FlutterError(code: "not_directory", message: "The selected item is not a directory", details: url.path)
    }

    activeSecurityScopedUrls[url.standardizedFileURL.path] = url
    if !accessed {
      NSLog("[LocalDirectoryAccess] selected directory did not grant security scope path=%@", url.path)
    }

    do {
      let bookmark = try url.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil)
      var bookmarks = localDirectoryBookmarks()
      bookmarks[url.standardizedFileURL.path] = bookmark
      UserDefaults.standard.set(bookmarks, forKey: localDirectoryBookmarksKey)
    } catch {
      NSLog("[LocalDirectoryAccess] bookmark save failed path=%@ error=%@", url.path, error.localizedDescription)
    }
    return url.path
  }

  private func listLocalDirectory(path: String) -> [[String: String]] {
    let access = securityScopedUrl(for: path)
    let url = access.url
    let accessed = url.startAccessingSecurityScopedResource()
    defer {
      if accessed && !access.keepAccessing {
        url.stopAccessingSecurityScopedResource()
      }
    }

    do {
      let children = try FileManager.default.contentsOfDirectory(
        at: url,
        includingPropertiesForKeys: [.isDirectoryKey, .isRegularFileKey],
        options: []
      )
      return children.map { child in
        var type = "other"
        if let values = try? child.resourceValues(forKeys: [.isDirectoryKey, .isRegularFileKey]) {
          if values.isDirectory == true {
            type = "directory"
          } else if values.isRegularFile == true {
            type = "file"
          }
        }
        return ["path": child.path, "type": type]
      }
    } catch {
      NSLog("[LocalDirectoryAccess] list failed path=%@ resolved=%@ error=%@", path, url.path, error.localizedDescription)
      return []
    }
  }

  private func securityScopedUrl(for path: String) -> (url: URL, keepAccessing: Bool) {
    let normalizedPath = URL(fileURLWithPath: path).standardizedFileURL.path
    if let key = longestMatchingPrefix(normalizedPath, in: activeSecurityScopedUrls.keys),
       let rootUrl = activeSecurityScopedUrls[key] {
      return (appendSuffix(from: key, to: normalizedPath, rootUrl: rootUrl), true)
    }

    let bookmarks = localDirectoryBookmarks()
    if let key = longestMatchingPrefix(normalizedPath, in: bookmarks.keys),
       let bookmark = bookmarks[key],
       let rootUrl = resolveBookmark(bookmark) {
      activeSecurityScopedUrls[key] = rootUrl
      return (appendSuffix(from: key, to: normalizedPath, rootUrl: rootUrl), true)
    }

    return (URL(fileURLWithPath: path), false)
  }

  private func appendSuffix(from rootPath: String, to path: String, rootUrl: URL) -> URL {
    guard path != rootPath else { return rootUrl }
    let suffix = path.dropFirst(rootPath.count).trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    guard !suffix.isEmpty else { return rootUrl }
    return rootUrl.appendingPathComponent(suffix)
  }

  private func longestMatchingPrefix(_ path: String, in keys: Dictionary<String, URL>.Keys) -> String? {
    return keys.filter { path == $0 || path.hasPrefix($0 + "/") }.max { $0.count < $1.count }
  }

  private func longestMatchingPrefix(_ path: String, in keys: Dictionary<String, Data>.Keys) -> String? {
    return keys.filter { path == $0 || path.hasPrefix($0 + "/") }.max { $0.count < $1.count }
  }

  private func resolveBookmark(_ data: Data) -> URL? {
    var stale = false
    do {
      let url = try URL(
        resolvingBookmarkData: data,
        options: [],
        relativeTo: nil,
        bookmarkDataIsStale: &stale
      )
      if stale {
        NSLog("[LocalDirectoryAccess] bookmark is stale path=%@", url.path)
      }
      return url
    } catch {
      NSLog("[LocalDirectoryAccess] bookmark resolve failed: %@", error.localizedDescription)
      return nil
    }
  }

  private func localDirectoryBookmarks() -> [String: Data] {
    return UserDefaults.standard.dictionary(forKey: localDirectoryBookmarksKey) as? [String: Data] ?? [:]
  }
}

// Deep links are no longer opened from here. app_links conforms to
// FlutterSceneLifeCycleDelegate and FlutterSceneDelegate forwards
// scene:willConnectToSession:options: to it, so it picks up both cold-start and
// warm links itself. The old AppLinks.shared.getLink(launchOptions:) block read
// launch options that UIScene never populates.
