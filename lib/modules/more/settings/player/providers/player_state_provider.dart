import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'player_state_provider.g.dart';

@riverpod
class MarkEpisodeAsSeenTypeState extends _$MarkEpisodeAsSeenTypeState {
  @override
  int build() {
    return isar.settings.getSync(227)!.markEpisodeAsSeenType ?? 75;
  }

  void set(int value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings!..markEpisodeAsSeenType = value));
  }
}

@riverpod
class DefaultSkipIntroLengthState extends _$DefaultSkipIntroLengthState {
  @override
  int build() {
    return isar.settings.getSync(227)!.defaultSkipIntroLength ?? 85;
  }

  void set(int value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings!..defaultSkipIntroLength = value));
  }
}

@riverpod
class DefaultDoubleTapToSkipLengthState
    extends _$DefaultDoubleTapToSkipLengthState {
  @override
  int build() {
    return isar.settings.getSync(227)!.defaultDoubleTapToSkipLength ?? 10;
  }

  void set(int value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(() =>
        isar.settings.putSync(settings!..defaultDoubleTapToSkipLength = value));
  }
}

@riverpod
class DefaultPlayBackSpeedState extends _$DefaultPlayBackSpeedState {
  @override
  double build() {
    return isar.settings.getSync(227)!.defaultPlayBackSpeed ?? 1.0;
  }

  void set(double value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings!..defaultPlayBackSpeed = value));
  }
}

@riverpod
class FullScreenPlayerState extends _$FullScreenPlayerState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.fullScreenPlayer ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings!..fullScreenPlayer = value));
  }
}

@riverpod
class EnableAniSkipState extends _$EnableAniSkipState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.enableAniSkip ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings!..enableAniSkip = value));
  }
}

@riverpod
class EnableAutoSkipState extends _$EnableAutoSkipState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.enableAutoSkip ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings!..enableAutoSkip = value));
  }
}

@riverpod
class AniSkipTimeoutLengthState extends _$AniSkipTimeoutLengthState {
  @override
  int build() {
    return isar.settings.getSync(227)!.aniSkipTimeoutLength ?? 5;
  }

  void set(int value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings!..aniSkipTimeoutLength = value));
  }
}

@riverpod
class UseLibassState extends _$UseLibassState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.useLibass ?? true;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings!..useLibass = value));
  }
}