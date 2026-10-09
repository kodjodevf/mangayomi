import 'dart:async';

import 'package:flutter/material.dart';

class MobileSeekIndicator extends StatefulWidget {
  static const submitDelay = Duration(milliseconds: 400);

  final void Function(Duration) onChanged;
  final void Function(Duration) onSubmitted;
  final int skipDuration;

  /// Forward sits on the right edge and fades in from the left; backward
  /// is the mirror image.
  final bool forward;
  const MobileSeekIndicator({
    super.key,
    required this.onChanged,
    required this.onSubmitted,
    required this.skipDuration,
    required this.forward,
  });

  @override
  State<MobileSeekIndicator> createState() => _SeekIndicatorState();
}

class _SeekIndicatorState extends State<MobileSeekIndicator> {
  late Duration _value;
  Timer? _submitTimer;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _value = Duration(seconds: widget.skipDuration);
    _scheduleSubmit();
  }

  void increment() {
    if (_submitted) return;

    setState(() {
      _value += Duration(seconds: widget.skipDuration);
    });
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isRepeated = _value.inSeconds.abs() > widget.skipDuration.abs();
    final valueLabel = '${widget.forward ? '+' : '-'}${_value.inSeconds.abs()}';
    final directionLabel = widget.forward ? 'Seek forward' : 'Seek backward';
    final chevron = Icon(
      widget.forward
          ? isRepeated
                ? Icons.keyboard_double_arrow_right_rounded
                : Icons.keyboard_arrow_right_rounded
          : isRepeated
          ? Icons.keyboard_double_arrow_left_rounded
          : Icons.keyboard_arrow_left_rounded,
      key: ValueKey(
        'mobile-seek-${widget.forward ? 'forward' : 'backward'}-'
        '${isRepeated ? 'double' : 'single'}-chevron',
      ),
      size: 38,
      color: Colors.white,
      shadows: const [
        Shadow(color: Colors.black87, blurRadius: 8, offset: Offset(0, 2)),
      ],
    );
    final value = Text(
      valueLabel,
      key: const ValueKey('mobile-seek-value'),
      style: (textTheme.titleLarge ?? const TextStyle()).copyWith(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        fontFeatures: const [FontFeature.tabularFigures()],
        shadows: const [
          Shadow(color: Colors.black87, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
    );

    return Semantics(
      button: true,
      liveRegion: true,
      label: directionLabel,
      value: '${_value.inSeconds.abs()} seconds',
      onTap: increment,
      child: ExcludeSemantics(
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            splashColor: Colors.white.withValues(alpha: 0.12),
            highlightColor: Colors.transparent,
            onTap: increment,
            child: Align(
              alignment: widget.forward
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: widget.forward
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.forward
                        ? [value, const SizedBox(width: 2), chevron]
                        : [chevron, const SizedBox(width: 2), value],
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
