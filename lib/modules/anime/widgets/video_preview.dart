import 'package:flutter/material.dart';
import 'package:mangayomi/modules/anime/anime_player_view.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';

class TestTest extends StatefulWidget {
  final Duration? onDragDuration;
  final VideoPrefs video;
  const TestTest(
      {super.key, required this.onDragDuration, required this.video});

  @override
  State<TestTest> createState() => _TestTestState();
}

class _TestTestState extends State<TestTest> {
  late final Player _player =
      Player(configuration: const PlayerConfiguration());
  late final VideoController _controller = VideoController(_player);

  @override
  void initState() {
    _player.open(
        Media(widget.video.videoTrack!.id,
            httpHeaders: widget.video.headers, start: widget.onDragDuration),
        play: false);
    super.initState();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ValueListenableBuilder<PlatformVideoController?>(
        valueListenable: _controller.notifier,
        builder: (context, notifier, _) => notifier == null
            ? const SizedBox.shrink()
            : ValueListenableBuilder<int?>(
                valueListenable: notifier.id,
                builder: (context, id, _) {
                  return ValueListenableBuilder<Rect?>(
                    valueListenable: notifier.rect,
                    builder: (context, rect, _) {
                      if (id != null && rect != null) {
                        return Texture(textureId: id);
                      }
                      return const SizedBox.shrink();
                    },
                  );
                },
              ),
      ),
    );
  }
}

class VideoPreview extends StatelessWidget {
  final ValueNotifier<bool> isDragging;
  final ValueNotifier<double?> dragPosition;
  final ValueNotifier<Duration?> onDragDuration;
  final VideoPrefs video;
  const VideoPreview(
      {super.key,
      required this.isDragging,
      required this.dragPosition,
      required this.onDragDuration,
      required this.video});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDragging,
      builder: (context, isDragging, child) {
        return ValueListenableBuilder(
          valueListenable: dragPosition,
          builder: (context, dragPosition, child) {
            return ValueListenableBuilder(
              valueListenable: onDragDuration,
              builder: (context, onDragDuration, child) {
                if (dragPosition != null) {
                  return Positioned(
                    bottom: 100,
                    left: dragPosition >= (context.width(1) - 150)
                        ? null
                        : dragPosition >= 50
                            ? dragPosition - 50
                            : 0,
                    right: dragPosition >= (context.width(1) - 150) ? 0 : null,
                    child: Material(
                      elevation: 8.0,
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                          width: 200,
                          height: 100,
                          color: Colors.black,
                          child: Stack(
                            children: [
                              if (!isDragging)
                                TestTest(
                                    onDragDuration: onDragDuration,
                                    video: video),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Text(
                                    onDragDuration!
                                        .label(reference: onDragDuration),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                            offset: Offset(-1.5, -1.5),
                                            color: Colors.black,
                                            blurRadius: 1.2),
                                        Shadow(
                                            offset: Offset(1.5, -1.5),
                                            color: Colors.black,
                                            blurRadius: 1.2),
                                        Shadow(
                                            offset: Offset(1.5, 1.5),
                                            color: Colors.black,
                                            blurRadius: 1.2),
                                        Shadow(
                                            offset: Offset(-1.5, 1.5),
                                            color: Colors.black,
                                            blurRadius: 1.2)
                                      ],
                                    ),
                                    textAlign: TextAlign.center),
                              )
                            ],
                          )),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            );
          },
        );
      },
    );
  }
}
