import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'general_state_provider.g.dart';

@riverpod
class CustomDnsState extends _$CustomDnsState {
  @override
  String build() {
    return isar.settings.getSync(227)!.customDns ?? "";
  }

  void set(String value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..customDns = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class EnableDiscordRpcState extends _$EnableDiscordRpcState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.enableDiscordRpc ?? true;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..enableDiscordRpc = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class HideDiscordRpcInIncognitoState extends _$HideDiscordRpcInIncognitoState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.hideDiscordRpcInIncognito ?? true;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..hideDiscordRpcInIncognito = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class RpcShowReadingWatchingProgressState
    extends _$RpcShowReadingWatchingProgressState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.rpcShowReadingWatchingProgress ?? true;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..rpcShowReadingWatchingProgress = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class RpcShowTitleState extends _$RpcShowTitleState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.rpcShowTitle ?? true;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..rpcShowTitle = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class RpcShowCoverImageState extends _$RpcShowCoverImageState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.rpcShowCoverImage ?? true;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..rpcShowCoverImage = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
