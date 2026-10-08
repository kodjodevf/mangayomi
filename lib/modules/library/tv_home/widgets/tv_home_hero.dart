import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/widgets/library_entry_utils.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/modules/library/tv_home/tv_home_layout.dart';

/// The top hero: a blurred cover backdrop (clipped so it can't bleed into the
/// rows), darkened on the left for text and faded into the page background at
/// the bottom for a clean seam. Poster + title + the autofocused Continue.
/// Auto-rotating hero — cycles through the top few resume candidates with a
/// crossfade, pausing while it (its Continue button) is focused.
class TvHomeHero extends StatefulWidget {
  const TvHomeHero({super.key, required this.items});
  final List<Manga> items;

  @override
  State<TvHomeHero> createState() => _TvHomeHeroState();
}

class _TvHomeHeroState extends State<TvHomeHero>
    with SingleTickerProviderStateMixin {
  static const _dwell = Duration(seconds: 7);
  int _index = 0;
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    // One clock drives both the dwell timer and the progress indicator.
    _ctrl = AnimationController(vsync: this, duration: _dwell)
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed && mounted) {
          setState(() => _index = (_index + 1) % widget.items.length);
          _ctrl.forward(from: 0);
        }
      });
    if (widget.items.length > 1) _ctrl.forward();
  }

  /// Pause the dwell while the hero is focused so it never rotates out from
  /// under you; resume when focus leaves.
  void _setPaused(bool paused) {
    if (widget.items.length <= 1) return;
    if (paused) {
      _ctrl.stop();
    } else if (!_ctrl.isAnimating) {
      _ctrl.forward();
    }
  }

  @override
  void didUpdateWidget(TvHomeHero old) {
    super.didUpdateWidget(old);
    if (_index >= widget.items.length) _index = 0;
    if (widget.items.length > 1 && !_ctrl.isAnimating) _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();
    final manga = widget.items[_index.clamp(0, widget.items.length - 1)];
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onFocusChange: _setPaused,
      child: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _HeroContent(key: ValueKey(manga.id), manga: manga),
          ),
          if (widget.items.length > 1)
            Positioned(
              right: 34,
              bottom: 26,
              child: _RotationDots(
                controller: _ctrl,
                count: widget.items.length,
                index: _index,
              ),
            ),
        ],
      ),
    );
  }
}

/// The rotation timer: the active item is a short bar that fills over the dwell
/// time; the others are muted dots. Deliberately not a countdown number.
class _RotationDots extends StatelessWidget {
  const _RotationDots({
    required this.controller,
    required this.count,
    required this.index,
  });
  final AnimationController controller;
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final accent = context.primaryColor;
    final muted = Colors.white.withValues(alpha: 0.28);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final active = i == index;
        return Padding(
          padding: const EdgeInsets.only(left: 6),
          child: active
              ? SizedBox(
                  width: 24,
                  height: 4,
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, _) => ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: controller.value,
                        minHeight: 4,
                        backgroundColor: muted,
                        valueColor: AlwaysStoppedAnimation<Color>(accent),
                      ),
                    ),
                  ),
                )
              : Container(
                  width: 6,
                  height: 4,
                  decoration: BoxDecoration(
                    color: muted,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
        );
      }),
    );
  }
}

class _HeroContent extends ConsumerWidget {
  const _HeroContent({required this.manga, super.key});
  final Manga manga;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = resolveCoverImage(manga, ref);
    final total = manga.chapters.length;
    final read = manga.chapters.where((c) => c.isRead ?? false).length;
    final unread = manga.chapters.where((c) => !(c.isRead ?? true)).length;
    final resume = tvResumeChapter(manga);
    final posMs = int.tryParse(resume?.lastPageRead ?? '') ?? 0;

    // Series progress = watched / total (episode duration isn't reliably
    // stored, so within-episode % isn't available).
    final progress = (total > 0 && read > 0 && read < total)
        ? read / total
        : 0.0;
    final hasBar = progress > 0;

    final metaBits = <String>[
      if ((resume?.name ?? '').isNotEmpty) resume!.name!,
      if (posMs > 0) 'at ${tvFormatMs(posMs)}',
      if (unread > 0) '$unread new',
      if ((manga.source ?? '').isNotEmpty) manga.source!,
    ];
    final genreBits = (manga.genre ?? const <String>[])
        .where((g) => g.trim().isNotEmpty)
        .take(3)
        .toList();

    return ClipRect(
      child: SizedBox(
        height: 330,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // The backdrop fades its own alpha out into the rows below, rather
            // than blending toward a background colour it would have to guess
            // at. Its top edge is handled by the fade over the whole content
            // viewport — that edge moves as the hero scrolls, this one doesn't.
            ShaderMask(
              blendMode: BlendMode.dstIn,
              shaderCallback: (rect) => const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.72, 1.0],
                colors: [Colors.white, Colors.white, Colors.transparent],
              ).createShader(rect),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ImageFiltered(
                    imageFilter: ui.ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: Image(image: image, fit: BoxFit.cover),
                  ),
                  // Darken the left so the title/summary stay readable.
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xDB000000), Color(0x40000000)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 26, 40, 28),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 0.68,
                      child: Image(image: image, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          manga.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (metaBits.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            metaBits.join('  ·  '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.78),
                              fontSize: 14,
                            ),
                          ),
                        ],
                        if (genreBits.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            genreBits.join('  ·  '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.55),
                              fontSize: 12,
                            ),
                          ),
                        ],
                        if (hasBar) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 5,
                                    backgroundColor: Colors.white24,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      context.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '$read / $total',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if ((manga.description ?? '').trim().isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            manga.description!.trim(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.72),
                              fontSize: 13,
                              height: 1.35,
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        _HeroContinueButton(manga: manga, chapter: resume),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The hero's Continue button — focusable, autofocused (the home's landing
/// target), theme-accent when focused, OK/Select or tap to resume.
class _HeroContinueButton extends StatefulWidget {
  const _HeroContinueButton({required this.manga, this.chapter});
  final Manga manga;
  final Chapter? chapter;

  @override
  State<_HeroContinueButton> createState() => _HeroContinueButtonState();
}

class _HeroContinueButtonState extends State<_HeroContinueButton> {
  bool _focused = false;

  void _resume() {
    (widget.chapter ?? tvResumeChapter(widget.manga))?.pushToReaderView(
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = context.primaryColor;
    return Focus(
      // Entry focus lives on the "All" pill; the hero must not steal it when
      // switching back to All from a category view.
      autofocus: false,
      onFocusChange: (f) {
        setState(() => _focused = f);
        // When focus returns to the hero (e.g. scrolling up out of the rows),
        // pull the page fully to the top so the whole poster is revealed
        // instead of staying clipped under the first row.
        if (f) {
          Scrollable.maybeOf(context)?.position.animateTo(
            0,
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOut,
          );
        }
      },
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent && isTvSelectKey(event.logicalKey)) {
          _resume();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: _resume,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 130),
          curve: Curves.easeOut,
          transform: Matrix4.identity()
            ..scaleByDouble(
              _focused ? 1.05 : 1.0,
              _focused ? 1.05 : 1.0,
              _focused ? 1.05 : 1.0,
              1,
            ),
          transformAlignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: _focused ? accent : Colors.white.withValues(alpha: 0.14),
            border: Border.all(
              color: _focused ? accent : Colors.white.withValues(alpha: 0.28),
              width: 2,
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.play_arrow, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Continue',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
