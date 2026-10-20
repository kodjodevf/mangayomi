import 'package:flutter/material.dart';
import 'package:mangayomi/modules/anime/widgets/player_overlay_surface.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final tokens = context.shiori;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s32),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(ShioriShape.pill),
          onTap: _seekTo,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final remaining =
                  widget.timeoutLength -
                  (_controller.duration! * _controller.value).inSeconds;
              return ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: tokens.density.minTarget,
                ),
                child: PlayerOverlaySurface(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    ShioriSpace.s8,
                    ShioriSpace.s8,
                    ShioriSpace.s16,
                    ShioriSpace.s8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: ShioriSpace.s12,
                    children: [
                      SizedBox.square(
                        dimension: 22,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: 1 - _controller.value,
                              strokeWidth: 2.5,
                              color: tokens.color.accentInk,
                              backgroundColor: Colors.white.withValues(
                                alpha: Alphas.hairline,
                              ),
                            ),
                            Text(
                              '$remaining',
                              style: TextStyle(
                                fontSize: tokens.text.badge.fontSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(widget.skipTypeText),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
