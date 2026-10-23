import 'dart:async';
import 'dart:io';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:mangayomi/utils/error_toast.dart';
import 'package:mangayomi/utils/log/logger.dart';

const _channelId = 'mangayomi_background_work';
const _serviceId = 1207;

/// An Android foreground service that keeps the app alive while it works,
/// with its notification. It does no work itself: downloads and updates go on
/// where they already run, the service only stops Android from killing the
/// process under them.
///
/// Start, update and stop run one after another, so that none reads a
/// running state another is about to change.
abstract final class ForegroundService {
  static bool get isSupported => Platform.isAndroid;

  static Future<void> _last = Future.value();
  static bool _initialized = false;
  static bool _running = false;

  static void _enqueue(Future<void> Function() action) {
    _last = _last.then((_) => action()).catchError((Object e, StackTrace s) {
      recordError(e, stack: s, source: 'foreground_service');
    });
  }

  /// Shows the notification and starts the service, unless it runs already.
  ///
  /// Must be called while the app is on screen: Android 12 and later refuse a
  /// foreground service started from the background. Failing to start only
  /// leaves the work unprotected; it is logged, not reported.
  static void start({
    required String channelName,
    required String title,
    required String text,
    required List<NotificationButton> buttons,
    required Function callback,
  }) {
    if (!isSupported) return;
    _enqueue(() async {
      if (_running) return;
      await _askNotificationPermission();
      _init(channelName);
      final result = await FlutterForegroundTask.startService(
        serviceId: _serviceId,
        serviceTypes: const [ForegroundServiceTypes.dataSync],
        notificationTitle: title,
        notificationText: text,
        notificationButtons: buttons,
        callback: callback,
      );
      if (result is ServiceRequestFailure) {
        AppLogger.log(
          'Foreground service not started: ${result.error}',
          logLevel: LogLevel.warning,
        );
        return;
      }
      _running = true;
    });
  }

  static void update({
    required String title,
    required String text,
    required List<NotificationButton> buttons,
  }) {
    if (!isSupported) return;
    _enqueue(() async {
      if (!_running) return;
      final result = await FlutterForegroundTask.updateService(
        notificationTitle: title,
        notificationText: text,
        notificationButtons: buttons,
      );
      // Android stops a data sync service that has run too long; it is
      // started again with the next work.
      if (result is ServiceRequestFailure) _running = false;
    });
  }

  static void stop() {
    if (!isSupported) return;
    _enqueue(() async {
      if (!_running) return;
      _running = false;
      await FlutterForegroundTask.stopService();
    });
  }

  static void _init(String channelName) {
    if (_initialized) return;
    _initialized = true;
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: _channelId,
        channelName: channelName,
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot: false,
        autoRunOnMyPackageReplaced: false,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  /// Android 13 and later need it to show the notification. Asked only while
  /// undecided; the service runs without it, just without a notification.
  static Future<void> _askNotificationPermission() async {
    try {
      if (await FlutterForegroundTask.checkNotificationPermission() ==
          NotificationPermission.denied) {
        await FlutterForegroundTask.requestNotificationPermission();
      }
    } catch (e, s) {
      recordError(
        e,
        stack: s,
        source: 'foreground_service',
        level: LogLevel.warning,
      );
    }
  }
}
