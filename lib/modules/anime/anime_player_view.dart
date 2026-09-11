import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:ffi/ffi.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qjs/quickjs/ffi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riv;
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/custom_button_repository.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/custom_button.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/video.dart' as vid;
import 'package:mangayomi/modules/anime/providers/anime_player_controller_provider.dart';
import 'package:mangayomi/modules/anime/providers/auto_play_next_provider.dart';
import 'package:mangayomi/modules/anime/utils/player_lifecycle.dart';
import 'package:mangayomi/modules/anime/widgets/aniskip_countdown_btn.dart';
import 'package:mangayomi/modules/anime/widgets/tv_player_controls.dart';
import 'package:mangayomi/modules/anime/widgets/tv_player_settings_panel.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/anime/widgets/desktop.dart';
import 'package:mangayomi/modules/anime/widgets/play_or_pause_button.dart';
import 'package:mangayomi/utils/manga_cover_actions.dart';
import 'package:mangayomi/modules/manga/reader/widgets/btn_chapter_list_dialog.dart';
import 'package:mangayomi/modules/anime/widgets/mobile.dart';
import 'package:mangayomi/modules/anime/widgets/subtitle_view.dart';
import 'package:mangayomi/modules/anime/widgets/subtitle_setting_widget.dart';
import 'package:mangayomi/modules/anime/widgets/unified_settings_sheet.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_audio_state_provider.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_decoder_state_provider.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_state_provider.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/aniskip.dart';
import 'package:mangayomi/services/fetch_subtitles.dart';
import 'package:mangayomi/services/get_video_list.dart';
import 'package:mangayomi/services/torrent_server.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/utils/share.dart';
import 'package:mangayomi/utils/system_ui.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit/generated/libmpv/bindings.dart' as generated;
import 'package:media_kit_video/media_kit_video.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:window_manager/window_manager.dart' show windowManager;

import 'widgets/search_subtitles.dart';

class AnimePlayerView extends riv.ConsumerStatefulWidget {
  final int episodeId;
  const AnimePlayerView({super.key, required this.episodeId});

  @override
  riv.ConsumerState<AnimePlayerView> createState() => _AnimePlayerViewState();
}

class _AnimePlayerViewState extends riv.ConsumerState<AnimePlayerView> {
  late final Chapter episode = chapterRepository.getById(widget.episodeId);
  List<String> _infoHashList = [];
  bool desktopFullScreenPlayer = false;
  bool _episodeReplacementInProgress = false;
  @override
  void dispose() {
    if (shouldExitDesktopFullscreenOnDispose(
      isDesktop: isDesktop,
      isFullscreen: desktopFullScreenPlayer,
      isEpisodeReplacement: _episodeReplacementInProgress,
    )) {
      unawaited(setFullScreen(value: false));
    }
    for (var infoHash in _infoHashList) {
      MTorrentServer().removeTorrent(infoHash);
    }
    restoreSystemUI();
    super.dispose();
  }

  Widget _buildLoading() {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(''),
        leading: IconButton(
          color: Colors.white,
          // Lets the remote bail out of a hung load. IconButton, not
          // BackButton, because only it takes autofocus.
          autofocus: isTv,
          icon: const BackButtonIcon(),
          onPressed: () {
            restoreSystemUI();
            Navigator.pop(context);
          },
        ),
      ),
      body: const ProgressCenter(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultSubtitleLang = ref.watch(defaultSubtitleLangStateProvider);
    ref.listen(getVideoListProvider(episode: episode), (previous, next) {
      if (next is riv.AsyncData) {
        final infoHashes = next.value?.$3 ?? [];
        _infoHashList = infoHashes;
        if (!mounted) {
          for (var infoHash in infoHashes) {
            MTorrentServer().removeTorrent(infoHash);
          }
        }
      }
    });
    final serversData = ref.watch(getVideoListProvider(episode: episode));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return serversData.when(
      data: (data) {
        final (videos, isLocal, infoHashList, mpvDirectory) = data;
        _infoHashList = infoHashList;
        if (videos.isEmpty && !(episode.manga.value!.isLocalArchive ?? false)) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              title: const Text(''),
              leading: BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Center(child: Text(context.l10n.video_list_empty)),
          );
        }

        return AnimeStreamPage(
          defaultSubtitle: completeLanguageNameEnglish(
            defaultSubtitleLang.toLanguageTag(),
          ),
          episode: episode,
          videos: videos,
          isLocal: isLocal,
          isTorrent: infoHashList.isNotEmpty,
          infoHashList: infoHashList,
          desktopFullScreenPlayer: (value) {
            desktopFullScreenPlayer = value;
          },
          onEpisodeReplacement: () {
            _episodeReplacementInProgress = true;
          },
          mpvDirectory: mpvDirectory,
        );
      },
      error: (error, stackTrace) {
        if (serversData.isRefreshing || serversData.isReloading) {
          return _buildLoading();
        }
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text(''),
            leading: IconButton(
              // The error body is just text, so focus this or the remote is stuck.
              // IconButton, not BackButton, because only it takes autofocus.
              autofocus: isTv,
              icon: const BackButtonIcon(),
              onPressed: () {
                restoreSystemUI();
                Navigator.pop(context);
              },
            ),
          ),
          // The back button above already claims TV focus, so the retry must
          // not also ask for it; it stays reachable with the d-pad.
          body: ErrorState(
            autofocusRetry: false,
            detail: error.toString(),
            onRetry: () =>
                ref.invalidate(getVideoListProvider(episode: episode)),
          ),
        );
      },
      loading: () {
        return _buildLoading();
      },
    );
  }
}

class AnimeStreamPage extends riv.ConsumerStatefulWidget {
  final List<vid.Video> videos;
  final Chapter episode;
  final String defaultSubtitle;
  final bool isLocal;
  final bool isTorrent;
  final List<String> infoHashList;
  final Directory? mpvDirectory;
  final void Function(bool) desktopFullScreenPlayer;
  final VoidCallback onEpisodeReplacement;
  const AnimeStreamPage({
    super.key,
    required this.defaultSubtitle,
    required this.isLocal,
    required this.videos,
    required this.episode,
    required this.isTorrent,
    this.infoHashList = const [],
    required this.desktopFullScreenPlayer,
    required this.onEpisodeReplacement,
    required this.mpvDirectory,
  });

  @override
  riv.ConsumerState<AnimeStreamPage> createState() => _AnimeStreamPageState();
}

enum _AniSkipPhase { none, opening, ending }

/// When the user first opens a video (on Desktop).
/// Only used for fullscreen/windowed behavior.
bool _firstTime = true;

class _AnimeStreamPageState extends riv.ConsumerState<AnimeStreamPage>
    with
        _AlwaysOnTopStateMixin,
        TickerProviderStateMixin,
        WidgetsBindingObserver {
  bool _routeExitInProgress = false;
  bool _videoTextureVisible = true;
  late final GlobalKey<VideoState> _key = GlobalKey<VideoState>();
  late final useLibass = ref.read(useLibassStateProvider);
  late final useMpvConfig = ref.read(useMpvConfigStateProvider);
  late final useGpuNext = ref.read(useGpuNextStateProvider);
  late final debandingType = ref.read(debandingStateProvider);
  late final useYUV420P = ref.read(useYUV420PStateProvider);
  late final audioPreferredLang = ref.read(audioPreferredLangStateProvider);
  late final enableAudioPitchCorrection = ref.read(
    enableAudioPitchCorrectionStateProvider,
  );
  late final audioChannel = ref.read(audioChannelStateProvider);
  late final volumeBoostCap = ref.read(volumeBoostCapStateProvider);
  late final Player _player = Player(
    configuration: PlayerConfiguration(
      libass: useLibass,
      config: true,
      configDir: useMpvConfig ? widget.mpvDirectory?.path ?? "" : "",
      options: {
        if (debandingType == DebandingType.cpu) "vf": "gradfun=radius=12",
        if (debandingType == DebandingType.gpu) "deband": "yes",
        if (useYUV420P) "vf": "format=yuv420p",
        if (audioPreferredLang.isNotEmpty) "alang": audioPreferredLang,
        if (enableAudioPitchCorrection) "audio-pitch-correction": "yes",
        "volume-max": "${volumeBoostCap + 100}",
        if (audioChannel != AudioChannel.reverseStereo)
          "audio-channels": audioChannel.mpvName,
        if (audioChannel == AudioChannel.reverseStereo)
          "af": audioChannel.mpvName,
      },
      observeProperties: {
        "user-data/aniyomi/show_text": generated.mpv_format.MPV_FORMAT_NODE,
        "user-data/aniyomi/toggle_ui": generated.mpv_format.MPV_FORMAT_NODE,
        "user-data/aniyomi/show_panel": generated.mpv_format.MPV_FORMAT_NODE,
        "user-data/aniyomi/software_keyboard":
            generated.mpv_format.MPV_FORMAT_NODE,
        "user-data/aniyomi/set_button_title":
            generated.mpv_format.MPV_FORMAT_NODE,
        "user-data/aniyomi/reset_button_title":
            generated.mpv_format.MPV_FORMAT_NODE,
        "user-data/aniyomi/toggle_button": generated.mpv_format.MPV_FORMAT_NODE,
        "user-data/aniyomi/switch_episode":
            generated.mpv_format.MPV_FORMAT_NODE,
        "user-data/aniyomi/pause": generated.mpv_format.MPV_FORMAT_NODE,
        "user-data/aniyomi/seek_by": generated.mpv_format.MPV_FORMAT_NODE,
        "user-data/aniyomi/seek_to": generated.mpv_format.MPV_FORMAT_NODE,
        "user-data/aniyomi/seek_by_with_text":
            generated.mpv_format.MPV_FORMAT_NODE,
        "user-data/aniyomi/seek_to_with_text":
            generated.mpv_format.MPV_FORMAT_NODE,
        "user-data/aniyomi/launch_int_picker":
            generated.mpv_format.MPV_FORMAT_NODE,
        "user-data/mangayomi/chapter_titles":
            generated.mpv_format.MPV_FORMAT_NODE,
        "user-data/mangayomi/current_chapter":
            generated.mpv_format.MPV_FORMAT_INT64,
        "user-data/mangayomi/selected_shader":
            generated.mpv_format.MPV_FORMAT_NODE,
      },
      eventHandler: _handleMpvEvents,
    ),
  );
  late final hwdecMode = ref.read(hwdecModeStateProvider());
  late final enableHardwareAccel = ref.read(enableHardwareAccelStateProvider);
  late final VideoController _controller;
  late final _streamController = ref.read(
    animeStreamControllerProvider(episode: widget.episode).notifier,
  );
  final Stopwatch _watchStopwatch = Stopwatch();
  late final _firstVid = widget.videos.first;
  late final ValueNotifier<VideoPrefs?> _video = ValueNotifier(
    VideoPrefs(
      videoTrack: VideoTrack(
        widget.isLocal ? _firstVid.originalUrl : _firstVid.url,
        _firstVid.quality,
        _firstVid.quality,
      ),
      headers: _firstVid.headers,
    ),
  );

  final ValueNotifier<double> _playbackSpeed = ValueNotifier(1.0);
  final ValueNotifier<bool> _isDoubleSpeed = ValueNotifier(false);
  late final ValueNotifier<Duration> _currentPosition = ValueNotifier(
    _streamController.getCurrentPosition(),
  );
  final ValueNotifier<Duration?> _currentTotalDuration = ValueNotifier(null);
  final ValueNotifier<bool> _showFitLabel = ValueNotifier(false);
  final ValueNotifier<bool> _isCompleted = ValueNotifier(false);
  final ValueNotifier<Duration?> _tempPosition = ValueNotifier(null);
  final ValueNotifier<BoxFit> _fit = ValueNotifier(BoxFit.contain);
  final ValueNotifier<List<(String, int)>> _chapterMarks = ValueNotifier([]);
  final ValueNotifier<int?> _currentChapterMark = ValueNotifier(null);
  final ValueNotifier<String> _selectedShader = ValueNotifier("");
  final ValueNotifier<ActiveCustomButton?> _customButton = ValueNotifier(null);
  final ValueNotifier<List<CustomButton>?> _customButtons = ValueNotifier(null);
  late final ValueNotifier<_AniSkipPhase> _skipPhase = ValueNotifier(
    _AniSkipPhase.none,
  );
  Results? _openingResult;
  Results? _endingResult;
  bool _hasOpeningSkip = false;
  bool _hasEndingSkip = false;
  bool _initSubtitleAndAudio = true;
  // Whatever subtitle/audio track is actually active right now, whether
  // picked by the user or applied as the default - so a quality change can
  // restore it instead of always falling back to the default track.
  SubtitleTrack? _activeSubtitleTrack;
  AudioTrack? _activeAudioTrack;
  bool _includeSubtitles = false;
  int _subDelay = 0;
  final _subDelayController = TextEditingController(text: "0");
  double _subSpeed = 1;
  final _subSpeedController = TextEditingController(text: "1.00");
  int lastRpcTimestampUpdate = DateTime.now().millisecondsSinceEpoch;

  late final StreamSubscription<Duration> _currentPositionSub;

  late final StreamSubscription<Duration> _currentTotalDurationSub = _player
      .stream
      .duration
      .listen((duration) {
        _currentTotalDuration.value = duration;
        discordRpc?.updateChapterTimestamp(_currentPosition.value, duration);
      });

  bool get hasNextEpisode => _streamController.hasNextEpisode;

  late final StreamSubscription<bool> _completed = _player.stream.completed
      .listen(_handlePlaybackCompleted);

  Future<void> _handlePlaybackCompleted(bool completed) async {
    if (!completed || !mounted) return;

    _watchStopwatch.stop();
    final reportedDuration = _currentTotalDuration.value;
    final totalDuration =
        reportedDuration != null && reportedDuration > Duration.zero
        ? reportedDuration
        : _player.state.duration;
    try {
      await _streamController.completeEpisode(
        totalDuration,
        elapsedSeconds: _watchStopwatch.elapsed.inSeconds,
      );
    } catch (_) {}
    _watchStopwatch.reset();
    if (!mounted) return;

    final hasNext = hasNextEpisode;
    if (hasNext && ref.read(autoPlayNextEpisodeProvider)) {
      pushToNewEpisode(context, _streamController.getNextEpisode());
      return;
    }

    // If the last episode of an Anime has ended, exit fullscreen mode.
    final isFullScreen = ref.read(fullscreenProvider);
    if (!hasNext && isDesktop && isFullScreen) {
      setFullScreen(value: false);
      ref.read(fullscreenProvider.notifier).state = false;
      widget.desktopFullScreenPlayer.call(false);
    }
  }

  Future<void> _handleMpvEvents(Pointer<generated.mpv_event> event) async {
    try {
      if (event.ref.event_id ==
          generated.mpv_event_id.MPV_EVENT_PROPERTY_CHANGE) {
        final prop = event.ref.data.cast<generated.mpv_event_property>();
        final propName = prop.ref.name.cast<Utf8>().toDartString();
        if (kDebugMode) {
          if (propName.startsWith("user-data/")) {
            print("DEBUG 00: $propName - ${prop.ref.format}");
          }
        }
        if (propName.startsWith("user-data/") &&
            prop.ref.format == generated.mpv_format.MPV_FORMAT_NODE) {
          final value = prop.ref.data.cast<generated.mpv_node>();
          _handleMpvNodeEvents(propName, value);
        } else if (propName.startsWith("user-data/") &&
            prop.ref.format == generated.mpv_format.MPV_FORMAT_INT64) {
          final value = prop.ref.data.cast<Int64>().value;
          _handleMpvNumberEvents(propName, value);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    }
  }

  String? _readMpvString(Pointer<generated.mpv_node> value) {
    if (value.ref.format != generated.mpv_format.MPV_FORMAT_STRING) return null;
    final text = value.ref.u.string.cast<Utf8>().toDartString();
    return text.isEmpty ? null : text;
  }

  Future<void> _seekTo(int absoluteSeconds) async {
    _tempPosition.value = Duration(seconds: absoluteSeconds);
    await _player.seek(Duration(seconds: absoluteSeconds));
    _tempPosition.value = null;
  }

  Future<void> _seekBy(int deltaSeconds) async {
    final pos = _currentPosition.value.inSeconds + deltaSeconds;
    await _seekTo(pos);
  }

  Future<void> _handleMpvNodeEvents(
    String propName,
    Pointer<generated.mpv_node> value,
  ) async {
    final nativePlayer = _player.platform as NativePlayer;
    switch (propName.substring(10)) {
      case "aniyomi/show_text":
        final text = _readMpvString(value);
        if (text == null) break;
        botToast(
          text,
          alignY: -0.99,
          second: 2,
          dismissDirections: const [
            DismissDirection.vertical,
            DismissDirection.horizontal,
          ],
          showIcon: false,
        );
        nativePlayer.setProperty("user-data/aniyomi/show_text", "");
        break;
      case "aniyomi/toggle_ui":
        final text = _readMpvString(value);
        if (text == null) break;
        switch (text) {
          // WIP
          case "show":
            break;
          case "hide":
            break;
          case "toggle":
            break;
        }
        nativePlayer.setProperty("user-data/aniyomi/toggle_ui", "");
        break;
      case "aniyomi/show_panel":
        final text = _readMpvString(value);
        if (text == null) break;
        switch (text) {
          // WIP
          case "subtitle_settings":
            break;
          case "subtitle_delay":
            break;
          case "audio_delay":
            break;
          case "video_filters":
            break;
        }
        nativePlayer.setProperty("user-data/aniyomi/show_panel", "");
        break;
      case "aniyomi/software_keyboard":
        final text = _readMpvString(value);
        if (text == null) break;
        switch (text) {
          // WIP
          case "show":
            break;
          case "hide":
            break;
          case "toggle":
            break;
        }
        nativePlayer.setProperty("user-data/aniyomi/software_keyboard", "");
        break;
      case "aniyomi/set_button_title":
        final text = _readMpvString(value);
        if (text == null) break;
        final temp = _customButton.value;
        if (temp == null) break;
        _customButton.value = temp..currentTitle = text;
        nativePlayer.setProperty("user-data/aniyomi/set_button_title", "");
        break;
      case "aniyomi/reset_button_title":
        final text = _readMpvString(value);
        if (text == null) break;
        final temp = _customButton.value;
        if (temp == null) break;
        _customButton.value = temp..currentTitle = temp.button.title ?? "";
        nativePlayer.setProperty("user-data/aniyomi/reset_button_title", "");
        break;
      case "aniyomi/toggle_button":
        final text = _readMpvString(value);
        if (text == null) break;
        final temp = _customButton.value;
        if (temp == null) break;
        switch (text) {
          case "show":
            _customButton.value = temp..visible = true;
            break;
          case "hide":
            _customButton.value = temp..visible = false;
            break;
          case "toggle":
            _customButton.value = temp..visible = !temp.visible;
            break;
        }
        nativePlayer.setProperty("user-data/aniyomi/toggle_button", "");
        break;
      case "aniyomi/switch_episode":
        final text = _readMpvString(value);
        if (text == null) break;
        switch (text) {
          case "n":
            pushToNewEpisode(context, _streamController.getNextEpisode());
            break;
          case "p":
            pushToNewEpisode(context, _streamController.getPrevEpisode());
            break;
        }
        nativePlayer.setProperty("user-data/aniyomi/switch_episode", "");
        break;
      case "aniyomi/pause":
        final text = _readMpvString(value);
        if (text == null) break;
        switch (text) {
          case "pause":
            await _player.pause();
            break;
          case "unpause":
            await _player.play();
            break;
          case "pauseunpause":
            await _player.playOrPause();
            break;
        }
        nativePlayer.setProperty("user-data/aniyomi/pause", "");
        break;
      case "aniyomi/seek_by":
        final text = _readMpvString(value);
        if (text == null) break;
        final data = int.parse(text.replaceAll("\"", ""));
        await _seekBy(data);
        nativePlayer.setProperty("user-data/aniyomi/seek_by", "");
        break;
      case "aniyomi/seek_to":
        final text = _readMpvString(value);
        if (text == null) break;
        final data = int.parse(text.replaceAll("\"", ""));
        await _seekTo(data);
        nativePlayer.setProperty("user-data/aniyomi/seek_to", "");
        break;
      case "aniyomi/seek_by_with_text":
        final text = _readMpvString(value);
        if (text == null) break;
        final data = text.split("|");
        await _seekBy(int.parse(data[0].replaceAll("\"", "")));
        (_player.platform as NativePlayer).command(["show-text", data[1]]);
        nativePlayer.setProperty("user-data/aniyomi/seek_by_with_text", "");
        break;
      case "aniyomi/seek_to_with_text":
        final text = _readMpvString(value);
        if (text == null) break;
        final data = text.split("|");
        await _seekTo(int.parse(data[0].replaceAll("\"", "")));
        (_player.platform as NativePlayer).command(["show-text", data[1]]);
        nativePlayer.setProperty("user-data/aniyomi/seek_to_with_text", "");
        break;
      case "aniyomi/launch_int_picker":
        final text = _readMpvString(value);
        if (text == null) break;
        final data = text.split("|");
        final start = int.parse(data[2]);
        final stop = int.parse(data[3]);
        final step = int.parse(data[4]);
        int currentValue = start;
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(data[0]),
              content: StatefulBuilder(
                builder: (context, setState) => SizedBox(
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NumberPicker(
                        value: currentValue,
                        minValue: start,
                        maxValue: stop,
                        step: step,
                        haptics: true,
                        textMapper: (numberText) =>
                            data[1].replaceAll("%d", numberText),
                        onChanged: (value) =>
                            setState(() => currentValue = value),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text(
                        context.l10n.cancel,
                        style: TextStyle(color: context.primaryColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final namePtr = data[5].toNativeUtf8();
                        final valuePtr = calloc<Int64>(1)..value = currentValue;
                        nativePlayer.mpv.mpv_set_property(
                          nativePlayer.ctx,
                          namePtr.cast(),
                          generated.mpv_format.MPV_FORMAT_INT64,
                          valuePtr.cast(),
                        );
                        malloc.free(namePtr);
                        malloc.free(valuePtr);
                        Navigator.pop(context);
                      },
                      child: Text(
                        context.l10n.ok,
                        style: TextStyle(color: context.primaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
        nativePlayer.setProperty("user-data/aniyomi/launch_int_picker", "");
        break;
      case "mangayomi/chapter_titles":
        if (value.ref.format == generated.mpv_format.MPV_FORMAT_STRING) {
          final text = value.ref.u.string.cast<Utf8>().toDartString();
          final data = jsonDecode(text) as List<dynamic>;
          _chapterMarks.value = data
              .map(
                (e) => (
                  e["title"] as String,
                  e["timestamp"] is double
                      ? (e["timestamp"] as double).toInt() * 1000
                      : (e["timestamp"] as int) * 1000,
                ),
              )
              .toList();
        }
        break;
      case "mangayomi/selected_shader":
        final text = _readMpvString(value);
        _selectedShader.value = text ?? '';
        break;
    }
  }

  Future<void> _handleMpvNumberEvents(String propName, int value) async {
    switch (propName.substring(10)) {
      case "mangayomi/current_chapter":
        _currentChapterMark.value = max(value, 0);
        break;
    }
  }

  Future<void> _initCustomButton() async {
    if (!useMpvConfig) return;
    final customButtons = customButtonRepository.getAllSortedByPos();
    if (customButtons.isEmpty) return;
    final primaryButton =
        customButtons.firstWhereOrNull((e) => e.isFavourite ?? false) ??
        customButtons.first;
    final provider = StorageProvider();
    if (!(await provider.requestPermission())) {
      return;
    }
    final dir = await provider.getMpvDirectory();
    String scriptsDir = path.join(dir!.path, 'scripts');
    final mpvFile = File('$scriptsDir/init_custom_buttons.lua');
    final content = StringBuffer();
    content.writeln("""local lua_modules = mp.find_config_file('scripts')
if lua_modules then
  package.path = package.path .. ';' .. lua_modules .. '/?.lua;' .. lua_modules .. '/?/init.lua;' .. '\${scriptsDir()!!.filePath}' .. '/?.lua'
end
local aniyomi = require 'init_aniyomi_functions'""");
    for (final button in customButtons) {
      content.writeln(
        """
${button.getButtonStartup(primaryButton.id!).trim()}
function button${button.id}()
  ${button.getButtonPress(primaryButton.id!).trim()}
end
mp.register_script_message('call_button_${button.id}', button${button.id})
function button${button.id}long()
  ${button.getButtonLongPress(primaryButton.id!).trim()}
end
mp.register_script_message('call_button_${button.id}_long', button${button.id}long)""",
      );
    }
    await mpvFile.writeAsString(content.toString());
    await (_player.platform as NativePlayer).command([
      "load-script",
      mpvFile.path,
    ]);
    _customButton.value = ActiveCustomButton(
      currentTitle: primaryButton.title!,
      visible: true,
      button: primaryButton,
      onPress: () => (_player.platform as NativePlayer).command([
        "script-message",
        "call_button_${primaryButton.id}",
      ]),
      onLongPress: () => (_player.platform as NativePlayer).command([
        "script-message",
        "call_button_${primaryButton.id}_long",
      ]),
    );
    _customButtons.value = customButtons;
  }

  Future<void> pushToNewEpisode(BuildContext context, Chapter episode) async {
    if (_routeExitInProgress) return;
    _routeExitInProgress = true;
    widget.desktopFullScreenPlayer.call(ref.read(fullscreenProvider));
    widget.onEpisodeReplacement();
    await _retireVideoTexture();
    if (context.mounted) {
      pushReplacementMangaReaderView(context: context, chapter: episode);
    }
  }

  Future<void> _retireVideoTexture() async {
    if (!_videoTextureVisible || !mounted) return;
    await retirePlaybackSurface(
      hideSurface: () {
        if (mounted) setState(() => _videoTextureVisible = false);
      },
      waitForFrame: () => WidgetsBinding.instance.endOfFrame,
    );
  }

  Future<void> _exitDesktopFullScreen() async {
    final isFullScreen = await setFullScreen(value: false);
    if (!mounted) return;
    ref.read(fullscreenProvider.notifier).state = isFullScreen;
    widget.desktopFullScreenPlayer.call(isFullScreen);
  }

  Future<void> _goBackToDetail() async {
    if (_routeExitInProgress) return;
    _routeExitInProgress = true;
    if (isDesktop && ref.read(fullscreenProvider)) {
      await _exitDesktopFullScreen();
    }
    restoreSystemUI();
    await _retireVideoTexture();
    if (!mounted) return;
    _firstTime = true;
    Navigator.pop(context);
  }

  void _unifiedPositionHandler(Duration position) {
    final currentSecs = position.inSeconds;
    _setCurrentAudSub(position, currentSecs);
    _setSkipPhase(currentSecs);
  }

  void _setCurrentAudSub(Duration position, int secs) {
    final totalSecs = _player.state.duration.inSeconds;
    _isCompleted.value = (totalSecs - secs) <= 10;
    _currentPosition.value = position;
    if (_initSubtitleAndAudio) {
      _initSubtitleAndAudio = false;
      if (_activeSubtitleTrack != null) {
        try {
          _player.setSubtitleTrack(_activeSubtitleTrack!);
        } catch (_) {}
      } else if (_firstVid.subtitles?.isNotEmpty ?? false) {
        try {
          final defaultTrack = _firstVid.subtitles!.firstWhere(
            (sub) => sub.label == widget.defaultSubtitle,
            orElse: () => _firstVid.subtitles!.first,
          );
          final file = defaultTrack.file ?? "";
          final label = defaultTrack.label;
          final track = (file.startsWith("http") || file.startsWith("file"))
              ? SubtitleTrack.uri(file, title: label, language: label)
              : SubtitleTrack.data(file, title: label, language: label);
          _activeSubtitleTrack = track;
          _player.setSubtitleTrack(track);
        } catch (_) {}
      }

      if (_activeAudioTrack != null) {
        try {
          _player.setAudioTrack(_activeAudioTrack!);
        } catch (_) {}
      } else if (_firstVid.audios?.isNotEmpty ?? false) {
        try {
          final at = _firstVid.audios!.first;
          final track = AudioTrack.uri(
            at.file ?? "",
            title: at.label,
            language: at.label,
          );
          _activeAudioTrack = track;
          _player.setAudioTrack(track);
        } catch (_) {}
      }
    }
  }

  void _setSkipPhase(int secs) {
    _AniSkipPhase newPhase;
    if (_hasOpeningSkip &&
        secs >= _openingResult!.interval!.startTime!.ceil() &&
        secs < _openingResult!.interval!.endTime!.toInt()) {
      newPhase = _AniSkipPhase.opening;
    } else if (_hasEndingSkip &&
        secs >= _endingResult!.interval!.startTime!.ceil() &&
        secs < _endingResult!.interval!.endTime!.toInt()) {
      newPhase = _AniSkipPhase.ending;
    } else {
      newPhase = _AniSkipPhase.none;
    }
    if (_skipPhase.value != newPhase) _skipPhase.value = newPhase;
  }

  void _updateRpcTimestamp() {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (lastRpcTimestampUpdate + 5000 < now) {
      if (_currentTotalDuration.value != null) {
        discordRpc?.updateChapterTimestamp(
          _currentPosition.value,
          _currentTotalDuration.value!,
        );
      }
      lastRpcTimestampUpdate = now;
    }
  }

  void _onSubDelayChanged() {
    final nativePlayer = (_player.platform as NativePlayer);
    final delayMs = int.tryParse(_subDelayController.text);
    if (delayMs != null) {
      final namePtr = "sub-delay".toNativeUtf8();
      final valuePtr = calloc<Double>(1)..value = delayMs / 1000;
      nativePlayer.mpv.mpv_set_property(
        nativePlayer.ctx,
        namePtr.cast(),
        generated.mpv_format.MPV_FORMAT_DOUBLE,
        valuePtr.cast(),
      );
      malloc.free(namePtr);
      malloc.free(valuePtr);
      _subDelay = delayMs;
    }
  }

  void _onSubSpeedChanged() {
    final nativePlayer = (_player.platform as NativePlayer);
    final speed = double.tryParse(_subSpeedController.text);
    if (speed != null) {
      final namePtr = "sub-speed".toNativeUtf8();
      final valuePtr = calloc<Double>(1)
        ..value = speed < 0.1
            ? 0.1
            : speed > 10
            ? 10
            : speed;
      nativePlayer.mpv.mpv_set_property(
        nativePlayer.ctx,
        namePtr.cast(),
        generated.mpv_format.MPV_FORMAT_DOUBLE,
        valuePtr.cast(),
      );
      malloc.free(namePtr);
      malloc.free(valuePtr);
      _subSpeed = speed;
    }
  }

  @override
  void initState() {
    super.initState();
    _watchStopwatch.start();
    _controller = VideoController(
      _player,
      configuration: VideoControllerConfiguration(
        hwdec: hwdecMode,
        enableHardwareAcceleration: shouldUseHardwareAcceleratedVideoOutput(
          userEnabled: enableHardwareAccel,
          isWindows: Platform.isWindows,
        ),
        vo: Platform.isAndroid
            ? useGpuNext
                  ? "gpu-next"
                  : "gpu"
            : "libmpv",
      ),
    );
    // Picture-in-Picture is still off, but the reason has changed.
    //
    // It was disabled because the second UIScene PiP creates re-entered
    // didFinishLaunchingWithOptions and re-ran plugin registration, which
    // segfaulted connectivity_plus. That cause is now gone: the app is on the
    // UIScene lifecycle and registration happens once per engine in
    // didInitializeImplicitFlutterEngine.
    //
    // What blocks it now is the media_kit fork. The old call was
    // `_controller.enableAutoPictureInPicture()`, and that method no longer
    // exists: the fork moved PiP onto `VideoController.pictureInPicture`, a
    // PictureInPictureController with `isSupported()` and
    // `start(handle:, videoSize:, autoEnter:)` taking a native libmpv handle.
    // Re-enabling means porting to that API and testing on a device, so it is
    // deliberately left for its own change. See closed #757.
    // If player is being launched the first time,
    // use global "Use Fullscreen" setting.
    // Else (if user already watches an episode and just changes it),
    // stay in the same mode, the user left it in.
    try {
      final defaultSkipIntroLength = ref.read(
        defaultSkipIntroLengthStateProvider,
      );
      (_player.platform as NativePlayer).setProperty(
        "user-data/current-anime/intro-length",
        "$defaultSkipIntroLength",
      );
    } catch (_) {}
    if (isDesktop) {
      if (_firstTime) {
        final globalFullscreen = ref.read(fullScreenPlayerStateProvider);
        // Delay fullscreen until after the first frame so the window is ready.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setFullScreen(value: globalFullscreen);
          ref.read(fullscreenProvider.notifier).state = globalFullscreen;
          widget.desktopFullScreenPlayer.call(globalFullscreen);
        });
        _firstTime = false;
      } else {
        widget.desktopFullScreenPlayer.call(ref.read(fullscreenProvider));
      }
    }
    if (!isDesktop) {
      final forceLandscape = ref.read(forceLandscapePlayerStateProvider);
      // Preserve the player orientation across episode changes. Playing the next
      // episode pushes a fresh player, and the old one's dispose() resets the
      // orientation to portrait. So if the viewer is still in fullscreen — from
      // the force-landscape setting or a manual toggle that persists across
      // episodes (fullscreenProvider is global) — re-apply landscape here rather
      // than stranding them in portrait with the fullscreen button still active.
      if (forceLandscape || ref.read(fullscreenProvider)) {
        _setLandscapeMode(true);
      }
    }
    _currentPositionSub = _player.stream.position.listen(
      _unifiedPositionHandler,
    );
    _completed;
    _currentTotalDurationSub;
    _loadAndroidFont().then((_) {
      // Loading the subtitle font writes a file, so this callback can arrive
      // after the reader has already left. Everything below it touches the
      // player, and media_kit asserts "[Player] has been disposed" the moment
      // it is used after dispose. That is #925. The torrent branch further
      // down already checked for this; the path everyone takes did not.
      if (!mounted) return;
      _openMedia(_video.value!, _streamController.getCurrentPosition());
      if (widget.isTorrent) {
        Future.delayed(const Duration(seconds: 10)).then((_) {
          if (mounted) {
            _openMedia(_video.value!, _streamController.getCurrentPosition());
          }
        });
      }
      _setPlaybackSpeed(ref.read(defaultPlayBackSpeedStateProvider));
      if (ref.read(enableAniSkipStateProvider)) _initAniSkip();
    });
    _initCustomButton();
    discordRpc?.showChapterDetails(ref, widget.episode);
    _currentPosition.addListener(_updateRpcTimestamp);
    _subDelayController.addListener(_onSubDelayChanged);
    _subSpeedController.addListener(_onSubSpeedChanged);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _watchStopwatch.stop();
      _setCurrentPosition(true);
    } else if (state == AppLifecycleState.resumed) {
      _watchStopwatch.start();
    }
  }

  Future<void> _openMedia(VideoPrefs prefs, [Duration? position]) async {
    final start = position ?? _currentPosition.value;
    await _player.open(
      Media(prefs.videoTrack!.id, httpHeaders: prefs.headers, start: start),
    );
    if (start > Duration.zero) {
      // media_kit's Media(start:) is unreliable for some sources — playback can
      // begin at 0 even though the resume position was passed. Seek explicitly
      // once the media reports a duration (i.e. it has loaded). Fire-and-forget
      // so open() isn't delayed; the timeout guards a source that never reports
      // one, and a redundant seek (when start: did work) is harmless.
      unawaited(
        _player.stream.duration
            .firstWhere((d) => d > Duration.zero)
            .timeout(const Duration(seconds: 8))
            // Up to eight seconds after the media opened, which is long
            // enough for the reader to have gone. Seeking a disposed player
            // reaches native state that has already been torn down.
            .then((_) => mounted ? _player.seek(start) : null)
            .catchError((_) {}),
      );
    }
  }

  Future<void> _loadAndroidFont() async {
    if (Platform.isAndroid && useLibass) {
      try {
        final subDir = await getApplicationDocumentsDirectory();
        final fontPath = path.join(subDir.path, 'subfont.ttf');
        final data = await rootBundle.load('assets/fonts/subfont.ttf');
        final bytes = data.buffer.asInt8List(
          data.offsetInBytes,
          data.lengthInBytes,
        );
        final fontFile = await File(fontPath).create(recursive: true);
        await fontFile.writeAsBytes(bytes);
        await (_player.platform as NativePlayer).setProperty(
          'sub-fonts-dir',
          subDir.path,
        );
        await (_player.platform as NativePlayer).setProperty(
          'sub-font',
          'Droid Sans Fallback',
        );
      } catch (_) {}
    }
  }

  Future<void> _initAniSkip() async {
    // Waits for the media to buffer, which the reader can outlast.
    await _player.stream.buffer.first;
    if (!mounted) return;
    _streamController.getAniSkipResults((result) {
      final openingRes = result
          .where((element) => element.skipType == "op")
          .toList();
      _hasOpeningSkip = openingRes.isNotEmpty;
      if (_hasOpeningSkip) _openingResult = openingRes.first;
      final endingRes = result
          .where((element) => element.skipType == "ed")
          .toList();
      _hasEndingSkip = endingRes.isNotEmpty;
      if (_hasEndingSkip) _endingResult = endingRes.first;
      if (mounted) {
        setState(() {});
      }
    });
  }

  // Bumped on each d-pad key (see _onPlayerKey) so the mobile controls reveal
  // themselves on a TV remote.
  final ValueNotifier<int> _revealControls = ValueNotifier(0);
  // TV-only: when the advanced settings panel is open the video docks left and
  // the panel slides in on the right (YouTube-style), instead of a bottom sheet.
  bool _tvSettingsOpen = false;
  // Owned focus anchors for the split view so Left/Right cross deterministically
  // (geometric directional focus was losing focus entirely).
  final FocusNode _tvVideoFocus = FocusNode(debugLabel: 'tvVideoFrame');
  final FocusNode _tvPanelFocus = FocusNode(debugLabel: 'tvPanelHeader');

  @override
  void dispose() {
    _revealControls.dispose();
    _tvVideoFocus.dispose();
    _tvPanelFocus.dispose();
    _watchStopwatch.stop();
    _currentPosition.removeListener(_updateRpcTimestamp);
    _subDelayController.removeListener(_onSubDelayChanged);
    _subSpeedController.removeListener(_onSubSpeedChanged);
    WidgetsBinding.instance.removeObserver(this);
    _setCurrentPosition(true, saveWatchTime: true);
    final playerCleanup = disposePlaybackSession(
      listenerCancellations: [
        _completed.cancel(),
        _currentPositionSub.cancel(),
        _currentTotalDurationSub.cancel(),
      ],
      beforeDisposePlayer: Platform.isWindows
          ? () => Future<void>.delayed(const Duration(milliseconds: 250))
          : null,
      disposePlayer: _player.dispose,
    );
    unawaited(playerCleanup.catchError((_) {}));
    _currentPosition.dispose();
    _currentTotalDuration.dispose();
    _video.dispose();
    _playbackSpeed.dispose();
    _isDoubleSpeed.dispose();
    _showFitLabel.dispose();
    _isCompleted.dispose();
    _tempPosition.dispose();
    _fit.dispose();
    _skipPhase.dispose();
    _subDelayController.dispose();
    _subSpeedController.dispose();
    if (!isDesktop) _setLandscapeMode(false);
    discordRpc?.showIdleText();
    discordRpc?.showOriginalTimestamp();
    _streamController.keepAliveLink?.close();
    if (widget.isTorrent) {
      for (final hash in widget.infoHashList) {
        MTorrentServer().removeTorrent(hash);
      }
    }
    super.dispose();
  }

  void _setCurrentPosition(bool save, {bool saveWatchTime = false}) {
    _streamController.setCurrentPosition(
      _currentPosition.value,
      _currentTotalDuration.value,
      save: save,
    );
    _streamController.setHistoryUpdate(
      elapsedSeconds: saveWatchTime ? _watchStopwatch.elapsed.inSeconds : 0,
    );
  }

  void _setLandscapeMode(bool state) {
    if (state) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  Widget _videoQualityWidget(BuildContext context) {
    List<VideoPrefs> videoQuality = _player.state.tracks.video
        .where(
          (element) => element.w != null && element.h != null && widget.isLocal,
        )
        .toList()
        .map((e) => VideoPrefs(videoTrack: e, isLocal: true))
        .toList();

    if (widget.videos.isNotEmpty && !widget.isLocal) {
      for (var video in widget.videos) {
        videoQuality.add(
          VideoPrefs(
            videoTrack: VideoTrack(video.url, video.quality, video.quality),
            headers: video.headers,
            isLocal: false,
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Column(
        children: videoQuality.map((quality) {
          final selected =
              _video.value!.videoTrack!.title == quality.videoTrack!.title ||
              widget.isLocal;
          return SettingsOptionRow(
            label: widget.isLocal
                ? _firstVid.quality
                : quality.videoTrack!.title!,
            selected: selected,
            onTap: () async {
              if (_video.value?.videoTrack?.id == quality.videoTrack?.id) {
                _popSettings(context);
                return;
              }
              _video.value = quality;
              _player.stop();
              if (quality.isLocal) {
                if (widget.isLocal) {
                  _player.setVideoTrack(quality.videoTrack!);
                } else {
                  _openMedia(quality);
                }
              } else {
                _openMedia(quality);
              }
              _initSubtitleAndAudio = true;
              _popSettings(context);
            },
          );
        }).toList(),
      ),
    );
  }

  // When opened inside a SettingsDrilldown (mobile bottom sheet or desktop
  // popup), an option selection navigates back to the settings home list so the
  // user can see the new choice inline and adjust other options without having
  // to reopen the menu from scratch. If opened directly via a shortcut, it
  // closes the settings instead.
  void _popSettings(BuildContext context) {
    final scope = SettingsDrilldownScope.of(context);
    if (scope != null && !scope.isDirectShortcut) {
      scope.goHome();
    } else if (scope != null) {
      scope.close();
    } else {
      Navigator.pop(context);
    }
  }

  // The settings home list — YouTube's pattern instead of the segmented tabs
  // this used to be: each entry shows its current value inline, and tapping
  // one drills into that section's content, reusing the exact same widgets
  // the old tabs used. Computed fresh on every open, so the current-value
  // previews always reflect the latest player state.
  List<SettingsEntry> _buildSettingsEntries(BuildContext context) {
    final hasSubtitleTrack = _computeHasSubtitleTrack();
    return [
      SettingsEntry(
        label: context.l10n.video_quality,
        icon: Icons.high_quality_outlined,
        valueBuilder: (context) => ValueListenableBuilder<VideoPrefs?>(
          valueListenable: _video,
          builder: (context, v, _) => Text(
            widget.isLocal ? _firstVid.quality : (v?.videoTrack?.title ?? ''),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        contentBuilder: (context) => _videoQualityWidget(context),
      ),
      SettingsEntry(
        label: context.l10n.video_audio,
        icon: Icons.audiotrack_outlined,
        valueBuilder: (context) => StreamBuilder<Track>(
          stream: _player.stream.track,
          initialData: _player.state.track,
          builder: (context, snapshot) {
            final audio = snapshot.data?.audio;
            final label =
                audio?.title ?? audio?.language ?? audio?.channels ?? '';
            return Text(
              (label.isEmpty || audio?.id == 'no') ? context.l10n.off : label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          },
        ),
        contentBuilder: (context) => _videoAudios(context),
      ),
      SettingsEntry(
        label: context.l10n.video_subtitle,
        icon: Icons.subtitles_outlined,
        valueBuilder: (context) => StreamBuilder<Track>(
          stream: _player.stream.track,
          initialData: _player.state.track,
          builder: (context, snapshot) {
            final subtitle = snapshot.data?.subtitle;
            final label =
                subtitle?.title ??
                subtitle?.language ??
                subtitle?.channels ??
                '';
            return Text(
              (label.isEmpty || subtitle?.id == 'no')
                  ? context.l10n.off
                  : label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          },
        ),
        contentBuilder: (context) => _videoSubtitle(context),
      ),
      SettingsEntry(
        label: context.l10n.appearance,
        icon: Icons.palette_outlined,
        contentBuilder: (context) =>
            _appearanceSectionWidget(context, hasSubtitleTrack),
      ),
      if (_chapterMarks.value.isNotEmpty)
        SettingsEntry(
          label: context.l10n.chapters,
          icon: Icons.list_outlined,
          valueBuilder: (context) => ValueListenableBuilder<int?>(
            valueListenable: _currentChapterMark,
            builder: (context, i, _) => Text(
              i != null ? _chapterMarks.value[i].$1 : '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          contentBuilder: (context) => _chaptersSectionWidget(context),
        ),
      SettingsEntry(
        label: context.l10n.playback_speed,
        icon: Icons.speed_outlined,
        valueBuilder: (context) => ValueListenableBuilder<double>(
          valueListenable: _playbackSpeed,
          builder: (context, v, _) => Text('${v}x'),
        ),
        contentBuilder: (context) => _speedSectionWidget(context),
      ),
      SettingsEntry(
        label: context.l10n.video_fit,
        icon: Icons.fit_screen_outlined,
        valueBuilder: (context) => ValueListenableBuilder<BoxFit>(
          valueListenable: _fit,
          builder: (context, fit, _) => Text(_fitShortLabel(fit)),
        ),
        contentBuilder: (context) => _fitSectionWidget(context),
      ),
      // Each its own entry rather than grouped under one "Advanced" umbrella
      // — shaders, stats and custom buttons are unrelated to each other, and
      // burying three unrelated lists behind a shared label just adds a
      // pointless extra tap to reach any one of them.
      if (useMpvConfig)
        SettingsEntry(
          label: context.l10n.shaders,
          icon: Icons.auto_awesome_outlined,
          valueBuilder: (context) => ValueListenableBuilder<String>(
            valueListenable: _selectedShader,
            builder: (context, shader, _) => Text(
              shader.isEmpty ? context.l10n.off : shader,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          contentBuilder: (context) => _shadersSectionWidget(context),
        ),
      if (useMpvConfig)
        SettingsEntry(
          label: context.l10n.statistics,
          icon: Icons.query_stats_outlined,
          contentBuilder: (context) => _statsSectionWidget(context),
        ),
      if (useMpvConfig && (_customButtons.value?.isNotEmpty ?? false))
        SettingsEntry(
          label: context.l10n.custom_buttons,
          icon: Icons.terminal_outlined,
          contentBuilder: (context) => _customButtonsSectionWidget(context),
        ),
    ];
  }

  // Every player setting lives behind this one entry point instead of the
  // old two-level stack (a draggable tab bar for quality/subtitle/audio,
  // opening a *second* nested tab bar for font/color, plus separate
  // PopupMenuButtons elsewhere for speed/chapters/shaders/stats).
  // `initialIndex` lets a caller (the speed pill, the chapter label) jump
  // straight into a section; -1 (the default, from the gear icon) opens the
  // home list first, same as YouTube's gear menu.
  //
  // Desktop opens a small popup anchored to `context` — the widget the
  // caller itself is built from (a Builder around the gear icon, the pill...)
  // — matching YouTube's own settings gear there, and it doesn't pause
  // playback for the same reason YouTube doesn't. Mobile keeps the modal
  // bottom sheet, where a phone's screen has no room to spare, and does
  // pause — a full-screen sheet already blocks watching anyway.
  void _openPlayerSettings(
    BuildContext context, {
    int initialIndex = -1,
  }) async {
    final entries = _buildSettingsEntries(context);
    _player.pause();
    if (isDesktop) {
      await showDesktopPlayerSettingsMenu(
        context,
        title: context.l10n.settings,
        entries: entries,
        initialIndex: initialIndex,
      );
      setState(() {});
      _player.play();
      return;
    }
    await showUnifiedPlayerSettings(
      context,
      title: context.l10n.settings,
      entries: entries,
      initialIndex: initialIndex,
    );
    setState(() {});
    _player.play();
  }

  bool _computeHasSubtitleTrack() {
    final realPlayerTracks = _player.state.tracks.subtitle.where(
      (e) => (e.title ?? e.language ?? e.channels ?? '').isNotEmpty,
    );
    final hasSourceTracks = widget.videos.any(
      (v) => (v.subtitles?.isNotEmpty ?? false),
    );
    return realPlayerTracks.isNotEmpty || hasSourceTracks;
  }

  Widget _appearanceSectionWidget(BuildContext context, bool hasSubtitleTrack) {
    if (useLibass) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          context.l10n.libass_not_disable_message,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.75)),
        ),
      );
    }
    // FontSettingWidget/ColorSettingWidget style themselves from the ambient
    // Theme — they used to open inside their own draggable menu.
    // Forced dark here so they stay legible against this sheet's dark ground
    // even when the app itself runs in light mode.
    return Theme(
      data: ThemeData.dark(useMaterial3: true),
      child: Column(
        children: [
          FontSettingWidget(hasSubtitleTrack: hasSubtitleTrack),
          const Divider(height: 1, color: Color(0x14FFFFFF)),
          ColorSettingWidget(hasSubtitleTrack: hasSubtitleTrack),
        ],
      ),
    );
  }

  Widget _chaptersSectionWidget(BuildContext context) {
    return ValueListenableBuilder<int?>(
      valueListenable: _currentChapterMark,
      builder: (context, current, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Column(
          children: _chapterMarks.value.asMap().entries.map((entry) {
            final index = entry.key;
            final mark = entry.value;
            return SettingsOptionRow(
              label: mark.$1,
              hint: Duration(milliseconds: mark.$2).label(),
              selected: current == index,
              onTap: () {
                _player.seek(Duration(milliseconds: mark.$2));
                _popSettings(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _speedSectionWidget(BuildContext context) {
    const speeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.50, 1.75, 2.0];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Column(
        children: speeds.map((speed) {
          return ValueListenableBuilder<double>(
            valueListenable: _playbackSpeed,
            builder: (context, current, _) => SettingsOptionRow(
              label: '${speed}x',
              selected: current == speed,
              onTap: () {
                _setPlaybackSpeed(speed);
                _popSettings(context);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _fitSectionWidget(BuildContext context) {
    const fits = [
      BoxFit.contain,
      BoxFit.cover,
      BoxFit.fill,
      BoxFit.fitHeight,
      BoxFit.fitWidth,
      BoxFit.scaleDown,
      BoxFit.none,
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Column(
        children: fits.map((fit) {
          return ValueListenableBuilder<BoxFit>(
            valueListenable: _fit,
            builder: (context, current, _) => SettingsOptionRow(
              label: _fitShortLabel(fit),
              selected: current == fit,
              onTap: () {
                _fit.value = fit;
                _key.currentState?.update(fit: fit);
                _popSettings(context);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  static const _shaderModes = [
    ("Anime4K: Mode A (Fast)", "set_anime_a"),
    ("Anime4K: Mode B (Fast)", "set_anime_b"),
    ("Anime4K: Mode C (Fast)", "set_anime_c"),
    ("Anime4K: Mode A+A (Fast)", "set_anime_aa"),
    ("Anime4K: Mode B+B (Fast)", "set_anime_bb"),
    ("Anime4K: Mode C+A (Fast)", "set_anime_ca"),
    ("Anime4K: Mode A (HQ)", "set_anime_hq_a"),
    ("Anime4K: Mode B (HQ)", "set_anime_hq_b"),
    ("Anime4K: Mode C (HQ)", "set_anime_hq_c"),
    ("Anime4K: Mode A+A (HQ)", "set_anime_hq_aa"),
    ("Anime4K: Mode B+B (HQ)", "set_anime_hq_bb"),
    ("Anime4K: Mode C+A (HQ)", "set_anime_hq_ca"),
    ("AMD FSR", "set_fsr"),
    ("Luma Upscaling", "set_luma"),
    ("Qualcomm Snapdragon GSR", "set_snapdragon"),
    ("NVIDIA Image Scaling", "set_nvidia"),
    ("Clear GLSL shaders", "clear_anime"),
  ];

  Widget _shadersSectionWidget(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: _selectedShader,
      builder: (context, selectedShader, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Column(
          children: _shaderModes.map((mode) {
            return SettingsOptionRow(
              label: mode.$1,
              selected: selectedShader == mode.$1,
              onTap: () {
                (_player.platform as NativePlayer).command([
                  "script-message",
                  mode.$2,
                ]);
                _popSettings(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  static const _statsModes = [
    ("Stats Toggle", "stats/display-stats-toggle"),
    ("Stats Page 1", "stats/display-page-1"),
    ("Stats Page 2", "stats/display-page-2"),
    ("Stats Page 3", "stats/display-page-3"),
    ("Stats Page 4", "stats/display-page-4"),
    ("Stats Page 5", "stats/display-page-5"),
  ];

  Widget _statsSectionWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Column(
        children: _statsModes.map((mode) {
          return SettingsOptionRow(
            label: mode.$1,
            selected: false,
            onTap: () {
              (_player.platform as NativePlayer).command([
                "script-binding",
                mode.$2,
              ]);
              _popSettings(context);
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _customButtonsSectionWidget(BuildContext context) {
    return ValueListenableBuilder<List<CustomButton>?>(
      valueListenable: _customButtons,
      builder: (context, buttons, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Column(
          children: (buttons ?? []).map((btn) {
            return SettingsOptionRow(
              label: btn.title!,
              selected: false,
              onTap: () {
                (_player.platform as NativePlayer).command([
                  "script-message",
                  "call_button_${btn.id}",
                ]);
                _popSettings(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _videoSubtitle(BuildContext context) {
    List<VideoPrefs> videoSubtitle = _player.state.tracks.subtitle
        .toList()
        .map((e) => VideoPrefs(isLocal: true, subtitle: e))
        .toList();

    List<String> subs = [];
    if (widget.videos.isNotEmpty) {
      for (var video in widget.videos) {
        for (var sub in video.subtitles ?? []) {
          if (!subs.contains(sub.file)) {
            final file = sub.file!;
            final label = sub.label;
            videoSubtitle.add(
              VideoPrefs(
                isLocal: widget.isLocal,
                subtitle: (file.startsWith("http") || file.startsWith("file"))
                    ? SubtitleTrack.uri(file, title: label, language: label)
                    : SubtitleTrack.data(file, title: label, language: label),
              ),
            );
            subs.add(sub.file!);
          }
        }
      }
    }
    final subtitle = _player.state.track.subtitle;
    videoSubtitle = videoSubtitle
        .map((e) {
          VideoPrefs vid = e;
          vid.title =
              vid.subtitle?.title ??
              vid.subtitle?.language ??
              vid.subtitle?.channels ??
              "";
          return vid;
        })
        .toList()
        .where((element) => element.title!.isNotEmpty)
        .toList();
    videoSubtitle.sort((a, b) => a.title!.compareTo(b.title!));
    videoSubtitle.insert(
      0,
      VideoPrefs(isLocal: false, subtitle: SubtitleTrack.no()),
    );
    final seenTitles = <String>{};
    final List<VideoPrefs> videoSubtitleLast = [];
    for (var element in videoSubtitle) {
      final key =
          element.title ??
          element.subtitle?.title ??
          element.subtitle?.language ??
          element.subtitle?.channels ??
          "None";
      if (seenTitles.add(key)) {
        videoSubtitleLast.add(element);
      }
    }
    return StatefulBuilder(
      builder: (context, setSectionState) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.subtitle_delay_text,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setSectionState(() {
                      _subDelay = 0;
                      _subDelayController.value = const TextEditingValue(
                        text: "0",
                        selection: TextSelection.collapsed(offset: 1),
                      );
                      _subSpeed = 1;
                      _subSpeedController.value = const TextEditingValue(
                        text: "1.00",
                        selection: TextSelection.collapsed(offset: 4),
                      );
                    });
                  },
                  icon: Icon(
                    Icons.refresh,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 18,
                  ),
                ),
              ],
            ),
            SettingsStepperRow(
              label: context.l10n.subtitle_delay,
              controller: _subDelayController,
              suffix: ' ms',
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              onDecrement: () => setSectionState(() {
                _subDelay -= 50;
                final text = "$_subDelay";
                _subDelayController.value = TextEditingValue(
                  text: text,
                  selection: TextSelection.collapsed(offset: text.length),
                );
              }),
              onIncrement: () => setSectionState(() {
                _subDelay += 50;
                final text = "$_subDelay";
                _subDelayController.value = TextEditingValue(
                  text: text,
                  selection: TextSelection.collapsed(offset: text.length),
                );
              }),
              onSubmitted: (text) {
                final val = int.tryParse(text);
                if (val != null) {
                  setSectionState(() {
                    _subDelay = val;
                    final str = "$val";
                    _subDelayController.value = TextEditingValue(
                      text: str,
                      selection: TextSelection.collapsed(offset: str.length),
                    );
                  });
                } else {
                  final str = "$_subDelay";
                  _subDelayController.value = TextEditingValue(
                    text: str,
                    selection: TextSelection.collapsed(offset: str.length),
                  );
                }
              },
            ),
            SettingsStepperRow(
              label: context.l10n.subtitle_speed,
              controller: _subSpeedController,
              suffix: 'x',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onDecrement: () => setSectionState(() {
                _subSpeed = (_subSpeed - 0.01).clamp(0.1, 10.0);
                final text = _subSpeed.toStringAsFixed(2);
                _subSpeedController.value = TextEditingValue(
                  text: text,
                  selection: TextSelection.collapsed(offset: text.length),
                );
              }),
              onIncrement: () => setSectionState(() {
                _subSpeed = (_subSpeed + 0.01).clamp(0.1, 10.0);
                final text = _subSpeed.toStringAsFixed(2);
                _subSpeedController.value = TextEditingValue(
                  text: text,
                  selection: TextSelection.collapsed(offset: text.length),
                );
              }),
              onSubmitted: (text) {
                final val = double.tryParse(text);
                if (val != null) {
                  setSectionState(() {
                    _subSpeed = val.clamp(0.1, 10.0);
                    final str = _subSpeed.toStringAsFixed(2);
                    _subSpeedController.value = TextEditingValue(
                      text: str,
                      selection: TextSelection.collapsed(offset: str.length),
                    );
                  });
                } else {
                  final str = _subSpeed.toStringAsFixed(2);
                  _subSpeedController.value = TextEditingValue(
                    text: str,
                    selection: TextSelection.collapsed(offset: str.length),
                  );
                }
              },
            ),
            SettingsSectionLabel(context.l10n.tracks),
            ...videoSubtitleLast.toSet().toList().map((sub) {
              final title =
                  sub.title ??
                  sub.subtitle?.title ??
                  sub.subtitle?.language ??
                  sub.subtitle?.channels ??
                  "None";

              final selected =
                  (title ==
                      (subtitle.title ??
                          subtitle.language ??
                          subtitle.channels ??
                          "None")) ||
                  (subtitle.id == "no" && title == "None");
              return SettingsOptionRow(
                label: title,
                selected: selected,
                onTap: () {
                  _popSettings(context);
                  try {
                    _activeSubtitleTrack = sub.subtitle!;
                    _player.setSubtitleTrack(sub.subtitle!);
                  } catch (_) {}
                },
              );
            }),
            SettingsActionRow(
              label: context.l10n.load_own_subtitles,
              icon: Icons.file_open_outlined,
              onTap: () async {
                try {
                  final file = await FilePicker.pickFile();

                  if (file != null && context.mounted) {
                    final track = SubtitleTrack.uri(file.path!);
                    _activeSubtitleTrack = track;
                    _player.setSubtitleTrack(track);
                  }
                  if (!context.mounted) return;
                  _popSettings(context);
                } catch (e) {
                  botToast(context.l10n.error_with_message(e));
                  _popSettings(context);
                }
              },
            ),
            SettingsActionRow(
              label: context.l10n.search_subtitles,
              icon: Icons.search,
              onTap: () async {
                try {
                  final subtitle = await subtitlesSearchraggableMenu(
                    context,
                    chapter: widget.episode,
                    isLocal: widget.isLocal,
                  ) as ImdbSubtitle?;
                  if (subtitle != null && context.mounted) {
                    final track = SubtitleTrack.uri(
                      subtitle.url!,
                      title: subtitle.language,
                      language: subtitle.language,
                    );
                    _activeSubtitleTrack = track;
                    _player.setSubtitleTrack(track);
                  }
                  if (!context.mounted) return;
                  _popSettings(context);
                } catch (_) {
                  botToast(context.l10n.error);
                  _popSettings(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _videoAudios(BuildContext context) {
    List<VideoPrefs> videoAudio = _player.state.tracks.audio
        .toList()
        .map((e) => VideoPrefs(isLocal: true, audio: e))
        .toList();

    List<String> audios = [];
    if (widget.videos.isNotEmpty && !widget.isLocal) {
      for (var video in widget.videos) {
        for (var audio in video.audios ?? []) {
          if (!audios.contains(audio.file)) {
            videoAudio.add(
              VideoPrefs(
                isLocal: false,
                audio: AudioTrack.uri(
                  audio.file!,
                  title: audio.label,
                  language: audio.label,
                ),
              ),
            );
            audios.add(audio.file!);
          }
        }
      }
    }
    final audio = _player.state.track.audio;
    videoAudio = videoAudio
        .map((e) {
          VideoPrefs vid = e;
          vid.title =
              vid.audio?.title ??
              vid.audio?.language ??
              vid.audio?.channels ??
              "";
          return vid;
        })
        .toList()
        .where((element) => element.title!.isNotEmpty)
        .toList();
    videoAudio.sort((a, b) => a.title!.compareTo(b.title!));
    videoAudio.insert(0, VideoPrefs(isLocal: false, audio: AudioTrack.no()));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Column(
        children: videoAudio.toSet().toList().map((aud) {
          final title =
              aud.title ??
              aud.audio?.title ??
              aud.audio?.language ??
              aud.audio?.channels ??
              "None";
          final selected =
              (aud.audio == audio) || (audio.id == "no" && title == "None");
          return SettingsOptionRow(
            label: title,
            selected: selected,
            onTap: () {
              _popSettings(context);
              try {
                _activeAudioTrack = aud.audio!;
                _player.setAudioTrack(aud.audio!);
              } catch (_) {}
            },
          );
        }).toList(),
      ),
    );
  }

  // d-pad-focusable option data for the TV settings panel — the same track
  // switching the bottom-sheet widgets do, minus the Navigator.pop (the panel
  // is not a route). Records: (label, selected, onTap).
  List<({String label, bool selected, VoidCallback onTap})>
  _tvQualityOptions() {
    List<VideoPrefs> videoQuality = _player.state.tracks.video
        .where(
          (element) => element.w != null && element.h != null && widget.isLocal,
        )
        .toList()
        .map((e) => VideoPrefs(videoTrack: e, isLocal: true))
        .toList();
    if (widget.videos.isNotEmpty && !widget.isLocal) {
      for (var video in widget.videos) {
        videoQuality.add(
          VideoPrefs(
            videoTrack: VideoTrack(video.url, video.quality, video.quality),
            headers: video.headers,
            isLocal: false,
          ),
        );
      }
    }
    return videoQuality.map((quality) {
      final selected =
          _video.value!.videoTrack!.title == quality.videoTrack!.title ||
          widget.isLocal;
      return (
        label: widget.isLocal ? _firstVid.quality : quality.videoTrack!.title!,
        selected: selected,
        onTap: () {
          if (_video.value?.videoTrack?.id == quality.videoTrack?.id) return;
          _video.value = quality;
          _player.stop();
          if (quality.isLocal) {
            if (widget.isLocal) {
              _player.setVideoTrack(quality.videoTrack!);
            } else {
              _openMedia(quality);
            }
          } else {
            _openMedia(quality);
          }
          _initSubtitleAndAudio = true;
        },
      );
    }).toList();
  }

  List<({String label, bool selected, VoidCallback onTap})>
  _tvSubtitleOptions() {
    List<VideoPrefs> videoSubtitle = _player.state.tracks.subtitle
        .toList()
        .map((e) => VideoPrefs(isLocal: true, subtitle: e))
        .toList();
    List<String> subs = [];
    if (widget.videos.isNotEmpty) {
      for (var video in widget.videos) {
        for (var sub in video.subtitles ?? []) {
          if (!subs.contains(sub.file)) {
            final file = sub.file!;
            final label = sub.label;
            videoSubtitle.add(
              VideoPrefs(
                isLocal: widget.isLocal,
                subtitle: (file.startsWith("http") || file.startsWith("file"))
                    ? SubtitleTrack.uri(file, title: label, language: label)
                    : SubtitleTrack.data(file, title: label, language: label),
              ),
            );
            subs.add(sub.file!);
          }
        }
      }
    }
    final subtitle = _player.state.track.subtitle;
    videoSubtitle = videoSubtitle
        .map((e) {
          e.title =
              e.subtitle?.title ??
              e.subtitle?.language ??
              e.subtitle?.channels ??
              "";
          return e;
        })
        .toList()
        .where((element) => element.title!.isNotEmpty)
        .toList();
    videoSubtitle.sort((a, b) => a.title!.compareTo(b.title!));
    videoSubtitle.insert(
      0,
      VideoPrefs(isLocal: false, subtitle: SubtitleTrack.no()),
    );
    final List<VideoPrefs> last = [];
    for (var element in videoSubtitle) {
      final key =
          element.title ??
          element.subtitle?.title ??
          element.subtitle?.language ??
          element.subtitle?.channels ??
          "None";
      final contains = last.any(
        (sub) =>
            (sub.title ??
                sub.subtitle?.title ??
                sub.subtitle?.language ??
                sub.subtitle?.channels ??
                "None") ==
            key,
      );
      if (!contains) last.add(element);
    }
    return last.toSet().toList().map((sub) {
      final title =
          sub.title ??
          sub.subtitle?.title ??
          sub.subtitle?.language ??
          sub.subtitle?.channels ??
          "None";
      final selected =
          (title ==
              (subtitle.title ??
                  subtitle.language ??
                  subtitle.channels ??
                  "None")) ||
          (subtitle.id == "no" && title == "None");
      return (
        label: title == "None" ? "Off" : title,
        selected: selected,
        onTap: () {
          try {
            _activeSubtitleTrack = sub.subtitle!;
            _player.setSubtitleTrack(sub.subtitle!);
          } catch (_) {}
        },
      );
    }).toList();
  }

  List<({String label, bool selected, VoidCallback onTap})> _tvAudioOptions() {
    List<VideoPrefs> videoAudio = _player.state.tracks.audio
        .toList()
        .map((e) => VideoPrefs(isLocal: true, audio: e))
        .toList();
    List<String> audios = [];
    if (widget.videos.isNotEmpty && !widget.isLocal) {
      for (var video in widget.videos) {
        for (var audio in video.audios ?? []) {
          if (!audios.contains(audio.file)) {
            videoAudio.add(
              VideoPrefs(
                isLocal: false,
                audio: AudioTrack.uri(
                  audio.file!,
                  title: audio.label,
                  language: audio.label,
                ),
              ),
            );
            audios.add(audio.file!);
          }
        }
      }
    }
    final audio = _player.state.track.audio;
    videoAudio = videoAudio
        .map((e) {
          e.title =
              e.audio?.title ?? e.audio?.language ?? e.audio?.channels ?? "";
          return e;
        })
        .toList()
        .where((element) => element.title!.isNotEmpty)
        .toList();
    videoAudio.sort((a, b) => a.title!.compareTo(b.title!));
    videoAudio.insert(0, VideoPrefs(isLocal: false, audio: AudioTrack.no()));
    return videoAudio.toSet().toList().map((aud) {
      final title =
          aud.title ??
          aud.audio?.title ??
          aud.audio?.language ??
          aud.audio?.channels ??
          "None";
      final selected =
          (aud.audio == audio) || (audio.id == "no" && title == "None");
      return (
        label: title == "None" ? "Off" : title,
        selected: selected,
        onTap: () {
          try {
            _activeAudioTrack = aud.audio!;
            _player.setAudioTrack(aud.audio!);
          } catch (_) {}
        },
      );
    }).toList();
  }

  Future<void> _setPlaybackSpeed(double speed) async {
    await _player.setRate(speed);
    _playbackSpeed.value = speed;
  }

  Future<void> _changeFitLabel(WidgetRef ref) async {
    List<BoxFit> fitList = [
      BoxFit.contain,
      BoxFit.cover,
      BoxFit.fill,
      BoxFit.fitHeight,
      BoxFit.fitWidth,
      BoxFit.scaleDown,
      BoxFit.none,
    ];
    _showFitLabel.value = true;
    BoxFit? fit;
    if (fitList.indexOf(_fit.value) < fitList.length - 1) {
      fit = fitList[fitList.indexOf(_fit.value) + 1];
    } else {
      fit = fitList[0];
    }
    _fit.value = fit;
    _key.currentState?.update(fit: fit);
    BotToast.showText(
      onlyOne: true,
      align: const Alignment(0, 0.90),
      duration: const Duration(seconds: 1),
      text: fit.name.toUpperCase(),
    );
  }

  Widget _seekToWidget() {
    final defaultSkipIntroLength = ref.watch(
      defaultSkipIntroLengthStateProvider,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        height: 35,
        child: ValueListenableBuilder(
          valueListenable: _customButton,
          builder: (context, value, child) => (value?.visible ?? true)
              ? ElevatedButton(
                  onPressed:
                      value?.onPress ??
                      () async => await _seekBy(defaultSkipIntroLength),
                  onLongPress: value?.onLongPress,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      value != null
                          ? value.currentTitle
                          : "+$defaultSkipIntroLength",
                      style: const TextStyle(fontWeight: FontWeight.w100),
                    ),
                  ),
                )
              : Container(),
        ),
      ),
    );
  }

  // Sections in the unified sheet: quality(0), audio(1), subtitles(2), appearance(3),
  // then chapters(4) when present, then speed, then fit.
  int get _qualitySectionIndex => 0;
  int get _audioSectionIndex => 1;
  int get _subtitleSectionIndex => 2;
  int get _chaptersSectionIndex => 4;
  int get _speedSectionIndex => _chapterMarks.value.isNotEmpty ? 5 : 4;

  Widget _chapterMarkWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: SizedBox(
        height: 35,
        child: ValueListenableBuilder(
          valueListenable: _currentChapterMark,
          builder: (context, value, child) => value != null
              ? Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _openPlayerSettings(
                      context,
                      initialIndex: _chaptersSectionIndex,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${_chapterMarks.value[value].$1} - ${Duration(milliseconds: _chapterMarks.value[value].$2).label()}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ),
      ),
    );
  }

  Widget _tvControls() {
    return TvPlayerControls(
      player: _player,
      revealControls: _revealControls,
      title: widget.episode.manga.value?.name ?? '',
      episodeLabel: widget.episode.name ?? '',
      // Direct pop, not maybePop: the on-screen back arrow always exits the
      // player, bypassing the PopScope that makes the remote Back hide the
      // panel first.
      onBack: _goBackToDetail,
      onRestart: () => _player.seek(Duration.zero),
      onSettings: () {
        // On TV the settings open as the docked side panel; phones/desktop keep
        // the bottom-sheet menu.
        if (isTv) {
          setState(() => _tvSettingsOpen = true);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _tvPanelFocus.requestFocus();
          });
        } else {
          _openPlayerSettings(context);
        }
      },
      hasNext: hasNextEpisode,
      onNext: hasNextEpisode
          ? () => pushToNewEpisode(context, _streamController.getNextEpisode())
          : null,
      qualityListenable: _video,
      buildQualityOptions: _buildTvQualityOptions,
      speedListenable: _playbackSpeed,
      onSetSpeed: _setPlaybackSpeed,
    );
  }

  // The source video list is the real dub/sub control (entries like "1080p Sub"
  // / "1080p Dub"); switching re-opens the stream at that source. Mirrors
  // _videoQualityWidget's selection logic for the TV pill bar.
  List<TvTrackOption> _buildTvQualityOptions() {
    if (widget.isLocal || widget.videos.isEmpty) return const <TvTrackOption>[];
    final currentTitle = _video.value?.videoTrack?.title;
    return [
      for (final video in widget.videos)
        TvTrackOption(
          label: _shortQuality(video.quality),
          selected: currentTitle == video.quality,
          onSelect: () {
            if (_video.value?.videoTrack?.title == video.quality) return;
            final prefs = VideoPrefs(
              videoTrack: VideoTrack(video.url, video.quality, video.quality),
              headers: video.headers,
              isLocal: false,
            );
            _video.value = prefs;
            _player.stop();
            _openMedia(prefs);
            _initSubtitleAndAudio = true;
          },
        ),
    ];
  }

  // Shorten a source quality label like "1080p (Sub)" to "1080-sub"/"1080-dub".
  String _shortQuality(String raw) {
    final lower = raw.toLowerCase();
    final res = RegExp(r'(\d{3,4})\s*p?').firstMatch(lower)?.group(1);
    final tag = lower.contains('sub')
        ? 'sub'
        : lower.contains('dub')
        ? 'dub'
        : null;
    if (res != null && tag != null) return '$res-$tag';
    if (res != null) return '${res}p';
    return raw;
  }

  String _shortTrackLabel(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return '';
    final clean = trimmed.split(RegExp(r'[\(\[\-]')).first.trim();
    if (clean.length > 7) {
      return clean.substring(0, 6);
    }
    return clean;
  }

  Widget _mobileBottomButtonBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                _seekToWidget(),
                _chapterMarkWidget(),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: _buildSettingsButtons(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _desktopBottomButtonBar(BuildContext context) {
    final skipDuration = ref.watch(defaultDoubleTapToSkipLengthStateProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (_streamController.hasPreviousEpisode)
                      IconButton(
                        tooltip: 'Previous episode',
                        onPressed: () {
                          pushToNewEpisode(
                            context,
                            _streamController.getPrevEpisode(),
                          );
                        },
                        icon: const Icon(
                          Icons.skip_previous,
                          color: Colors.white,
                        ),
                      ),
                    CustomPlayOrPauseButton(controller: _controller),
                    if (hasNextEpisode)
                      IconButton(
                        tooltip: 'Next episode',
                        onPressed: () async {
                          pushToNewEpisode(
                            context,
                            _streamController.getNextEpisode(),
                          );
                        },
                        icon: const Icon(Icons.skip_next, color: Colors.white),
                      ),
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: IconButton(
                        tooltip: '-$skipDuration seconds',
                        onPressed: () async => await _seekBy(-skipDuration),
                        icon: Stack(
                          children: [
                            const Positioned.fill(
                              child: Icon(
                                Icons.rotate_left_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            Positioned.fill(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    skipDuration.toString(),
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: IconButton(
                        tooltip: '+$skipDuration seconds',
                        onPressed: () async => await _seekBy(skipDuration),
                        icon: Stack(
                          children: [
                            const Positioned.fill(
                              child: Icon(
                                Icons.rotate_right_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            Positioned.fill(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    skipDuration.toString(),
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    CustomMaterialDesktopVolumeButton(controller: _controller),
                    ValueListenableBuilder(
                      valueListenable: _tempPosition,
                      builder: (context, value, child) =>
                          CustomMaterialDesktopPositionIndicator(
                            delta: value,
                            controller: _controller,
                          ),
                    ),
                    _chapterMarkWidget(),
                  ],
                ),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: _buildSettingsButtons(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _fitShortLabel(BoxFit fit) => switch (fit) {
    BoxFit.contain => 'Contain',
    BoxFit.cover => 'Cover',
    BoxFit.fill => 'Fill',
    BoxFit.fitHeight => 'Height',
    BoxFit.fitWidth => 'Width',
    BoxFit.scaleDown => 'Scale',
    BoxFit.none => 'None',
  };

  /// helper method for _mobileBottomButtonBar() and _desktopBottomButtonBar()
  Widget _buildSettingsButtons(BuildContext context) {
    final hasMultipleVideos = widget.videos.length > 1;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Quality shortcut pill
        if (hasMultipleVideos)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.5),
            child: Builder(
              builder: (context) => ValueListenableBuilder<VideoPrefs?>(
                valueListenable: _video,
                builder: (context, videoPrefs, _) {
                  final rawQuality =
                      videoPrefs?.videoTrack?.title ??
                      (widget.videos.isNotEmpty
                          ? widget.videos.first.quality
                          : '');
                  final qualityLabel = _shortQuality(rawQuality);
                  return PlayerPillButton(
                    icon: Icons.high_quality,
                    label: qualityLabel.isNotEmpty ? qualityLabel : null,
                    tooltip: context.l10n.video_quality,
                    isCompact: isMobile,
                    onTap: () => _openPlayerSettings(
                      context,
                      initialIndex: _qualitySectionIndex,
                    ),
                  );
                },
              ),
            ),
          ),

        // Subtitles CC shortcut pill
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.5),
          child: Builder(
            builder: (context) => StreamBuilder<Track>(
              stream: _player.stream.track,
              builder: (context, snapshot) {
                final subTrack = _player.state.track.subtitle;
                final isSubOff =
                    subTrack.id == 'no' ||
                    (subTrack.title == null &&
                        subTrack.language == null &&
                        subTrack.channels == null);
                final rawName =
                    subTrack.title ??
                    subTrack.language ??
                    subTrack.channels ??
                    '';
                final shortLabel = _shortTrackLabel(rawName);

                return PlayerPillButton(
                  icon: Icons.subtitles_outlined,
                  label: !isSubOff && shortLabel.isNotEmpty
                      ? shortLabel
                      : 'Off',
                  active: false,
                  tooltip: context.l10n.video_subtitle,
                  isCompact: isMobile,
                  onTap: () => _openPlayerSettings(
                    context,
                    initialIndex: _subtitleSectionIndex,
                  ),
                );
              },
            ),
          ),
        ),

        // Audio track shortcut pill (if multiple audio tracks or explicitly set)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.5),
          child: Builder(
            builder: (context) => StreamBuilder<Track>(
              stream: _player.stream.track,
              builder: (context, snapshot) {
                final audioTrack = _player.state.track.audio;
                final rawName =
                    audioTrack.title ??
                    audioTrack.language ??
                    audioTrack.channels ??
                    '';
                final shortLabel = _shortTrackLabel(rawName);
                final hasMultipleAudios =
                    _player.state.tracks.audio.length > 1 ||
                    widget.videos.any((v) => (v.audios?.length ?? 0) > 1);

                if (!hasMultipleAudios && shortLabel.isEmpty) {
                  return const SizedBox.shrink();
                }

                return PlayerPillButton(
                  icon: Icons.audiotrack_outlined,
                  label: shortLabel.isNotEmpty ? shortLabel : null,
                  tooltip: context.l10n.video_audio,
                  isCompact: isMobile,
                  onTap: () => _openPlayerSettings(
                    context,
                    initialIndex: _audioSectionIndex,
                  ),
                );
              },
            ),
          ),
        ),

        // Playback speed pill
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.5),
          child: Builder(
            builder: (context) => ValueListenableBuilder<double>(
              valueListenable: _playbackSpeed,
              builder: (context, speed, _) => PlayerPillButton(
                icon: Icons.speed,
                label: '${speed}x',
                active: false,
                tooltip: context.l10n.playback_speed,
                isCompact: isMobile,
                onTap: () => _openPlayerSettings(
                  context,
                  initialIndex: _speedSectionIndex,
                ),
              ),
            ),
          ),
        ),

        // Fit screen pill
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.5),
          child: ValueListenableBuilder<BoxFit>(
            valueListenable: _fit,
            builder: (context, fit, _) => PlayerPillButton(
              icon: Icons.fit_screen_outlined,
              label: _fitShortLabel(fit),
              active: false,
              tooltip: 'Fit screen',
              isCompact: isMobile,
              onTap: () => _changeFitLabel(ref),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.5),
          child: Builder(
            builder: (btnContext) => PlayerPillButton(
              icon: Icons.video_settings,
              active: false,
              tooltip: context.l10n.settings,
              isCompact: isMobile,
              onTap: () => _openPlayerSettings(btnContext),
            ),
          ),
        ),

        if (!isTv)
          Consumer(
            builder: (context, ref, _) {
              final isFullscreen = ref.watch(fullscreenProvider);
              return Padding(
                padding: const EdgeInsets.only(left: 2.5, right: 5),
                child: PlayerPillButton(
                  icon: isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  active: false,
                  tooltip: context.l10n.fullscreen,
                  isCompact: isMobile,
                  onTap: () async {
                    if (isDesktop) {
                      final isFullScreen = await setFullScreen(
                        value: !isFullscreen,
                      );
                      ref.read(fullscreenProvider.notifier).state =
                          isFullScreen;
                      widget.desktopFullScreenPlayer.call(isFullScreen);
                    } else {
                      _setLandscapeMode(!isFullscreen);
                      ref.read(fullscreenProvider.notifier).state =
                          !isFullscreen;
                      widget.desktopFullScreenPlayer.call(!isFullscreen);
                    }
                  },
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _topButtonBar(BuildContext context) {
    final fullScreen = ref.watch(fullscreenProvider);
    return Padding(
      padding: EdgeInsets.only(
        top: !isDesktop && !fullScreen ? MediaQuery.of(context).padding.top : 0,
      ),
      child: Row(
        children: [
          BackButton(color: Colors.white, onPressed: _goBackToDetail),
          Flexible(
            child: ListTile(
              dense: true,
              title: Text(
                widget.episode.manga.value?.name ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                widget.episode.name ?? '',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Row(
            children: [
              Consumer(
                builder: (context, ref, _) {
                  final autoPlay = ref.watch(autoPlayNextEpisodeProvider);
                  // Same drawn play/pause switch as the TV player, for a
                  // consistent autoplay toggle across all players.
                  return Tooltip(
                    message: autoPlay
                        ? 'Autoplay next episode: on'
                        : 'Autoplay next episode: off',
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => ref
                          .read(autoPlayNextEpisodeProvider.notifier)
                          .toggle(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        child: AutoplaySwitch(
                          on: autoPlay,
                          accent: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  );
                },
              ),
              if (_supportAlwaysOnTop())
                IconButton(
                  icon: Icon(
                    _alwaysOnTop ? Icons.push_pin : Icons.push_pin_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() => _alwaysOnTop = !_alwaysOnTop);
                    windowManager.setAlwaysOnTop(_alwaysOnTop);
                  },
                ),
              btnToShowChapterListDialog(
                context,
                context.l10n.episodes,
                widget.episode,
                onChanged: (v) {
                  if (v) {
                    _player.play();
                  } else {
                    _player.pause();
                  }
                },
                iconColor: Colors.white,
              ),
              btnToShowShareScreenshot(
                widget.episode,
                onChanged: (v) {
                  if (v) {
                    _player.play();
                  } else {
                    _player.pause();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  BoxFit? _lastFit;
  void _resize(BoxFit fit) async {
    if (fit == _lastFit) return;
    _lastFit = fit;
    // Wait for the widget tree to settle before updating fit
    await WidgetsBinding.instance.endOfFrame;
    if (mounted) {
      _key.currentState?.update(
        fit: fit,
        width: context.width(1),
        height: context.height(1),
      );
    }
  }

  Widget _videoPlayer(BuildContext context) {
    final fit = _fit.value;
    _resize(fit);
    final enableAniSkip = ref.read(enableAniSkipStateProvider);
    final enableAutoSkip = ref.read(enableAutoSkipStateProvider);
    final aniSkipTimeoutLength = ref.read(aniSkipTimeoutLengthStateProvider);
    final skipIntroLength = ref.read(defaultSkipIntroLengthStateProvider);
    final splitSettingsTv = isTv && _tvSettingsOpen;
    final docked = splitSettingsTv;
    final Widget player = Stack(
      children: [
        if (_videoTextureVisible)
          Video(
            pip: const PipConfig(autoEnter: true),
            subtitleViewConfiguration: SubtitleViewConfiguration(
              visible: false,
              style: subtileTextStyle(ref),
            ),
            // Docked in the split view, always contain so the whole frame shows
            // at its true aspect ratio rather than cropping to the narrower slot.
            fit: docked ? BoxFit.contain : fit,
            key: _key,
            controls: (state) => (isTv && ref.read(tvPlayerStyleProvider))
                ? (_tvSettingsOpen ? const SizedBox.shrink() : _tvControls())
                : (isDesktop || isTv)
                ? DesktopControllerWidget(
                    videoController: _controller,
                    topButtonBarWidget: _topButtonBar(context),
                    videoStatekey: _key,
                    bottomButtonBarWidget: _desktopBottomButtonBar(context),
                    streamController: _streamController,
                    seekToWidget: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(children: [_seekToWidget()]),
                    ),
                    tempDuration: (value) {
                      _tempPosition.value = value;
                    },
                    doubleSpeed: (value) {
                      _isDoubleSpeed.value = value ?? false;
                    },
                    defaultSkipIntroLength: skipIntroLength,
                    desktopFullScreenPlayer: widget.desktopFullScreenPlayer,
                    chapterMarks: _chapterMarks,
                    revealControls: _revealControls,
                  )
                : MobileControllerWidget(
                    videoController: _controller,
                    topButtonBarWidget: _topButtonBar(context),
                    videoStatekey: _key,
                    bottomButtonBarWidget: _mobileBottomButtonBar(context),
                    streamController: _streamController,
                    revealControls: _revealControls,
                    doubleSpeed: (value) {
                      _isDoubleSpeed.value = value ?? false;
                    },
                    chapterMarks: _chapterMarks,
                  ),
            controller: _controller,
            // When docked left for the settings panel, fill the (narrower) slot
            // the Row gives us rather than forcing full-screen width.
            width: docked ? null : context.width(1),
            height: docked ? null : context.height(1),
            resumeUponEnteringForegroundMode: true,
          )
        else
          const SizedBox.expand(),
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Positioned(
              top: 30,
              child: ValueListenableBuilder<bool>(
                valueListenable: _isDoubleSpeed,
                builder: (context, snapshot, _) {
                  return Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      style: TextStyle(
                        background: Paint()
                          ..color = Theme.of(context).scaffoldBackgroundColor
                          ..strokeWidth = 30.0
                          ..strokeJoin = StrokeJoin.round
                          ..style = PaintingStyle.stroke,
                      ),
                      children: snapshot
                          ? [
                              TextSpan(
                                text: " 2X ",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Icon(Icons.fast_forward),
                              ),
                            ]
                          : [],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        if (enableAniSkip && (_hasOpeningSkip || _hasEndingSkip))
          Positioned(
            right: 0,
            bottom: 80,
            child: ValueListenableBuilder<_AniSkipPhase>(
              valueListenable: _skipPhase,
              builder: (context, phase, _) {
                if (phase == _AniSkipPhase.none) return const SizedBox.shrink();
                final isOpening = phase == _AniSkipPhase.opening;
                final result = isOpening ? _openingResult! : _endingResult!;
                return AniSkipCountDownButton(
                  key: Key(isOpening ? 'skip_opening' : 'skip_ending'),
                  active: true,
                  autoSkip: enableAutoSkip,
                  timeoutLength: aniSkipTimeoutLength,
                  skipTypeText: isOpening
                      ? context.l10n.skip_opening
                      : context.l10n.skip_ending,
                  player: _player,
                  aniSkipResult: result,
                );
              },
            ),
          ),
      ],
    );
    if (!docked) return player;
    // YouTube-style split: video docks left (a single focusable unit — Left
    // from the panel focuses it, Select toggles play/pause), a gap, then the
    // settings panel on the right.
    final accent = Theme.of(context).colorScheme.primary;
    return ColoredBox(
      color: Colors.black,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TvVideoFocusFrame(
                accent: accent,
                player: _player,
                focusNode: _tvVideoFocus,
                onSelect: () => _player.playOrPause(),
                onExitRight: () => _tvPanelFocus.requestFocus(),
                child: player,
              ),
            ),
          ),
          TvPlayerSettingsPanel(
            player: _player,
            speedListenable: _playbackSpeed,
            onSetSpeed: _setPlaybackSpeed,
            selectedShaderListenable: _selectedShader,
            qualityOptions: _tvQualityOptions,
            subtitleOptions: _tvSubtitleOptions,
            audioOptions: _tvAudioOptions,
            headerFocusNode: _tvPanelFocus,
            onExitLeft: () => _tvVideoFocus.requestFocus(),
            onClose: () => setState(() => _tvSettingsOpen = false),
          ),
        ],
      ),
    );
  }

  Widget btnToShowShareScreenshot(
    Chapter episode, {
    void Function(bool)? onChanged,
  }) {
    return IconButton(
      onPressed: () async {
        onChanged?.call(false);
        Widget button(String label, IconData icon, Function() onPressed) =>
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: onPressed,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(icon),
                      ),
                      Text(label),
                    ],
                  ),
                ),
              ),
            );
        final name =
            "${episode.manga.value!.name} ${episode.name} - ${_currentPosition.value.toString()}"
                .replaceAll(RegExp(r'[^a-zA-Z0-9 .()\-\s]'), '_');
        await showModalBottomSheet(
          context: context,
          constraints: BoxConstraints(maxWidth: context.width(1)),
          builder: (context) {
            return SuperListView(
              shrinkWrap: true,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: context.themeData.scaffoldBackgroundColor,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 7,
                          width: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: context.secondaryColor.withValues(
                              alpha: 0.4,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          button(
                            context.l10n.set_as_cover,
                            Icons.image_outlined,
                            () async {
                              final imageBytes = await _player.screenshot(
                                format: "image/png",
                                includeLibassSubtitles: _includeSubtitles,
                              );
                              if (!context.mounted) return;
                              final confirmed = await confirmUseAsMangaCover(
                                context,
                              );
                              if (!confirmed || !context.mounted) return;
                              await applyMangaCover(
                                context,
                                episode.manga.value!,
                                imageBytes,
                              );
                              if (context.mounted) Navigator.pop(context);
                            },
                          ),
                          button(
                            context.l10n.share,
                            Icons.share_outlined,
                            () async {
                              final imageBytes = await _player.screenshot(
                                format: "image/png",
                                includeLibassSubtitles: _includeSubtitles,
                              );
                              if (context.mounted) {
                                final box =
                                    context.findRenderObject() as RenderBox?;
                                await shareOrCopy(
                                  ShareParams(
                                    files: [
                                      XFile.fromData(
                                        imageBytes!,
                                        name: name,
                                        mimeType: 'image/png',
                                      ),
                                    ],
                                    sharePositionOrigin:
                                        box!.localToGlobal(Offset.zero) &
                                        box.size,
                                  ),
                                  fallbackName: name,
                                );
                              }
                            },
                          ),
                          button(
                            context.l10n.save,
                            Icons.save_outlined,
                            () async {
                              final imageBytes = await _player.screenshot(
                                format: "image/png",
                                includeLibassSubtitles: _includeSubtitles,
                              );
                              final dir = await StorageProvider()
                                  .getGalleryDirectory();
                              final file = File(
                                path.join(dir!.path, "$name.png"),
                              );
                              file.writeAsBytesSync(imageBytes!);
                              if (context.mounted) {
                                botToast(context.l10n.picture_saved, second: 3);
                              }
                            },
                          ),
                        ],
                      ),
                      SwitchListTile(
                        onChanged: (value) {
                          setState(() {
                            _includeSubtitles = value;
                          });
                        },
                        title: Text(context.l10n.include_subtitles),
                        value: _includeSubtitles,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
        onChanged?.call(true);
      },
      icon: Icon(Icons.adaptive.share, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    final body = _videoPlayer(context);
    // Desktop already gets player keyboard shortcuts through media_kit's
    // DesktopControllerWidget. On mobile / Android TV the controls have none,
    // so wrap the player so a physical keyboard or TV remote can drive
    // playback too. See #668 / #729.
    return Scaffold(body: isDesktop ? body : _wrapWithPlayerShortcuts(body));
  }

  /// Maps keyboard and TV-remote keys to player actions for non-desktop
  /// builds. Only dedicated media keys + the usual mpv-style keys are bound
  /// (no D-pad arrows beyond seek), so it stays additive and doesn't fight
  /// touch input. Reuses the existing player + episode-navigation methods.
  Widget _wrapWithPlayerShortcuts(Widget child) {
    void seekBy(int seconds) {
      _player.seek(_player.state.position + Duration(seconds: seconds));
    }

    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.space): () {
          _player.playOrPause();
        },
        const SingleActivator(LogicalKeyboardKey.mediaPlayPause): () {
          _player.playOrPause();
        },
        const SingleActivator(LogicalKeyboardKey.mediaPlay): () {
          _player.play();
        },
        const SingleActivator(LogicalKeyboardKey.mediaPause): () {
          _player.pause();
        },
        // Seek via J/L and the dedicated media keys only. Arrow keys are left
        // unbound so they keep driving d-pad focus traversal on Android TV
        // (and arrow-key focus movement with a keyboard) instead of seeking.
        const SingleActivator(LogicalKeyboardKey.keyJ): () => seekBy(-10),
        const SingleActivator(LogicalKeyboardKey.keyL): () => seekBy(10),
        const SingleActivator(LogicalKeyboardKey.mediaRewind): () =>
            seekBy(-10),
        const SingleActivator(LogicalKeyboardKey.mediaFastForward): () =>
            seekBy(10),
        const SingleActivator(LogicalKeyboardKey.mediaTrackNext): () {
          if (hasNextEpisode && mounted) {
            pushToNewEpisode(context, _streamController.getNextEpisode());
          }
        },
        const SingleActivator(LogicalKeyboardKey.mediaTrackPrevious): () {
          if (_streamController.hasPreviousEpisode && mounted) {
            pushToNewEpisode(context, _streamController.getPrevEpisode());
          }
        },
      },
      child: MouseRegion(
        // Desktop debugging: a mouse has no d-pad, so let hover and clicks
        // reveal the auto-hiding controls (bumping the same notifier the remote
        // does). No-op on a TV, which sends no pointer-hover events.
        onEnter: (_) => _revealControls.value++,
        onHover: (_) => _revealControls.value++,
        child: Listener(
          // Reveal on a mouse click (desktop), but NOT on touch. On a touch
          // device the mobile controls handle tap-to-toggle themselves, so
          // revealing here on finger-down makes the following tap immediately
          // hide them again (controls flash and vanish in under a second).
          onPointerDown: (event) {
            if (event.kind == PointerDeviceKind.mouse) _revealControls.value++;
          },
          child: Focus(autofocus: true, onKeyEvent: _onPlayerKey, child: child),
        ),
      ),
    );
  }

  // On a TV remote / keyboard, reveal the on-screen controls when the user
  // presses the d-pad. The arrow keys stay unbound above (so they still drive
  // focus traversal between the control buttons) — we just bump [_revealControls]
  // so the controls become visible and the focus is on something the user can
  // see. Returns ignored so traversal + the media shortcuts still run.
  KeyEventResult _onPlayerKey(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      final k = event.logicalKey;
      final isNav =
          k == LogicalKeyboardKey.arrowUp ||
          k == LogicalKeyboardKey.arrowDown ||
          k == LogicalKeyboardKey.arrowLeft ||
          k == LogicalKeyboardKey.arrowRight ||
          k == LogicalKeyboardKey.select ||
          k == LogicalKeyboardKey.enter ||
          k == LogicalKeyboardKey.numpadEnter ||
          k == LogicalKeyboardKey.gameButtonA;
      if (isNav) _revealControls.value++;
    }
    return KeyEventResult.ignored;
  }
}

Widget seekIndicatorTextWidget(Duration duration, Duration currentPosition) {
  final swipeDuration = duration.inSeconds;
  final value = currentPosition.inSeconds + swipeDuration;
  return Builder(
    builder: (ctx) {
      final accent = ctx.primaryColor;
      final colorScheme = Theme.of(ctx).colorScheme;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.90),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Duration(seconds: value).label(),
              style: const TextStyle(
                fontSize: 44.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
            Text(
              swipeDuration > 0
                  ? "+${Duration(seconds: swipeDuration).label()}"
                  : "-${Duration(seconds: swipeDuration).label()}",
              style: TextStyle(
                fontSize: 20.0,
                color: accent,
                fontWeight: FontWeight.w600,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      );
    },
  );
}

class VideoPrefs {
  String? title;
  VideoTrack? videoTrack;
  SubtitleTrack? subtitle;
  AudioTrack? audio;
  bool isLocal;
  final Map<String, String>? headers;
  VideoPrefs({
    this.videoTrack,
    this.isLocal = true,
    this.headers,
    this.subtitle,
    this.audio,
    this.title,
  });
}

mixin _AlwaysOnTopStateMixin<T extends StatefulWidget> on State<T> {
  // The original alwaysOnTop state.
  // This will be used to restore the original state when the widget disposed.
  bool? _savedAlwaysOnTop;

  bool _alwaysOnTop = false;

  @override
  void initState() {
    super.initState();
    _initAlwaysOnTop();
  }

  @override
  void dispose() {
    super.dispose();
    _disposeAlwaysOnTop();
  }

  Future<void> _initAlwaysOnTop() async {
    if (_supportAlwaysOnTop()) {
      _savedAlwaysOnTop = await windowManager.isAlwaysOnTop();
      if (mounted) {
        setState(() => _alwaysOnTop = _savedAlwaysOnTop!);
      }
    }
  }

  Future<void> _disposeAlwaysOnTop() async {
    if (_supportAlwaysOnTop()) {
      if (_savedAlwaysOnTop != null) {
        await windowManager.setAlwaysOnTop(_savedAlwaysOnTop!);
      }
    }
  }

  // Whether the platform support AlwaysOnTop feature.
  bool _supportAlwaysOnTop() => !kIsWeb && isDesktop;
}
