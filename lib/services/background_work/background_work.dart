import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/services/background_work/foreground_service.dart';
import 'package:mangayomi/utils/localized_message.dart';

/// What the app can be busy with while it is off screen.
enum BackgroundWorkKind {
  download,
  libraryUpdate,
  restore,
  sync;

  /// The notification button stopping this work, if it can be stopped.
  String? get stopAction => switch (this) {
    download => 'cancel_downloads',
    libraryUpdate => 'stop_library_update',
    restore || sync => null,
  };
}

/// How far one kind of work has got.
class BackgroundWorkProgress {
  const BackgroundWorkProgress({
    this.done = 0,
    this.total = 0,
    this.current,
    this.detail,
  });

  /// Items finished out of [total]; 0 of 0 when there is no count.
  final int done;
  final int total;

  /// How far the item in progress is, 0 to 1.
  final double? current;

  /// What is being worked on, such as a chapter's title. Left out when the
  /// notification's content is hidden.
  final String? detail;
}

/// The single notification and foreground service shared by everything the
/// app does in the background.
///
/// Several kinds of work can run at once: the service starts with the first,
/// stops with the last, and its notification sums up all of them. Updates
/// are kept to one every [_updateInterval], as progress arrives much faster
/// than a notification is worth redrawing.
abstract final class BackgroundWork {
  static const _updateInterval = Duration(milliseconds: 500);

  static final _work = <BackgroundWorkKind, BackgroundWorkProgress>{};
  static DateTime? _lastUpdate;
  static (String, String)? _lastShown;

  /// Called with a stop button's action when it is pressed.
  static void Function(String action)? onAction;

  static bool isRunning(BackgroundWorkKind kind) => _work.containsKey(kind);

  /// Whether [report] would reach the notification now, so a caller can skip
  /// working out progress that would be dropped.
  static bool get wantsReport =>
      ForegroundService.isSupported &&
      _work.isNotEmpty &&
      (_lastUpdate == null ||
          DateTime.now().difference(_lastUpdate!) >= _updateInterval);

  /// Whether the notification may say what is being worked on.
  static bool get showsDetail =>
      !(settingsRepository.currentOrNull?.hideNotificationContent ?? false);

  static void begin(BackgroundWorkKind kind) {
    if (!ForegroundService.isSupported || _work.containsKey(kind)) return;
    final first = _work.isEmpty;
    _work[kind] = const BackgroundWorkProgress();
    final (title, text) = _content();
    if (first) {
      _lastShown = (title, text);
      ForegroundService.start(
        channelName: localizedMessage((l10n) => l10n.background_work),
        title: title,
        text: text,
        buttons: _buttons(),
        callback: backgroundWorkTaskCallback,
      );
    } else {
      _show(force: true);
    }
  }

  static void report(BackgroundWorkKind kind, BackgroundWorkProgress progress) {
    if (!_work.containsKey(kind)) return;
    _work[kind] = progress;
    _show();
  }

  static void end(BackgroundWorkKind kind) {
    if (_work.remove(kind) == null) return;
    if (_work.isEmpty) {
      _lastUpdate = null;
      _lastShown = null;
      ForegroundService.stop();
    } else {
      _show(force: true);
    }
  }

  /// A notification button was pressed.
  static void handleAction(Object? action) {
    if (action is String) onAction?.call(action);
  }

  static void _show({bool force = false}) {
    final now = DateTime.now();
    if (!force &&
        _lastUpdate != null &&
        now.difference(_lastUpdate!) < _updateInterval) {
      return;
    }
    _lastUpdate = now;
    final content = _content();
    if (!force && content == _lastShown) return;
    _lastShown = content;
    ForegroundService.update(
      title: content.$1,
      text: content.$2,
      buttons: _buttons(),
    );
  }

  static (String, String) _content() => localizedMessage(
    (l10n) => (
      backgroundWorkTitle(l10n, _work.keys),
      backgroundWorkText(l10n, _work, showDetail: showsDetail),
    ),
  );

  static List<NotificationButton> _buttons() => localizedMessage(
    (l10n) => [
      for (final kind in _work.keys)
        if (kind.stopAction case final action?)
          NotificationButton(
            id: action,
            text: switch (kind) {
              BackgroundWorkKind.download => l10n.background_cancel_downloads,
              _ => l10n.background_stop_update,
            },
          ),
    ],
  );
}

String _label(AppLocalizations l10n, BackgroundWorkKind kind) => switch (kind) {
  BackgroundWorkKind.download => l10n.background_downloading,
  BackgroundWorkKind.libraryUpdate => l10n.background_updating_library,
  BackgroundWorkKind.restore => l10n.background_restoring,
  BackgroundWorkKind.sync => l10n.background_syncing,
};

/// The notification's title: what is going on, every kind of it.
String backgroundWorkTitle(
  AppLocalizations l10n,
  Iterable<BackgroundWorkKind> kinds,
) => kinds.map((kind) => _label(l10n, kind)).join(' · ');

/// The notification's text, one line per kind of work:
/// `5 / 12 · 42 %` then what is being worked on, unless [showDetail] is off.
/// With a single kind, the title already names it.
String backgroundWorkText(
  AppLocalizations l10n,
  Map<BackgroundWorkKind, BackgroundWorkProgress> work, {
  required bool showDetail,
}) {
  final lines = <String>[];
  for (final MapEntry(key: kind, value: progress) in work.entries) {
    final parts = [
      if (work.length > 1) _label(l10n, kind),
      if (progress.total > 0) '${progress.done} / ${progress.total}',
      if (progress.current case final current?)
        '${(current.clamp(0, 1) * 100).floor()} %',
      if (showDetail && (progress.detail?.isNotEmpty ?? false))
        progress.detail!,
    ];
    if (parts.isNotEmpty) lines.add(parts.join(' · '));
  }
  return lines.isEmpty ? l10n.background_work_in_progress : lines.join('\n');
}

/// Runs in the service's own isolate: passes the notification's buttons on
/// to the app.
@pragma('vm:entry-point')
void backgroundWorkTaskCallback() {
  FlutterForegroundTask.setTaskHandler(_NotificationRelay());
}

class _NotificationRelay extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {}

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {}

  @override
  void onNotificationButtonPressed(String id) =>
      FlutterForegroundTask.sendDataToMain(id);

  @override
  void onNotificationPressed() => FlutterForegroundTask.launchApp();
}
