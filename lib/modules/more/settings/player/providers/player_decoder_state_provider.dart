import 'dart:io';

import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
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
    final hwdecMode = settingsRepository.current.hwdecMode ?? "auto";
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
    state = value;
    settingsRepository.update((s) => s.hwdecMode = value);
  }
}

@riverpod
class EnableHardwareAccelState extends _$EnableHardwareAccelState {
  @override
  bool build() {
    return settingsRepository.current.enableHardwareAcceleration ??
            Platform.isMacOS
        ? false
        : true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.enableHardwareAcceleration = value);
  }
}

@riverpod
class DebandingState extends _$DebandingState {
  @override
  DebandingType build() {
    return settingsRepository.current.debandingType;
  }

  void set(DebandingType value) {
    state = value;
    settingsRepository.update((s) => s.debandingType = value);
  }
}

@riverpod
class UseGpuNextState extends _$UseGpuNextState {
  @override
  bool build() {
    return settingsRepository.current.enableGpuNext ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.enableGpuNext = value);
  }
}

@riverpod
class UseYUV420PState extends _$UseYUV420PState {
  @override
  bool build() {
    return settingsRepository.current.useYUV420P ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.useYUV420P = value);
  }
}
