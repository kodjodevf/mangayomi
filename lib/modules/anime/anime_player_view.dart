import 'dart:async';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riv;
import 'package:mangayomi/services/discord_rpc.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/custom_button.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/video.dart' as vid;
import 'package:mangayomi/modules/anime/mixins/anime_mpv_bridge_mixin.dart';
import 'package:mangayomi/modules/anime/mixins/anime_player_controls_mixin.dart';
import 'package:mangayomi/modules/anime/mixins/anime_player_settings_mixin.dart';
import 'package:mangayomi/modules/anime/mixins/anime_track_selection_mixin.dart';
import 'package:mangayomi/modules/anime/providers/anime_player_controller_provider.dart';
import 'package:mangayomi/modules/anime/providers/auto_play_next_provider.dart';
import 'package:mangayomi/modules/anime/utils/playback_media.dart';
import 'package:mangayomi/modules/anime/utils/video_filters.dart';
import 'package:mangayomi/modules/anime/utils/video_prefs.dart';
import 'package:mangayomi/modules/anime/providers/state_provider.dart';
import 'package:mangayomi/modules/anime/utils/player_lifecycle.dart';
import 'package:mangayomi/modules/anime/widgets/anime_screenshot_sheet.dart';
import 'package:mangayomi/modules/anime/widgets/aniskip_countdown_btn.dart';
import 'package:mangayomi/modules/anime/widgets/gesture_hint_overlay.dart';
import 'package:mangayomi/modules/anime/widgets/up_next_chip.dart';
import 'package:mangayomi/modules/anime/widgets/tv_player_settings_panel.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/anime/widgets/desktop.dart';
import 'package:mangayomi/modules/anime/widgets/mobile.dart';
import 'package:mangayomi/modules/anime/widgets/subtitle_view.dart';
import 'package:mangayomi/router/push_router.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_audio_state_provider.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_decoder_state_provider.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_state_provider.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/reader_common/widgets/chapter_bar_title.dart';
import 'package:mangayomi/modules/reader_common/widgets/reader_app_bar.dart'
    show buildWebViewData;
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/aniskip.dart';
import 'package:mangayomi/services/get_video_list.dart';
import 'package:mangayomi/services/torrent_server.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/utils/system_ui.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit/generated/libmpv/bindings.dart' as generated;
import 'package:media_kit_video/media_kit_video.dart';
import 'package:mangayomi/modules/anime/utils/always_on_top.dart';
import 'package:mangayomi/modules/anime/utils/mpv_subtitle_options.dart';
import 'package:mangayomi/modules/reader_common/mixins/chapter_controller_mixin.dart';

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

  Widget _buildLoading() =>
      _stateScaffold(const ProgressCenter(), onImage: true);

  /// The loading, failure and no-video states, under a bar that says which
  /// episode is being opened, as the player's own top bar does. The bodies
  /// hold nothing to focus first, so the back button takes the remote's
  /// focus on TV (an IconButton, as only it takes autofocus); it also gives
  /// the system bars back.
  Widget _stateScaffold(Widget body, {bool onImage = false}) {
    return Scaffold(
      backgroundColor: onImage ? Colors.black : context.shiori.color.ink0,
      extendBodyBehindAppBar: onImage,
      appBar: AppBar(
        backgroundColor: onImage ? Colors.transparent : null,
        titleSpacing: 0,
        title: ChapterBarTitle(chapter: episode, onImage: onImage),
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          color: onImage ? Colors.white : null,
          autofocus: isTv,
          icon: const BackButtonIcon(),
          onPressed: () {
            restoreSystemUI();
            Navigator.pop(context);
          },
        ),
      ),
      body: body,
    );
  }

  /// The source's own page for the episode, where a viewer can see why it
  /// gives no video; local files have none.
  VoidCallback? get _openWebView {
    if (episode.manga.value?.isLocalArchive ?? true) return null;
    final data = buildWebViewData(episode);
    if (data == null) return null;
    return () => context.push("/mangawebview", extra: data);
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
          // No video is a failure like another: say so, and offer to try
          // again or to look at the source's page.
          final openWebView = _openWebView;
          return _stateScaffold(
            ErrorState(
              message: context.l10n.video_list_empty,
              autofocusRetry: false,
              onRetry: () =>
                  ref.invalidate(getVideoListProvider(episode: episode)),
              secondaryLabel: openWebView == null ? null : context.l10n.webview,
              secondaryIcon: Symbols.public_rounded,
              onSecondary: openWebView,
            ),
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
        final openWebView = _openWebView;
        // The back button above already claims TV focus, so the retry must
        // not also ask for it; it stays reachable with the d-pad.
        return _stateScaffold(
          ErrorState(
            autofocusRetry: false,
            detail: error.toString(),
            onRetry: () =>
                ref.invalidate(getVideoListProvider(episode: episode)),
            secondaryLabel: openWebView == null ? null : context.l10n.webview,
            secondaryIcon: Symbols.public_rounded,
            onSecondary: openWebView,
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
        AlwaysOnTopStateMixin,
        TickerProviderStateMixin,
        WidgetsBindingObserver,
        AnimeMpvBridgeMixin,
        AnimeTrackSelectionMixin,
        AnimePlayerSettingsMixin,
        AnimePlayerControlsMixin {
  @override
  VideoController get controlsVideoController => _controller;
  @override
  ValueNotifier<Duration?> get controlsTempPosition => _tempPosition;
  @override
  ValueNotifier<bool> get controlsIsLocked => _isLocked;
  @override
  ValueNotifier<int> get controlsReveal => _revealControls;
  @override
  FocusNode get controlsTvPanelFocus => _tvPanelFocus;
  @override
  VoidCallback get controlsGoBackToDetail => _goBackToDetail;
  @override
  VoidCallback get controlsChangeFitLabel =>
      () => _changeFitLabel(ref);
  @override
  Future<void> Function(bool isFullscreen) get controlsToggleFullscreen =>
      _toggleFullscreen;
  @override
  VoidCallback get controlsOpenTvSettingsPanel =>
      () => setState(() => _tvSettingsOpen = true);
  @override
  Player get mpvBridgePlayer => _player;
  @override
  bool get mpvUseLibass => useLibass;
  @override
  bool get mpvUseMpvConfig => useMpvConfig;
  @override
  AnimeStreamController get mpvStreamController => _streamController;
  @override
  ValueNotifier<ActiveCustomButton?> get mpvCustomButton => _customButton;
  @override
  ValueNotifier<List<CustomButton>?> get mpvCustomButtons => _customButtons;
  @override
  ValueNotifier<List<(String, int)>> get mpvChapterMarks => _chapterMarks;
  @override
  ValueNotifier<int?> get mpvCurrentChapterMark => _currentChapterMark;
  @override
  ValueNotifier<String> get mpvSelectedShader => _selectedShader;
  @override
  TextEditingController get mpvSubDelayController => _subDelayController;
  @override
  TextEditingController get mpvAudioDelayController => _audioDelayController;
  @override
  TextEditingController get mpvSubSpeedController => _subSpeedController;
  @override
  Future<void> mpvSeekTo(int absoluteSeconds) => _seekTo(absoluteSeconds);
  @override
  Future<void> mpvSeekBy(int deltaSeconds) => _seekBy(deltaSeconds);
  @override
  Future<void> mpvPushToNewEpisode(BuildContext context, Chapter episode) =>
      pushToNewEpisode(context, episode);

  @override
  Player get trackPlayer => _player;
  @override
  List<vid.Video> get trackVideos => widget.videos;
  @override
  vid.Video get firstVideoForTracks => _firstVid;
  @override
  bool get isLocalForTracks => widget.isLocal;
  @override
  String get defaultSubtitleLanguage => widget.defaultSubtitle;
  @override
  String get preferredAudioLanguagesCsv => audioPreferredLang;
  @override
  ValueNotifier<VideoPrefs?> get selectedVideoPrefs => _video;
  @override
  Future<void> openMediaFromTrackSelection(VideoPrefs prefs) =>
      _openMedia(prefs);

  @override
  Chapter get settingsEpisode => widget.episode;
  @override
  GlobalKey<VideoState> get settingsVideoStateKey => _key;
  @override
  ValueNotifier<double> get settingsPlaybackSpeed => _playbackSpeed;
  @override
  ValueNotifier<BoxFit> get settingsFit => _fit;
  @override
  ValueNotifier<bool> get settingsAutoplayNext => _autoplayNext;
  @override
  Future<void> settingsSetPlaybackSpeed(double speed) =>
      _setPlaybackSpeed(speed);
  @override
  Future<void> settingsShareScreenshot(
    BuildContext sheetContext,
    Chapter episode,
  ) => _showShareScreenshotActions(sheetContext, episode);

  bool _routeExitInProgress = false;
  bool _videoTextureVisible = true;

  /// The gesture guide, over the first video on a phone only: a desktop
  /// has a pointer and a TV a remote, neither of which swipes.
  late bool _showGestureHint = !isDesktop && !isTv && shouldShowGestureHint();
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
  riv.ProviderSubscription<PlayerSubtitleSettings>? _subSettingsSub;

  late final audioChannel = ref.read(audioChannelStateProvider);
  late final volumeBoostCap = ref.read(volumeBoostCapStateProvider);
  late final audioDelayMs = ref.read(audioDelayStateProvider);

  /// Read once the player starts: dispose() can no longer use ref.
  late final bool _rememberVolume;
  late final double? rememberedVolume = _rememberVolume
      ? settingsRepository.current.playerVolume
      : null;
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
        if (audioDelayMs != 0) "audio-delay": "${audioDelayMs / 1000}",
        ...videoFilterOptions(ref.read(videoFiltersStateProvider)),
        // On a desktop the volume is the player's own; a phone's is the
        // system's, which the mobile controls restore.
        if (isDesktop && rememberedVolume != null)
          "volume": "${rememberedVolume!.round()}",
        if (audioChannel != AudioChannel.reverseStereo)
          "audio-channels": audioChannel.mpvName,
        if (audioChannel == AudioChannel.reverseStereo)
          "af": audioChannel.mpvName,
        if (useLibass)
          ...mpvInitialSubtitleOptions(ref.read(subtitleSettingsStateProvider)),
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
      eventHandler: handleMpvEvents,
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
  final ValueNotifier<bool> _isLocked = ValueNotifier(false);
  late final ValueNotifier<_AniSkipPhase> _skipPhase = ValueNotifier(
    _AniSkipPhase.none,
  );
  Results? _openingResult;
  Results? _endingResult;

  /// The autoplay switch in the settings, mirroring its provider.
  final ValueNotifier<bool> _autoplayNext = ValueNotifier(true);

  /// The opening and the ending, in milliseconds, for the timeline to mark.
  final ValueNotifier<List<(int, int)>> _skipRanges = ValueNotifier(const []);
  bool _hasOpeningSkip = false;
  bool _hasEndingSkip = false;
  bool _includeSubtitles = false;
  final _subDelayController = TextEditingController(text: "0");
  final _subSpeedController = TextEditingController(text: "1.00");
  late final _audioDelayController = TextEditingController(
    text: "${ref.read(audioDelayStateProvider)}",
  );
  int lastRpcTimestampUpdate = DateTime.now().millisecondsSinceEpoch;

  late final StreamSubscription<Duration> _currentPositionSub;
  late final StreamSubscription<String> _playerErrorSub;
  StreamSubscription<Tracks>? _tracksSub;
  StreamSubscription<Track>? _trackSub;

  late final StreamSubscription<Duration> _currentTotalDurationSub = _player
      .stream
      .duration
      .listen((duration) {
        _currentTotalDuration.value = duration;
        discordRpc?.updateChapterTimestamp(_currentPosition.value, duration);
      });

  bool get hasNextEpisode => _streamController.hasNextEpisode;

  /// The viewer chose to stay on this episode from the "up next" chip, so
  /// it does not roll on into the next one when it ends.
  final ValueNotifier<bool> _stayOnEpisode = ValueNotifier(false);

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
    if (hasNext &&
        ref.read(autoPlayNextEpisodeProvider) &&
        !_stayOnEpisode.value) {
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

  Future<void> _seekTo(int absoluteSeconds) async {
    _tempPosition.value = Duration(seconds: absoluteSeconds);
    await _player.seek(Duration(seconds: absoluteSeconds));
    _tempPosition.value = null;
  }

  Future<void> _seekBy(int deltaSeconds) async {
    final pos = _currentPosition.value.inSeconds + deltaSeconds;
    await _seekTo(pos);
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
    initializeDefaultSubtitleAndAudioTracks();
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

  @override
  void initState() {
    super.initState();
    beginReadingSession();
    _rememberVolume = ref.read(rememberPlayerVolumeStateProvider);
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
    _playerErrorSub = _player.stream.error.listen(reportPlaybackError);
    _tracksSub = _player.stream.tracks.listen((_) {
      syncActiveAudioTrackFromMpv();
      syncActiveSubtitleTrackFromMpv();
    });
    _trackSub = _player.stream.track.listen((_) {
      syncActiveAudioTrackFromMpv();
      syncActiveSubtitleTrackFromMpv();
    });
    // ignore: unnecessary_statements
    _completed;
    // ignore: unnecessary_statements
    _currentTotalDurationSub;
    loadAndroidFont().then((_) {
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
    initCustomButton();
    discordRpc?.showChapterDetails(ref, widget.episode);
    _currentPosition.addListener(_updateRpcTimestamp);
    _subDelayController.addListener(onSubDelayChanged);
    _subSpeedController.addListener(onSubSpeedChanged);
    _audioDelayController.addListener(onAudioDelayChanged);
    if (useLibass) {
      _subSettingsSub = ref.listenManual(subtitleSettingsStateProvider, (
        previous,
        next,
      ) {
        applySubtitleSettingsToMpv(next);
      });
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _watchStopwatch.stop();
      // Save the watch time now: the system may kill the app in the
      // background, and dispose() would never run.
      _setCurrentPosition(true, saveWatchTime: true);
      _watchStopwatch.reset();
    } else if (state == AppLifecycleState.resumed) {
      _watchStopwatch.start();
    }
  }

  Future<void> _openMedia(VideoPrefs prefs, [Duration? position]) async {
    final start = position ?? _currentPosition.value;
    resetAudioFallbackState(resetRequestedLanguage: true);
    await _player.open(
      playbackMedia(
        prefs.videoTrack!.id,
        isLocal: widget.isLocal,
        httpHeaders: prefs.headers,
        start: start,
      ),
    );
    if (start > Duration.zero) {
      unawaited(
        _player.stream.duration
            .firstWhere((d) => d > Duration.zero)
            .timeout(const Duration(seconds: 8))
            .then((_) => mounted ? _player.seek(start) : null)
            .catchError((_) {}),
      );
    }
    unawaited(syncActiveAudioTrackFromMpv());
    unawaited(syncActiveSubtitleTrackFromMpv());
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
      _skipRanges.value = [
        for (final r in [?_openingResult, ?_endingResult])
          if (r.interval?.startTime != null && r.interval?.endTime != null)
            (
              (r.interval!.startTime! * 1000).round(),
              (r.interval!.endTime! * 1000).round(),
            ),
      ];
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
    _subDelayController.removeListener(onSubDelayChanged);
    _audioDelayController.removeListener(onAudioDelayChanged);
    _subSpeedController.removeListener(onSubSpeedChanged);
    _subSettingsSub?.close();
    WidgetsBinding.instance.removeObserver(this);
    _setCurrentPosition(true, saveWatchTime: true);
    if (isDesktop && _rememberVolume) {
      final volume = _player.state.volume;
      settingsRepository.update((s) => s.playerVolume = volume);
    }
    final playerCleanup = disposePlaybackSession(
      listenerCancellations: [
        _completed.cancel(),
        _currentPositionSub.cancel(),
        _playerErrorSub.cancel(),
        _currentTotalDurationSub.cancel(),
        if (_tracksSub != null) _tracksSub!.cancel(),
        if (_trackSub != null) _trackSub!.cancel(),
      ],
      beforeDisposePlayer: Platform.isWindows
          ? () => Future<void>.delayed(const Duration(milliseconds: 250))
          : null,
      disposePlayer: _player.dispose,
    );
    unawaited(playerCleanup.catchError((_) {}));
    _currentPosition.dispose();
    _stayOnEpisode.dispose();
    _currentTotalDuration.dispose();
    _video.dispose();
    _playbackSpeed.dispose();
    _isDoubleSpeed.dispose();
    _showFitLabel.dispose();
    _isCompleted.dispose();
    _tempPosition.dispose();
    _fit.dispose();
    _isLocked.dispose();
    _skipRanges.dispose();
    _autoplayNext.dispose();
    _skipPhase.dispose();
    _subDelayController.dispose();
    _audioDelayController.dispose();
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
    final label = fit.name.toUpperCase();
    BotToast.showCustomText(
      onlyOne: true,
      align: const Alignment(0, 0.90),
      duration: const Duration(seconds: 1),
      toastBuilder: (_) => ShioriOverlayLabel(label),
    );
  }

  Future<void> _toggleFullscreen(bool isFullscreen) async {
    if (isDesktop) {
      final isFullScreen = await setFullScreen(value: !isFullscreen);
      ref.read(fullscreenProvider.notifier).state = isFullScreen;
      widget.desktopFullScreenPlayer.call(isFullScreen);
    } else {
      _setLandscapeMode(!isFullscreen);
      ref.read(fullscreenProvider.notifier).state = !isFullscreen;
      widget.desktopFullScreenPlayer.call(!isFullscreen);
    }
  }

  /// How high above the bottom edge (past the system's inset) what floats
  /// over the video sits so the controls panel never covers it: the
  /// timeline, a row of pills and the panel's margins.
  static const double _aboveControlsPanel = 128;

  BoxFit? _lastFit;
  Future<void> _resize(BoxFit fit) async {
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
    final insets = MediaQuery.viewPaddingOf(context);
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
                ? (_tvSettingsOpen ? const SizedBox.shrink() : tvControls())
                : (isDesktop || isTv)
                ? DesktopControllerWidget(
                    videoController: _controller,
                    topButtonBarWidget: topButtonBar(context),
                    videoStatekey: _key,
                    bottomButtonBarWidget: desktopBottomButtonBar(context),
                    streamController: _streamController,
                    seekToWidget: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ShioriSpace.s12,
                      ),
                      child: Row(children: [seekToWidget()]),
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
                    skipRanges: _skipRanges,
                  )
                : MobileControllerWidget(
                    videoController: _controller,
                    topButtonBarWidget: topButtonBar(context),
                    videoStatekey: _key,
                    bottomButtonBarWidget: mobileBottomButtonBar(context),
                    abovePanelWidget: mobileAbovePanel(context),
                    streamController: _streamController,
                    revealControls: _revealControls,
                    chapterMarks: _chapterMarks,
                    isLocked: _isLocked,
                    skipRanges: _skipRanges,
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
                          ..color = context.shiori.color.ink0
                          ..strokeWidth = 30.0
                          ..strokeJoin = StrokeJoin.round
                          ..style = PaintingStyle.stroke,
                      ),
                      children: snapshot
                          ? [
                              TextSpan(
                                text: " 2X ",
                                style: TextStyle(
                                  fontSize: context.shiori.text.body.fontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Icon(
                                  Symbols.fast_forward_rounded,
                                  fill: 1,
                                ),
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
        // Above the floating panel, on its right edge, where the eye already
        // goes for what comes next.
        if (enableAniSkip && (_hasOpeningSkip || _hasEndingSkip))
          Positioned(
            right: insets.right + ShioriSpace.s8,
            bottom: insets.bottom + _aboveControlsPanel,
            child: ValueListenableBuilder<bool>(
              valueListenable: _isLocked,
              builder: (context, isLocked, _) {
                if (isLocked) return const SizedBox.shrink();
                return ValueListenableBuilder<_AniSkipPhase>(
                  valueListenable: _skipPhase,
                  builder: (context, phase, _) {
                    if (phase == _AniSkipPhase.none) {
                      return const SizedBox.shrink();
                    }
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
                );
              },
            ),
          ),
        // "Next episode in 12 s" over the last seconds, when the player is set
        // to roll on: say so, and let the viewer stay.
        if (hasNextEpisode)
          Positioned(
            right: insets.right + ShioriSpace.s16,
            bottom: insets.bottom + _aboveControlsPanel + ShioriSpace.s48,
            child: Consumer(
              builder: (context, ref, _) {
                if (!ref.watch(autoPlayNextEpisodeProvider)) {
                  return const SizedBox.shrink();
                }
                return ValueListenableBuilder<bool>(
                  valueListenable: _stayOnEpisode,
                  builder: (context, stay, _) => stay
                      ? const SizedBox.shrink()
                      : ValueListenableBuilder<Duration>(
                          valueListenable: _currentPosition,
                          builder: (context, position, _) {
                            final total = _currentTotalDuration.value;
                            if (total == null || total <= Duration.zero) {
                              return const SizedBox.shrink();
                            }
                            final left = total - position;
                            if (left <= Duration.zero || left > upNextWindow) {
                              return const SizedBox.shrink();
                            }
                            return UpNextChip(
                              secondsLeft: left.inSeconds,
                              onPlayNow: () => pushToNewEpisode(
                                context,
                                _streamController.getNextEpisode(),
                              ),
                              onCancel: () => _stayOnEpisode.value = true,
                            );
                          },
                        ),
                );
              },
            ),
          ),
        if (_showGestureHint)
          Positioned.fill(
            child: GestureHintOverlay(
              onDismiss: () {
                markGestureHintSeen();
                setState(() => _showGestureHint = false);
              },
            ),
          ),
      ],
    );
    if (!docked) return player;
    // YouTube-style split: video docks left (a single focusable unit — Left
    // from the panel focuses it, Select toggles play/pause), a gap, then the
    // settings panel on the right.
    final accent = context.shiori.color.accentInk;
    return ColoredBox(
      color: Colors.black,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(ShioriSpace.s16),
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
            qualityOptions: tvQualityOptions,
            subtitleOptions: tvSubtitleOptions,
            audioOptions: tvAudioOptions,
            headerFocusNode: _tvPanelFocus,
            onExitLeft: () => _tvVideoFocus.requestFocus(),
            onClose: () => setState(() => _tvSettingsOpen = false),
          ),
        ],
      ),
    );
  }

  Future<void> _showShareScreenshotActions(
    BuildContext sheetContext,
    Chapter episode, {
    void Function(bool)? onChanged,
  }) => showAnimeShareScreenshotActions(
    sheetContext,
    episode: episode,
    player: _player,
    currentPosition: _currentPosition.value,
    includeSubtitles: () => _includeSubtitles,
    onIncludeSubtitlesChanged: (value) {
      setState(() => _includeSubtitles = value);
    },
    onChanged: onChanged,
  );

  @override
  Widget build(BuildContext context) {
    final body = _videoPlayer(context);
    // Desktop already gets player keyboard shortcuts through media_kit's
    // DesktopControllerWidget. On mobile / Android TV the controls have none,
    // so wrap the player so a physical keyboard or TV remote can drive
    // playback too. See #668 / #729.
    final content = Scaffold(
      body: isDesktop ? body : wrapWithPlayerShortcuts(body),
    );

    if (isDesktop) return content;

    return ValueListenableBuilder<bool>(
      valueListenable: _isLocked,
      builder: (context, isLocked, _) {
        return PopScope(
          canPop: !isLocked,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              _revealControls.value++;
            }
          },
          child: content,
        );
      },
    );
  }
}
