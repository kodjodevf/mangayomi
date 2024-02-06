import 'dart:io';

import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

void main(List<String> args) {
  debugPrint('args: $args');
  if (runWebViewTitleBarWidget(args)) {
    return;
  }
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController(
    text: 'https://example.com',
  );

  bool? _webviewAvailable;

  @override
  void initState() {
    super.initState();
    WebviewWindow.isWebviewAvailable().then((value) {
      setState(() {
        _webviewAvailable = value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: [
            IconButton(
              onPressed: () async {
                final webview = await WebviewWindow.create(
                  configuration: CreateConfiguration(
                    windowHeight: 1280,
                    windowWidth: 720,
                    title: "ExampleTestWindow",
                    titleBarTopPadding: Platform.isMacOS ? 20 : 0,
                    userDataFolderWindows: await _getWebViewPath(),
                  ),
                );
                webview
                  ..registerJavaScriptMessageHandler("test", (name, body) {
                    debugPrint('on javaScipt message: $name $body');
                  })
                  ..setApplicationNameForUserAgent(" WebviewExample/1.0.0")
                  ..setPromptHandler((prompt, defaultText) {
                    if (prompt == "test") {
                      return "Hello World!";
                    } else if (prompt == "init") {
                      return "initial prompt";
                    }
                    return "";
                  })
                  ..addScriptToExecuteOnDocumentCreated("""
  const mixinContext = {
    platform: 'Desktop',
    conversation_id: 'conversationId',
    immersive: false,
    app_version: '1.0.0',
    appearance: 'dark',
  }
  window.MixinContext = {
    getContext: function() {
      return JSON.stringify(mixinContext)
    }
  }
""")
                  ..launch("http://localhost:3000/test.html");
              },
              icon: const Icon(Icons.bug_report),
            )
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(controller: _controller),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _webviewAvailable != true ? null : _onTap,
                  child: const Text('Open'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () async {
                    await WebviewWindow.clearAll(
                      userDataFolderWindows: await _getWebViewPath(),
                    );
                    debugPrint('clear complete');
                  },
                  child: const Text('Clear all'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTap() async {
    final webview = await WebviewWindow.create(
      configuration: CreateConfiguration(
        userDataFolderWindows: await _getWebViewPath(),
        titleBarTopPadding: Platform.isMacOS ? 20 : 0,
      ),
    );
    webview
      ..setBrightness(Brightness.dark)
      ..setApplicationNameForUserAgent(" WebviewExample/1.0.0")
      ..launch(_controller.text)
      ..addOnUrlRequestCallback((url) {
        debugPrint('url: $url');
        final uri = Uri.parse(url);
        if (uri.path == '/login_success') {
          debugPrint('login success. token: ${uri.queryParameters['token']}');
          webview.close();
        }
      })
      ..onClose.whenComplete(() {
        debugPrint("on close");
      });
    await Future.delayed(const Duration(seconds: 2));
    for (final javaScript in _javaScriptToEval) {
      try {
        final ret = await webview.evaluateJavaScript(javaScript);
        debugPrint('evaluateJavaScript: $ret');
      } catch (e) {
        debugPrint('evaluateJavaScript error: $e \n $javaScript');
      }
    }
  }
}

const _javaScriptToEval = [
  """
  function test() {
    return;
  }
  test();
  """,
  'eval({"name": "test", "user_agent": navigator.userAgent})',
  '1 + 1',
  'undefined',
  '1.0 + 1.0',
  '"test"',
];

Future<String> _getWebViewPath() async {
  final document = await getApplicationDocumentsDirectory();
  return p.join(
    document.path,
    'desktop_webview_window',
  );
}
