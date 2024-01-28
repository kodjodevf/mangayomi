// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/cloudflare/cookie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class MangaWebView extends ConsumerStatefulWidget {
  final String url;
  final String sourceId;
  final String title;
  const MangaWebView({
    super.key,
    required this.url,
    required this.sourceId,
    required this.title,
  });

  @override
  ConsumerState<MangaWebView> createState() => _MangaWebViewState();
}

class _MangaWebViewState extends ConsumerState<MangaWebView> {
  final GlobalKey webViewKey = GlobalKey();
  late final MyInAppBrowser browser;
  double progress = 0;
  @override
  void initState() {
    browser = MyInAppBrowser(context: context);
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      _runWebViewDesktop();
    } else {
      setState(() {
        isNotDesktop = true;
      });
    }
    super.initState();
  }

  Webview? webview;
  _runWebViewDesktop() async {
    if (Platform.isMacOS) {
      await browser.openUrlRequest(
        urlRequest: URLRequest(url: WebUri(widget.url)),
        settings: InAppBrowserClassSettings(
          browserSettings: InAppBrowserSettings(
              toolbarTopBackgroundColor: Colors.blue,
              presentationStyle: ModalPresentationStyle.POPOVER),
          webViewSettings: InAppWebViewSettings(
            isInspectable: kDebugMode,
            useShouldOverrideUrlLoading: true,
            useOnLoadResource: true,
          ),
        ),
      );
    } else {
      webview = await WebviewWindow.create(
        configuration: CreateConfiguration(
          userDataFolderWindows: await getWebViewPath(),
        ),
      );
      webview!
        ..setBrightness(Brightness.dark)
        ..launch(widget.url)
        ..onClose.whenComplete(() {
          Navigator.pop(context);
        });
    }
  }

  bool isNotDesktop = false;
  InAppWebViewController? _webViewController;
  late String _url = widget.url;
  late String _title = widget.title;
  bool _canGoback = false;
  bool _canGoForward = false;
  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context);
    return !isNotDesktop
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                _title,
                style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                  onPressed: () {
                    if (Platform.isMacOS) {
                      if (browser.isOpened()) {
                        browser.close();
                      }
                    } else {
                      webview!.close();
                    }

                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close)),
            ),
          )
        : SafeArea(
            child: WillPopScope(
              onWillPop: () async {
                _webViewController?.goBack();
                return false;
              },
              child: Column(
                children: [
                  SizedBox(
                    height: AppBar().preferredSize.height,
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            dense: true,
                            subtitle: Text(
                              _url,
                              style: const TextStyle(
                                  fontSize: 10,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            title: Text(
                              _title,
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold),
                            ),
                            leading: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.close)),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: _canGoback ? null : Colors.grey),
                          onPressed: _canGoback
                              ? () {
                                  _webViewController?.goBack();
                                }
                              : null,
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward,
                              color: _canGoForward ? null : Colors.grey),
                          onPressed: _canGoForward
                              ? () {
                                  _webViewController?.goForward();
                                }
                              : null,
                        ),
                        PopupMenuButton(itemBuilder: (context) {
                          return [
                            PopupMenuItem<int>(
                                value: 0, child: Text(l10n!.refresh)),
                            PopupMenuItem<int>(
                                value: 1, child: Text(l10n.share)),
                            PopupMenuItem<int>(
                                value: 2, child: Text(l10n.open_in_browser)),
                            PopupMenuItem<int>(
                                value: 3, child: Text(l10n.clear_cookie)),
                          ];
                        }, onSelected: (value) async {
                          if (value == 0) {
                            _webViewController?.reload();
                          } else if (value == 1) {
                            Share.share(_url);
                          } else if (value == 2) {
                            await InAppBrowser.openWithSystemBrowser(
                                url: WebUri(_url));
                          } else if (value == 3) {
                            CookieManager.instance().deleteAllCookies();
                          }
                        }),
                      ],
                    ),
                  ),
                  progress < 1.0
                      ? LinearProgressIndicator(value: progress)
                      : Container(),
                  Expanded(
                    child: InAppWebView(
                      key: webViewKey,
                      onWebViewCreated: (controller) async {
                        _webViewController = controller;
                      },
                      onLoadStart: (controller, url) async {
                        setState(() {
                          _url = url.toString();
                        });
                      },
                      shouldOverrideUrlLoading:
                          (controller, navigationAction) async {
                        var uri = navigationAction.request.url!;

                        if (![
                          "http",
                          "https",
                          "file",
                          "chrome",
                          "data",
                          "javascript",
                          "about"
                        ].contains(uri.scheme)) {
                          if (await canLaunchUrl(uri)) {
                            // Launch the App
                            await launchUrl(
                              uri,
                            );
                            // and cancel the request
                            return NavigationActionPolicy.CANCEL;
                          }
                        }

                        return NavigationActionPolicy.ALLOW;
                      },
                      onLoadStop: (controller, url) async {
                        setState(() {
                          _url = url.toString();
                        });
                      },
                      onProgressChanged: (controller, progress) async {
                        setState(() {
                          this.progress = progress / 100;
                        });
                      },
                      onUpdateVisitedHistory:
                          (controller, url, isReload) async {
                        final ua = await controller.evaluateJavascript(
                                source: "navigator.userAgent") ??
                            "";
                        await addCookie(widget.sourceId, url.toString(), ua);
                        final canGoback = await controller.canGoBack();
                        final canGoForward = await controller.canGoForward();
                        final title = await controller.getTitle();
                        setState(() {
                          _url = url.toString();
                          _title = title!;
                          _canGoback = canGoback;
                          _canGoForward = canGoForward;
                        });
                      },
                      initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

Future<String> getWebViewPath() async {
  final document = await getApplicationDocumentsDirectory();
  return p.join(
    document.path,
    'desktop_webview_window',
  );
}

Future<String?> decodeHtml(Webview webview, {String? sourceId}) async {
  try {
    final html = await webview
        .evaluateJavaScript("window.document.documentElement.outerHTML;");
    final ua = await webview.evaluateJavaScript("navigator.userAgent") ?? "";
    final newCookie =
        await webview.evaluateJavaScript("window.document.cookie;");
    if (newCookie != null && sourceId != null) {
      CookieState(idSource: sourceId)
          .set(jsonDecode(newCookie), ua.isNotEmpty ? jsonDecode(ua) : "");
    }

    final res = jsonDecode(html!) as String;

    return res == "<html><head></head><body></body></html>" || res.isEmpty
        ? null
        : res;
  } catch (_) {
    return null;
  }
}

class MyInAppBrowser extends InAppBrowser {
  MyInAppBrowser(
      {super.windowId,
      super.initialUserScripts,
      super.pullToRefreshController,
      required this.context});
  late BuildContext context;
  @override
  Future onBrowserCreated() async {
  }

  @override
  Future onLoadStart(url) async {}

  @override
  Future onLoadStop(url) async {}

  @override
  Future<PermissionResponse> onPermissionRequest(permissionRequest) async {
    return PermissionResponse(
        resources: permissionRequest.resources, action: PermissionResponseAction.GRANT);
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
  }

  @override
  void onExit() {
    Navigator.pop(context);
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(
      navigationAction) async {
    var uri = navigationAction.request.url!;

    if (!["http", "https", "file", "chrome", "data", "javascript", "about"]
        .contains(uri.scheme)) {
      if (await canLaunchUrl(uri)) {
        // Launch the App
        await launchUrl(
          uri,
        );
        // and cancel the request
        return NavigationActionPolicy.CANCEL;
      }
    }

    return NavigationActionPolicy.ALLOW;
  }

  @override
  void onMainWindowWillClose() {
    close();
  }
}
