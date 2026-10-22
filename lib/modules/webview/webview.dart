import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/more/settings/general/providers/general_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/utils/share.dart';

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
    // Always stop the cookie poll, even if the route is popped externally
    // (e.g. router/back) without going through _popWebviewRoute — otherwise the
    // periodic timer keeps hitting a closed WebView and pins this State.
    _cookieTimer?.cancel();
    if (Platform.isLinux) {
      _closeDesktopWebview();
    } else {
      _closeBrowser();
    }
    super.dispose();
  }

  bool _browserClosed = false;

  /// Closes and disposes the Windows in-app browser at most once. It can be
  /// asked to close from three places for one teardown (the in-app close
  /// button, the native window's own close via onExit, and dispose()) —
  /// disposing twice crashes with "used after being disposed".
  void _closeBrowser() {
    if (_browserClosed) return;
    _browserClosed = true;
    if (browser != null && browser!.isOpened()) {
      browser!.close();
    }
    browser?.dispose();
  }

  Webview? _desktopWebview;
  Timer? _cookieTimer;
  bool _webviewClosed = false;
  bool _routePopped = false;

  /// Closes the native desktop WebView window at most once. On Linux the close
  /// can be triggered from three places for a single teardown (the in-app
  /// button, the `onClose` callback after the user closes the window, and
  /// `dispose()`). Closing more than once removes the WebView's FlView and then
  /// the GTK embedder paints the now-invalid view on the next frame → SIGSEGV.
  /// Guarding it keeps the app from aggravating that. See #752.
  void _closeDesktopWebview() {
    if (_webviewClosed) return;
    _webviewClosed = true;
    _desktopWebview?.close();
  }

  /// Pops this route at most once and stops the cookie poll.
  void _popWebviewRoute() {
    if (_routePopped) return;
    _routePopped = true;
    _cookieTimer?.cancel();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _runWebViewDesktop() async {
    String? ua = ref.watch(userAgentStateProvider);
    if (ua == defaultUserAgent) {
      ua = null;
    }
    if (Platform.isLinux) {
      // Like Windows, the controls live in this screen rather than in the
      // webview window: the plugin's own title bar is a second Flutter engine,
      // and tearing it down when the window closes crashes the app.
      // Opened as a child of this window and centred on it, so size it to
      // cover the area below the toolbar.
      final size = MediaQuery.sizeOf(context);
      _desktopWebview = await WebviewWindow.create(
        configuration: CreateConfiguration(
          title: widget.title,
          titleBarHeight: 0,
          windowWidth: (size.width - 64).round(),
          windowHeight: (size.height - 180).round(),
        ),
      );
      final navigating = _desktopWebview!.isNavigating;
      navigating.addListener(() {
        if (mounted) setState(() => _progress = navigating.value ? 0 : 1);
      });
      _desktopWebview!.setOnHistoryChangedCallback((canGoBack, canGoForward) {
        if (mounted) {
          setState(() {
            _canGoback = canGoBack;
            _canGoForward = canGoForward;
          });
        }
      });

      _cookieTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
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
          await MClient.setCookie(widget.url, ua, null, cookie: cookie);
          // location.href is the main frame's URL; the plugin's URL requests
          // also include iframes (ads, captchas). Results come back
          // JSON-encoded on Linux, quotes included.
          final href = await _desktopWebview!.evaluateJavaScript(
            "location.href",
          );
          final url = href == null ? null : jsonDecode(href) as String;
          if (mounted && url != null && url != 'about:blank' && url != _url) {
            setState(() => _url = url);
          }
        } catch (_) {}
      });
      _desktopWebview!
        ..setBrightness(Brightness.dark)
        ..launch(widget.url)
        ..onClose.whenComplete(() {
          // The native window has already closed itself; mark it so dispose()
          // doesn't try to close it again, then pop this route once.
          _webviewClosed = true;
          _popWebviewRoute();
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
        onExitCallback: () {
          // The native window has already torn itself down; mark it closed so
          // dispose() and the in-app close button don't try to close/dispose
          // it again, then pop this route once.
          _browserClosed = true;
          if (mounted) Navigator.pop(context);
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
    return Material(
      child: SafeArea(
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            final canGoback = await _webViewController?.canGoBack();
            if (canGoback ?? false) {
              _webViewController?.goBack();
            } else if (context.mounted) {
              context.pop();
            }
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.shiori.caption,
                        ),
                        title: Text(
                          _title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.shiori.text.row.copyWith(
                            color: context.shiori.color.fg,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        leading: IconButton(
                          tooltip: MaterialLocalizations.of(context)
                              .closeButtonTooltip,
                          onPressed: () {
                            if (Platform.isLinux) {
                              _closeDesktopWebview();
                              _popWebviewRoute();
                              return;
                            }
                            if (Platform.isWindows) {
                              _closeBrowser();
                            }
                            Navigator.pop(context);
                          },
                          icon: const Icon(Symbols.close_rounded, fill: 1),
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: MaterialLocalizations.of(context)
                          .backButtonTooltip,
                      icon: Icon(
                        Symbols.arrow_back_rounded,
                        fill: 1,
                        color: _canGoback
                            ? null
                            : context.shiori.color.fg.withValues(
                                alpha: Alphas.disabled,
                              ),
                      ),
                      onPressed: _canGoback
                          ? () {
                              if (Platform.isLinux) {
                                _desktopWebview?.back();
                              } else {
                                _webViewController?.goBack();
                              }
                            }
                          : null,
                    ),
                    IconButton(
                      tooltip: context.l10n.go_forward,
                      icon: Icon(
                        Symbols.arrow_forward_rounded,
                        fill: 1,
                        color: _canGoForward
                            ? null
                            : context.shiori.color.fg.withValues(
                                alpha: Alphas.disabled,
                              ),
                      ),
                      onPressed: _canGoForward
                          ? () {
                              if (Platform.isLinux) {
                                _desktopWebview?.forward();
                              } else {
                                _webViewController?.goForward();
                              }
                            }
                          : null,
                    ),
                    ShioriMenuButton(
                      tooltip: MaterialLocalizations.of(context)
                          .moreButtonTooltip,
                      items: [
                        ShioriMenuItem(
                          label: l10n!.refresh,
                          icon: Symbols.refresh_rounded,
                          onSelected: () => Platform.isLinux
                              ? _desktopWebview?.reload()
                              : _webViewController?.reload(),
                        ),
                        ShioriMenuItem(
                          label: l10n.share,
                          icon: Symbols.share_rounded,
                          onSelected: () {
                            final box =
                                context.findRenderObject() as RenderBox?;
                            shareOrCopy(
                              ShareParams(
                                text: _url,
                                sharePositionOrigin:
                                    box!.localToGlobal(Offset.zero) & box.size,
                              ),
                            );
                          },
                        ),
                        ShioriMenuItem(
                          label: l10n.open_in_browser,
                          icon: Symbols.open_in_browser_rounded,
                          // flutter_inappwebview has no Linux support.
                          onSelected: () => Platform.isLinux
                              ? launchUrl(
                                  Uri.parse(_url),
                                  mode: LaunchMode.externalApplication,
                                )
                              : InAppBrowser.openWithSystemBrowser(
                                  url: WebUri(_url),
                                ),
                        ),
                        null,
                        ShioriMenuItem(
                          label: l10n.clear_cookie,
                          icon: Symbols.cookie_rounded,
                          destructive: true,
                          onSelected: () {
                            if (Platform.isLinux) {
                              WebviewWindow.clearAll();
                            } else {
                              CookieManager.instance().deleteAllCookies();
                            }
                            MClient.deleteAllCookies(_url);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _progress < 1.0
                  // The Linux webview only says whether it is loading.
                  ? ShioriProgressBar(
                      value: Platform.isLinux ? null : _progress,
                      height: 2,
                    )
                  : Container(),
              if (isNotWebviewWindow)
                Expanded(
                  // Android's WebView drives its own d-pad focus once it
                  // has focus, but nothing here ever gave it any, so on a
                  // TV the remote could not reach into the page at all.
                  // That matters most for a Cloudflare challenge, which
                  // is the whole reason this screen exists. Autofocus it
                  // on TV so the keys land in the page rather than the
                  // toolbar.
                  child: Focus(
                    autofocus: isTv,
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
                      initialUrlRequest: URLRequest(url: WebUri(widget.url)),
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
  void Function() onExitCallback;
  MyInAppBrowser({
    required this.context,
    required this.controller,
    required this.onProgress,
    required this.onExitCallback,
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
    onExitCallback.call();
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
