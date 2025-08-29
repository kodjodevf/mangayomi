import 'dart:io';

import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_decoder_state_provider.g.dart';

final hwdecs = {
  "no": ["all"],
  "auto": ["all"],
  "d3d11va": ["windows"],
  "d3d11va-copy": ["windows"],
  "videotoolbox": ["ios"],
  "videotoolbox-copy": ["ios"],
  "nvdec": ["all"],
  "nvdec-copy": ["all"],
  "mediacodec": ["android"],
  "mediacodec-copy": ["android"],
  "crystalhd": ["all"],
};

@riverpod
class HwdecModeState extends _$HwdecModeState {
  @override
  String build({bool rawValue = false}) {
    final hwdecMode = isar.settings.getSync(227)!.hwdecMode ?? "auto";
    if (rawValue) {
      return hwdecMode;
    }
    final hwdecSupport = hwdecs[hwdecMode] ?? [];
    if (!hwdecSupport.contains("all") &&
        !hwdecSupport.contains(Platform.operatingSystem)) {
      return Platform.isAndroid ? "auto-safe" : "auto";
    }
    return hwdecMode;
  }

  void set(String value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..hwdecMode = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class EnableHardwareAccelState extends _$EnableHardwareAccelState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.enableHardwareAcceleration ??
            Platform.isMacOS
        ? false
        : true;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..enableHardwareAcceleration = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class DebandingState extends _$DebandingState {
  @override
  DebandingType build() {
    return isar.settings.getSync(227)!.debandingType;
  }

  void set(DebandingType value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..debandingType = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class UseGpuNextState extends _$UseGpuNextState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.enableGpuNext ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..enableGpuNext = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class UseYUV420PState extends _$UseYUV420PState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.useYUV420P ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..useYUV420P = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
