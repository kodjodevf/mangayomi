import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/utils/constant.dart';

/// The full screen shown while the app finishes starting up.
///
/// This used to paint a fixed white background with a black icon, which meant a
/// full screen white flash on every cold start under a dark theme. Both colours
/// now come from the active scheme, so the splash matches whatever palette the
/// user picked.
class LoadingIcon extends StatelessWidget {
  const LoadingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.shiori.color.ink0,
      body: Center(
        child: Image.asset(
          appIconAssets[2],
          color: context.shiori.color.fg,
          fit: BoxFit.cover,
          height: 100,
        ),
      ),
    );
  }
}
