import 'package:flutter_discord_rpc_fork/flutter_discord_rpc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/general/providers/general_state_provider.dart';

class DiscordRPC {
  /// Id of the Discord Application
  final String applicationId;

  /// Whether it should reconnect to the discord client
  final bool autoRetry;

  /// Seconds between each attempt to reconnect
  final int retryDelayInSeconds;

  /// Start timestamp in millis
  final int startAt = DateTime.timestamp().millisecondsSinceEpoch;

  /// Start timestamp in millis for the current chapter/episode
  int chapterStartAt = 0;

  /// End timestamp in millis for the current chapter/episode
  int chapterEndAt = 0;

  /// Temp var
  late bool rpcShowReadingWatchingProgress;

  /// Instance of the current RPC activity
  final RpcActivity activity = RpcActivity(
    assets: const RPCAssets(largeImage: "app-icon", largeText: "Mangayomi"),
    buttons: [
      const RPCButton(
        label: "Get Mangayomi",
        url: "https://github.com/kodjodevf/mangayomi",
      ),
      const RPCButton(
        label: "Join us",
        url: "https://discord.com/invite/EjfBuYahsP",
      ),
    ],
    details: "Idle",
    state: "-----",
    timestamps: RPCTimestamps(
      start: DateTime.timestamp().millisecondsSinceEpoch,
    ),
    activityType: ActivityType.watching,
  );

  DiscordRPC({
    required this.applicationId,
    this.autoRetry = true,
    this.retryDelayInSeconds = 10,
  });

  Future<void> initialize() async {
    await FlutterDiscordRPC.initialize(applicationId);
  }

  Future<void> connect(WidgetRef ref) async {
    final enableDiscordRpc = ref.read(enableDiscordRpcStateProvider);
    final incognitoMode = ref.read(incognitoModeStateProvider);
    final hideDiscordRpcInIncognito = ref.read(
      hideDiscordRpcInIncognitoStateProvider,
    );
    rpcShowReadingWatchingProgress = ref.read(
      rpcShowReadingWatchingProgressStateProvider,
    );
    if (enableDiscordRpc && (!hideDiscordRpcInIncognito || !incognitoMode)) {
      await FlutterDiscordRPC.instance.connect(
        autoRetry: autoRetry,
        retryDelay: Duration(seconds: retryDelayInSeconds),
      );
      await Future.delayed(Duration(seconds: 3));
      showIdleText();
    }
  }

  Future<void> showIdleText() async {
    await updateActivity(
      details: "Idle",
      state: "-----",
      assets: const RPCAssets(largeImage: "app-icon", largeText: "Mangayomi"),
    );
  }

  Future<void> showChapterDetails(WidgetRef ref, Chapter chapter) async {
    final status = chapter.manga.value!.itemType == ItemType.anime
        ? "Watching"
        : "Reading";
    final title = chapter.manga.value!.name;
    final chapterTitle = chapter.name;
    final rpcShowTitle = ref.read(rpcShowTitleStateProvider);
    final rpcShowCoverImage = ref.read(rpcShowCoverImageStateProvider);
    await updateActivity(
      details: rpcShowTitle ? "$status $title" : "Idle",
      state: rpcShowTitle && rpcShowReadingWatchingProgress
          ? chapterTitle
          : "-----",
      assets: rpcShowCoverImage
          ? RPCAssets(
              largeImage: chapter.manga.value!.imageUrl,
              largeText: rpcShowTitle ? chapter.manga.value!.name : "-----",
              smallImage: "app-icon",
              smallText: "Mangayomi",
            )
          : const RPCAssets(largeImage: "app-icon", largeText: "Mangayomi"),
    );
  }

  Future<void> showLargeImage() async {
    await updateActivity(
      assets: const RPCAssets(largeImage: "app-icon", largeText: "Mangayomi"),
    );
  }

  Future<void> showSmallImage(String largeImage, String largeText) async {
    await updateActivity(
      assets: RPCAssets(
        largeImage: largeImage,
        largeText: largeText,
        smallImage: "app-icon",
        smallText: "Mangayomi",
      ),
    );
  }

  Future<void> showOriginalTimestamp() async {
    await updateActivity(timestamps: RPCTimestamps(start: startAt));
  }

  Future<void> startChapterTimestamp(
    int offsetInMillis,
    int durationInMillis,
  ) async {
    if (!rpcShowReadingWatchingProgress) {
      return;
    }
    chapterStartAt = DateTime.timestamp().millisecondsSinceEpoch;
    chapterEndAt =
        DateTime.timestamp().millisecondsSinceEpoch + durationInMillis;
    await updateActivity(
      timestamps: RPCTimestamps(
        start: chapterStartAt,
        end: chapterEndAt - offsetInMillis,
      ),
    );
  }

  Future<void> updateChapterTimestamp(int newOffsetInMillis) async {
    if (!rpcShowReadingWatchingProgress) {
      return;
    }
    await updateActivity(
      timestamps: RPCTimestamps(
        start: chapterStartAt,
        end: chapterEndAt - newOffsetInMillis,
      ),
    );
  }

  Future<void> updateActivity({
    String? state,
    String? details,
    RPCTimestamps? timestamps,
    RPCParty? party,
    RPCAssets? assets,
    RPCSecrets? secrets,
    List<RPCButton>? buttons,
    ActivityType? activityType,
  }) async {
    if (!FlutterDiscordRPC.instance.isConnected) {
      return;
    }
    if (state != null) {
      activity.state = state;
    }
    if (details != null) {
      activity.details = details;
    }
    if (timestamps != null) {
      activity.timestamps = timestamps;
    }
    if (party != null) {
      activity.party = party;
    }
    if (assets != null) {
      activity.assets = assets;
    }
    if (secrets != null) {
      activity.secrets = secrets;
    }
    if (buttons != null) {
      activity.buttons = buttons;
    }
    if (activityType != null) {
      activity.activityType = activityType;
    }
    await FlutterDiscordRPC.instance.setActivity(
      activity: activity.toRPCActivity(),
    );
  }

  Future<void> disconnect() async {
    if (!FlutterDiscordRPC.instance.isConnected) return;
    await FlutterDiscordRPC.instance.disconnect();
  }

  Future<void> destroy() async {
    await FlutterDiscordRPC.instance.disconnect();
    await FlutterDiscordRPC.instance.dispose();
  }
}

class RpcActivity {
  String? state;
  String? details;
  RPCTimestamps? timestamps;
  RPCParty? party;
  RPCAssets? assets;
  RPCSecrets? secrets;
  List<RPCButton>? buttons;
  ActivityType? activityType;

  RpcActivity({
    this.state,
    this.details,
    this.timestamps,
    this.party,
    this.assets,
    this.secrets,
    this.buttons,
    this.activityType,
  });

  RPCActivity toRPCActivity() {
    return RPCActivity(
      state: state,
      details: details,
      timestamps: timestamps,
      party: party,
      assets: assets,
      secrets: secrets,
      buttons: buttons,
      activityType: activityType,
    );
  }
}
