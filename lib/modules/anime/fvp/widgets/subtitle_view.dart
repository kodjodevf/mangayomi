// ignore_for_file: deprecated_member_use
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/anime/providers/state_provider.dart';
import 'package:video_player/video_player.dart';

class CustomSubtitleView extends ConsumerStatefulWidget {
  final VideoPlayerController controller;

  const CustomSubtitleView({super.key, required this.controller});

  @override
  ConsumerState<CustomSubtitleView> createState() => _CustomSubtitleViewState();
}

class _CustomSubtitleViewState extends ConsumerState<CustomSubtitleView> {
  late String subtitle = widget.controller.value.caption.text;
  late Duration duration = const Duration(milliseconds: 100);

  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {
        subtitle = widget.controller.value.caption.text;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textScaleFactor = MediaQuery.of(context).textScaleFactor *
            sqrt(
              ((constraints.maxWidth * constraints.maxHeight) /
                      (1920.0 * 1080.0))
                  .clamp(0.0, 1.0),
            );
        return Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: duration,
            alignment: Alignment.bottomCenter,
            child: Text(
              subtitle,
              style: subtileTextStyle(ref),
              textAlign: TextAlign.center,
              textScaleFactor: textScaleFactor,
            ),
          ),
        );
      },
    );
  }
}

TextStyle subtileTextStyle(WidgetRef ref) {
  final subSets = ref.watch(subtitleSettingsStateProvider);
  final borderColor = Color.fromARGB(subSets.borderColorA!,
      subSets.borderColorR!, subSets.borderColorG!, subSets.borderColorB!);
  return TextStyle(
      fontSize: subSets.fontSize!.toDouble(),
      fontWeight: subSets.useBold! ? FontWeight.bold : null,
      fontStyle: subSets.useItalic! ? FontStyle.italic : null,
      color: Color.fromARGB(subSets.textColorA!, subSets.textColorR!,
          subSets.textColorG!, subSets.textColorB!),
      shadows: [
        Shadow(
            offset: const Offset(-1.5, -1.5),
            color: borderColor,
            blurRadius: 1.4),
        Shadow(
            offset: const Offset(1.5, -1.5),
            color: borderColor,
            blurRadius: 1.4),
        Shadow(
            offset: const Offset(1.5, 1.5),
            color: borderColor,
            blurRadius: 1.4),
        Shadow(
            offset: const Offset(-1.5, 1.5),
            color: borderColor,
            blurRadius: 1.4)
      ],
      backgroundColor: Color.fromARGB(
          subSets.backgroundColorA!,
          subSets.backgroundColorR!,
          subSets.backgroundColorG!,
          subSets.backgroundColorB!));
}
