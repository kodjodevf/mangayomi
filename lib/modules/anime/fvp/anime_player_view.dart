import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riv;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/video.dart' as vid;
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/modules/anime/providers/anime_player_controller_provider.dart';
import 'package:mangayomi/modules/anime/fvp/widgets/aniskip_countdown_btn.dart';
import 'package:mangayomi/modules/anime/fvp/widgets/desktop.dart';
import 'package:mangayomi/modules/anime/fvp/widgets/mobile.dart';
import 'package:mangayomi/modules/anime/widgets/subtitle_setting_widget.dart';
import 'package:mangayomi/modules/manga/reader/widgets/btn_chapter_list_dialog.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_state_provider.dart';
import 'package:mangayomi/modules/widgets/custom_draggable_tabbar.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/aniskip.dart';
import 'package:mangayomi/services/get_video_list.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/services/torrent_server.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';
import 'package:video_player/video_player.dart';
import 'package:window_manager/window_manager.dart';

class AnimePlayerViewFvp extends riv.ConsumerStatefulWidget {
  final Chapter episode;
  const AnimePlayerViewFvp({super.key, required this.episode});

  @override
  riv.ConsumerState<AnimePlayerViewFvp> createState() =>
      _AnimePlayerViewFvpState();
}

class _AnimePlayerViewFvpState extends riv.ConsumerState<AnimePlayerViewFvp> {
  String? _infoHash;
  @override
  void dispose() {
    MTorrentServer().removeTorrent(_infoHash);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serversData =
        ref.watch(getVideoListProvider(episode: widget.episode));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return serversData.when(
      data: (data) {
        _infoHash = data.$3;
        if (data.$1.isEmpty &&
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
              child: Text("Error"),
            ),
          );
        }

        return AnimeStreamPage(
          episode: widget.episode,
          videos: data.$1,
          isLocal: data.$2,
        );
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
  const AnimeStreamPage(
      {super.key,
      required this.isLocal,
      required this.videos,
      required this.episode});

  @override
  riv.ConsumerState<AnimeStreamPage> createState() => _AnimeStreamPageState();
}

class _AnimeStreamPageState extends riv.ConsumerState<AnimeStreamPage>
    with TickerProviderStateMixin {
  late Video _selectedVideo = widget.videos.first;
  late final List<Track> _subtitles = _selectedVideo.subtitles ?? [];
  late Track? _selectedSubtitle =
      _subtitles.isNotEmpty ? _subtitles.first : null;
  late VideoPlayerController _controller =
      _load(_selectedVideo, _selectedSubtitle);

  VideoPlayerController _load(Video video, Track? subtitle) {
    return video.originalUrl.startsWith('http')
        ? VideoPlayerController.networkUrl(Uri.parse(video.originalUrl),
            httpHeaders: video.headers ?? {},
            closedCaptionFile:
                subtitle != null ? _loadCaption(subtitle.file!) : null)
        : VideoPlayerController.file(File(video.originalUrl),
            httpHeaders: video.headers ?? {},
            closedCaptionFile:
                subtitle != null ? _loadCaption(subtitle.file!) : null);
  }

  late final _streamController =
      ref.read(animeStreamControllerProvider(episode: widget.episode).notifier);

  final ValueNotifier<double> _playbackSpeed = ValueNotifier(1.0);
  final ValueNotifier<bool> _enterFullScreen = ValueNotifier(false);
  late final ValueNotifier<Duration> _currentPosition =
      ValueNotifier(_streamController.geTCurrentPosition());
  final ValueNotifier<Duration?> _currentTotalDuration = ValueNotifier(null);
  final ValueNotifier<bool> _isCompleted = ValueNotifier(false);
  final ValueNotifier<Duration?> _tempPosition = ValueNotifier(null);

  Results? _openingResult;
  Results? _endingResult;
  bool _hasOpeningSkip = false;
  bool _hasEndingSkip = false;
  final ValueNotifier<bool> _showAniSkipOpeningButton = ValueNotifier(false);
  final ValueNotifier<bool> _showAniSkipEndingButton = ValueNotifier(false);

  Future<ClosedCaptionFile>? _loadCaption(String url) async {
    String fileContents = "";
    fileContents =
        utf8.decode((await MClient.init().get(Uri.parse(url))).bodyBytes);
    if (url.endsWith(".srt")) {
      return SubRipCaptionFile(fileContents);
    }
    return WebVTTCaptionFile(fileContents);
  }

  @override
  void initState() {
    _setCurrentPosition(true);
    _listener();
    _controller.initialize().then((_) => setState(() {}));

    _initAniSkip();
    super.initState();
  }

  bool _isInitiated = false;
  void _listener({Duration? duration}) {
    _controller.addListener(() {
      setState(() {});
      if (_controller.value.isPlaying && !_isInitiated) {
        _seekToCurrentPosition(duration: duration);
        _isInitiated = true;
      }
      _isCompleted.value = _controller.value.duration.inSeconds -
              _currentPosition.value.inSeconds <=
          10;
      _currentPosition.value = _controller.value.position;
    });
  }

  Future<void> _seekToCurrentPosition({Duration? duration}) async {
    await _controller.play();
    await _controller
        .seekTo(duration ?? _streamController.geTCurrentPosition());
  }

  void _initAniSkip() async {
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

  bool isDesktop = Platform.isMacOS || Platform.isLinux || Platform.isWindows;
  @override
  void dispose() {
    _setCurrentPosition(true);
    if (isDesktop) {
      setFullScreen(value: false);
    } else {
      _setLandscapeMode(false);
    }
    _controller.dispose();
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

  Future<void> _setPlaybackSpeed(double speed) async {
    await _controller.setPlaybackSpeed(speed);
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
    // List<BoxFit> fitList = [
    //   BoxFit.contain,
    //   BoxFit.cover,
    //   BoxFit.fill,
    //   BoxFit.fitHeight,
    //   BoxFit.fitWidth,
    //   BoxFit.scaleDown,
    //   BoxFit.none
    // ];
    // _showFitLabel.value = true;
    // BoxFit? fit;
    // if (fitList.indexOf(_fit.value) < fitList.length - 1) {
    //   fit = fitList[fitList.indexOf(_fit.value) + 1];
    // } else {
    //   fit = fitList[0];
    // }
    // _fit.value = fit;
    // _controller.currentState?.update(fit: fit);
    // BotToast.showText(
    //     onlyOne: true,
    //     align: const Alignment(0, 0.90),
    //     duration: const Duration(seconds: 1),
    //     text: fit.name.toUpperCase());
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
              await _controller.seekTo(Duration(
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
                    // IconButton(
                    //   icon: const Icon(Icons.fit_screen_outlined,
                    //       color: Colors.white),
                    //   onPressed: () async {
                    //     _changeFitLabel(ref);
                    //   },
                    // ),
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
                    onPressed: () async {
                      if (isDesktop) {
                        final isFullScreen = await windowManager.isFullScreen();
                        if (isFullScreen) {
                          await setFullScreen(value: false);
                        }
                      }
                      if (context.mounted) {
                        pushReplacementMangaReaderView(
                            context: context,
                            chapter: _streamController.getPrevEpisode());
                      }
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
                      if (isDesktop) {
                        final isFullScreen = await windowManager.isFullScreen();
                        if (isFullScreen) {
                          await setFullScreen(value: false);
                        }
                      }
                      if (context.mounted) {
                        pushReplacementMangaReaderView(
                          context: context,
                          chapter: _streamController.getNextEpisode(),
                        );
                      }
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
                      await _controller.seekTo(Duration(
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
                      await _controller.seekTo(Duration(
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
                  isFullscreen: (v) {},
                )
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _videoQualityWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
      child: Column(
        children: widget.videos.map((quality) {
          final selected = quality == _selectedVideo || widget.isLocal;
          return GestureDetector(
            child: textWidget(
                widget.isLocal ? _selectedVideo.quality : quality.quality,
                selected),
            onTap: () async {
              if (widget.isLocal) {
              } else {
                _controller = VideoPlayerController.networkUrl(
                    Uri.parse(quality.originalUrl),
                    httpHeaders: quality.headers ?? {},
                    closedCaptionFile: _selectedSubtitle != null
                        ? _loadCaption(_selectedSubtitle!.file!)
                        : null);
              }
              setState(() {
                _isInitiated = false;
              });
              _listener(duration: _currentPosition.value);
              _selectedVideo = quality;
              await _controller.initialize();
              if (context.mounted) {
                setState(() {});
                Navigator.pop(context);
              }
            },
          );
        }).toList(),
      ),
    );
  }

  void _videoSettingDraggableMenu(BuildContext context) async {
    final l10n = l10nLocalizations(context)!;
    bool hasSubtitleTrack = false;
    _controller.pause();
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
          },
          icon: const Icon(Icons.settings_outlined)),
    );
    setState(() {});
    _controller.play();
  }

  Widget _videoSubtitle(BuildContext context, Function(bool) hasSubtitleTrack) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
      child: Column(
        children: (_selectedVideo.subtitles ?? []).toList().map((sub) {
          final title = sub.label!;

          final selected = sub == _selectedSubtitle;
          return GestureDetector(
            onTap: () async {
              try {
                await _controller.setClosedCaptionFile(_loadCaption(sub.file!));
                _listener();
                if (context.mounted) {
                  setState(() {
                    _selectedSubtitle = sub;
                  });
                  Navigator.pop(context);
                }
              } catch (_) {}
            },
            child: textWidget(title, selected),
          );
        }).toList(),
      ),
    );
  }

  Widget _videoAudios(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
      child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: textWidget("#1", true)),
    );
  }

  Widget _topButtonBar(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: _enterFullScreen,
        builder: (context, fullScreen, _) {
          return Padding(
            padding: EdgeInsets.only(
                top: !isDesktop && !fullScreen
                    ? MediaQuery.of(context).padding.top
                    : 0),
            child: Row(
              children: [
                BackButton(
                  color: Colors.white,
                  onPressed: () async {
                    if (isDesktop) {
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
                            color: Colors.white.withOpacity(0.7)),
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
                        _controller.play();
                      } else {
                        _controller.pause();
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
                  //               title: const Text("Player Settings"),
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
                  //                                   .withOpacity(0.9),
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
                  //                                   .withOpacity(0.9),
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

  Widget _videoPlayer(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller)),
        ),
        isDesktop
            ? DesktopControllerWidget(
                videoController: _controller,
                topButtonBarWidget: _topButtonBar(context),
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
                isFullScreen: false,
              )
            : MobileControllerWidget(
                videoController: _controller,
                topButtonBarWidget: _topButtonBar(context),
                isFullScreen: false,
                bottomButtonBarWidget: _mobileBottomButtonBar(context),
                streamController: _streamController,
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
                                  controller: _controller,
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
                                      controller: _controller,
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
