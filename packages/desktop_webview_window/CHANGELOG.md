## 0.2.3

* fix macOS webview window size not working.

## 0.2.2

* fix memory leak on macOS after close webview window.
* Show and Hide Webview window by [@Iri-Hor](https://github.com/Iri-Hor) in [#268](https://github.com/MixinNetwork/flutter-plugins/pull/268)

## 0.2.1

* add Windows attentions to readme.
* fix linux close sub window cause app exited.
* fix linux webview title bar expanded unexpected.
* More control over webview position and size under windows. [#206](https://github.com/MixinNetwork/flutter-plugins/pull/206) by [Lukas Heinze](https://github.com/Iri-Hor)
* fix zone mismatch [#250](https://github.com/MixinNetwork/flutter-plugins/pull/250) by [CD](https://github.com/459217974)
* fix linux webkit2gtk deprecated error [#246](https://github.com/MixinNetwork/flutter-plugins/pull/246) by [Zhiqiang Zhang](https://github.com/zhangzqs)

## 0.2.0

* BREAK CHANGE: bump linux webkit2gtk version to 4.1

## 0.1.6

* fix WebView render area wrong offset on Windows.

## 0.1.5

* add `close` method for WebView.
* add `onUrlRequest` event for WebView.

## 0.1.4

* support custom userDataFolder on Windows.
* fix open web view failed cause crash on Windows.

## 0.1.3

Remove windows addition import requirements.

## 0.1.2

fix TitleBar reload do not work.

## 0.1.1

fix window title not show on macOS

## 0.1.0

support custom titlebar.

NOTE: contains break change. more details see readme.

## 0.0.7

1. support `isWebviewAvailable` check.
2. fix `clearAll` crash on Linux if no webview created.

## 0.0.6

fix swift definition conflict on macOS.  [flutter-plugins#17](https://github.com/MixinNetwork/flutter-plugins/issues/17)

## 0.0.5

add `setApplicationNameForUserAgent` for append application name to webview user agent.

## 0.0.4

1. implement `addScriptToExecuteOnDocumentCreated` on macOS.
2. add hot key `command + w` to close window.

## 0.0.3

fix linux build

## 0.0.2

* rename project to desktop_webview_window

## 0.0.1

* add Windows, Linux, macOS support.
