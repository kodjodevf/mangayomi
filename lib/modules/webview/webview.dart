// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_windows_webview/flutter_windows_webview.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/http/m_client.dart';
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
  double _progress = 0;
  @override
  void initState() {
    if (Platform.isWindows) {
      _runWindowWebView();
    }
    super.initState();
  }

  final _windowsWebview = FlutterWindowsWebview();
  void _runWindowWebView() async {
    //credit: https://github.com/wgh136/PicaComic/blob/master/lib/network/nhentai_network/cloudflare.dart
    if (await FlutterWindowsWebview.isAvailable()) {
      _windowsWebview.launchWebview(
          widget.url,
          WebviewOptions(messageReceiver: (s) {
            if (s.substring(0, 2) == "UA") {
              MClient.setCookie(_url, s.replaceFirst("UA", ""));
            }
          }, onTitleChange: (_) {
            _windowsWebview.runScript(
                "window.chrome.webview.postMessage(\"UA\" + navigator.userAgent)");
            _windowsWebview.getCookies(widget.url).then((cookies) {
              final cookie =
                  cookies.entries.map((e) => "${e.key}=${e.value}").join("; ");
              MClient.setCookie(_url, "", cookie: cookie);
            });
          }));
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
    return Platform.isWindows
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
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close)),
            ),
          )
        : Material(
            child: SafeArea(
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
                          PopupMenuButton(
                              popUpAnimationStyle: popupAnimationStyle,
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem<int>(
                                      value: 0, child: Text(l10n!.refresh)),
                                  PopupMenuItem<int>(
                                      value: 1, child: Text(l10n.share)),
                                  PopupMenuItem<int>(
                                      value: 2,
                                      child: Text(l10n.open_in_browser)),
                                  PopupMenuItem<int>(
                                      value: 3, child: Text(l10n.clear_cookie)),
                                ];
                              },
                              onSelected: (value) async {
                                if (value == 0) {
                                  _webViewController?.reload();
                                } else if (value == 1) {
                                  Share.share(_url);
                                } else if (value == 2) {
                                  await InAppBrowser.openWithSystemBrowser(
                                      url: WebUri(_url));
                                } else if (value == 3) {
                                  CookieManager.instance().deleteAllCookies();
                                  MClient.deleteAllCookies(_url);
                                }
                              }),
                        ],
                      ),
                    ),
                    _progress < 1.0
                        ? LinearProgressIndicator(value: _progress)
                        : Container(),
                    Expanded(
                      child: InAppWebView(
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
                          final ua = await controller.evaluateJavascript(
                                  source: "navigator.userAgent") ??
                              "";
                          await MClient.setCookie(url.toString(), ua);
                          final canGoback = await controller.canGoBack();
                          final canGoForward = await controller.canGoForward();
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
                        initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
