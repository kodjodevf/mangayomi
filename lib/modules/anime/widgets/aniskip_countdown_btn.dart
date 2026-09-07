import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/anime/widgets/player_theme.dart';
import 'package:mangayomi/services/aniskip.dart';
import 'package:media_kit/media_kit.dart';

class AniSkipCountDownButton extends ConsumerStatefulWidget {
  final bool active;
  final bool autoSkip;
  final int timeoutLength;
  final String skipTypeText;
  final Results? aniSkipResult;
  final Player player;
  const AniSkipCountDownButton({
    super.key,
    required this.skipTypeText,
    required this.aniSkipResult,
    required this.player,
    required this.active,
    required this.autoSkip,
    required this.timeoutLength,
  });

  @override
  ConsumerState<AniSkipCountDownButton> createState() =>
      _AniSkipCountDownButtonState();
}

class _AniSkipCountDownButtonState extends ConsumerState<AniSkipCountDownButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.timeoutLength),
    )..forward();
    super.initState();
    if (widget.active) {
      if (widget.autoSkip) {
        _seekTo();
      } else {
        _controller.addListener(() {
          if (_controller.isCompleted) {
            setState(() {
              _isCompleted = true;
            });
            _controller.reset();
          }
        });
      }
    }
  }

  void _seekTo() {
    setState(() {
      _isCompleted = true;
    });
    _controller.reset();
    widget.player.seek(
      Duration(seconds: widget.aniSkipResult!.interval!.endTime!.ceil()),
    );
  }

  bool _isCompleted = false;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active || widget.autoSkip || _isCompleted) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: _seekTo,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final remaining =
                  widget.timeoutLength -
                  (_controller.duration! * _controller.value).inSeconds;
              return Container(
                padding: const EdgeInsets.fromLTRB(6, 6, 14, 6),
                decoration: BoxDecoration(
                  color: PlayerTheme.glassStrong,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: 1 - _controller.value,
                            strokeWidth: 2.4,
                            color: PlayerTheme.semantic,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.18,
                            ),
                          ),
                          Text(
                            '$remaining',
                            style: const TextStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w600,
                              color: PlayerTheme.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 9),
                    Text(
                      widget.skipTypeText,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: PlayerTheme.ink,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
