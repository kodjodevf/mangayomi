import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/modules/anime/widgets/mobile_player_controls_layout.dart';

const _seekFeedbackShadow = Shadow(
  // shiori: a hairline shadow under white text on video, a const top-level value
  color: Color(0x30000000),
  blurRadius: 3,
  offset: Offset(0, 1),
);

class MobileSeekIndicator extends StatefulWidget {
  static const submitDelay = Duration(milliseconds: 550);

  final void Function(Duration) onChanged;
  final void Function(Duration) onSubmitted;
  final int skipDuration;
  final bool compactPortrait;

  /// Forward sits on the right edge and fades in from the left; backward
  /// is the mirror image.
  final bool forward;
  const MobileSeekIndicator({
    super.key,
    required this.onChanged,
    required this.onSubmitted,
    required this.skipDuration,
    required this.forward,
    required this.compactPortrait,
  });

  @override
  State<MobileSeekIndicator> createState() => _SeekIndicatorState();
}

class _SeekIndicatorState extends State<MobileSeekIndicator>
    with SingleTickerProviderStateMixin {
  static const _chevronAnimationDuration = ShioriMotion.standard;

  late Duration _value;
  late final AnimationController _chevronController;
  Timer? _submitTimer;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _value = Duration(seconds: widget.skipDuration);
    _chevronController = AnimationController(
      vsync: this,
      duration: _chevronAnimationDuration,
    )..forward();
    _scheduleSubmit();
  }

  void increment() {
    if (_submitted) return;

    setState(() {
      _value += Duration(seconds: widget.skipDuration);
    });
    _chevronController.forward(from: 0);
    widget.onChanged(_value);
    _scheduleSubmit();
  }

  void _scheduleSubmit() {
    _submitTimer?.cancel();
    _submitTimer = Timer(MobileSeekIndicator.submitDelay, _submit);
  }

  void _submit() {
    if (_submitted || !mounted) return;
    _submitted = true;
    widget.onSubmitted(_value);
  }

  @override
  void dispose() {
    _submitTimer?.cancel();
    _chevronController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final safeInsets = MediaQuery.viewPaddingOf(context);
    final visualPadding = widget.compactPortrait
        ? EdgeInsets.zero
        : EdgeInsets.only(
            top: safeInsets.top,
            bottom: safeInsets.bottom + mobilePlayerBottomControlsBottomPadding,
          );
    final valueLabel = '${widget.forward ? '+' : '-'}${_value.inSeconds.abs()}';
    // Read out in the app's language where it has one (tests may not).
    final l10n = l10nLocalizations(context);
    final seconds = _value.inSeconds.abs();
    final directionLabel = l10n == null
        ? (widget.forward ? 'Seek forward' : 'Seek backward')
        : (widget.forward
              ? l10n.shortcut_seek_forward(seconds)
              : l10n.shortcut_seek_back(seconds));
    final direction = widget.forward ? 1.0 : -1.0;
    final chevrons = SizedBox(
      width: 54,
      height: 42,
      child: AnimatedBuilder(
        animation: _chevronController,
        builder: (context, child) {
          final progress = _chevronController.value;
          final trailingOpacity = progress <= 0.55
              ? progress / 0.55
              : (1 - progress) / 0.45;
          final leadingOpacity =
              0.7 + (Curves.easeOut.transform(progress) * 0.3);
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Transform.translate(
                offset: Offset(direction * (-18 + (progress * 10)), 0),
                child: Opacity(
                  key: ValueKey(
                    'mobile-seek-${widget.forward ? 'forward' : 'backward'}-'
                    'chevron-0',
                  ),
                  opacity: trailingOpacity,
                  child: Icon(
                    fill: 1,
                    widget.forward
                        ? Symbols.keyboard_arrow_right_rounded
                        : Symbols.keyboard_arrow_left_rounded,
                    size: 32,
                    color: Colors.white,
                    shadows: const [_seekFeedbackShadow],
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(direction * 12, 0),
                child: Opacity(
                  key: ValueKey(
                    'mobile-seek-${widget.forward ? 'forward' : 'backward'}-'
                    'chevron-1',
                  ),
                  opacity: leadingOpacity,
                  child: Icon(
                    fill: 1,
                    widget.forward
                        ? Symbols.keyboard_arrow_right_rounded
                        : Symbols.keyboard_arrow_left_rounded,
                    size: 32,
                    color: Colors.white,
                    shadows: const [_seekFeedbackShadow],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
    final value = TweenAnimationBuilder<double>(
      key: ValueKey('mobile-seek-value-${_value.inSeconds}'),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: ShioriMotion.fast,
      curve: Curves.easeOut,
      builder: (context, progress, child) => Opacity(
        opacity: progress,
        child: Transform.scale(scale: 0.96 + (progress * 0.04), child: child),
      ),
      child: Text(
        valueLabel,
        key: const ValueKey('mobile-seek-value'),
        style: (textTheme.titleLarge ?? const TextStyle()).copyWith(
          color: Colors.white,
          fontSize: context.shiori.text.seriesTitle.fontSize,
          fontWeight: FontWeight.w700,
          fontFeatures: const [FontFeature.tabularFigures()],
          shadows: const [_seekFeedbackShadow],
        ),
      ),
    );

    return Semantics(
      button: true,
      liveRegion: true,
      label: directionLabel,
      value: l10n == null ? '$seconds seconds' : null,
      onTap: increment,
      child: ExcludeSemantics(
        child: GestureDetector(
          key: const ValueKey('mobile-seek-gesture-surface'),
          behavior: HitTestBehavior.opaque,
          onTap: increment,
          child: Padding(
            padding: visualPadding,
            child: Align(
              alignment: widget.forward
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 18 + (widget.forward ? 0 : safeInsets.left),
                  right: 18 + (widget.forward ? safeInsets.right : 0),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: widget.forward
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.forward
                        ? [value, const SizedBox(width: 2), chevrons]
                        : [chevrons, const SizedBox(width: 2), value],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
