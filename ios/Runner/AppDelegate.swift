import UIKit
import Flutter
import Libmtorrentserver
import workmanager_apple
import UniformTypeIdentifiers

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate, UIDocumentPickerDelegate, UIAdaptivePresentationControllerDelegate {
  private let backgroundLibraryUpdateTaskId =
    "com.kodjodevf.mangayomi.background_library_update"
  private var activeBackgroundTasks: [String: UIBackgroundTaskIdentifier] = [:]
  private let localDirectoryBookmarksKey =
    "com.kodjodevf.mangayomi.local_directory_bookmarks"
  private var localDirectoryPickerResult: FlutterResult?
  private weak var localDirectoryPickerController: UIDocumentPickerViewController?
  private var activeSecurityScopedUrls: [String: URL] = [:]
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    WorkmanagerPlugin.registerPeriodicTask(
      withIdentifier: backgroundLibraryUpdateTaskId,
      frequency: NSNumber(value: 15 * 60)
    )
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
