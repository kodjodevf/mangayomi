import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riv;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/modules/anime/providers/stream_controller_provider.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/services/get_anime_servers.dart';
import 'package:mangayomi/utils/media_query.dart';

class AnimeStreamView extends riv.ConsumerStatefulWidget {
  final Chapter episode;
  const AnimeStreamView({
    super.key,
    required this.episode,
  });

  @override
  riv.ConsumerState<AnimeStreamView> createState() => _AnimeStreamViewState();
}

class _AnimeStreamViewState extends riv.ConsumerState<AnimeStreamView> {
  final _controller = MeeduPlayerController(
    autoHideControls: false,
    responsive: Responsive(
      fontSizeRelativeToScreen: 2.0,
      maxFontSize: 12,
      iconsSizeRelativeToScreen: 10,
      maxIconsSize: 50,
      buttonsSizeRelativeToScreen: 10,
      maxButtonsSize: 50,
    ),
    enabledButtons: const EnabledButtons(playPauseAndRepeat: false),
    screenManager: const ScreenManager(
      forceLandScapeInFullscreen: false,
    ),
  );
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: []);
    final serversData = ref.watch(getAnimeServersProvider(
      chapter: widget.episode,
    ));
    return serversData.when(
      data: (data) {
        if (data.isEmpty &&
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
        data.sort(
          (a, b) => a.quality.compareTo(b.quality),
        );
        return AnimeStreamPage(
          episode: widget.episode,
          videos: data,
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
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: WillPopScope(
            onWillPop: () async {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                  overlays: SystemUiOverlay.values);
              Navigator.pop(context);
              return false;
            },
            child: Stack(
              children: [
                MeeduVideoPlayer(
                    header: (context, controller, responsive) => AppBar(
                          leading: BackButton(
                            color: Colors.white,
                            onPressed: () {
                              SystemChrome.setEnabledSystemUIMode(
                                  SystemUiMode.manual,
                                  overlays: SystemUiOverlay.values);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                    controller: _controller),
                const ProgressCenter(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AnimeStreamPage extends StatefulWidget {
  final List<Video> videos;
  final Chapter episode;
  const AnimeStreamPage({Key? key, required this.videos, required this.episode})
      : super(key: key);

  @override
  State<AnimeStreamPage> createState() => _AnimeStreamPageState();
}

class _AnimeStreamPageState extends State<AnimeStreamPage> {
  final _controller = MeeduPlayerController(
    responsive: Responsive(
      fontSizeRelativeToScreen: 2.0,
      maxFontSize: 12,
      iconsSizeRelativeToScreen: 10,
      maxIconsSize: 50,
      buttonsSizeRelativeToScreen: 10,
      maxButtonsSize: 50,
    ),
    pipEnabled: true,
  );
  late final streamController = AnimeStreamController(episode: widget.episode);

  /// listener for the video quality
  final ValueNotifier<Video?> _video = ValueNotifier(null);

  late Duration _currentPosition =
      streamController.geTCurrentPosition(); // to save the video position

  /// subscription to listen the video position changes
  StreamSubscription? _currentPositionSubs;

  @override
  void initState() {
    super.initState();
    _video.value = widget.videos[0]; // set the default video quality (480p)

    // listen the video position
    _currentPositionSubs = _controller.onPositionChanged.listen(
      (Duration position) {
        _currentPosition = position; // save the video position

        streamController.setCurrentPosition(position.inMilliseconds);
        streamController.setAnimeHistoryUpdate();
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setDataSource();
    });
  }

  @override
  void dispose() {
    _currentPositionSubs?.cancel(); // cancel the subscription
    _controller.dispose();
    super.dispose();
  }

  void _onChangeVideoQuality() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: List.generate(
          widget.videos.length,
          (index) {
            final quality = widget.videos[index];
            return CupertinoActionSheetAction(
              child: Text(quality.quality),
              onPressed: () {
                _video.value = quality; // change the video quality
                _setDataSource(); // update the datasource
                Navigator.maybePop(_);
              },
            );
          },
        ),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.maybePop(_),
          isDestructiveAction: true,
          child: const Text("Cancel"),
        ),
      ),
    );
  }

  Future<void> _setDataSource() async {
    // set the data source and play the video in the last video position
    await _controller.setDataSource(
      DataSource(
          type: DataSourceType.network,
          source: _video.value!.originalUrl,
          httpHeaders: _video.value!.headers),
      autoplay: true,
      seekTo: _currentPosition,
    );
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
        child: MeeduVideoPlayer(
          controller: _controller,
          header: (ctx, controller, responsive) {
            // creates a responsive fontSize using the size of video container
            final double fontSize = responsive.ip(3);

            return AppBar(
              title: ListTile(
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
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              leading: BackButton(
                color: Colors.white,
                onPressed: () {
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                      overlays: SystemUiOverlay.values);
                  Navigator.pop(context);
                },
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoButton(
                    padding: const EdgeInsets.all(5),
                    onPressed: _onChangeVideoQuality,
                    child: ValueListenableBuilder<Video?>(
                      valueListenable: _video,
                      builder: (context, Video? video, child) {
                        return Text(
                          video!.quality,
                          style: TextStyle(
                            fontSize: fontSize > 18 ? 18 : fontSize,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
