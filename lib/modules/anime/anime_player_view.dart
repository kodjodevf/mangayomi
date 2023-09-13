import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riv;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/video.dart' as vid;
import 'package:mangayomi/modules/anime/providers/anime_player_controller_provider.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/get_anime_servers.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/methods/video_state.dart';

class AnimePlayerView extends riv.ConsumerStatefulWidget {
  final Chapter episode;
  const AnimePlayerView({
    super.key,
    required this.episode,
  });

  @override
  riv.ConsumerState<AnimePlayerView> createState() => _AnimePlayerViewState();
}

class _AnimePlayerViewState extends riv.ConsumerState<AnimePlayerView> {
  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: []);
    final serversData = ref.watch(getAnimeServersProvider(
      episode: widget.episode,
    ));
    return serversData.when(
      data: (data) {
        if (data.$1.isEmpty &&
            (widget.episode.manga.value!.isLocalArchive ?? false) == false) {
          return Scaffold(
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
            body: WillPopScope(
              onWillPop: () async {
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                    overlays: SystemUiOverlay.values);
                Navigator.pop(context);
                return false;
              },
              child: const Center(
                child: Text("Error"),
              ),
            ),
          );
        }
        data.$1.sort(
          (a, b) => a.quality.compareTo(b.quality),
        );
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
        body: WillPopScope(
          onWillPop: () async {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                overlays: SystemUiOverlay.values);

            Navigator.pop(context);
            return false;
          },
          child: Center(
            child: Text(error.toString()),
          ),
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
          body: WillPopScope(
            onWillPop: () async {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                  overlays: SystemUiOverlay.values);

              Navigator.pop(context);
              return false;
            },
            child: const ProgressCenter(),
          ),
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
      {Key? key,
      required this.isLocal,
      required this.videos,
      required this.episode})
      : super(key: key);

  @override
  riv.ConsumerState<AnimeStreamPage> createState() => _AnimeStreamPageState();
}

class _AnimeStreamPageState extends riv.ConsumerState<AnimeStreamPage> {
  late final Player _player = Player();

  late final VideoController _controller = VideoController(_player);

  late final _streamController = AnimeStreamController(episode: widget.episode);

  final ValueNotifier<VideoPrefs?> _video = ValueNotifier(null);
  final ValueNotifier<VideoPrefs?> _subtitle = ValueNotifier(null);
  final ValueNotifier<double> _playbackSpeed = ValueNotifier(1.0);
  bool _seekToCurrentPosition = true;
  bool _initSubtitle = true;
  late Duration _currentPosition = _streamController.geTCurrentPosition();
  final _showFitLabel = StateProvider((ref) => false);
  final ValueNotifier<bool> _isCompleted = ValueNotifier(false);
  final _fit = StateProvider((ref) => BoxFit.contain);
  final bool _isDesktop =
      Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  late StreamSubscription<Duration> _currentPositionSub =
      _player.stream.position.listen(
    (position) {
      if (_initSubtitle) {
        if (_firstVid.subtitles!.isNotEmpty) {
          _player.setSubtitleTrack(SubtitleTrack.uri(
              _firstVid.subtitles!.first.file!,
              title: _firstVid.subtitles!.first.label,
              language: _firstVid.subtitles!.first.label));
          _initSubtitle = false;
        }
      }
      if (_seekToCurrentPosition && _currentPosition != Duration.zero) {
        _player.seek(_currentPosition);
        _seekToCurrentPosition = false;
        _isCompleted.value =
            _player.state.duration.inSeconds - _currentPosition.inSeconds <= 10;
      } else {
        _currentPosition = position;
        _streamController.setCurrentPosition(position.inMilliseconds);
        _streamController.setAnimeHistoryUpdate();
      }
    },
  );
  late final _firstVid = widget.videos.first;
  @override
  void initState() {
    super.initState();
    _currentPositionSub;

    _video.value = VideoPrefs(
        videoTrack: VideoTrack(
            _firstVid.originalUrl, _firstVid.quality, _firstVid.quality),
        headers: _firstVid.headers);
    _player.open(Media(_video.value!.videoTrack!.id,
        httpHeaders: _video.value!.headers));
  }

  @override
  void dispose() {
    _player.dispose();
    _currentPositionSub.cancel();
    super.dispose();
  }

  void _onChangeVideoQuality() {
    List<VideoPrefs> videoQuality = [];
    List<VideoTrack> videoTracks = _player.state.tracks.video
        .where((element) => element.w != null && element.h != null)
        .toList();

    for (var track in videoTracks) {
      videoQuality.add(VideoPrefs(videoTrack: track, isLocal: true));
    }

    if (widget.videos.isNotEmpty && !widget.isLocal) {
      for (var video in widget.videos) {
        videoQuality.add(VideoPrefs(
            videoTrack: VideoTrack(
              video.url,
              video.quality,
              video.quality,
            ),
            headers: video.headers,
            isLocal: false));
      }
    }

    final l10n = l10nLocalizations(context)!;
    showCupertinoModalPopup(
        context: context,
        builder: (_) => CupertinoActionSheet(
              title: Text(l10n.change_video_quality,
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.8)),
                  textAlign: TextAlign.center),
              actions: videoQuality
                  .map((quality) => CupertinoActionSheetAction(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                quality.isLocal && !widget.isLocal
                                    ? "${_firstVid.quality} ${quality.videoTrack!.h}p"
                                    : widget.isLocal
                                        ? _firstVid.quality
                                        : quality.videoTrack!.title!,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Icon(
                              Icons.check,
                              color: quality.isLocal &&
                                          !widget.isLocal &&
                                          "${quality.videoTrack!.title}${quality.videoTrack!.h}p" ==
                                              "${_video.value!.videoTrack!.title}${_video.value!.videoTrack!.h}p" ||
                                      "${_video.value!.videoTrack!.id}${_video.value!.videoTrack!.title}" ==
                                          "${quality.videoTrack!.id}${quality.videoTrack!.title}"
                                  ? Theme.of(context).iconTheme.color
                                  : Colors.transparent,
                            ),
                          ],
                        ),
                        onPressed: () {
                          _video.value = quality; // change the video quality
                          if (quality.isLocal) {
                            if (widget.isLocal) {
                              _player.setVideoTrack(quality.videoTrack!);
                            } else {
                              _player.open(Media(quality.videoTrack!.id,
                                  httpHeaders: quality.headers));
                            }
                          } else {
                            _player.open(Media(quality.videoTrack!.id,
                                httpHeaders: quality.headers));
                          }
                          _seekToCurrentPosition = true;
                          _initSubtitle = true;
                          _currentPositionSub = _player.stream.position.listen(
                            (position) {
                              if (_initSubtitle && _subtitle.value != null) {
                                _player.setSubtitleTrack(
                                    _subtitle.value!.subtitle!);
                                _initSubtitle = false;
                              }
                              if (_seekToCurrentPosition &&
                                  _currentPosition != Duration.zero) {
                                _player.seek(_currentPosition);
                                _seekToCurrentPosition = false;
                              } else {
                                _currentPosition = position;
                                _streamController.setCurrentPosition(
                                    position.inMilliseconds);
                                _streamController.setAnimeHistoryUpdate();
                              }
                            },
                          );
                          Navigator.maybePop(_);
                        },
                      ))
                  .toList(),
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => Navigator.maybePop(_),
                isDestructiveAction: true,
                child: Text(l10n.cancel),
              ),
            ));
  }

  void _onChangeVideoSubtitle() {
    List<VideoPrefs> videoSubtitle = [];
    List<SubtitleTrack> videoSubs = _player.state.tracks.subtitle
        .where((element) => element.title != null && element.language != null)
        .toList();
    for (var sub in videoSubs) {
      videoSubtitle.add(VideoPrefs(isLocal: true, subtitle: sub));
    }
    List<String> subs = [];
    if (widget.videos.isNotEmpty && !widget.isLocal) {
      for (var video in widget.videos) {
        for (var sub in video.subtitles!) {
          if (!subs.contains(sub.file)) {
            videoSubtitle.add(VideoPrefs(
                isLocal: false,
                subtitle: SubtitleTrack.uri(sub.file!,
                    title: sub.label, language: sub.label)));
            subs.add(sub.file!);
          }
        }
      }
    }

    _subtitle.value ??= videoSubtitle.first;
    final l10n = l10nLocalizations(context)!;
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: Text(l10n.change_video_subtitle,
            style: TextStyle(
                fontSize: 20,
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .color!
                    .withOpacity(0.8)),
            textAlign: TextAlign.center),
        actions: videoSubtitle
            .toSet()
            .toList()
            .map((subtitle) => CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.maybePop(_);
                    _subtitle.value = subtitle;
                    _player.setSubtitleTrack(subtitle.subtitle!);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        subtitle.subtitle!.title ??
                            subtitle.subtitle!.language ??
                            subtitle.subtitle!.channels ??
                            "N/A",
                        style: TextStyle(
                            fontSize: 16,
                            color:
                                Theme.of(context).textTheme.bodyLarge!.color),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Icon(
                        Icons.check,
                        color: _subtitle.value != null &&
                                "${_subtitle.value!.subtitle!.id}${_subtitle.value!.subtitle!.title}${_subtitle.value!.subtitle!.language}" ==
                                    "${subtitle.subtitle!.id}${subtitle.subtitle!.title}${subtitle.subtitle!.language}"
                            ? Theme.of(context).iconTheme.color
                            : Colors.transparent,
                      ),
                    ],
                  ),
                ))
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.maybePop(_),
          isDestructiveAction: true,
          child: Text(l10n.cancel),
        ),
      ),
    );
  }

  Future<void> _setPlaybackSpeed(double speed) async {
    await _player.setRate(speed);
    _playbackSpeed.value = speed;
  }

  Future<void> _togglePlaybackSpeed() async {
    List<double> allowedSpeeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.50, 1.75, 2.0];
    if (allowedSpeeds.indexOf(_playbackSpeed.value) <
        allowedSpeeds.length - 1) {
      _setPlaybackSpeed(
          allowedSpeeds[allowedSpeeds.indexOf(_playbackSpeed.value) + 1]);
    } else {
      _setPlaybackSpeed(allowedSpeeds[0]);
    }
  }

  List<Widget> _bottomButtonBar(BuildContext context, bool isFullScreen) {
    bool hasPrevEpisode = _streamController.getEpisodeIndex() + 1 !=
        _streamController.getEpisodesLength();
    bool hasNextEpisode = _streamController.getEpisodeIndex() != 0;
    return [
      Flexible(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const MaterialPositionIndicator(),
            const Spacer(),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (!isFullScreen)
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CupertinoButton(
                                  padding: const EdgeInsets.all(5),
                                  onPressed: _onChangeVideoQuality,
                                  child: const Icon(
                                    Icons.video_settings_outlined,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                )),
                          if (!isFullScreen)
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CupertinoButton(
                                  padding: const EdgeInsets.all(5),
                                  onPressed: _onChangeVideoSubtitle,
                                  child: const Icon(
                                    Icons.subtitles,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                )),
                          if (_isDesktop)
                            const MaterialDesktopVolumeButton(
                              iconSize: 38,
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          MaterialButton(
                              child: ValueListenableBuilder<double>(
                                valueListenable: _playbackSpeed,
                                builder: (context, value, child) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${value}x",
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              onPressed: () {
                                _togglePlaybackSpeed();
                              }),
                          MaterialButton(
                            child: const Icon(Icons.fit_screen,
                                size: 30, color: Colors.white),
                            onPressed: () async {
                              ref.read(_showFitLabel.notifier).state = true;
                              final fit = switch (ref.watch(_fit)) {
                                BoxFit.contain => BoxFit.cover,
                                BoxFit.cover => BoxFit.fill,
                                BoxFit.fill => BoxFit.fitHeight,
                                BoxFit.fitHeight => BoxFit.fitWidth,
                                BoxFit.fitWidth => BoxFit.none,
                                BoxFit.none => BoxFit.scaleDown,
                                _ => BoxFit.contain,
                              };
                              ref.read(_fit.notifier).state = fit;
                              await Future.delayed(const Duration(seconds: 1));
                              ref.read(_showFitLabel.notifier).state = false;
                            },
                          ),
                          if (_isDesktop)
                            const MaterialDesktopFullscreenButton()
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      onPressed: hasPrevEpisode
                          ? () {
                              pushReplacementMangaReaderView(
                                  context: context,
                                  chapter: _streamController.getPrevEpisode());
                            }
                          : null,
                      child: Icon(
                        Icons.skip_previous_outlined,
                        size: 30,
                        color: hasPrevEpisode
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Stack(
                      children: [
                        Positioned.fill(
                          child: UnconstrainedBox(
                            child: Container(
                              width: 47,
                              height: 47,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                      color: Colors.white, width: 3)),
                            ),
                          ),
                        ),
                        _isDesktop
                            ? const MaterialDesktopPlayOrPauseButton(
                                iconSize: 36,
                              )
                            : const MaterialPlayOrPauseButton(
                                iconSize: 36,
                              ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    MaterialButton(
                      onPressed: hasNextEpisode
                          ? () {
                              pushReplacementMangaReaderView(
                                context: context,
                                chapter: _streamController.getNextEpisode(),
                              );
                            }
                          : null,
                      child: Icon(
                        Icons.skip_next_outlined,
                        size: 30,
                        color: hasNextEpisode
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      )
    ];
  }

  List<Widget> _topButtonBar(BuildContext context, bool isFullScreen) {
    return [
      Flexible(
        child: Row(
          children: [
            if (isFullScreen)
              MaterialDesktopFullscreenButton(
                icon: Icon(Platform.isIOS || Platform.isMacOS
                    ? Icons.arrow_back_ios
                    : Icons.arrow_back),
              ),
            if (!isFullScreen)
              BackButton(
                color: Colors.white,
                onPressed: () {
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                      overlays: SystemUiOverlay.values);
                  Navigator.pop(context);
                },
              ),
            Flexible(
              child: ListTile(
                dense: true,
                title: SizedBox(
                  width: mediaWidth(context, 0.8),
                  child: Text(
                    widget.episode.manga.value!.name!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                subtitle: SizedBox(
                  width: mediaWidth(context, 0.8),
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
          ],
        ),
      )
    ];
  }

  Widget _videoPlayer(BuildContext context) {
    final fit = ref.watch(_fit);
    return Stack(
      children: [
        Video(
          subtitleViewConfiguration: const SubtitleViewConfiguration(
            style: TextStyle(
                height: 1.4,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: "",
                shadows: [Shadow(offset: Offset(0.0, 0.0), blurRadius: 7.0)],
                backgroundColor: Colors.transparent),
          ),
          fit: fit,
          controller: _controller,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          resumeUponEnteringForegroundMode: true,
        ),
        if (ref.watch(_showFitLabel))
          Positioned.fill(
              child: Center(
                  child: Text(
            fit.name.toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          )))
      ],
    );
  }

  Widget _mobilePlayer() {
    return MaterialVideoControlsTheme(
        normal: MaterialVideoControlsThemeData(
            visibleOnMount: true,
            buttonBarHeight: 83,
            seekOnDoubleTap: true,
            controlsHoverDuration: const Duration(seconds: 5),
            volumeGesture: true,
            brightnessGesture: true,
            seekBarPositionColor: primaryColor(context),
            seekBarThumbColor: primaryColor(context),
            primaryButtonBar: [],
            seekBarMargin: const EdgeInsets.only(bottom: 60, left: 8, right: 8),
            topButtonBarMargin: const EdgeInsets.all(0),
            topButtonBar: _topButtonBar(context, false),
            bottomButtonBarMargin: const EdgeInsets.only(left: 8, right: 8),
            bottomButtonBar: _bottomButtonBar(context, false)),
        fullscreen: MaterialVideoControlsThemeData(
            buttonBarHeight: 83,
            seekOnDoubleTap: true,
            controlsHoverDuration: const Duration(seconds: 5),
            volumeGesture: true,
            brightnessGesture: true,
            seekBarPositionColor: primaryColor(context),
            seekBarThumbColor: primaryColor(context),
            primaryButtonBar: [],
            seekBarMargin: const EdgeInsets.only(bottom: 60, left: 8, right: 8),
            topButtonBarMargin: const EdgeInsets.all(0),
            topButtonBar: _topButtonBar(context, true),
            bottomButtonBarMargin: const EdgeInsets.only(left: 8, right: 8),
            bottomButtonBar: _bottomButtonBar(context, true)),
        child: _videoPlayer(context));
  }

  Widget _desktopPlayer() {
    return MaterialDesktopVideoControlsTheme(
        normal: MaterialDesktopVideoControlsThemeData(
            visibleOnMount: true,
            buttonBarHeight: 83,
            seekBarContainerHeight: 4,
            controlsHoverDuration: const Duration(seconds: 5),
            seekBarPositionColor: primaryColor(context),
            seekBarThumbColor: primaryColor(context),
            primaryButtonBar: [],
            seekBarMargin: const EdgeInsets.only(left: 8, right: 8),
            topButtonBarMargin: const EdgeInsets.all(0),
            topButtonBar: _topButtonBar(context, false),
            bottomButtonBarMargin: const EdgeInsets.only(left: 8, right: 8),
            bottomButtonBar: _bottomButtonBar(context, false)),
        fullscreen: MaterialDesktopVideoControlsThemeData(
            buttonBarHeight: 83,
            seekBarContainerHeight: 4,
            controlsHoverDuration: const Duration(seconds: 5),
            seekBarPositionColor: primaryColor(context),
            seekBarThumbColor: primaryColor(context),
            primaryButtonBar: [],
            seekBarMargin: const EdgeInsets.only(left: 8, right: 8),
            topButtonBarMargin: const EdgeInsets.all(0),
            topButtonBar: _topButtonBar(context, true),
            bottomButtonBarMargin: const EdgeInsets.only(left: 8, right: 8),
            bottomButtonBar: _bottomButtonBar(context, true)),
        child: _videoPlayer(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: SystemUiOverlay.values);
          Navigator.pop(context);
          return false;
        },
        child: _isDesktop ? _desktopPlayer() : _mobilePlayer(),
      ),
    );
  }
}

class MaterialPositionIndicator extends StatefulWidget {
  /// Overriden [TextStyle] for the [MaterialPositionIndicator].
  final TextStyle? style;
  const MaterialPositionIndicator({super.key, this.style});

  @override
  MaterialPositionIndicatorState createState() =>
      MaterialPositionIndicatorState();
}

class MaterialPositionIndicatorState extends State<MaterialPositionIndicator> {
  late Duration position = controller(context).player.state.position;
  late Duration duration = controller(context).player.state.duration;

  final List<StreamSubscription> subscriptions = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (subscriptions.isEmpty) {
      subscriptions.addAll(
        [
          controller(context).player.stream.position.listen((event) {
            setState(() {
              position = event;
            });
          }),
          controller(context).player.stream.duration.listen((event) {
            setState(() {
              duration = event;
            });
          }),
        ],
      );
    }
  }

  @override
  void dispose() {
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          position.label(reference: duration),
          style: widget.style ??
              const TextStyle(
                height: 1.0,
                fontSize: 12.0,
                color: Colors.white,
              ),
        ),
        Text(
          duration.label(reference: duration),
          style: widget.style ??
              const TextStyle(
                height: 1.0,
                fontSize: 12.0,
                color: Colors.white,
              ),
        ),
      ],
    );
  }
}

class VideoPrefs {
  VideoTrack? videoTrack;
  SubtitleTrack? subtitle;
  bool isLocal;
  final Map<String, String>? headers;
  VideoPrefs(
      {this.videoTrack, this.isLocal = true, this.headers, this.subtitle});
}
