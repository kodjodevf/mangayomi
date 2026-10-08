import 'dart:async';

import 'package:flutter/material.dart';

class MobileSeekIndicator extends StatefulWidget {
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
  late Duration value = Duration(seconds: widget.skipDuration);

  Timer? timer;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(milliseconds: 400), () {
      widget.onSubmitted.call(value);
    });
  }

  void increment() {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 400), () {
      widget.onSubmitted.call(value);
    });
    widget.onChanged.call(value);
    setState(() {
      value += Duration(seconds: widget.skipDuration);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.forward
              ? const [Color(0x00000000), Color(0x66000000)]
              : const [Color(0x66000000), Color(0x00000000)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: InkWell(
        splashColor: colorScheme.primary.withValues(alpha: 0.16),
        highlightColor: Colors.transparent,
        onTap: increment,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.85,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.35),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.forward ? Icons.forward_10 : Icons.replay_10,
                  size: 26.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 4.0),
                Text(
                  '${value.inSeconds}s',
                  style: (textTheme.labelMedium ?? const TextStyle()).copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
