import 'dart:async';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riv;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/video.dart' as vid;
import 'package:mangayomi/modules/anime/providers/anime_player_controller_provider.dart';
import 'package:mangayomi/modules/anime/widgets/aniskip_countdown_btn.dart';
import 'package:mangayomi/modules/anime/widgets/desktop.dart';
import 'package:mangayomi/modules/manga/reader/widgets/btn_chapter_list_dialog.dart';
import 'package:mangayomi/modules/anime/widgets/mobile.dart';
import 'package:mangayomi/modules/anime/widgets/subtitle_view.dart';
import 'package:mangayomi/modules/anime/widgets/subtitle_setting_widget.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_state_provider.dart';
import 'package:mangayomi/modules/widgets/custom_draggable_tabbar.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/aniskip.dart';
import 'package:mangayomi/services/get_video_list.dart';
import 'package:mangayomi/services/torrent_server.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

bool _isDesktop = Platform.isMacOS || Platform.isLinux || Platform.isWindows;

class AnimePlayerView extends riv.ConsumerStatefulWidget {
  final Chapter episode;
  const AnimePlayerView({super.key, required this.episode});

  @override
  riv.ConsumerState<AnimePlayerView> createState() => _AnimePlayerViewState();
}

class _AnimePlayerViewState extends riv.ConsumerState<AnimePlayerView> {
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    if (_isDesktop) {
      setFullScreen(value: ref.read(fullScreenPlayerStateProvider));
    }
  }

  @override
  Widget build(BuildContext context) {
    final serversData =
        ref.watch(getVideoListProvider(episode: widget.episode));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return serversData.when(
      data: (data) {
        final (videos, isLocal, infoHashList) = data;
        _infoHashList = infoHashList;
        if (videos.isEmpty &&
            !(widget.episode.manga.value!.isLocalArchive ?? false)) {
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
            body: const Center(
              child: Text("Video list is empty"),
            ),
          );
        }

        return AnimeStreamPage(
            episode: widget.episode,
            videos: videos,
            isLocal: isLocal,
            isTorrent: infoHashList.isNotEmpty,
            desktopFullScreenPlayer: (value) {
              desktopFullScreenPlayer = value;
            });
      },
      error: (error, stackTrace) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text(''),
          leading: BackButton(
            onPressed: () {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                  overlays: SystemUiOverlay.values);
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Text(error.toString()),
        ),
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
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                    overlays: SystemUiOverlay.values);
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
  final bool isLocal;
  final bool isTorrent;
  final void Function(bool) desktopFullScreenPlayer;
  const AnimeStreamPage(
      {super.key,
      required this.isLocal,
      required this.videos,
      required this.episode,
      required this.isTorrent,
      required this.desktopFullScreenPlayer});

  @override
  riv.ConsumerState<AnimeStreamPage> createState() => _AnimeStreamPageState();
}

class _AnimeStreamPageState extends riv.ConsumerState<AnimeStreamPage>
    with TickerProviderStateMixin {
  late final GlobalKey<VideoState> _key = GlobalKey<VideoState>();
  late final useLibass = ref.read(useLibassStateProvider);
  late final Player _player =
      Player(configuration: PlayerConfiguration(libass: useLibass));
  late final VideoController _controller = VideoController(_player);
  late final _streamController =
      ref.read(animeStreamControllerProvider(episode: widget.episode).notifier);
  late final _firstVid = widget.videos.first;
  late final ValueNotifier<VideoPrefs?> _video = ValueNotifier(VideoPrefs(
      videoTrack: VideoTrack(
          _firstVid.originalUrl, _firstVid.quality, _firstVid.quality),
      headers: _firstVid.headers));
  final ValueNotifier<double> _playbackSpeed = ValueNotifier(1.0);
  final ValueNotifier<bool> _enterFullScreen = ValueNotifier(false);
  late final ValueNotifier<Duration> _currentPosition =
      ValueNotifier(_streamController.geTCurrentPosition());
  final ValueNotifier<Duration?> _currentTotalDuration = ValueNotifier(null);
  final ValueNotifier<bool> _showFitLabel = ValueNotifier(false);
  final ValueNotifier<bool> _isCompleted = ValueNotifier(false);
  final ValueNotifier<Duration?> _tempPosition = ValueNotifier(null);
  final ValueNotifier<BoxFit> _fit = ValueNotifier(BoxFit.contain);
  final ValueNotifier<bool> _showAniSkipOpeningButton = ValueNotifier(false);
  final ValueNotifier<bool> _showAniSkipEndingButton = ValueNotifier(false);
  Results? _openingResult;
  Results? _endingResult;
  bool _hasOpeningSkip = false;
  bool _hasEndingSkip = false;
  bool _initSubtitleAndAudio = true;

  late final StreamSubscription<Duration> _currentPositionSub =
      _player.stream.position.listen(
    (position) async {
      _isCompleted.value =
          _player.state.duration.inSeconds - _currentPosition.value.inSeconds <=
              10;
      _currentPosition.value = position;

      if (_firstVid.subtitles?.isNotEmpty ?? false) {
        if (_initSubtitleAndAudio) {
          try {
            final file = _firstVid.subtitles!.first.file ?? "";
            final label = _firstVid.subtitles!.first.label;
            _player.setSubtitleTrack(file.startsWith("http")
                ? SubtitleTrack.uri(file, title: label, language: label)
                : SubtitleTrack.data(file, title: label, language: label));
          } catch (_) {}
          try {
            if (_firstVid.audios?.isNotEmpty ?? false) {
              _player.setAudioTrack(AudioTrack.uri(
                  _firstVid.audios!.first.file ?? "",
                  title: _firstVid.audios!.first.label,
                  language: _firstVid.audios!.first.label));
            }
          } catch (_) {}
        }
        _initSubtitleAndAudio = false;
      }
    },
  );

  late final StreamSubscription<Duration> _currentTotalDurationSub =
      _player.stream.duration.listen(
    (duration) {
      _currentTotalDuration.value = duration;
    },
  );

  late final StreamSubscription<bool> _completed =
      _player.stream.completed.listen((val) {
    if (_streamController.getEpisodeIndex().$1 != 0 && val == true) {
      if (mounted) {
        pushToNewEpisode(context, _streamController.getNextEpisode());
      }
    }
  });

  void pushToNewEpisode(BuildContext context, Chapter episode) {
    widget.desktopFullScreenPlayer.call(true);
    if (context.mounted) {
      pushReplacementMangaReaderView(context: context, chapter: episode);
    }
  }

  bool isFFF = false;
  @override
  void initState() {
    _currentPositionSub;
    _currentTotalDurationSub;
    _completed;
    _loadAndroidFont().then(
      (_) {
        _player.open(Media(_video.value!.videoTrack!.id,
            httpHeaders: _video.value!.headers,
            start: _streamController.geTCurrentPosition()));
        if (widget.isTorrent) {
          Future.delayed(const Duration(seconds: 10)).then((_) {
            if (mounted) {
              _player.open(Media(_video.value!.videoTrack!.id,
                  httpHeaders: _video.value!.headers,
                  start: _streamController.geTCurrentPosition()));
            }
          });
        }
        _setPlaybackSpeed(ref.read(defaultPlayBackSpeedStateProvider));
        _initAniSkip();
      },
    );
    super.initState();
  }

  Future<void> _loadAndroidFont() async {
    if (Platform.isAndroid && useLibass) {
      try {
        final subDir = await getApplicationDocumentsDirectory();
        final fontPath = path.join(subDir.path, 'subfont.ttf');
        final data = await rootBundle.load('assets/fonts/subfont.ttf');
        final bytes =
            data.buffer.asInt8List(data.offsetInBytes, data.lengthInBytes);
        final fontFile = await File(fontPath).create(recursive: true);
        await fontFile.writeAsBytes(bytes);
        await (_player.platform as NativePlayer)
            .setProperty('sub-fonts-dir', subDir.path);
        await (_player.platform as NativePlayer)
            .setProperty('sub-font', 'Droid Sans Fallback');
      } catch (_) {}
    }
  }

  void _initAniSkip() async {
    await _player.stream.buffer.first;
    _streamController.getAniSkipResults((result) {
      final openingRes =
          result.where((element) => element.skipType == "op").toList();
      _hasOpeningSkip = openingRes.isNotEmpty;
      if (_hasOpeningSkip) {
        _openingResult = openingRes.first;
      }
      final endingRes =
          result.where((element) => element.skipType == "ed").toList();
      _hasEndingSkip = endingRes.isNotEmpty;
      if (_hasEndingSkip) {
        _endingResult = endingRes.first;
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _setCurrentPosition(true);
    _player.dispose();
    _currentPositionSub.cancel();
    _currentTotalDurationSub.cancel();
    _completed.cancel();
    if (!_isDesktop) {
      _setLandscapeMode(false);
    }
    super.dispose();
  }

  void _setCurrentPosition(bool save) {
    _streamController.setCurrentPosition(
        _currentPosition.value, _currentTotalDuration.value,
        save: save);
    _streamController.setAnimeHistoryUpdate();
  }

  void _setLandscapeMode(bool state) {
    if (state) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight
      ]);
    }
  }

  Widget textWidget(String text, bool selected) => Row(
        children: [
          Flexible(
              child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).padding.top),
            child: Text(text,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 16,
                    fontStyle: selected ? FontStyle.italic : null,
                    color: selected ? context.primaryColor : null),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          )),
        ],
      );

  Widget _videoQualityWidget(BuildContext context) {
    List<VideoPrefs> videoQuality = _player.state.tracks.video
        .where((element) =>
            element.w != null && element.h != null && widget.isLocal)
        .toList()
        .map((e) => VideoPrefs(videoTrack: e, isLocal: true))
        .toList();

    if (widget.videos.isNotEmpty && !widget.isLocal) {
      for (var video in widget.videos) {
        videoQuality.add(VideoPrefs(
            videoTrack: VideoTrack(video.url, video.quality, video.quality),
            headers: video.headers,
            isLocal: false));
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
                selected),
            onTap: () async {
              _video.value = quality;
              if (quality.isLocal) {
                if (widget.isLocal) {
                  _player.setVideoTrack(quality.videoTrack!);
                } else {
                  _player.open(Media(quality.videoTrack!.id,
                      httpHeaders: quality.headers,
                      start: _currentPosition.value));
                }
              } else {
                _player.open(Media(quality.videoTrack!.id,
                    httpHeaders: quality.headers,
                    start: _currentPosition.value));
              }
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
        _videoAudios(context)
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
                  text: context.l10n.libass_not_disable_message);
            } else {
              await customDraggableTabBar(tabs: [
                Tab(text: l10n.font),
                Tab(text: l10n.color),
              ], children: [
                FontSettingWidget(hasSubtitleTrack: hasSubtitleTrack),
                ColorSettingWidget(hasSubtitleTrack: hasSubtitleTrack)
              ], context: context, vsync: this, fullWidth: true);
              if (context.mounted) {
                Navigator.pop(context);
              }
            }
          },
          icon: const Icon(Icons.settings_outlined)),
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
    if (widget.videos.isNotEmpty && !widget.isLocal) {
      for (var video in widget.videos) {
        for (var sub in video.subtitles ?? []) {
          if (!subs.contains(sub.file)) {
            final file = sub.file!;
            final label = sub.label;
            videoSubtitle.add(VideoPrefs(
                isLocal: false,
                subtitle: file.startsWith("http")
                    ? SubtitleTrack.uri(file, title: label, language: label)
                    : SubtitleTrack.data(file, title: label, language: label)));
            subs.add(sub.file!);
          }
        }
      }
    }
    final subtitle = _player.state.track.subtitle;
    videoSubtitle = videoSubtitle
        .map((e) {
          VideoPrefs vid = e;
          vid.title = vid.subtitle?.title ??
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
        0, VideoPrefs(isLocal: false, subtitle: SubtitleTrack.no()));
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
        children: videoSubtitleLast.toSet().toList().map((sub) {
          final title = sub.title ??
              sub.subtitle?.title ??
              sub.subtitle?.language ??
              sub.subtitle?.channels ??
              "None";

          final selected = (title ==
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
        }).toList(),
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
            videoAudio.add(VideoPrefs(
                isLocal: false,
                audio: AudioTrack.uri(audio.file!,
                    title: audio.label, language: audio.label)));
            audios.add(audio.file!);
          }
        }
      }
    }
    final audio = _player.state.track.audio;
    videoAudio = videoAudio
        .map((e) {
          VideoPrefs vid = e;
          vid.title = vid.audio?.title ??
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
          final title = aud.title ??
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
              child: textWidget(title, selected));
        }).toList(),
      ),
    );
  }

  Future<void> _setPlaybackSpeed(double speed) async {
    await _player.setRate(speed);
    _playbackSpeed.value = speed;
  }

  void _togglePlaybackSpeed() {
    List<double> allowedSpeeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.50, 1.75, 2.0];
    if (allowedSpeeds.indexOf(_playbackSpeed.value) <
        allowedSpeeds.length - 1) {
      _setPlaybackSpeed(
          allowedSpeeds[allowedSpeeds.indexOf(_playbackSpeed.value) + 1]);
    } else {
      _setPlaybackSpeed(allowedSpeeds[0]);
    }
  }

  Future<void> _changeFitLabel(WidgetRef ref) async {
    List<BoxFit> fitList = [
      BoxFit.contain,
      BoxFit.cover,
      BoxFit.fill,
      BoxFit.fitHeight,
      BoxFit.fitWidth,
      BoxFit.scaleDown,
      BoxFit.none
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
        text: fit.name.toUpperCase());
  }

  Widget _seekToWidget() {
    final defaultSkipIntroLength =
        ref.watch(defaultSkipIntroLengthStateProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        height: 35,
        child: ElevatedButton(
            onPressed: () async {
              _tempPosition.value = Duration(
                  seconds: defaultSkipIntroLength +
                      _currentPosition.value.inSeconds);
              await _player.seek(Duration(
                  seconds: _currentPosition.value.inSeconds +
                      defaultSkipIntroLength));
              _tempPosition.value = null;
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("+$defaultSkipIntroLength",
                  style: const TextStyle(fontWeight: FontWeight.w100)),
            )),
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
                Row(
                  children: [
                    IconButton(
                      padding: const EdgeInsets.all(5),
                      onPressed: () => _videoSettingDraggableMenu(context),
                      icon: const Icon(
                        Icons.video_settings,
                        color: Colors.white,
                      ),
                    ),
                    TextButton(
                        child: ValueListenableBuilder<double>(
                          valueListenable: _playbackSpeed,
                          builder: (context, value, child) {
                            return Text(
                              "${value}x",
                              style: const TextStyle(color: Colors.white),
                            );
                          },
                        ),
                        onPressed: () {
                          _togglePlaybackSpeed();
                        }),
                    IconButton(
                      icon: const Icon(Icons.fit_screen_outlined,
                          color: Colors.white),
                      onPressed: () async {
                        _changeFitLabel(ref);
                      },
                    ),
                    ValueListenableBuilder<bool>(
                        valueListenable: _enterFullScreen,
                        builder: (context, snapshot, _) {
                          return IconButton(
                            onPressed: () {
                              _setLandscapeMode(!snapshot);
                              _enterFullScreen.value = !snapshot;
                            },
                            icon: Icon(snapshot
                                ? Icons.fullscreen_exit
                                : Icons.fullscreen),
                            iconSize: 25,
                            color: Colors.white,
                          );
                        })
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _desktopBottomButtonBar(BuildContext context) {
    bool hasPrevEpisode = _streamController.getEpisodeIndex().$1 + 1 !=
        _streamController
            .getEpisodesLength(_streamController.getEpisodeIndex().$2);
    bool hasNextEpisode = _streamController.getEpisodeIndex().$1 != 0;
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
                          context, _streamController.getPrevEpisode());
                    },
                    icon: const Icon(
                      Icons.skip_previous,
                      color: Colors.white,
                    ),
                  ),
                CustomeMaterialDesktopPlayOrPauseButton(
                  controller: _controller,
                ),
                if (hasNextEpisode)
                  IconButton(
                    onPressed: () async {
                      pushToNewEpisode(
                          context, _streamController.getNextEpisode());
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
                              skipDuration - _currentPosition.value.inSeconds);
                      await _player.seek(Duration(
                          seconds:
                              _currentPosition.value.inSeconds - skipDuration));
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
                                  fontSize: 9, color: Colors.white),
                            ),
                          )),
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
                              skipDuration + _currentPosition.value.inSeconds);
                      await _player.seek(Duration(
                          seconds:
                              _currentPosition.value.inSeconds + skipDuration));
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
                                  fontSize: 9, color: Colors.white),
                            ),
                          )),
                        ),
                      ],
                    ),
                  ),
                ),
                CustomMaterialDesktopVolumeButton(
                  controller: _controller,
                ),
                ValueListenableBuilder(
                  valueListenable: _tempPosition,
                  builder: (context, value, child) =>
                      CustomMaterialDesktopPositionIndicator(
                          delta: value, controller: _controller),
                )
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () => _videoSettingDraggableMenu(context),
                  icon: const Icon(
                    Icons.video_settings,
                    color: Colors.white,
                  ),
                ),
                TextButton(
                    child: ValueListenableBuilder<double>(
                      valueListenable: _playbackSpeed,
                      builder: (context, value, child) {
                        return Text(
                          "${value}x",
                          style: const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                    onPressed: () {
                      _togglePlaybackSpeed();
                    }),
                IconButton(
                  icon: const Icon(Icons.fit_screen_outlined,
                      color: Colors.white),
                  onPressed: () async {
                    _changeFitLabel(ref);
                  },
                ),
                CustomMaterialDesktopFullscreenButton(
                  controller: _controller,
                )
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _topButtonBar(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: _enterFullScreen,
        builder: (context, fullScreen, _) {
          return Padding(
            padding: EdgeInsets.only(
                top: !_isDesktop && !fullScreen
                    ? MediaQuery.of(context).padding.top
                    : 0),
            child: Row(
              children: [
                BackButton(
                  color: Colors.white,
                  onPressed: () async {
                    if (_isDesktop) {
                      if (fullScreen) {
                        setFullScreen(value: false);
                      } else {
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      }
                    } else {
                      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                          overlays: SystemUiOverlay.values);
                      if (mounted) {
                        Navigator.pop(context);
                      }
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
                            fontWeight: FontWeight.bold, color: Colors.white),
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
                            color: Colors.white.withValues(alpha: 0.7)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                Row(children: [
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
                  ),
                  // IconButton(
                  //     onPressed: () {
                  //       showDialog(
                  //           context: context,
                  //           builder: (context) {
                  //             return AlertDialog(
                  //               scrollable: true,
                  //               title: Text("Player Settings"),
                  //               content: SizedBox(
                  //                 width: context.width(0.8),
                  //                 child: Column(
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.start,
                  //                   children: [
                  //                     SwitchListTile(
                  //                         value: false,
                  //                         title: Text(
                  //                           "Enable Volume and Brightness Gestures",
                  //                           style: TextStyle(
                  //                               color: Theme.of(context)
                  //                                   .textTheme
                  //                                   .bodyLarge!
                  //                                   .color!
                  //                                   .withValues(alpha: 0.9),
                  //                               fontSize: 14),
                  //                         ),
                  //                         onChanged: (value) {}),
                  //                     SwitchListTile(
                  //                         value: false,
                  //                         title: Text(
                  //                           "Enable Horizonal Seek Gestures",
                  //                           style: TextStyle(
                  //                               color: Theme.of(context)
                  //                                   .textTheme
                  //                                   .bodyLarge!
                  //                                   .color!
                  //                                   .withValues(alpha: 0.9),
                  //                               fontSize: 14),
                  //                         ),
                  //                         onChanged: (value) {}),
                  //                   ],
                  //                 ),
                  //               ),
                  //             );
                  //           });
                  //     },
                  //     icon: Icon(Icons.adaptive.more))
                ])
              ],
            ),
          );
        });
  }

  void _resize(BoxFit fit) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      _key.currentState?.update(
          fit: fit, width: context.width(1), height: context.height(1));
    }
  }

  Widget _videoPlayer(BuildContext context) {
    final fit = _fit.value;
    _resize(fit);
    return Stack(
      children: [
        Video(
          subtitleViewConfiguration: SubtitleViewConfiguration(
              visible: false, style: subtileTextStyle(ref)),
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
                    child: Row(
                      children: [
                        _seekToWidget(),
                      ],
                    ),
                  ),
                  tempDuration: (value) {
                    _tempPosition.value = value;
                  },
                )
              : MobileControllerWidget(
                  videoController: _controller,
                  topButtonBarWidget: _topButtonBar(context),
                  videoStatekey: _key,
                  bottomButtonBarWidget: _mobileBottomButtonBar(context),
                  streamController: _streamController,
                ),
          controller: _controller,
          width: context.width(1),
          height: context.height(1),
          resumeUponEnteringForegroundMode: true,
        ),
        Positioned(
          right: 0,
          bottom: 80,
          child: ValueListenableBuilder(
            valueListenable: _currentPosition,
            builder: (context, value, child) {
              if (_hasOpeningSkip || _hasEndingSkip) {
                if (_hasOpeningSkip) {
                  if (_openingResult!.interval!.startTime!.ceil() <=
                          value.inSeconds &&
                      _openingResult!.interval!.endTime!.toInt() >
                          value.inSeconds) {
                    _showAniSkipOpeningButton.value = true;
                    _showAniSkipEndingButton.value = false;
                  } else {
                    _showAniSkipOpeningButton.value = false;
                  }
                }
                if (_hasEndingSkip) {
                  if (_endingResult!.interval!.startTime!.ceil() <=
                          value.inSeconds &&
                      _endingResult!.interval!.endTime!.toInt() >
                          value.inSeconds) {
                    _showAniSkipEndingButton.value = true;
                    _showAniSkipOpeningButton.value = false;
                  }
                } else {
                  _showAniSkipEndingButton.value = false;
                }
              }
              return Consumer(builder: (context, ref, _) {
                late final enableAniSkip =
                    ref.watch(enableAniSkipStateProvider);
                late final enableAutoSkip =
                    ref.watch(enableAutoSkipStateProvider);
                late final aniSkipTimeoutLength =
                    ref.watch(aniSkipTimeoutLengthStateProvider);
                return ValueListenableBuilder(
                  valueListenable: _showAniSkipOpeningButton,
                  builder: (context, showAniSkipOpENINGButton, child) {
                    return ValueListenableBuilder(
                      valueListenable: _showAniSkipEndingButton,
                      builder: (context, showAniSkipENDINGButton, child) {
                        return showAniSkipOpENINGButton
                            ? Container(
                                key: const Key('skip_opening'),
                                child: AniSkipCountDownButton(
                                  active: enableAniSkip,
                                  autoSkip: enableAutoSkip,
                                  timeoutLength: aniSkipTimeoutLength,
                                  skipTypeText: context.l10n.skip_opening,
                                  player: _player,
                                  aniSkipResult: _openingResult,
                                ))
                            : showAniSkipENDINGButton
                                ? Container(
                                    key: const Key('skip_ending'),
                                    child: AniSkipCountDownButton(
                                      active: enableAniSkip,
                                      autoSkip: enableAutoSkip,
                                      timeoutLength: aniSkipTimeoutLength,
                                      skipTypeText: context.l10n.skip_ending,
                                      player: _player,
                                      aniSkipResult: _endingResult,
                                    ))
                                : const SizedBox.shrink();
                      },
                    );
                  },
                );
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _videoPlayer(context),
    );
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
            fontSize: 65.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      Text(
        "[${swipeDuration > 0 ? "+${Duration(seconds: swipeDuration).label()}" : "-${Duration(seconds: swipeDuration).label()}"}]",
        style: const TextStyle(
            fontSize: 40.0, color: Colors.white, fontWeight: FontWeight.bold),
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
  VideoPrefs(
      {this.videoTrack,
      this.isLocal = true,
      this.headers,
      this.subtitle,
      this.audio,
      this.title});
}
