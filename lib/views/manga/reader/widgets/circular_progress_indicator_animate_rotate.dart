import 'dart:math';
import 'package:flutter/material.dart';

class CircularProgressIndicatorAnimateRotate extends StatefulWidget {
  final double progress;
  const CircularProgressIndicatorAnimateRotate(
      {Key? key, required this.progress})
      : super(key: key);

  @override
  State<CircularProgressIndicatorAnimateRotate> createState() =>
      _CircularProgressIndicatorAnimateRotateState();
}

class _CircularProgressIndicatorAnimateRotateState
    extends State<CircularProgressIndicatorAnimateRotate>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: widget.progress == 0
          ? const CircularProgressIndicator()
          : AnimatedBuilder(
              animation: _controller,
              builder: (_, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * pi,
                  child: child,
                );
              },
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                tween: Tween<double>(
                  begin: 0,
                  end: widget.progress,
                ),
                builder: (context, value, _) => CircularProgressIndicator(
                  value: value,
                ),
              ),
            ),
    );
  }
}
