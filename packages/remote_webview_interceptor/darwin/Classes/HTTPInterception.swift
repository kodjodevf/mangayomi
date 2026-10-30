import Foundation
import ObjectiveC
import WebKit

/// Answers whether the app wants to serve a request itself.
///
/// `completion` receives the response to serve (`statusCode`, `reasonPhrase`,
/// `headers`, `mimeType`, `encoding`, `body` as `Data`), or nil to load the
/// request from the network. It must be called on the main thread.
protocol InterceptionDecider: AnyObject {
    func shouldInterceptRequest(
        _ request: [String: Any],
        completion: @escaping ([String: Any]?) -> Void
    )
}

/// Gives WKWebView a `shouldInterceptRequest`.
///
/// WKWebView refuses a `WKURLSchemeHandler` for http and https because
/// `+[WKWebView handlesURLScheme:]` says it handles them itself. While a
/// handler is being registered for a WebView that asked for interception, that
/// answer is turned off, so the handler is accepted and receives every http(s)
/// request of that WebView — and of no other.
///
/// A WebView asks by registering a handler for a scheme named
/// `mangayomi-intercept-<session>`, which the app does through the
/// `resourceCustomSchemes` setting of flutter_inappwebview.
enum HTTPInterception {
    static let markerPrefix = "mangayomi-intercept-"

    static weak var decider: InterceptionDecider?

    /// True while our own http/https handlers are being registered.
    fileprivate static var registeringHTTPHandlers = false

    private static var installed: Bool?

    /// Installs the hooks once; false when this WebKit does not allow it.
    static func install() -> Bool {
        if let installed { return installed }
        let result =
            exchange(
                WKWebView.self,
                #selector(WKWebView.handlesURLScheme(_:)),
                #selector(WKWebView.mangayomi_handlesURLScheme(_:)),
                classMethod: true
            )
            && exchange(
                WKWebViewConfiguration.self,
                #selector(WKWebViewConfiguration.setURLSchemeHandler(_:forURLScheme:)),
                #selector(WKWebViewConfiguration.mangayomi_setURLSchemeHandler(_:forURLScheme:)),
                classMethod: false
            )
        installed = result
        return result
    }

    private static func exchange(
        _ type: AnyClass,
        _ original: Selector,
        _ replacement: Selector,
        classMethod: Bool
    ) -> Bool {
        let lookup = classMethod ? class_getClassMethod : class_getInstanceMethod
        guard let originalMethod = lookup(type, original),
              let replacementMethod = lookup(type, replacement)
        else { return false }
        method_exchangeImplementations(originalMethod, replacementMethod)
        return true
    }
}

extension WKWebView {
    @objc fileprivate class func mangayomi_handlesURLScheme(_ urlScheme: String) -> Bool {
        if HTTPInterception.registeringHTTPHandlers {
            let scheme = urlScheme.lowercased()
            if scheme == "http" || scheme == "https" { return false }
        }
        // Implementations are exchanged: this calls WebKit's own.
        return mangayomi_handlesURLScheme(urlScheme)
    }
}

extension WKWebViewConfiguration {
    @objc fileprivate func mangayomi_setURLSchemeHandler(
        _ urlSchemeHandler: WKURLSchemeHandler?,
        forURLScheme urlScheme: String
    ) {
        // Implementations are exchanged: this calls WebKit's own.
        mangayomi_setURLSchemeHandler(urlSchemeHandler, forURLScheme: urlScheme)

        guard urlScheme.hasPrefix(HTTPInterception.markerPrefix) else { return }
        let sessionId = String(urlScheme.dropFirst(HTTPInterception.markerPrefix.count))
        let handler = HTTPSchemeHandler(sessionId: sessionId)
        HTTPInterception.registeringHTTPHandlers = true
        defer { HTTPInterception.registeringHTTPHandlers = false }
        mangayomi_setURLSchemeHandler(handler, forURLScheme: "https")
        mangayomi_setURLSchemeHandler(handler, forURLScheme: "http")
    }
}

/// Receives every http(s) request of one intercepted WebView: asks the app
/// first, then serves its answer or loads the request from the network with
/// the WebView's own cookies, as WebKit would have.
final class HTTPSchemeHandler: NSObject, WKURLSchemeHandler, URLSessionDataDelegate {
    private final class Load {
        let task: WKURLSchemeTask
        weak var webView: WKWebView?
        var stopped = false
        var dataTask: URLSessionDataTask?
        var response: URLResponse?
        var responseDelivered = false
        var bufferedData = Data()
        var completion: Error??

        init(task: WKURLSchemeTask, webView: WKWebView) {
            self.task = task
            self.webView = webView
        }
    }

    let sessionId: String
    private var loads: [ObjectIdentifier: Load] = [:]
    private var loadsByDataTask: [Int: Load] = [:]

    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        // Cookies live in the WebView's own store; this session only carries them.
        configuration.httpShouldSetCookies = false
        configuration.httpCookieAcceptPolicy = .never
        configuration.httpCookieStorage = nil
        return URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
    }()

    init(sessionId: String) {
        self.sessionId = sessionId
    }

    // MARK: WKURLSchemeHandler

    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        let load = Load(task: urlSchemeTask, webView: webView)
        loads[ObjectIdentifier(urlSchemeTask)] = load
        let request = urlSchemeTask.request
        let body = Self.body(of: request)

        guard let decider = HTTPInterception.decider, let url = request.url else {
            loadFromNetwork(load, request: request, body: body)
            return
        }
        let arguments: [String: Any] = [
            "session": sessionId,
            "url": url.absoluteString,
            "method": request.httpMethod ?? "GET",
            "headers": request.allHTTPHeaderFields ?? [:],
            "isForMainFrame": Self.isMainFrame(request, url: url),
        ]
        decider.shouldInterceptRequest(arguments) { [weak self] answer in
            guard let self, !load.stopped else { return }
            if let answer {
                self.serve(load, answer: answer, url: url)
            } else {
                self.loadFromNetwork(load, request: request, body: body)
            }
        }
    }

    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        guard let load = loads.removeValue(forKey: ObjectIdentifier(urlSchemeTask)) else { return }
        load.stopped = true
        if let dataTask = load.dataTask {
            loadsByDataTask.removeValue(forKey: dataTask.taskIdentifier)
            dataTask.cancel()
        }
    }

    // MARK: Serving the app's answer

    private func serve(_ load: Load, answer: [String: Any], url: URL) {
        let statusCode = (answer["statusCode"] as? Int) ?? 200
        var headers = (answer["headers"] as? [String: String]) ?? [:]
        if !headers.keys.contains(where: { $0.caseInsensitiveCompare("Content-Type") == .orderedSame }),
           let mimeType = answer["mimeType"] as? String, !mimeType.isEmpty {
            if let encoding = answer["encoding"] as? String, !encoding.isEmpty {
                headers["Content-Type"] = "\(mimeType); charset=\(encoding)"
            } else {
                headers["Content-Type"] = mimeType
            }
        }
        let body = (answer["body"] as? Data) ?? Data()
        let response =
            HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: "HTTP/1.1", headerFields: headers)
            ?? URLResponse(url: url, mimeType: answer["mimeType"] as? String, expectedContentLength: body.count, textEncodingName: answer["encoding"] as? String)
        load.task.didReceive(response)
        load.task.didReceive(body)
        load.task.didFinish()
        finish(load)
    }

    // MARK: Loading from the network

    private func loadFromNetwork(_ load: Load, request: URLRequest, body: Data?) {
        var outgoing = request
        outgoing.httpBody = body
        outgoing.httpShouldHandleCookies = false
        if outgoing.value(forHTTPHeaderField: "User-Agent") == nil,
           let userAgent = load.webView?.customUserAgent, !userAgent.isEmpty {
            outgoing.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        }
        withCookies(for: outgoing, in: load) { [weak self] prepared in
            guard let self, !load.stopped else { return }
            let dataTask = self.session.dataTask(with: prepared)
            load.dataTask = dataTask
            self.loadsByDataTask[dataTask.taskIdentifier] = load
            dataTask.resume()
        }
    }

    /// Adds the WebView's cookies for the request, as WebKit itself would.
    private func withCookies(
        for request: URLRequest,
        in load: Load,
        completion: @escaping (URLRequest) -> Void
    ) {
        guard let url = request.url, let store = load.webView?.configuration.websiteDataStore.httpCookieStore,
              request.value(forHTTPHeaderField: "Cookie") == nil
        else {
            completion(request)
            return
        }
        store.getAllCookies { cookies in
            var prepared = request
            let matching = cookies.filter { Self.cookie($0, matches: url) }
            for (name, value) in HTTPCookie.requestHeaderFields(with: matching) {
                prepared.setValue(value, forHTTPHeaderField: name)
            }
            completion(prepared)
        }
    }

    /// Stores the response's cookies in the WebView's store, then continues.
    private func storeCookies(
        from response: URLResponse,
        in load: Load,
        completion: @escaping () -> Void
    ) {
        guard let http = response as? HTTPURLResponse, let url = http.url,
              let store = load.webView?.configuration.websiteDataStore.httpCookieStore
        else {
            completion()
            return
        }
        let fields = http.allHeaderFields.reduce(into: [String: String]()) { result, entry in
            if let name = entry.key as? String, let value = entry.value as? String { result[name] = value }
        }
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: url)
        guard !cookies.isEmpty else {
            completion()
            return
        }
        let group = DispatchGroup()
        for cookie in cookies {
            group.enter()
            store.setCookie(cookie) { group.leave() }
        }
        group.notify(queue: .main, execute: completion)
    }

    // MARK: URLSessionDataDelegate

    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive response: URLResponse,
        completionHandler: @escaping (URLSession.ResponseDisposition) -> Void
    ) {
        completionHandler(.allow)
        guard let load = loadsByDataTask[dataTask.taskIdentifier], !load.stopped else { return }
        load.response = response
        // Cookies first, so the page sees them as soon as it runs.
        storeCookies(from: response, in: load) { [weak self] in
            guard let self, !load.stopped else { return }
            load.task.didReceive(Self.forWebKit(response))
            load.responseDelivered = true
            if !load.bufferedData.isEmpty {
                load.task.didReceive(load.bufferedData)
                load.bufferedData = Data()
            }
            if let completion = load.completion {
                self.complete(load, error: completion)
            }
        }
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let load = loadsByDataTask[dataTask.taskIdentifier], !load.stopped else { return }
        if load.responseDelivered {
            load.task.didReceive(data)
        } else {
            load.bufferedData.append(data)
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let load = loadsByDataTask.removeValue(forKey: task.taskIdentifier), !load.stopped else { return }
        if load.responseDelivered || load.response == nil {
            complete(load, error: error)
        } else {
            // Still storing the response's cookies; finish right after.
            load.completion = .some(error)
        }
    }

    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest,
        completionHandler: @escaping (URLRequest?) -> Void
    ) {
        guard let load = loadsByDataTask[task.taskIdentifier], !load.stopped else {
            completionHandler(nil)
            return
        }
        storeCookies(from: response, in: load) { [weak self] in
            guard let self, !load.stopped else {
                completionHandler(nil)
                return
            }
            var next = request
            next.httpShouldHandleCookies = false
            next.setValue(nil, forHTTPHeaderField: "Cookie")
            self.withCookies(for: next, in: load) { prepared in
                guard !load.stopped else {
                    completionHandler(nil)
                    return
                }
                // Tell WebKit about the redirect when it lets us, so the page's
                // URL (and relative links) follow it like a normal load.
                if !Self.reportRedirect(on: load.task, response: response, newRequest: prepared, completion: completionHandler) {
                    completionHandler(prepared)
                }
            }
        }
    }

    // MARK: Helpers

    private func complete(_ load: Load, error: Error?) {
        guard !load.stopped else { return }
        if let error {
            load.task.didFailWithError(error)
        } else {
            if !load.responseDelivered, let url = load.task.request.url {
                load.task.didReceive(URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil))
            }
            load.task.didFinish()
        }
        finish(load)
    }

    private func finish(_ load: Load) {
        loads.removeValue(forKey: ObjectIdentifier(load.task))
        if let dataTask = load.dataTask { loadsByDataTask.removeValue(forKey: dataTask.taskIdentifier) }
    }

    /// URLSession already decoded the body, so its encoding and length no
    /// longer describe what WebKit receives.
    private static func forWebKit(_ response: URLResponse) -> URLResponse {
        guard let http = response as? HTTPURLResponse, let url = http.url else { return response }
        var headers: [String: String] = [:]
        for (key, value) in http.allHeaderFields {
            guard let name = key as? String, let value = value as? String else { continue }
            let lowered = name.lowercased()
            if lowered == "content-encoding" || lowered == "content-length" { continue }
            headers[name] = value
        }
        return HTTPURLResponse(url: url, statusCode: http.statusCode, httpVersion: "HTTP/1.1", headerFields: headers) ?? response
    }

    private static func reportRedirect(
        on task: WKURLSchemeTask,
        response: HTTPURLResponse,
        newRequest: URLRequest,
        completion: @escaping (URLRequest?) -> Void
    ) -> Bool {
        let selector = NSSelectorFromString("_willPerformRedirection:newRequest:completionHandler:")
        let target = task as AnyObject
        guard target.responds(to: selector) else { return false }
        typealias Redirect = @convention(c) (
            AnyObject, Selector, URLResponse, NSURLRequest, @escaping @convention(block) (NSURLRequest?) -> Void
        ) -> Void
        let implementation = unsafeBitCast(target.method(for: selector), to: Redirect.self)
        implementation(target, selector, response, newRequest as NSURLRequest) { proposed in
            completion(proposed.map { $0 as URLRequest })
        }
        return true
    }

    /// A fetch of the page's own URL also has it as main document, so the
    /// Fetch Metadata destination decides when WebKit sends it.
    private static func isMainFrame(_ request: URLRequest, url: URL) -> Bool {
        if let destination = request.value(forHTTPHeaderField: "Sec-Fetch-Dest") {
            return destination == "document"
        }
        return request.mainDocumentURL == url
    }

    private static func body(of request: URLRequest) -> Data? {
        if let body = request.httpBody { return body }
        guard let stream = request.httpBodyStream else { return nil }
        stream.open()
        defer { stream.close() }
        var data = Data()
        let bufferSize = 64 * 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer { buffer.deallocate() }
        while stream.hasBytesAvailable {
            let read = stream.read(buffer, maxLength: bufferSize)
            if read <= 0 { break }
            data.append(buffer, count: read)
        }
        return data
    }

    private static func cookie(_ cookie: HTTPCookie, matches url: URL) -> Bool {
        guard let host = url.host?.lowercased() else { return false }
        if let expires = cookie.expiresDate, expires < Date() { return false }
        if cookie.isSecure, url.scheme?.lowercased() != "https" { return false }

        var domain = cookie.domain.lowercased()
        let includesSubdomains = domain.hasPrefix(".")
        if includesSubdomains { domain.removeFirst() }
        guard host == domain || (includesSubdomains && host.hasSuffix("." + domain)) else { return false }

        let path = url.path.isEmpty ? "/" : url.path
        let cookiePath = cookie.path.isEmpty ? "/" : cookie.path
        guard path.hasPrefix(cookiePath) else { return false }
        return cookiePath.hasSuffix("/") || path.count == cookiePath.count
            || path[path.index(path.startIndex, offsetBy: cookiePath.count)] == "/"
    }
}
