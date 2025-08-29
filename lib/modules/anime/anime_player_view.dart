import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:bot_toast/bot_toast.dart';
import 'package:ffi/ffi.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qjs/quickjs/ffi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riv;
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/custom_button.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/video.dart' as vid;
import 'package:mangayomi/modules/anime/providers/anime_player_controller_provider.dart';
import 'package:mangayomi/modules/anime/widgets/aniskip_countdown_btn.dart';
import 'package:mangayomi/modules/anime/widgets/desktop.dart';
import 'package:mangayomi/modules/anime/widgets/play_or_pause_button.dart';
import 'package:mangayomi/modules/manga/reader/widgets/btn_chapter_list_dialog.dart';
import 'package:mangayomi/modules/anime/widgets/mobile.dart';
import 'package:mangayomi/modules/anime/widgets/subtitle_view.dart';
import 'package:mangayomi/modules/anime/widgets/subtitle_setting_widget.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/modules/more/settings/player/providers/custom_buttons_provider.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_audio_state_provider.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_decoder_state_provider.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_state_provider.dart';
import 'package:mangayomi/modules/widgets/custom_draggable_tabbar.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/aniskip.dart';
import 'package:mangayomi/services/fetch_subtitles.dart';
import 'package:mangayomi/services/get_video_list.dart';
import 'package:mangayomi/services/torrent_server.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit/generated/libmpv/bindings.dart' as generated;
import 'package:media_kit_video/media_kit_video.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:path/path.dart' as p;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import 'widgets/search_subtitles.dart';

bool _isDesktop = Platform.isMacOS || Platform.isLinux || Platform.isWindows;

class AnimePlayerView extends riv.ConsumerStatefulWidget {
  final int episodeId;
  const AnimePlayerView({super.key, required this.episodeId});

  @override
  riv.ConsumerState<AnimePlayerView> createState() => _AnimePlayerViewState();
}

class _AnimePlayerViewState extends riv.ConsumerState<AnimePlayerView> {
  late final Chapter episode = isar.chapters.getSync(widget.episodeId)!;
  List<String> _infoHashList = [];
  bool desktopFullScreenPlayer = false;
  @override
  void dispose() {
    if (_isDesktop) {
      setFullScreen(value: desktopFullScreenPlayer);
    }
    for (var infoHash in _infoHashList) {
      MTorrentServer().removeTorrent(infoHash);
    }
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultSubtitleLang = ref.watch(defaultSubtitleLangStateProvider);
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
            body: const Center(child: Text("Video list is empty")),
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
          desktopFullScreenPlayer: (value) {
            desktopFullScreenPlayer = value;
          },
          mpvDirectory: mpvDirectory,
        );
      },
      error: (error, stackTrace) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text(''),
          leading: BackButton(
            onPressed: () {
              SystemChrome.setEnabledSystemUIMode(
                SystemUiMode.manual,
                overlays: SystemUiOverlay.values,
              );
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(child: Text(error.toString())),
      ),
      loading: () {
        return Scaffold(
          backgroundColor: Colors.black,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text(''),
            leading: BackButton(
              color: Colors.white,
              onPressed: () {
                SystemChrome.setEnabledSystemUIMode(
                  SystemUiMode.manual,
                  overlays: SystemUiOverlay.values,
                );
                Navigator.pop(context);
              },
            ),
          ),
          body: const ProgressCenter(),
        );
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
  final Directory? mpvDirectory;
  final void Function(bool) desktopFullScreenPlayer;
  const AnimeStreamPage({
    super.key,
    required this.defaultSubtitle,
    required this.isLocal,
    required this.videos,
    required this.episode,
    required this.isTorrent,
    required this.desktopFullScreenPlayer,
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
    with TickerProviderStateMixin, WidgetsBindingObserver {
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
  late final _firstVid = widget.videos.first;
  late final ValueNotifier<VideoPrefs?> _video = ValueNotifier(
    VideoPrefs(
      videoTrack: VideoTrack(
        _firstVid.originalUrl,
        _firstVid.quality,
        _firstVid.quality,
      ),
      headers: _firstVid.headers,
    ),
  );
  final ValueNotifier<double> _playbackSpeed = ValueNotifier(1.0);
  final ValueNotifier<bool> _isDoubleSpeed = ValueNotifier(false);
  late final ValueNotifier<Duration> _currentPosition = ValueNotifier(
    _streamController.geTCurrentPosition(),
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
  bool _includeSubtitles = false;
  int _subDelay = 0;
  final _subDelayController = TextEditingController(text: "0");
  double _subSpeed = 1;
  final _subSpeedController = TextEditingController(text: "1");
  int lastRpcTimestampUpdate = DateTime.now().millisecondsSinceEpoch;

  late final StreamSubscription<Duration> _currentPositionSub;

  late final StreamSubscription<Duration> _currentTotalDurationSub = _player
      .stream
      .duration
      .listen((duration) {
        _currentTotalDuration.value = duration;
        discordRpc?.updateChapterTimestamp(_currentPosition.value, duration);
      });

  bool get hasNextEpisode => _streamController.getEpisodeIndex().$1 != 0;

  late final StreamSubscription<bool> _completed = _player.stream.completed
      .listen((val) {
        if (hasNextEpisode && val) {
          if (mounted) {
            pushToNewEpisode(context, _streamController.getNextEpisode());
          }
        }
        // If the last episode of an Anime has ended, exit fullscreen mode
        final isFullScreen = ref.read(fullscreenProvider);
        if (!hasNextEpisode && val && _isDesktop && isFullScreen) {
          setFullScreen(value: false);
          ref.read(fullscreenProvider.notifier).state = false;
          widget.desktopFullScreenPlayer.call(false);
        }
      });

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

  Future<void> _handleMpvNodeEvents(
    String propName,
    Pointer<generated.mpv_node> value,
  ) async {
    final nativePlayer = _player.platform as NativePlayer;
    switch (propName.substring(10)) {
      case "aniyomi/show_text":
        if (value.ref.format == generated.mpv_format.MPV_FORMAT_STRING) {
          final text = value.ref.u.string.cast<Utf8>().toDartString();
          if (text.isEmpty) break;
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
        }
        break;
      case "aniyomi/toggle_ui":
        if (value.ref.format == generated.mpv_format.MPV_FORMAT_STRING) {
          final text = value.ref.u.string.cast<Utf8>().toDartString();
          if (text.isEmpty) break;
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
        }
        break;
      case "aniyomi/show_panel":
        if (value.ref.format == generated.mpv_format.MPV_FORMAT_STRING) {
          final text = value.ref.u.string.cast<Utf8>().toDartString();
          if (text.isEmpty) break;
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
        }
        break;
      case "aniyomi/software_keyboard":
        if (value.ref.format == generated.mpv_format.MPV_FORMAT_STRING) {
          final text = value.ref.u.string.cast<Utf8>().toDartString();
          if (text.isEmpty) break;
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
        }
        break;
      case "aniyomi/set_button_title":
        if (value.ref.format == generated.mpv_format.MPV_FORMAT_STRING) {
          final text = value.ref.u.string.cast<Utf8>().toDartString();
          if (text.isEmpty) break;
          final temp = _customButton.value;
          if (temp == null) break;
          _customButton.value = temp..currentTitle = text;
          nativePlayer.setProperty("user-data/aniyomi/set_button_title", "");
        }
        break;
      case "aniyomi/reset_button_title":
        if (value.ref.format == generated.mpv_format.MPV_FORMAT_STRING) {
          final text = value.ref.u.string.cast<Utf8>().toDartString();
          if (text.isEmpty) break;
          final temp = _customButton.value;
          if (temp == null) break;
          _customButton.value = temp..currentTitle = temp.button.title ?? "";
          nativePlayer.setProperty("user-data/aniyomi/reset_button_title", "");
        }
        break;
      case "aniyomi/toggle_button":
        if (value.ref.format == generated.mpv_format.MPV_FORMAT_STRING) {
          final text = value.ref.u.string.cast<Utf8>().toDartString();
          if (text.isEmpty) break;
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
        }
        break;
      case "aniyomi/switch_episode":
        if (value.ref.format == generated.mpv_format.MPV_FORMAT_STRING) {
          final text = value.ref.u.string.cast<Utf8>().toDartString();
          if (text.isEmpty) break;
          switch (text) {
            case "n":
              pushToNewEpisode(context, _streamController.getNextEpisode());
              break;
            case "p":
              pushToNewEpisode(context, _streamController.getPrevEpisode());
              break;
          }
          nativePlayer.setProperty("user-data/aniyomi/switch_episode", "");
        }
        break;
      case "aniyomi/pause":
        if (value.ref.format == generated.mpv_format.MPV_FORMAT_STRING) {
          final text = value.ref.u.string.cast<Utf8>().toDartString();
          if (text.isEmpty) break;
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
        }
        break;
      case "aniyomi/seek_by":
        if (value.ref.format == generated.mpv_format.MPV_FORMAT_STRING) {
          final text = value.ref.u.string.cast<Utf8>().toDartString();
          if (text.isEmpty) break;
          final data = int.parse(text.replaceAll("\"", ""));
          final pos = _currentPosition.value.inSeconds + data;
          _tempPosition.value = Duration(seconds: pos);
          await _player.seek(Duration(seconds: pos));
          _tempPosition.value = null;
          nativePlayer.setProperty("user-data/aniyomi/seek_by", "");
        }
        break;
      case "aniyomi/seek_to":
        if (value.ref.format == generated.mpv_format.MPV_FORMAT_STRING) {
          final text = value.ref.u.string.cast<Utf8>().toDartString();
          if (text.isEmpty) break;
          final data = int.parse(text.replaceAll("\"", ""));
          _tempPosition.value = Duration(seconds: data);
          await _player.seek(Duration(seconds: data));
          _tempPosition.value = null;
          nativePlayer.setProperty("user-data/aniyomi/seek_to", "");
        }
        break;
      case "aniyomi/seek_by_with_text":
        if (value.ref.format == generated.mpv_format.MPV_FORMAT_STRING) {
          final text = value.ref.u.string.cast<Utf8>().toDartString();
          if (text.isEmpty) break;
          final data = text.split("|");
          final pos =
              _currentPosition.value.inSeconds +
              int.parse(data[0].replaceAll("\"", ""));
          _tempPosition.value = Duration(seconds: pos);
          await _player.seek(Duration(seconds: pos));
          _tempPosition.value = null;
          (_player.platform as NativePlayer).command(["show-text", data[1]]);
          nativePlayer.setProperty("user-data/aniyomi/seek_by_with_text", "");
        }
        break;
      case "aniyomi/seek_to_with_text":
        if (value.ref.format == generated.mpv_format.MPV_FORMAT_STRING) {
          final text = value.ref.u.string.cast<Utf8>().toDartString();
          if (text.isEmpty) break;
          final data = text.split("|");
          final pos = int.parse(data[0].replaceAll("\"", ""));
          _tempPosition.value = Duration(seconds: pos);
          await _player.seek(Duration(seconds: pos));
          _tempPosition.value = null;
          (_player.platform as NativePlayer).command(["show-text", data[1]]);
          nativePlayer.setProperty("user-data/aniyomi/seek_to_with_text", "");
        }
        break;
      case "aniyomi/launch_int_picker":
        if (value.ref.format == generated.mpv_format.MPV_FORMAT_STRING) {
          final text = value.ref.u.string.cast<Utf8>().toDartString();
          if (text.isEmpty) break;
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
                          final valuePtr = calloc<Int64>(1)
                            ..value = currentValue;
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
        }
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
        if (value.ref.format == generated.mpv_format.MPV_FORMAT_STRING) {
          final text = value.ref.u.string.cast<Utf8>().toDartString();
          _selectedShader.value = text;
        }
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
    final customButtons = await ref.read(getCustomButtonsStreamProvider.future);
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

  void pushToNewEpisode(BuildContext context, Chapter episode) {
    widget.desktopFullScreenPlayer.call(ref.read(fullscreenProvider));
    if (context.mounted) {
      pushReplacementMangaReaderView(context: context, chapter: episode);
    }
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
      if (_firstVid.subtitles?.isNotEmpty ?? false) {
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
          _player.setSubtitleTrack(track);
        } catch (_) {}
        if (_firstVid.audios?.isNotEmpty ?? false) {
          try {
            final at = _firstVid.audios!.first;
            _player.setAudioTrack(
              AudioTrack.uri(
                at.file ?? "",
                title: at.label,
                language: at.label,
              ),
            );
          } catch (_) {}
        }
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
    _controller = VideoController(
      _player,
      configuration: VideoControllerConfiguration(
        hwdec: hwdecMode,
        enableHardwareAcceleration: enableHardwareAccel,
        vo: Platform.isAndroid
            ? useGpuNext
                  ? "gpu-next"
                  : "gpu"
            : "libmpv",
      ),
    );
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
    if (_isDesktop && _firstTime) {
      final globalFullscreen = ref.read(fullScreenPlayerStateProvider);
      setFullScreen(value: globalFullscreen);
      Future.microtask(() {
        ref.read(fullscreenProvider.notifier).state = globalFullscreen;
        widget.desktopFullScreenPlayer.call(globalFullscreen);
      });
      _firstTime = false;
    }
    _currentPositionSub = _player.stream.position.listen(
      _unifiedPositionHandler,
    );
    _completed;
    _currentTotalDurationSub;
    _loadAndroidFont().then((_) {
      _openMedia(_video.value!, _streamController.geTCurrentPosition());
      if (widget.isTorrent) {
        Future.delayed(const Duration(seconds: 10)).then((_) {
          if (mounted) {
            _openMedia(_video.value!, _streamController.geTCurrentPosition());
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
      _setCurrentPosition(true);
    }
  }

  Future<void> _openMedia(VideoPrefs prefs, [Duration? position]) {
    return _player.open(
      Media(
        prefs.videoTrack!.id,
        httpHeaders: prefs.headers,
        start: position ?? _currentPosition.value,
      ),
    );
  }

  Future<void> _loadAndroidFont() async {
    if (Platform.isAndroid && useLibass) {
      try {
        final subDir = await getApplicationDocumentsDirectory();
        final fontPath = p.join(subDir.path, 'subfont.ttf');
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
    await _player.stream.buffer.first;
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

  @override
  void dispose() {
    _currentPosition.removeListener(_updateRpcTimestamp);
    WidgetsBinding.instance.removeObserver(this);
    _setCurrentPosition(true);
    _player.dispose();
    _currentPositionSub.cancel();
    _currentTotalDurationSub.cancel();
    _completed.cancel();
    _video.dispose();
    _playbackSpeed.dispose();
    _isDoubleSpeed.dispose();
    _currentTotalDuration.dispose();
    _showFitLabel.dispose();
    _isCompleted.dispose();
    _tempPosition.dispose();
    _fit.dispose();
    if (!_isDesktop) {
      _setLandscapeMode(false);
    }
    _skipPhase.dispose();
    discordRpc?.showIdleText();
    discordRpc?.showOriginalTimestamp();
    _currentPosition.dispose();
    _subDelayController.dispose();
    _subSpeedController.dispose();
    super.dispose();
  }

  void _setCurrentPosition(bool save) {
    _streamController.setCurrentPosition(
      _currentPosition.value,
      _currentTotalDuration.value,
      save: save,
    );
    _streamController.setAnimeHistoryUpdate();
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

  Widget textWidget(String text, bool selected) => Row(
    children: [
      Flexible(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).padding.top,
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: 16,
              fontStyle: selected ? FontStyle.italic : null,
              color: selected ? context.primaryColor : null,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ],
  );

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
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
      child: Column(
        children: videoQuality.map((quality) {
          final selected =
              _video.value!.videoTrack!.title == quality.videoTrack!.title ||
              widget.isLocal;
          return GestureDetector(
            child: textWidget(
              widget.isLocal ? _firstVid.quality : quality.videoTrack!.title!,
              selected,
            ),
            onTap: () async {
              if (_video.value?.videoTrack?.id == quality.videoTrack?.id) {
                Navigator.pop(context);
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
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }

  void _videoSettingDraggableMenu(BuildContext context) async {
    final l10n = l10nLocalizations(context)!;
    bool hasSubtitleTrack = false;
    _player.pause();
    await customDraggableTabBar(
      tabs: [
        Tab(text: l10n.video_quality),
        Tab(text: l10n.video_subtitle),
        Tab(text: l10n.video_audio),
      ],
      children: [
        _videoQualityWidget(context),
        _videoSubtitle(context, (value) => hasSubtitleTrack = value),
        _videoAudios(context),
      ],
      context: context,
      vsync: this,
      fullWidth: true,
      moreWidget: IconButton(
        onPressed: () async {
          if (useLibass) {
            BotToast.showText(
              contentColor: Colors.white,
              textStyle: const TextStyle(color: Colors.black, fontSize: 20),
              onlyOne: true,
              align: const Alignment(0, 0.90),
              duration: const Duration(seconds: 2),
              text: context.l10n.libass_not_disable_message,
            );
          } else {
            await customDraggableTabBar(
              tabs: [
                Tab(text: l10n.font),
                Tab(text: l10n.color),
              ],
              children: [
                FontSettingWidget(hasSubtitleTrack: hasSubtitleTrack),
                ColorSettingWidget(hasSubtitleTrack: hasSubtitleTrack),
              ],
              context: context,
              vsync: this,
              fullWidth: true,
            );
            if (context.mounted) {
              Navigator.pop(context);
            }
          }
        },
        icon: const Icon(Icons.settings_outlined),
      ),
    );
    setState(() {});
    _player.play();
  }

  Widget _videoSubtitle(BuildContext context, Function(bool) hasSubtitleTrack) {
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
    hasSubtitleTrack.call(videoSubtitle.isNotEmpty);
    videoSubtitle.insert(
      0,
      VideoPrefs(isLocal: false, subtitle: SubtitleTrack.no()),
    );
    List<VideoPrefs> videoSubtitleLast = [];
    for (var element in videoSubtitle) {
      final contains = videoSubtitleLast.any((sub) {
        return (sub.title ??
                sub.subtitle?.title ??
                sub.subtitle?.language ??
                sub.subtitle?.channels ??
                "None") ==
            (element.title ??
                element.subtitle?.title ??
                element.subtitle?.language ??
                element.subtitle?.channels ??
                "None");
      });
      if (!contains) {
        videoSubtitleLast.add(element);
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
      child: Column(
        children: [
          Row(
            children: [
              Text(context.l10n.subtitle_delay_text),
              IconButton(
                onPressed: () {
                  _subDelay = 0;
                  _subDelayController.value = TextEditingValue(
                    text: "$_subDelay",
                  );
                  _subSpeed = 1;
                  _subSpeedController.value = TextEditingValue(
                    text: _subSpeed.toStringAsFixed(2),
                  );
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  _subDelay -= 50;
                  _subDelayController.value = TextEditingValue(
                    text: "$_subDelay",
                  );
                },
                icon: const Icon(Icons.remove_circle),
              ),
              Expanded(
                child: TextFormField(
                  controller: _subDelayController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    label: Text(context.l10n.subtitle_delay),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  _subDelay += 50;
                  _subDelayController.value = TextEditingValue(
                    text: "$_subDelay",
                  );
                },
                icon: const Icon(Icons.add_circle),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  _subSpeed -= 0.01;
                  _subSpeedController.value = TextEditingValue(
                    text: _subSpeed.toStringAsFixed(2),
                  );
                },
                icon: const Icon(Icons.remove_circle),
              ),
              Expanded(
                child: TextFormField(
                  controller: _subSpeedController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    isDense: true,
                    label: Text(context.l10n.subtitle_speed),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  _subSpeed += 0.01;
                  _subSpeedController.value = TextEditingValue(
                    text: _subSpeed.toStringAsFixed(2),
                  );
                },
                icon: const Icon(Icons.add_circle),
              ),
            ],
          ),
          const SizedBox(height: 30),
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
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                try {
                  _player.setSubtitleTrack(sub.subtitle!);
                } catch (_) {}
              },
              child: textWidget(title, selected),
            );
          }),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () async {
              try {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                );

                if (result != null && context.mounted) {
                  _player.setSubtitleTrack(
                    SubtitleTrack.uri(result.files.first.path!),
                  );
                }
                if (!context.mounted) return;
                Navigator.pop(context);
              } catch (_) {
                botToast("Error");
                Navigator.pop(context);
              }
            },
            child: textWidget(context.l10n.load_own_subtitles, false),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () async {
              try {
                final subtitle =
                    await subtitlesSearchraggableMenu(
                          context,
                          chapter: widget.episode,
                          isLocal: widget.isLocal,
                        )
                        as ImdbSubtitle?;
                if (subtitle != null && context.mounted) {
                  _player.setSubtitleTrack(
                    SubtitleTrack.uri(
                      subtitle.url!,
                      title: subtitle.language,
                      language: subtitle.language,
                    ),
                  );
                }
                if (!context.mounted) return;
                Navigator.pop(context);
              } catch (_) {
                botToast("Error");
                Navigator.pop(context);
              }
            },
            child: textWidget(context.l10n.search_subtitles, false),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
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
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
              try {
                _player.setAudioTrack(aud.audio!);
              } catch (_) {}
            },
            child: textWidget(title, selected),
          );
        }).toList(),
      ),
    );
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
                      () async {
                        _tempPosition.value = Duration(
                          seconds:
                              defaultSkipIntroLength +
                              _currentPosition.value.inSeconds,
                        );
                        await _player.seek(
                          Duration(
                            seconds:
                                _currentPosition.value.inSeconds +
                                defaultSkipIntroLength,
                          ),
                        );
                        _tempPosition.value = null;
                      },
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

  Widget _chapterMarkWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: SizedBox(
        height: 35,
        child: ValueListenableBuilder(
          valueListenable: _currentChapterMark,
          builder: (context, value, child) => value != null
              ? PopupMenuButton<int>(
                  tooltip: '',
                  itemBuilder: (context) => _chapterMarks.value
                      .map(
                        (mark) => PopupMenuItem<int>(
                          value: mark.$2,
                          child: Text(
                            "${mark.$1} - ${Duration(milliseconds: mark.$2).label()}",
                          ),
                          onTap: () =>
                              _player.seek(Duration(milliseconds: mark.$2)),
                        ),
                      )
                      .toList(),
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
                )
              : Container(),
        ),
      ),
    );
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _seekToWidget(),
                _chapterMarkWidget(),
                _buildSettingsButtons(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _desktopBottomButtonBar(BuildContext context) {
    bool hasPrevEpisode =
        _streamController.getEpisodeIndex().$1 + 1 !=
        _streamController.getEpisodesLength(
          _streamController.getEpisodeIndex().$2,
        );
    final skipDuration = ref.watch(defaultDoubleTapToSkipLengthStateProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (hasPrevEpisode)
                  IconButton(
                    onPressed: () {
                      pushToNewEpisode(
                        context,
                        _streamController.getPrevEpisode(),
                      );
                    },
                    icon: const Icon(Icons.skip_previous, color: Colors.white),
                  ),
                CustomPlayOrPauseButton(
                  controller: _controller,
                  isDesktop: _isDesktop,
                ),
                if (hasNextEpisode)
                  IconButton(
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
                    onPressed: () async {
                      _tempPosition.value = Duration(
                        seconds:
                            skipDuration - _currentPosition.value.inSeconds,
                      );
                      await _player.seek(
                        Duration(
                          seconds:
                              _currentPosition.value.inSeconds - skipDuration,
                        ),
                      );
                      _tempPosition.value = null;
                    },
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
                    onPressed: () async {
                      _tempPosition.value = Duration(
                        seconds:
                            skipDuration + _currentPosition.value.inSeconds,
                      );
                      await _player.seek(
                        Duration(
                          seconds:
                              _currentPosition.value.inSeconds + skipDuration,
                        ),
                      );
                      _tempPosition.value = null;
                    },
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
            _buildSettingsButtons(context),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildMpvSettingsButton(BuildContext context) {
    return [
      PopupMenuButton<String>(
        tooltip: 'Shaders',
        icon: const Icon(Icons.high_quality, color: Colors.white),
        itemBuilder: (context) =>
            [
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
                ]
                .map(
                  (mode) => PopupMenuItem<String>(
                    value: mode.$1,
                    child: Text(
                      mode.$1,
                      style: TextStyle(
                        fontWeight: _selectedShader.value == mode.$1
                            ? FontWeight.w900
                            : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      (_player.platform as NativePlayer).command([
                        "script-message",
                        mode.$2,
                      ]);
                    },
                  ),
                )
                .toList(),
      ),
      PopupMenuButton<String>(
        tooltip: 'Stats',
        icon: const Icon(Icons.memory, color: Colors.white),
        itemBuilder: (context) =>
            [
                  ("Stats Toggle", "stats/display-stats-toggle"),
                  ("Stats Page 1", "stats/display-page-1"),
                  ("Stats Page 2", "stats/display-page-2"),
                  ("Stats Page 3", "stats/display-page-3"),
                  ("Stats Page 4", "stats/display-page-4"),
                  ("Stats Page 5", "stats/display-page-5"),
                ]
                .map(
                  (mode) => PopupMenuItem<String>(
                    value: mode.$1,
                    child: Text(
                      mode.$1,
                      style: TextStyle(
                        fontWeight: _selectedShader.value == mode.$1
                            ? FontWeight.w900
                            : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      (_player.platform as NativePlayer).command([
                        "script-binding",
                        mode.$2,
                      ]);
                    },
                  ),
                )
                .toList(),
      ),
      ValueListenableBuilder(
        valueListenable: _customButtons,
        builder: (context, value, child) => value != null
            ? PopupMenuButton<String>(
                tooltip: context.l10n.custom_buttons,
                icon: const Icon(Icons.terminal, color: Colors.white),
                itemBuilder: (context) => value
                    .map(
                      (btn) => PopupMenuItem<String>(
                        value: btn.title!,
                        child: Text(btn.title!),
                        onTap: () {
                          (_player.platform as NativePlayer).command([
                            "script-message",
                            "call_button_${btn.id}",
                          ]);
                        },
                      ),
                    )
                    .toList(),
              )
            : Container(),
      ),
    ];
  }

  /// helper method for _mobileBottomButtonBar() and _desktopBottomButtonBar()
  Widget _buildSettingsButtons(BuildContext context) {
    final isFullscreen = ref.watch(fullscreenProvider);
    return Row(
      children: [
        IconButton(
          padding: _isDesktop ? EdgeInsets.zero : const EdgeInsets.all(5),
          onPressed: () => _videoSettingDraggableMenu(context),
          icon: const Icon(Icons.video_settings, color: Colors.white),
        ),
        if (useMpvConfig) ..._buildMpvSettingsButton(context),
        PopupMenuButton<double>(
          tooltip: '', // Remove default tooltip "Show menu" for consistency
          icon: const Icon(Icons.speed, color: Colors.white),
          itemBuilder: (context) =>
              [0.25, 0.5, 0.75, 1.0, 1.25, 1.50, 1.75, 2.0]
                  .map(
                    (speed) => PopupMenuItem<double>(
                      value: speed,
                      child: Text("${speed}x"),
                      onTap: () {
                        _setPlaybackSpeed(speed);
                      },
                    ),
                  )
                  .toList(),
        ),
        IconButton(
          icon: const Icon(Icons.fit_screen_outlined, color: Colors.white),
          onPressed: () async {
            _changeFitLabel(ref);
          },
        ),
        if (_isDesktop)
          CustomMaterialDesktopFullscreenButton(
            controller: _controller,
            desktopFullScreenPlayer: widget.desktopFullScreenPlayer,
          )
        else
          IconButton(
            icon: Icon(isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen),
            iconSize: 25,
            color: Colors.white,
            onPressed: () {
              _setLandscapeMode(!isFullscreen);
              ref.read(fullscreenProvider.notifier).state = !isFullscreen;
              widget.desktopFullScreenPlayer.call(!isFullscreen);
            },
          ),
      ],
    );
  }

  Widget _topButtonBar(BuildContext context) {
    final fullScreen = ref.watch(fullscreenProvider);
    return Padding(
      padding: EdgeInsets.only(
        top: !_isDesktop && !fullScreen
            ? MediaQuery.of(context).padding.top
            : 0,
      ),
      child: Row(
        children: [
          BackButton(
            color: Colors.white,
            onPressed: () {
              if (_isDesktop && fullScreen) {
                setFullScreen(value: !fullScreen);
                ref.read(fullscreenProvider.notifier).state = !fullScreen;
                widget.desktopFullScreenPlayer.call(!fullScreen);
              } else {
                SystemChrome.setEnabledSystemUIMode(
                  SystemUiMode.manual,
                  overlays: SystemUiOverlay.values,
                );
              }
              if (mounted) {
                // Set variable to true, so the player uses the global
                // "Use Fullscreen" setting again.
                _firstTime = true;
                Navigator.pop(context);
              }
            },
          ),
          Flexible(
            child: ListTile(
              dense: true,
              title: SizedBox(
                width: context.width(0.8),
                child: Text(
                  widget.episode.manga.value!.name!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              subtitle: SizedBox(
                width: context.width(0.8),
                child: Text(
                  widget.episode.name!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          Row(
            children: [
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

  void _resize(BoxFit fit) async {
    await Future.delayed(const Duration(milliseconds: 100));
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
    return Stack(
      children: [
        Video(
          subtitleViewConfiguration: SubtitleViewConfiguration(
            visible: false,
            style: subtileTextStyle(ref),
          ),
          fit: fit,
          key: _key,
          controls: (state) => _isDesktop
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
                )
              : MobileControllerWidget(
                  videoController: _controller,
                  topButtonBarWidget: _topButtonBar(context),
                  videoStatekey: _key,
                  bottomButtonBarWidget: _mobileBottomButtonBar(context),
                  streamController: _streamController,
                  doubleSpeed: (value) {
                    _isDoubleSpeed.value = value ?? false;
                  },
                  chapterMarks: _chapterMarks,
                ),
          controller: _controller,
          width: context.width(1),
          height: context.height(1),
          resumeUponEnteringForegroundMode: true,
        ),
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
                              if (context.mounted) {
                                final res = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text(
                                        context.l10n.use_this_as_cover_art,
                                      ),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(context.l10n.cancel),
                                            ),
                                            const SizedBox(width: 15),
                                            TextButton(
                                              onPressed: () {
                                                final manga =
                                                    episode.manga.value!;
                                                isar.writeTxnSync(() {
                                                  isar.mangas.putSync(
                                                    manga
                                                      ..updatedAt = DateTime.now()
                                                          .millisecondsSinceEpoch
                                                      ..customCoverImage =
                                                          imageBytes,
                                                  );
                                                });
                                                if (context.mounted) {
                                                  Navigator.pop(context, "ok");
                                                }
                                              },
                                              child: Text(context.l10n.ok),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                                if (res != null &&
                                    res == "ok" &&
                                    context.mounted) {
                                  Navigator.pop(context);
                                  botToast(
                                    context.l10n.cover_updated,
                                    second: 3,
                                  );
                                }
                              }
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
                                await Share.shareXFiles(
                                  [
                                    XFile.fromData(
                                      imageBytes!,
                                      name: name,
                                      mimeType: 'image/png',
                                    ),
                                  ],
                                  sharePositionOrigin:
                                      box!.localToGlobal(Offset.zero) &
                                      box.size,
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
                              final file = File(p.join(dir!.path, "$name.png"));
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
    return Scaffold(body: _videoPlayer(context));
  }
}

Widget seekIndicatorTextWidget(Duration duration, Duration currentPosition) {
  final swipeDuration = duration.inSeconds;
  final value = currentPosition.inSeconds + swipeDuration;
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        Duration(seconds: value).label(),
        style: const TextStyle(
          fontSize: 65.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      Text(
        "[${swipeDuration > 0 ? "+${Duration(seconds: swipeDuration).label()}" : "-${Duration(seconds: swipeDuration).label()}"}]",
        style: const TextStyle(
          fontSize: 40.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
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
