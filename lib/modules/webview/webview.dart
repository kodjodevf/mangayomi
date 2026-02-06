import 'dart:async';
import 'dart:io';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/modules/more/settings/general/providers/general_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/global_style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class MangaWebView extends ConsumerStatefulWidget {
  final String url;
  final String title;
  const MangaWebView({super.key, required this.url, required this.title});

  @override
  ConsumerState<MangaWebView> createState() => _MangaWebViewState();
}

class _MangaWebViewState extends ConsumerState<MangaWebView> {
  MyInAppBrowser? browser;
  double _progress = 0;
  bool isNotWebviewWindow = false;
  bool _initialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    if (Platform.isLinux || Platform.isWindows) {
      _runWebViewDesktop();
    } else {
      setState(() {
        isNotWebviewWindow = true;
      });
    }
  }

  @override
  void dispose() {
    if (Platform.isLinux) {
      _desktopWebview?.close();
    } else {
      if (browser != null) {
        if (browser!.isOpened()) browser!.close();
        browser!.dispose();
      }
    }
    super.dispose();
  }

  Webview? _desktopWebview;
  Future<void> _runWebViewDesktop() async {
    String? ua = ref.watch(userAgentStateProvider);
    if (ua == defaultUserAgent) {
      ua = null;
    }
    if (Platform.isLinux) {
      _desktopWebview = await WebviewWindow.create();

      final timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        try {
          final cookieList = await _desktopWebview!.getAllCookies();
          final ua =
              await _desktopWebview!.evaluateJavaScript(
                "navigator.userAgent",
              ) ??
              "";
          final cookie = cookieList
              .map((e) => "${e.name}=${e.value}")
              .join(";");
          await MClient.setCookie(_url, ua, null, cookie: cookie);
        } catch (_) {}
      });
      _desktopWebview!
        ..setBrightness(Brightness.dark)
        ..launch(widget.url)
        ..onClose.whenComplete(() {
          timer.cancel();
          if (mounted) {
            Navigator.pop(context);
          }
        });
    } else {
      browser = MyInAppBrowser(
        context: context,
        controller: (controller) {
          _webViewController = controller;
        },
        onProgress: (progress) async {
          final canGoback = await _webViewController?.canGoBack();
          final canGoForward = await _webViewController?.canGoForward();
          final title = await _webViewController?.getTitle();
          final url = await _webViewController?.getUrl();
          if (mounted) {
            setState(() {
              _progress = progress / 100;
              _url = url.toString();
              _title = title!;
              _canGoback = canGoback ?? false;
              _canGoForward = canGoForward ?? false;
            });
          }
        },
      );
      await browser!.openUrlRequest(
        urlRequest: URLRequest(url: WebUri(widget.url)),
        settings: InAppBrowserClassSettings(
          browserSettings: InAppBrowserSettings(
            presentationStyle: ModalPresentationStyle.POPOVER,
          ),
          webViewSettings: InAppWebViewSettings(
            isInspectable: kDebugMode,
            useShouldOverrideUrlLoading: true,
            userAgent: ua,
          ),
        ),
      );
    }
  }

  InAppWebViewController? _webViewController;
  late String _url = widget.url;
  late String _title = widget.title;
  bool _canGoback = false;
  bool _canGoForward = false;
  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context);
    return (!isNotWebviewWindow && Platform.isLinux)
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                _title,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  if (_desktopWebview != null) _desktopWebview!.close();

                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ),
          )
        : Material(
            child: SafeArea(
              child: WillPopScope(
                onWillPop: () async {
                  final canGoback = await _webViewController?.canGoBack();
                  if (canGoback ?? false) {
                    _webViewController?.goBack();
                  } else if (context.mounted) {
                    context.pop();
                  }
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
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              title: Text(
                                _title,
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              leading: IconButton(
                                onPressed: () {
                                  if (Platform.isWindows) {
                                    if (browser!.isOpened()) {
                                      browser!.close();
                                      browser!.dispose();
                                    }
                                  }
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: _canGoback ? null : Colors.grey,
                            ),
                            onPressed: _canGoback
                                ? () {
                                    _webViewController?.goBack();
                                  }
                                : null,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.arrow_forward,
                              color: _canGoForward ? null : Colors.grey,
                            ),
                            onPressed: _canGoForward
                                ? () {
                                    _webViewController?.goForward();
                                  }
                                : null,
                          ),
                          PopupMenuButton(
                            popUpAnimationStyle: popupAnimationStyle,
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem<int>(
                                  value: 0,
                                  child: Text(l10n!.refresh),
                                ),
                                PopupMenuItem<int>(
                                  value: 1,
                                  child: Text(l10n.share),
                                ),
                                PopupMenuItem<int>(
                                  value: 2,
                                  child: Text(l10n.open_in_browser),
                                ),
                                PopupMenuItem<int>(
                                  value: 3,
                                  child: Text(l10n.clear_cookie),
                                ),
                              ];
                            },
                            onSelected: (value) async {
                              if (value == 0) {
                                _webViewController?.reload();
                              } else if (value == 1) {
                                final box =
                                    context.findRenderObject() as RenderBox?;
                                SharePlus.instance.share(
                                  ShareParams(
                                    text: _url,
                                    sharePositionOrigin:
                                        box!.localToGlobal(Offset.zero) &
                                        box.size,
                                  ),
                                );
                              } else if (value == 2) {
                                await InAppBrowser.openWithSystemBrowser(
                                  url: WebUri(_url),
                                );
                              } else if (value == 3) {
                                CookieManager.instance().deleteAllCookies();
                                MClient.deleteAllCookies(_url);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    _progress < 1.0
                        ? LinearProgressIndicator(value: _progress)
                        : Container(),
                    if (!Platform.isWindows)
                      Expanded(
                        child: InAppWebView(
                          webViewEnvironment: webViewEnvironment,
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
                                  "about",
                                ].contains(uri.scheme)) {
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri);
                                    return NavigationActionPolicy.CANCEL;
                                  }
                                }
                                return NavigationActionPolicy.ALLOW;
                              },
                          onLoadStop: (controller, url) async {
                            if (mounted) {
                              setState(() {
                                _url = url.toString();
                              });
                            }
                          },
                          onProgressChanged: (controller, progress) async {
                            if (mounted) {
                              setState(() {
                                _progress = progress / 100;
                              });
                            }
                          },
                          onUpdateVisitedHistory:
                              (controller, url, isReload) async {
                                final ua =
                                    await controller.evaluateJavascript(
                                      source: "navigator.userAgent",
                                    ) ??
                                    "";
                                await MClient.setCookie(
                                  url.toString(),
                                  ua,
                                  controller,
                                );
                                final canGoback = await controller.canGoBack();
                                final canGoForward = await controller
                                    .canGoForward();
                                final title = await controller.getTitle();
                                if (mounted) {
                                  setState(() {
                                    _url = url.toString();
                                    _title = title!;
                                    _canGoback = canGoback;
                                    _canGoForward = canGoForward;
                                  });
                                }
                              },
                          initialUrlRequest: URLRequest(
                            url: WebUri(widget.url),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
  }
}

class MyInAppBrowser extends InAppBrowser {
  BuildContext context;
  void Function(InAppWebViewController) controller;
  void Function(int) onProgress;
  MyInAppBrowser({
    required this.context,
    required this.controller,
    required this.onProgress,
  }) : super(webViewEnvironment: webViewEnvironment);

  @override
  Future onBrowserCreated() async {
    controller.call(webViewController!);
  }

  @override
  void onProgressChanged(progress) {
    onProgress.call(progress);
  }

  @override
  void onExit() {
    Navigator.pop(context);
  }

  @override
  void onLoadStop(url) async {
    if (webViewController != null) {
      final ua =
          await webViewController!.evaluateJavascript(
            source: "navigator.userAgent",
          ) ??
          "";
      await MClient.setCookie(url.toString(), ua, webViewController);
    }
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(
    navigationAction,
  ) async {
    var uri = navigationAction.request.url!;
    if (![
      "http",
      "https",
      "file",
      "chrome",
      "data",
      "javascript",
      "about",
    ].contains(uri.scheme)) {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return NavigationActionPolicy.CANCEL;
      }
    }
    return NavigationActionPolicy.ALLOW;
  }
}
