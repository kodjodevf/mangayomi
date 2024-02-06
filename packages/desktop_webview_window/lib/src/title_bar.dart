import 'dart:async';

import 'package:flutter/material.dart';

import 'message_channel.dart';

const _channel = ClientMessageChannel();

/// runs the title bar
/// title bar is a widget that displays the title of the webview window
/// return true if the args is matchs the title bar
///
/// [builder] custom TitleBar widget builder.
/// can use [TitleBarWebViewController] to controller the WebView
/// use [TitleBarWebViewState] to triger the title bar status.
///
bool runWebViewTitleBarWidget(
  List<String> args, {
  WidgetBuilder? builder,
  Color? backgroundColor,
  void Function(Object error, StackTrace stack)? onError,
}) {
  if (args.isEmpty || args[0] != 'web_view_title_bar') {
    return false;
  }
  final webViewId = int.tryParse(args[1]);
  if (webViewId == null) {
    return false;
  }
  final titleBarTopPadding = int.tryParse(args.length > 2 ? args[2] : '0') ?? 0;
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();
      runApp(_TitleBarApp(
        webViewId: webViewId,
        titleBarTopPadding: titleBarTopPadding,
        backgroundColor: backgroundColor,
        builder: builder ?? _defaultTitleBar,
      ));
    },
    onError ??
        (e, s) {
          debugPrint('WebViewTitleBar: unhandled expections: $e, $s');
        },
  );

  return true;
}

mixin TitleBarWebViewController {
  static TitleBarWebViewController of(BuildContext context) {
    final state = context.findAncestorStateOfType<_TitleBarAppState>();
    assert(state != null,
        'only can find TitleBarWebViewController in widget which run from runWebViewTitleBarWidget');
    return state!;
  }

  int get _webViewId;

  /// navigate back
  void back() {
    _channel.invokeMethod('onBackPressed', {
      'webViewId': _webViewId,
    });
  }

  /// navigate forward
  void forward() {
    _channel.invokeMethod('onForwardPressed', {
      'webViewId': _webViewId,
    });
  }

  /// reload the webview
  void reload() {
    _channel.invokeMethod('onRefreshPressed', {
      'webViewId': _webViewId,
    });
  }

  /// stop loading the webview
  void stop() {
    _channel.invokeMethod('onStopPressed', {
      'webViewId': _webViewId,
    });
  }

  /// close the webview
  void close() {
    _channel.invokeMethod('onClosePressed', {
      'webViewId': _webViewId,
    });
  }
}

class TitleBarWebViewState extends InheritedWidget {
  const TitleBarWebViewState({
    Key? key,
    required Widget child,
    required this.isLoading,
    required this.canGoBack,
    required this.canGoForward,
    required this.url,
  }) : super(key: key, child: child);

  final bool isLoading;
  final bool canGoBack;
  final bool canGoForward;
  final String? url;

  static TitleBarWebViewState of(BuildContext context) {
    final TitleBarWebViewState? result =
        context.dependOnInheritedWidgetOfExactType<TitleBarWebViewState>();
    assert(result != null, 'No WebViewState found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(TitleBarWebViewState oldWidget) {
    return isLoading != oldWidget.isLoading ||
        canGoBack != oldWidget.canGoBack ||
        canGoForward != oldWidget.canGoForward;
  }
}

class _TitleBarApp extends StatefulWidget {
  const _TitleBarApp({
    Key? key,
    required this.webViewId,
    required this.titleBarTopPadding,
    required this.builder,
    this.backgroundColor,
  }) : super(key: key);

  final int webViewId;

  final int titleBarTopPadding;

  final WidgetBuilder builder;

  final Color? backgroundColor;

  @override
  State<_TitleBarApp> createState() => _TitleBarAppState();
}

class _TitleBarAppState extends State<_TitleBarApp>
    with TitleBarWebViewController {
  bool _canGoBack = false;
  bool _canGoForward = false;

  bool _isLoading = false;

  String? _url;

  @override
  int get _webViewId => widget.webViewId;

  @override
  void initState() {
    super.initState();
    _channel.setMessageHandler((call) async {
      final args = call.arguments as Map;
      final webViewId = args['webViewId'] as int;
      if (webViewId != widget.webViewId) {
        return;
      }
      switch (call.method) {
        case "onHistoryChanged":
          setState(() {
            _canGoBack = args['canGoBack'] as bool;
            _canGoForward = args['canGoForward'] as bool;
          });
          break;
        case "onNavigationStarted":
          setState(() {
            _isLoading = true;
          });
          break;
        case "onNavigationCompleted":
          setState(() {
            _isLoading = false;
          });
          break;
        case "onUrlRequested":
          setState(() {
            _url = args['url'] as String;
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(
        color:
            widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: EdgeInsets.only(top: widget.titleBarTopPadding.toDouble()),
          child: TitleBarWebViewState(
            isLoading: _isLoading,
            canGoBack: _canGoBack,
            canGoForward: _canGoForward,
            url: _url,
            child: Builder(builder: widget.builder),
          ),
        ),
      ),
    );
  }
}

Widget _defaultTitleBar(BuildContext context) {
  final state = TitleBarWebViewState.of(context);
  final controller = TitleBarWebViewController.of(context);
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      IconButton(
        padding: EdgeInsets.zero,
        splashRadius: 16,
        iconSize: 16,
        onPressed: !state.canGoBack ? null : controller.back,
        icon: const Icon(Icons.arrow_back),
      ),
      IconButton(
        padding: EdgeInsets.zero,
        splashRadius: 16,
        iconSize: 16,
        onPressed: !state.canGoForward ? null : controller.forward,
        icon: const Icon(Icons.arrow_forward),
      ),
      if (state.isLoading)
        IconButton(
          padding: EdgeInsets.zero,
          splashRadius: 16,
          iconSize: 16,
          onPressed: controller.stop,
          icon: const Icon(Icons.close),
        )
      else
        IconButton(
          padding: EdgeInsets.zero,
          splashRadius: 16,
          iconSize: 16,
          onPressed: controller.reload,
          icon: const Icon(Icons.refresh),
        ),
      const Spacer()
    ],
  );
}
