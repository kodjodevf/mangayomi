import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/services/cloudflare/cookie.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class MangaWebView extends ConsumerStatefulWidget {
  final String url;
  final String source;
  const MangaWebView({super.key, required this.url, required this.source});

  @override
  ConsumerState<MangaWebView> createState() => _MangaWebViewState();
}

class _MangaWebViewState extends ConsumerState<MangaWebView> {
  final GlobalKey webViewKey = GlobalKey();

  double progress = 0;

  InAppWebViewController? webViewController;
  String _url = "";
  @override
  void initState() {
    setState(() {
      _url = widget.url;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close)),
        title: Text(
          _url,
          style: const TextStyle(fontSize: 10),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              webViewController?.goBack();
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              webViewController?.goForward();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              webViewController?.reload();
            },
          ),
          IconButton(
              onPressed: () async {
                await InAppBrowser.openWithSystemBrowser(
                    url: WebUri.uri(Uri.parse(_url)));
              },
              icon: const Icon(Icons.read_more))
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          webViewController?.goBack();
          return false;
        },
        child: Column(
          children: [
            progress < 1.0
                ? LinearProgressIndicator(value: progress)
                : Container(),
            Flexible(
              child: InAppWebView(
                key: webViewKey,
                onWebViewCreated: (controller) async {
                  webViewController = controller;
                },
                onLoadStart: (controller, url) async {
                  setState(() {
                    _url = url.toString();
                  });
                },
                onPermissionRequest: (controller, request) async {
                  return PermissionResponse(
                      resources: request.resources,
                      action: PermissionResponseAction.GRANT);
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
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
                onReceivedError: (controller, request, error) {},
                onProgressChanged: (controller, progress) async {
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
                onUpdateVisitedHistory: (controller, url, isReload) async {
                  await setCookie(widget.source, url.toString());
                  setState(() {
                    _url = url.toString();
                  });
                },
                initialSettings: InAppWebViewSettings(
                    userAgent: Hive.box(HiveConstant.hiveBoxAppSettings).get(
                        "ua",
                        defaultValue:
                            "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:110.0) Gecko/20100101 Firefox/110.0")),
                initialUrlRequest:
                    URLRequest(url: WebUri.uri(Uri.parse(widget.url))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
