import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'general_state_provider.g.dart';

@riverpod
class CustomDnsState extends _$CustomDnsState {
  @override
  String build() {
    return settingsRepository.current.customDns ?? "";
  }

  void set(String value) {
    state = value;
    settingsRepository.update((s) => s.customDns = value);
  }
}

@riverpod
class EnableDiscordRpcState extends _$EnableDiscordRpcState {
  @override
  bool build() {
    return settingsRepository.current.enableDiscordRpc ?? true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.enableDiscordRpc = value);
  }
}

@riverpod
class HideDiscordRpcInIncognitoState extends _$HideDiscordRpcInIncognitoState {
  @override
  bool build() {
    return settingsRepository.current.hideDiscordRpcInIncognito ?? true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.hideDiscordRpcInIncognito = value);
  }
}

@riverpod
class RpcShowReadingWatchingProgressState
    extends _$RpcShowReadingWatchingProgressState {
  @override
  bool build() {
    return settingsRepository.current.rpcShowReadingWatchingProgress ?? true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update(
      (s) => s.rpcShowReadingWatchingProgress = value,
    );
  }
}

@riverpod
class RpcShowTitleState extends _$RpcShowTitleState {
  @override
  bool build() {
    return settingsRepository.current.rpcShowTitle ?? true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.rpcShowTitle = value);
  }
}

@riverpod
class RpcShowCoverImageState extends _$RpcShowCoverImageState {
  @override
  bool build() {
    return settingsRepository.current.rpcShowCoverImage ?? true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.rpcShowCoverImage = value);
  }
}

@riverpod
class UserAgentState extends _$UserAgentState {
  @override
  String build() {
    return settingsRepository.current.userAgent!;
  }

  void set(String value) {
    state = value;
    settingsRepository.update((s) => s.userAgent = value);
  }
}
